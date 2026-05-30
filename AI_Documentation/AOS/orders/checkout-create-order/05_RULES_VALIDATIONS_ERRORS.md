# AOS Checkout Create Order - Rules Validations Errors

## Cel Pliku

Ten plik zbiera reguły biznesowe, walidacje i komunikaty błędów związane z checkoutem i utworzeniem zamówienia.

## Reguły Biznesowe

| ID reguły | Opis biznesowy | Warunek | Wynik gdy spelniona | Wynik gdy naruszona | Egzekwowana w kodzie | Test |
|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-RULE-001` | Tylko Dealer może złożyć zamówienie z checkoutu. | User role = Dealer | Dostęp do `/checkout` i `POST /orders/api/orders` | 403/unauthorized | `app.routes.ts`, `OrdersController.Create` | `E2E-002`, `API-TC-004` |
| `AOS-ORD-CHECKOUT-RULE-002` | Koszyk musi mieć co najmniej jedna pozycję. | `cartStore.items().length > 0`, `Lines.NotEmpty()` | Mozna probowac złożyć zamówienie | redirect/no-op/validation error | `CheckoutComponent`, `CreateOrderRequestValidator` | `TC-002` |
| `AOS-ORD-CHECKOUT-RULE-003` | Ilość pozycji musi być dodatnia i zgodna z MOQ. | `quantity > 0` i `quantity >= minOrderQty` | Linia może być zapisana | validation/domain exception | `CartStore`, `CreateOrderRequestValidator`, `OrderLine.Create` | `API-TC-002` |
| `AOS-ORD-CHECKOUT-RULE-004` | Produkt musi być aktywny i mieć dostępny stock. | `product.isActive && availableStock > 0` | Item zostaje w koszyku | Item usunięty/order niewysłany albo soft-lock failed | `validateCartAgainstCurrentStock`, `CatalogInventoryService.SoftLockStockAsync` | `TC-003`, `API-TC-005` |
| `AOS-ORD-CHECKOUT-RULE-005` | Credit approved przesuwa order do `Processing`. | `CreditCheckResult.Approved == true` | Status `Processing`, credit hold `Approved`, outbox `OrderPlaced` | n/a | `OrderService.CreateOrderAsync` | `API-TC-001` |
| `AOS-ORD-CHECKOUT-RULE-006` | Credit failed/niedostępny przesuwa order do `OnHold`. | `Approved == false` | Status `OnHold`, credit hold `PendingApproval`, outbox `AdminApprovalRequired` | n/a | `OrderService.CreateOrderAsync`, `PaymentCreditCheckGateway` fallback | `API-TC-006` |
| `AOS-ORD-CHECKOUT-RULE-007` | Soft-lock musi przejść dla wszystkich linii. | Każdy `SoftLockStockAsync` zwraca true | Order może być zapisany | exception `Unable to reserve stock...` | `SoftLockOrderStockAsync` | `API-TC-005` |

## Walidacje Frontendu

| ID | Pole/akcja | Regula | Komunikat UI | Blokuje request? | Źródło w kodzie |
|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-VFE-001` | Wejscie na checkout | Koszyk pusty | Brak, redirect `/cart` | Tak | `ngOnInit()` |
| `AOS-ORD-CHECKOUT-VFE-002` | Place Order | Koszyk pusty | Brak, return | Tak | `placeOrder()` |
| `AOS-ORD-CHECKOUT-VFE-003` | Cart item | Product missing/inactive/no stock | `All cart items are unavailable now...` albo stock changed | Tak | `validateCartAgainstCurrentStock()` |
| `AOS-ORD-CHECKOUT-VFE-004` | Cart item quantity | Normalizacja wg MOQ i available stock | `Cart updated due to stock changes...` | Tak, przy zmianie | `CartStore.normalizeQuantity`, `validateCartAgainstCurrentStock()` |
| `AOS-ORD-CHECKOUT-VFE-005` | PrePaid payment | Razorpay script/order/verify musi się udac | Rozne komunikaty payment error | Tak | `startGatewayPaymentFlow`, `verifyGatewayPayment` |

## Walidacje Backendu

