# AOS Checkout

Identyfikator: `AOS-CHECKOUT`
Status: `potwierdzone` dla śladu kodowego, `do potwierdzenia` dla decyzji biznesowych wskazanych w ryzykach.
Zakres: route `/checkout`, złożenie zamówienia przez dealera, walidacja stocku, credit check, gateway payment, utworzenie orderu.

## Cel Biznesowy

Ekran pozwala dealerowi sprawdzić pozycje koszyka, wybrać metodę płatności i złożyć zamówienie. Dla `PrePaid` frontend pokazuje wynik credit check i uruchamia płatność Razorpay przed wysłaniem `POST /orders/api/orders`. Backend niezależnie wykonuje soft-lock stocku i credit check przed zapisem zamówienia.

## Role I Dostęp

| Warstwa | Reguła | Status | Źródło |
|---|---|---|---|
| Angular route | `/checkout`, `roleGuard`, `UserRole.Dealer` | potwierdzone | `app.routes.ts:75-78` |
| UI dependencies | `CartStore`, `AuthStore`, `OrderApiService`, `PaymentApiService`, `CatalogApiService`, `ToastService` | potwierdzone | `checkout.component.ts:33-40` |
| Order API | `POST api/orders` ma `[Authorize(Roles = "Dealer")]` | potwierdzone | `OrdersController.cs:17-28` |
| Payment gateway API | `POST api/payment/gateway/orders`, `POST api/payment/gateway/verify` mają rolę `Dealer` | potwierdzone | `PaymentController.cs:16-41` |
| Internal API | inventory i payment internal używają `X-Internal-Api-Key`, nie roli użytkownika | potwierdzone | `InternalInventoryController.cs:80-93`, `PaymentController.cs:267-275` |

## UI: Pola, Stany I Akcje

| Element UI | Dane / akcja | Źródło | Ślad danych | Status |
|---|---|---|---|---|
| Nagłówek `Checkout` | wejście na ekran | `checkout.component.html:4` | brak zapisu | potwierdzone |
| `Back to Cart` | link do `/cart` | `checkout.component.html:5` | brak zapisu | potwierdzone |
| Lista pozycji | `productName`, `sku`, `quantity`, opcjonalne `note`, `lineTotal` | `checkout.component.html:13-23` | `CartStore` / `localStorage sc_cart`; docelowo `OrderLines` | potwierdzone |
| Total | `cartStore.total()` | `checkout.component.html:25-28` | wyliczenie z `CartItem.lineTotal`; docelowo `Orders.TotalAmount` | potwierdzone |
| Payment method | `PaymentMode.COD`, `PaymentMode.PrePaid` | `checkout.component.html:31-48` | `Orders.PaymentMode` | potwierdzone |
| Credit info | `approved`, `availableCredit`, `cartStore.total()` | `checkout.component.html:51-59` | odczyt `DealerCreditAccounts` przez `CreditCheckResponse` | potwierdzone |
| Place Order | `(click)="placeOrder()"`, disabled tylko przez `loading()` | `checkout.component.html:71-73` | uruchamia walidację stocku i order flow | potwierdzone |
| Draft metody płatności | `localStorage sc_checkout_draft` | `checkout.component.ts:337-363` | brak zapisu w DB | potwierdzone |

## Ślad End-To-End

