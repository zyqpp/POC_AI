# AOS Checkout Create Order - Actions And Process Trace

## Cel Pliku

Ten plik mapuje akcje uzytkownika na przeplyw systemowy od ekranu checkout do zapisu zamowienia i danych zaleznych.

## Macierz Akcji

| ID akcji | Nazwa UI | Trigger | Metoda front | API | Proces backend | Skutek danych | Testy |
|---|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-ACT-002` | Zmiana metody platnosci | radio change | `onPaymentChange()` | `GET /payments/api/payment/dealers/{dealerId}/credit-check` dla `PrePaid` | `PaymentInvoiceService.CheckCreditAsync` | Czyta/tworzy `DealerCreditAccounts` | `AOS-ORD-CHECKOUT-API-TC-003` |
| `AOS-ORD-CHECKOUT-ACT-003` | Place Order | button click | `placeOrder()` -> `submitOrder()` | `GET /catalog/api/products/{id}`, opcjonalnie payment gateway, `POST /orders/api/orders` | `OrderService.CreateOrderAsync` | `Orders`, `OrderLines`, `OrderStatusHistory`, `OutboxMessages`, `OrderSagaStates`, `Products.ReservedStock`, `StockTransactions`, `DealerCreditAccounts`, `PaymentRecords` | `AOS-ORD-CHECKOUT-TC-001..007` |

## `AOS-ORD-CHECKOUT-ACT-003` - Place Order

### Cel Biznesowy

Dealer potwierdza koszyk i tworzy zamowienie. System ma zabezpieczyc proces przed nieaktualnym stockiem/cena po stronie UI oraz przed brakiem rezerwacji stocku i brakiem kredytu po stronie backendu.

### Warunki Dostepnosci W UI

| Warunek | Zrodlo | Co jesli niespelniony |
|---|---|---|
| Uzytkownik zalogowany | `authGuard` | Brak dostepu do shell routes |
| Rola `Dealer` | `roleGuard`, `app.routes.ts` | Redirect/unauthorized wedlug guard |
| Koszyk niepusty | `ngOnInit()` i `placeOrder()` | Przekierowanie do `/cart` albo no-op |
| `loading() == false` | `[disabled]="loading()"` | Button disabled |

### Przeplyw Techniczny

```mermaid
sequenceDiagram
    participant User as Dealer
    participant UI as CheckoutComponent
    participant Cart as CartStore/localStorage
    participant Catalog as Catalog API
    participant Pay as Payment API / Razorpay
    participant OrderApi as Order API
    participant OrderSvc as OrderService
    participant Inv as Catalog Internal Inventory
    participant PayInternal as Payment Internal Credit
    participant Db as SQL Databases

    User->>UI: click Place Order
    UI->>Cart: read items,total,paymentMode
    UI->>Catalog: GET /catalog/api/products/{id} per item
    Catalog-->>UI: ProductDto with price,MOQ,stock,isActive
    alt cart changed
        UI->>Cart: remove/update items
        UI-->>User: warning + error
    else PrePaid
        UI->>Pay: create gateway order + verify payment
        Pay-->>UI: verified
    end
    UI->>OrderApi: POST /orders/api/orders
    OrderApi->>OrderSvc: CreateOrderCommand
    OrderSvc->>Db: create OrderAggregate + OrderLines in memory
    OrderSvc->>Inv: internal soft-lock per product
    Inv->>Db: Products.ReservedStock, StockTransactions, OutboxMessages
    OrderSvc->>PayInternal: internal credit-check
    PayInternal->>Db: DealerCreditAccounts read/create
    OrderSvc->>Db: Orders, OrderLines, history/outbox
    OrderSvc->>PayInternal: add outstanding if credit approved
    PayInternal->>Db: DealerCreditAccounts, PaymentRecords
    OrderSvc->>Db: OrderSagaStates
    OrderApi-->>UI: 201 OrderDto
    UI->>Cart: clear()
    UI-->>User: toast + navigate /orders/{orderId}
