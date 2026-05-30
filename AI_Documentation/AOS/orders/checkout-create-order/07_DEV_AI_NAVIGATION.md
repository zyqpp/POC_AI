# AOS Checkout Create Order - Dev AI Navigation

## Cel Pliku

Ten plik jest mapa dla developera i agenta AI. Pokazuje gdzie zaczac analize checkoutu i jak potwierdzac fakty bez zgadywania.

## Punkty Startowe

| Obszar | Plik / symbol | Po co otworzyc |
|---|---|---|
| Route frontendu | `supply-chain-frontend/src/app/app.routes.ts` | Potwierdzic `/checkout`, role `Dealer`, guard |
| Komponent | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.ts` | Logika payment, stock validation, submit |
| Template | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` | Pola, przyciski, komunikaty |
| Cart store | `supply-chain-frontend/src/app/core/stores/cart.store.ts` | Zrodlo koszyka, quantity normalization, localStorage |
| Order API TS | `supply-chain-frontend/src/app/core/api/order-api.service.ts` | `POST /orders/api/orders` |
| Catalog API TS | `supply-chain-frontend/src/app/core/api/catalog-api.service.ts` | Product refresh przed order |
| Payment API TS | `supply-chain-frontend/src/app/core/api/payment-api.service.ts` | Credit-check i gateway flow |
| Modele TS | `order.models.ts`, `catalog.models.ts`, `payment.models.ts`, `enums.ts` | Kontrakty frontendu |
| Gateway | `gateway/OcelotGateway/ocelot.json` | Trasy `/orders`, `/catalog`, `/payments` |
| Controller Order | `services/Order/Order.API/Controllers/OrdersController.cs` | Auth, status HTTP, user id |
| Command | `services/Order/Order.Application/Features/Orders/Commands/OrderCommands.cs` | Wejscie do use case |
| Order service | `services/Order/Order.Application/Services/OrderService.cs` | Glowna logika procesu |
| Domain Order | `OrderAggregate.cs`, `OrderLine.cs`, `OrderStatusHistory.cs` | Reguly statusu i linii |
| Order DB | `services/Order/Order.Infrastructure/Persistence/OrderDbContext.cs` | Tabele SQL i kolumny |
| Order repository | `services/Order/Order.Infrastructure/Repositories/OrderRepository.cs` | Add order, outbox, queries |
| Inventory integration | `CatalogInventoryGateway.cs`, `InternalInventoryController.cs`, `CatalogInventoryService.cs` | Soft-lock stocku |
| Payment integration | `PaymentCreditCheckGateway.cs`, `PaymentController.cs`, `PaymentInvoiceService.cs` | Credit-check i outstanding |

## Sciezka Analizy Dla Nowej Zmiany

1. Zacznij od `app.routes.ts`, potwierdz role i route.
2. Otworz `checkout.component.html`, wypisz widoczne pola i akcje.
3. Otworz `checkout.component.ts`, znajdz metody `onPaymentChange`, `placeOrder`, `validateCartAgainstCurrentStock`, `submitOrder`.
4. Otworz `CartStore`, bo to zrodlo danych UI i localStorage.
5. Otworz `OrderApiService.createOrder` i `order.models.ts`.
6. Dopasuj `/orders/api/orders` do `ocelot.json`.
7. Otworz `OrdersController.Create`, sprawdz auth i pobranie DealerId.
8. Przejdz do `CreateOrderCommandHandler`.
9. Przejdz do `OrderService.CreateOrderAsync`.
10. Dla reguly linii wejdz w `OrderAggregate` i `OrderLine`.
11. Dla SQL wejdz w `OrderDbContext` i encje.
12. Dla stocku przejdz z `SoftLockOrderStockAsync` do `CatalogInventoryGateway`, potem `InternalInventoryController`, `CatalogInventoryService`, `CatalogInventoryDbContext`.
13. Dla creditu przejdz z `PaymentCreditCheckGateway` do `PaymentController` i `PaymentInvoiceService`, potem `PaymentInvoiceDbContext`.
14. Dopiero po tej sciezce aktualizuj AOS.

## Fakty Do Potwierdzenia Przy Kazdej Aktualizacji

| Fakt | Jak potwierdzic | Gdzie zapisac |
|---|---|---|
| Czy Dealer ma dostep do checkout | `app.routes.ts`, `OrdersController.Create` | `00`, `01`, `05` |
| Jakie pola widzi uzytkownik | `checkout.component.html` | `01` |
| Jak jest budowany request | `submitOrder()` + `order.models.ts` | `02`, `03`, `04` |
| Czy backend ufa requestowi | `OrderService.CreateOrderAsync` | `04`, `05` |
| Jakie tabele SQL sa zapisywane | `OrderDbContext`, `CatalogInventoryDbContext`, `PaymentInvoiceDbContext` | `04` |
| Jak sa walidowane linie | `OrderValidators`, `OrderLine.Create` | `05` |
| Jak stock jest blokowany | `SoftLockOrderStockAsync`, `CatalogInventoryService.SoftLockStockAsync` | `02`, `04`, `05` |
| Jak credit decyduje o statusie | `PaymentCreditCheckGateway`, `OrderService.CreateOrderAsync` | `02`, `04`, `05` |
| Jakie testy istnieja | `rg "...pattern..." tests supply-chain-frontend/src -g "*.spec.ts" -g "*.cs"` | `06` |

## Komendy Pomocnicze

```powershell
rg "checkout|createOrder|placeOrder|CreateOrder" supply-chain-frontend\src services -g "*.ts" -g "*.cs"
rg "CreateOrderRequest|OrderDto|PaymentMode" supply-chain-frontend\src services -g "*.ts" -g "*.cs"
rg "SoftLockStockAsync|CheckCreditAsync|AddOutstandingAsync" services -g "*.cs"
rg "ToTable\\(\"Orders|ToTable\\(\"OrderLines|ToTable\\(\"Products|ToTable\\(\"DealerCreditAccounts" services -g "*.cs"
rg "CheckoutComponent|CreateOrderRequest|CreateOrderAsync" tests supply-chain-frontend\src -g "*.cs" -g "*.spec.ts"
```

## Standard Dowodu W AOS

| Twierdzenie | Minimalny dowod |
|---|---|
| Checkout jest tylko dla Dealer | `app.routes.ts` + `OrdersController.Create [Authorize(Roles="Dealer")]` |
| Przycisk tworzy order | `checkout.component.html` click + `CheckoutComponent.placeOrder()` |
| Request ma konkretne pola | `order.models.ts` + `OrderDtos.cs` |
| Pole UI zapisuje sie w SQL | `submitOrder()` + `OrderService.CreateOrderAsync` + encja + `OrderDbContext` |
| Stock zmienia SQL | `CatalogInventoryService.SoftLockStockAsync` + `Product` + `CatalogInventoryDbContext` |
| Credit zmienia status | `PaymentCreditCheckGateway.CheckCreditAsync` + `OrderService.CreateOrderAsync` |

## Luki Dla Developera

| Luka | Objaw | Wplyw | Propozycja poprawki |
|---|---|---|---|
| Brak `data-testid` | Testy UI beda kruche | Sredni/wysoki | Dodac stale selektory do checkout |
| Backend ufa cenie z requestu | Manipulacja kwota | Wysoki | Backend pobiera price/SKU z Catalog albo uzywa podpisanego koszyka |
| `idempotencyKey` nieuzywany | Duplikaty | Wysoki | Implementowac idempotency dla CreateOrderCommand |
| Note nie jest zapisywana | Utrata danych | Sredni | Usunac z UI checkout albo dodac do kontraktu i DB |