| Krok | Frontend | API / backend | Dane | Status |
|---:|---|---|---|---|
| 1 | `ngOnInit()` przekierowuje na `/cart`, jeśli koszyk pusty | brak | `CartStore.items()` | potwierdzone |
| 2 | `placeOrder()` ustawia `loading`, czyści błąd i wywołuje `validateCartAgainstCurrentStock()` | `GET /catalog/api/products/{id}` per pozycja | `Products`, pola stock/cena/aktywność | potwierdzone |
| 3 | UI usuwa lub koryguje pozycje, jeśli produkt nieaktywny albo stock/cena się zmieniły | brak zapisu backend | `CartStore` / `localStorage sc_cart` | potwierdzone |
| 4 | Dla `PrePaid` `onPaymentChange()` i flow płatności używają `PaymentApiService` | `GET /payments/api/payment/dealers/{dealerId}/credit-check`, `POST gateway/orders`, `POST gateway/verify` | `DealerCreditAccounts`, `PaymentRecords`, Payment outbox | potwierdzone |
| 5 | `submitOrder()` buduje `CreateOrderRequest` z `paymentMode`, `idempotencyKey`, `lines[]` | `POST /orders/api/orders` | `Orders`, `OrderLines`, `OrderStatusHistory`, `OrderSagaStates`, Order outbox | potwierdzone |
| 6 | `OrdersController.Create` bierze `userId` z tokenu i wysyła `CreateOrderCommand` | `CreateOrderCommandHandler -> IOrderService.CreateOrderAsync` | przekazanie `dealerId` z tokenu | potwierdzone |
| 7 | `OrderService` waliduje DTO, tworzy numer orderu i agregat z liniami | `CreateOrderRequestValidator`, `OrderAggregate.Create`, `OrderLine.Create` | przygotowanie encji | potwierdzone |
| 8 | `OrderService` soft-lockuje stock dla zgrupowanych `ProductId` | `CatalogInventoryGateway -> /api/internal/inventory/soft-lock` | `Products.ReservedStock`, `StockTransactions` | potwierdzone |
| 9 | `OrderService` wykonuje credit check | `PaymentCreditCheckGateway -> /api/payment/internal/dealers/{id}/credit-check` | `DealerCreditAccounts` | potwierdzone |
| 10 | Jeśli credit odrzucony, order dostaje hold i outbox `AdminApprovalRequired` | `MarkCreditHold`, `AddOutboxMessageAsync` | `Orders.Status`, `Orders.CreditHoldStatus`, `OutboxMessages` | potwierdzone |
| 11 | Jeśli credit zatwierdzony, order przechodzi do `Processing`, outbox `OrderPlaced`, a potem outstanding | `MarkCreditApproved`, `TransitionTo`, `AddOutstandingAsync` | `Orders`, `OutboxMessages`, `DealerCreditAccounts.CurrentOutstanding` | potwierdzone |
| 12 | Saga jest startowana i ustawiana na `CompletedApproved` albo `AwaitingManualApproval` | `OrderSagaCoordinator` | `OrderSagaStates` | potwierdzone |
| 13 | UI czyści koszyk/draft, pokazuje toast i przechodzi do `/orders/{orderId}` | `OrderDto` | odczyt wynikowy zamówienia | potwierdzone |

## API I Kontrakty

| Akcja UI | Serwis Angular | Endpoint | DTO | Backend | Status |
|---|---|---|---|---|---|
| Walidacja produktu | `CatalogApiService.getProductById` | `GET /catalog/api/products/{id}` | `ProductDto` | `ProductsController.GetById` | potwierdzone |
| Credit check dla `PrePaid` | `PaymentApiService.checkCredit` | `GET /payments/api/payment/dealers/{dealerId}/credit-check` | `CreditCheckResponse` | `PaymentController.CheckCredit` | potwierdzone |
| Gateway order | `PaymentApiService.createGatewayOrder` | `POST /payments/api/payment/gateway/orders` | `CreateGatewayOrderRequest`, `GatewayOrderDto` | `PaymentController.CreateGatewayOrder` | potwierdzone |
| Gateway verify | `PaymentApiService.verifyGatewayPayment` | `POST /payments/api/payment/gateway/verify` | `VerifyGatewayPaymentRequest`, `GatewayPaymentVerificationDto` | `PaymentController.VerifyGatewayPayment` | potwierdzone |
| Utworzenie zamówienia | `OrderApiService.createOrder` | `POST /orders/api/orders` | `CreateOrderRequest`, `OrderDto` | `OrdersController.Create` | potwierdzone |

## Walidacje I Błędy

| Warstwa | Walidacja / błąd | Zachowanie | Status |
|---|---|---|---|
| UI | pusty koszyk | przekierowanie do `/cart` | potwierdzone |
| UI | produkt nieaktywny, brak stocku, zmiana ceny/min qty | korekta koszyka, komunikat i blokada bieżącego submitu | potwierdzone |
| UI | brak `userId` przy PrePaid | komunikat `Unable to identify current user` | potwierdzone |
| UI | błąd Razorpay script/init/verify | komunikat błędu, `loading=false` | potwierdzone |
| Backend order | `PaymentMode` musi być enumem | walidacja FluentValidation | potwierdzone |
| Backend order | `Lines` niepuste | walidacja FluentValidation | potwierdzone |
| Backend order line | `ProductId`, `ProductName`, `Sku`, `Quantity`, `UnitPrice`, `MinOrderQty` | walidacja FluentValidation | potwierdzone |
| Backend stock | soft-lock false | `InvalidOperationException` i brak zapisu orderu | potwierdzone |
| Backend credit | credit rejected | order zapisany jako hold i saga awaiting manual approval | potwierdzone |
| Integracja payment | `AddOutstandingAsync` po zapisie orderu może się nie udać | order zostaje zapisany wcześniej | ryzyko potwierdzone |