```

### Kroki Procesu

| Krok | Warstwa | Co sie dzieje | Zrodlo w kodzie | Dane wejscia | Dane wyjscia |
|---|---|---|---|---|---|
| 1 | UI | Jesli koszyk pusty, stop/przekierowanie | `checkout.component.ts` | `cartStore.items()` | `/cart` albo kontynuacja |
| 2 | UI | Walidacja koszyka przez aktualne dane produktu | `validateCartAgainstCurrentStock()` | `CartItem[]` | `valid=true/false`, ewentualna aktualizacja koszyka |
| 3 | UI/API | Dla kazdej pozycji pobranie produktu | `CatalogApiService.getProductById()` | `productId` | `ProductDto` |
| 4 | UI | Dla `PrePaid` zaladowanie Razorpay, utworzenie gateway order i weryfikacja platnosci | `startGatewayPaymentFlow()`, `verifyGatewayPayment()` | `total`, dane Razorpay | `verified=true/false` |
| 5 | UI/API | Zbudowanie `CreateOrderRequest` i POST | `submitOrder()`, `OrderApiService.createOrder()` | `paymentMode`, `idempotencyKey`, `lines` | `OrderDto` albo blad |
| 6 | API | Pobranie `DealerId` z tokenu i wyslanie komendy | `OrdersController.Create()` | JWT sub/nameidentifier, request body | `CreateOrderCommand` |
| 7 | Application | Walidacja requestu | `CreateOrderRequestValidator` | `CreateOrderRequest` | OK albo FluentValidation exception |
| 8 | Domain | Utworzenie agregatu i linii | `OrderAggregate.Create()`, `OrderAggregate.AddLine()` | DealerId, orderNumber, paymentMode, lines | `OrderAggregate` z `TotalAmount` |
| 9 | Integration | Soft-lock stocku dla kazdej pozycji | `SoftLockOrderStockAsync()`, `CatalogInventoryGateway.SoftLockStockAsync()` | `orderId`, `productId`, `quantity` | true/false |
| 10 | Catalog service | Rezerwacja stocku | `CatalogInventoryService.SoftLockStockAsync()` | `SoftLockStockRequest` | `Products.ReservedStock`, `StockTransactions`, outbox |
| 11 | Integration | Credit-check | `PaymentCreditCheckGateway.CheckCreditAsync()` | `dealerId`, `totalAmount` | `CreditCheckResult` |
| 12 | Domain | Credit approved: `Processing`; credit failed: `OnHold` | `MarkCreditApproved()`, `TransitionTo()`, `MarkCreditHold()` | `CreditCheckResult` | status, creditHoldStatus, history dla approved |
| 13 | Persistence | Zapis zamowienia i outboxa | `OrderRepository.AddOrderAsync()`, `SaveChangesAsync()` | `OrderAggregate` | SQL rows |
| 14 | Integration | Jesli credit approved: dodanie outstanding | `PaymentCreditCheckGateway.AddOutstandingAsync()` | dealer/order/amount/paymentMode | `DealerCreditAccounts`, `PaymentRecords` |
| 15 | Saga | Start i finalizacja sagi | `OrderSagaCoordinator` | orderId, orderNumber, dealerId | `OrderSagaStates` |
| 16 | UI | Sukces | `submitOrder().next` | `OrderDto` | clear cart, clear draft, toast, navigate |

### Reguly Biznesowe W Procesie

| ID reguly | Opis | Gdzie egzekwowana | Blad gdy naruszona |
|---|---|---|---|
| `AOS-ORD-CHECKOUT-RULE-001` | Checkout jest tylko dla `Dealer`. | `app.routes.ts`, `OrdersController.Create [Authorize(Roles="Dealer")]` | frontend redirect/403; backend 403 |
| `AOS-ORD-CHECKOUT-RULE-002` | Koszyk nie moze byc pusty. | `ngOnInit()`, `placeOrder()`, `CreateOrderRequestValidator.Lines.NotEmpty()` | redirect/no-op albo 400 validation |
| `AOS-ORD-CHECKOUT-RULE-003` | Produkt musi byc aktywny i miec stock. | frontend `validateCartAgainstCurrentStock()`, backend Catalog soft-lock | UI aktualizuje koszyk; backend zwraca failure soft-lock |
| `AOS-ORD-CHECKOUT-RULE-004` | Ilosc musi byc dodatnia i nie mniejsza niz MOQ. | `CartStore.normalizeQuantity()`, `CreateOrderRequestValidator`, `OrderLine.Create()` | UI normalizuje; backend validation/exception |
| `AOS-ORD-CHECKOUT-RULE-005` | Credit-check decyduje czy zamowienie idzie do `Processing` czy `OnHold`. | `OrderService.CreateOrderAsync()` | OnHold + outbox `AdminApprovalRequired` |

### Efekty Uboczne

| Typ | Opis | Zrodlo |
|---|---|---|
| Local storage | Odczyt koszyka `sc_cart`, zapis draftu `sc_checkout_draft`, clear po sukcesie | `CartStore`, `CheckoutComponent` |
| Event/outbox Order | `OrderPlaced` albo `AdminApprovalRequired` | `OrderService.CreateOrderAsync()` |
| Event/outbox Catalog | `StockSoftLocked` | `CatalogInventoryService.SoftLockStockAsync()` |
| Event/outbox Payment | `PaymentCaptured` / `PaymentFailed` dla Razorpay verify | `PaymentInvoiceService.VerifyGatewayPaymentAsync()` |
| Integracja HTTP | Order -> Catalog internal inventory | `CatalogInventoryGateway` |
| Integracja HTTP | Order -> Payment internal credit/outstanding | `PaymentCreditCheckGateway` |
| Cache | Soft-lock key `inventory:softlock:{productId}:{orderId}` i invalidacja cache product list/detail/search | `CatalogInventoryService` |
| UI refresh | Przekierowanie na `/orders/{orderId}` | `CheckoutComponent.submitOrder()` |

### Scenariusze Bledu

| Sytuacja | Warstwa | Status / komunikat | Zachowanie UI | Test |
|---|---|---|---|---|
| Brak tokenu / invalid token | Order API | 401 `{ message: "Invalid token." }` | Pokazuje `Invalid token.` albo fallback | `AOS-ORD-CHECKOUT-API-TC-004` |
| Rola inna niz Dealer | Front/backend | 403 | Brak dostepu / error | `AOS-ORD-CHECKOUT-E2E-002` |
| Product not found/ inactive / no stock | UI/Catalog | frontend message | Koszyk usuniety/zmieniony, order nie wyslany | `AOS-ORD-CHECKOUT-TC-003` |
| Soft-lock nieudany | Backend Order/Catalog | Exception `Unable to reserve stock...` | Alert z backend message albo fallback | `AOS-ORD-CHECKOUT-API-TC-005` |
| Credit-check niedostepny | Backend Order/Payment | fallback `CreditCheckResult(false,0,0,0)` | Order zapisany jako `OnHold` | `AOS-ORD-CHECKOUT-API-TC-006` |
| Payment gateway niedostepny | UI/Payment | `Failed to load/init/verify...` | Order nie jest wyslany | `AOS-ORD-CHECKOUT-E2E-003` |

## Algorytm

```text
1. Dealer klika Place Order.
2. Jezeli koszyk pusty, zakoncz.
3. Dla kazdego itemu pobierz ProductDto z Catalog.
4. Jezeli produkt nie istnieje, jest nieaktywny albo stock <= 0, usun item.
5. Przelicz quantity wg minOrderQty i availableStock.
6. Jezeli cena, SKU, nazwa, MOQ albo stock zmienily sie, zaktualizuj item i przerwij proces.
7. Jezeli paymentMode = PrePaid, wykonaj Razorpay create order i verify.
8. Zbuduj CreateOrderRequest i wyslij POST /orders/api/orders.
9. Backend waliduje request.
10. Backend tworzy OrderAggregate i OrderLines.
11. Backend soft-lockuje stock w Catalog dla kazdego productId.
12. Backend sprawdza credit w Payment.
13. Jezeli credit approved, przejdz Placed -> Processing i dodaj outbox OrderPlaced.
14. Jezeli credit rejected/unavailable, ustaw OnHold i dodaj outbox AdminApprovalRequired.
15. Backend zapisuje Orders, OrderLines, history/outbox.
16. Jezeli credit approved, Payment dostaje outstanding dla orderId.
17. Backend tworzy/aktualizuje OrderSagaStates.
18. Front czysci koszyk i draft, pokazuje toast, przechodzi do /orders/{orderId}.
```