| ID | DTO / encja | Regula | Status HTTP | Kod błędu | Źródło w kodzie |
|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-VBE-001` | `CreateOrderRequest.PaymentMode` | `IsInEnum()` | 400 | validation | `CreateOrderRequestValidator` |
| `AOS-ORD-CHECKOUT-VBE-002` | `CreateOrderRequest.Lines` | NotNull, NotEmpty | 400 | validation | `CreateOrderRequestValidator` |
| `AOS-ORD-CHECKOUT-VBE-003` | `CreateOrderLineRequest` | ProductId not empty, ProductName not empty max 220, Sku not empty max 60, Quantity > 0, UnitPrice > 0, MinOrderQty > 0 | 400 | validation | `CreateOrderRequestValidator` |
| `AOS-ORD-CHECKOUT-VBE-004` | `OrderLine` | `quantity > 0`, `quantity >= minOrderQty`, `unitPrice > 0` | 500/exception unless mapped | domain exception | `OrderLine.Create` |
| `AOS-ORD-CHECKOUT-VBE-005` | Internal stock | Product exists, active, available stock >= quantity | 409 from Catalog internal; 500/exception through Order | `Stock soft-lock failed` / `Unable to reserve stock...` | `CatalogInventoryService.SoftLockStockAsync`, `OrderService` |
| `AOS-ORD-CHECKOUT-VBE-006` | Internal API key | Header `X-Internal-Api-Key` matches config | 401 | `Invalid internal API key.` | `InternalInventoryController`, `PaymentController` |

## Uprawnienia I Scope Danych

| ID | Rola | Co wolno | Co zabronione | Jak egzekwowane | Test |
|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-AUTH-001` | Dealer | `/checkout`, `POST /orders/api/orders`, public product detail przez protected UI | Dostęp do admin/warehouse/logistics checkout | `roleGuard`, `[Authorize(Roles="Dealer")]` | `E2E-002`, `API-TC-004` |
| `AOS-ORD-CHECKOUT-AUTH-002` | Dealer | Credit-check tylko dla własnego `dealerId` | Credit-check innego dealera | `PaymentController.EnsureDealerScope` | `API-TC-003` |
| `AOS-ORD-CHECKOUT-AUTH-003` | Internal service | Soft-lock i internal credit/outstanding | Wywolanie bez internal key | `IsAuthorizedInternalCall()` | `API-TC-007` |

## Komunikaty Bledow

| ID błędu | Warunek | Warstwa | HTTP | Payload | Komunikat UI | Retryable |
|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-ERR-001` | Stock validation API error | UI/Catalog | n/a | n/a | `Unable to validate stock right now. Please try again.` | true |
| `AOS-ORD-CHECKOUT-ERR-002` | Wszystkie itemy niedostępne | UI | n/a | n/a | `All cart items are unavailable now. Please add products again.` | false |
| `AOS-ORD-CHECKOUT-ERR-003` | Stock/cena/MOQ zmienione | UI | n/a | n/a | `Cart updated due to stock changes. Review and place order again.` | false |
| `AOS-ORD-CHECKOUT-ERR-004` | Brak current user dla PrePaid | UI | n/a | n/a | `Unable to identify current user. Please login again.` | false |
| `AOS-ORD-CHECKOUT-ERR-005` | Razorpay script failed | UI | n/a | n/a | `Failed to load payment gateway script.` | true |
| `AOS-ORD-CHECKOUT-ERR-006` | Payment verify failed | UI/Payment | 200 verified false albo API error | `failureReason` | `Payment verification failed.` albo `Unable to verify payment. Please contact support.` | depends |
| `AOS-ORD-CHECKOUT-ERR-007` | Order API error | UI/Order | any | `err.error?.messąge` | backend messąge albo `Failed to place order. Please try again.` | depends |

## Stany Brzegowe

| ID | Sytuacja | Oczekiwane zachowanie | Warstwa odpowiedzialna | Test |
|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-EDGE-001` | Koszyk zmieniony w innej karcie przed checkout | Checkout czyta aktualny `localStorage` przy starcie store | Front | `E2E suggested` |
| `AOS-ORD-CHECKOUT-EDGE-002` | Jeden z wielu soft-lockow fails | Wczesniejsze soft-locki są release best-effort po stronie Order service | Backend Order/Catalog | `API-TC-005` |
| `AOS-ORD-CHECKOUT-EDGE-003` | Payment service niedostępny przy backend credit-check | `PaymentCreditCheckGateway` zwraca failed credit, order OnHold | Backend Order | `API-TC-006` |
| `AOS-ORD-CHECKOUT-EDGE-004` | Dealer klika Place Order kilka razy szybko | Button disabled po `loading=true`, ale brak backend idempotency | UI/backend | `TC-007` |

## Niespójnośći I Ryzyka

| ID | Opis | Dowod | Wpływ | Rekomendacja |
|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-RISK-001` | `idempotencyKey` nie jest widocznie użyty w backend create order. | DTO + `CheckoutComponent.submitOrder`, brak użycia w `OrderService.CreateOrderAsync`. | Duplikaty przy retry/odswiezeniu. | Dodać idempotency behavior albo unikalny indeks/record. |
| `AOS-ORD-CHECKOUT-RISK-002` | Backend ufa cenie i nazwie z klienta. | `OrderService.CreateOrderAsync` dodaje linie z requestu. | Manipulacja kwotą zamówienia. | Backend powinien potwierdzić produkt i cenę w Catalog. |
| `AOS-ORD-CHECKOUT-RISK-003` | Note z koszyka nie trafia do order. | `CartItem.note` wyświetlane, brak pola w `CreateOrderLineRequest`. | Utrata danych. | Decyzja biznesowa: usunac note z UI albo dodać do order. |