## Model Danych

| Pole / decyzja | Tabela | Kolumna | R/W | Status |
|---|---|---|---|---|
| Dealer z tokenu | `Orders` | `DealerId` | zapis | potwierdzone |
| Numer zamówienia | `Orders` | `OrderNumber` | zapis | potwierdzone |
| Metoda płatności | `Orders` | `PaymentMode` | zapis | potwierdzone |
| Suma koszyka | `Orders` | `TotalAmount` | zapis | potwierdzone |
| Status credit/order | `Orders` | `Status`, `CreditHoldStatus` | zapis | potwierdzone |
| Pozycje koszyka | `OrderLines` | `ProductId`, `ProductName`, `Sku`, `Quantity`, `UnitPrice` | zapis | potwierdzone |
| Line total | brak | brak | wyliczane | potwierdzone |
| Stock produktu | `Products` | `TotalStock`, `ReservedStock`, `IsActive`, `UnitPrice`, `MinOrderQty` | odczyt UI i zapis soft-lock | potwierdzone |
| Transakcja stocku | `StockTransactions` | `TransactionType`, `Quantity`, `ReferenceId`, `ProductId` | zapis | potwierdzone |
| Konto kredytowe | `DealerCreditAccounts` | `CreditLimit`, `CurrentOutstanding` | odczyt i zapis outstanding | potwierdzone |
| Payment gateway record | `PaymentRecords` | `OrderId`, `DealerId`, `PaymentMode`, `Amount`, `ReferenceNo` | zapis po verify | potwierdzone |
| Saga | `OrderSagaStates` | `CurrentState`, `LastMessage`, `UpdatedAtUtc` | zapis | potwierdzone |
| Outbox | `OutboxMessages` | `EventType`, `Payload`, `Status` | zapis | potwierdzone |

## Relacje

| Relacja | Typ | Status |
|---|---|---|
| `OrderLines.OrderId -> Orders.OrderId` | fizyczna FK | potwierdzone |
| `OrderStatusHistory.OrderId -> Orders.OrderId` | fizyczna FK | potwierdzone |
| `Orders.DealerId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy |
| `OrderLines.ProductId -> CatalogInventory.Products.ProductId` | logiczna między bazami | wniosek z analizy |
| `DealerCreditAccounts.DealerId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy |
| `PaymentRecords.OrderId -> Orders.OrderId` | logiczna między bazami; `Guid.Empty` dla gateway verify | potwierdzone jako ryzyko |

## Testy I Luki

| Obszar | Istniejące pokrycie | Brak / luka | Priorytet |
|---|---|---|---|
| Domena order | testy `OrderAggregateTests` dla przejść statusów i credit reject | brak testu pełnego `CreateOrderAsync` z soft-lock + credit + outbox + saga | P0 |
| Inventory | testy domenowe produktu i stocku | brak testu integracyjnego soft-lock przez internal API | P1 |
| Payment | testy domenowe `DealerCreditAccount` | brak testu spójności gateway verify -> późniejszy order | P0 |
| Frontend | smoke i `OrderSlaService` | brak testu `CheckoutComponent` dla COD/PrePaid/błędów stocku | P1 |
| E2E | brak znalezionego pełnego checkout E2E | brak Playwright/API E2E checkout | P0 |

## Ryzyka

| Ryzyko | Dowód | Skutek | Status |
|---|---|---|---|
| `idempotencyKey` jest wysyłany z UI, ale nie widać użycia w `OrderService.CreateOrderAsync` | `checkout.component.ts:108-115`, `OrderService.cs:38-128` | możliwe duplikaty zamówień przy retry | do potwierdzenia |
| `PrePaid` najpierw zapisuje payment record z `OrderId = Guid.Empty`, potem tworzy order | `PaymentInvoiceService.cs:248-252`, `checkout.component.ts:199-216` | płatność może nie być powiązana z orderem | potwierdzone jako ryzyko |
| Backend wykonuje credit check także dla `COD`, choć UI pokazuje go tylko dla `PrePaid` | `checkout.component.ts:63-73`, `OrderService.cs:62` | UX może sugerować inną regułę niż backend | potwierdzone jako rozjazd |
| `AddOutstandingAsync` jest po `SaveChangesAsync` orderu | `OrderService.cs:95-107` | brak transakcyjności między mikroserwisami | potwierdzone jako ryzyko |
| Brak pełnego testu checkout | testy domenowe istnieją, brak E2E | regresje mogą przejść niewykryte | potwierdzone |
