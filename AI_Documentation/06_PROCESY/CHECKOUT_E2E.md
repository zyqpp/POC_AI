# Proces End-To-End: Checkout

Status: `potwierdzone` dla ścieżek kodowych, `do potwierdzenia` dla decyzji biznesowych w ryzykach.
Powiązany AOS: `AI_Documentation/05_UI_AOS/AOS_CHECKOUT.md`.

## Happy Path COD

| Krok | Warstwa | Działanie | Dane / efekt | Status |
|---:|---|---|---|---|
| 1 | Angular | Dealer wchodzi na `/checkout`; route wymaga `Dealer`. | brak zapisu | potwierdzone |
| 2 | Angular | `validateCartAgainstCurrentStock()` odczytuje każdy produkt. | odczyt `Products` przez `GET /catalog/api/products/{id}` | potwierdzone |
| 3 | Angular | `submitOrder()` wysyła `CreateOrderRequest`. | `paymentMode`, `idempotencyKey`, `lines[]` | potwierdzone |
| 4 | Order API | `OrdersController.Create` pobiera `userId` z tokenu i wysyła `CreateOrderCommand`. | `dealerId` z JWT | potwierdzone |
| 5 | Order Application | `CreateOrderRequestValidator` waliduje request. | walidacja linii i enumu | potwierdzone |
| 6 | Order Domain | `OrderAggregate.Create` i `AddLine` budują agregat. | `Orders`, `OrderLines` kandydacko | potwierdzone |
| 7 | Order -> Inventory | `SoftLockOrderStockAsync` blokuje stock per `ProductId`. | `Products.ReservedStock`, `StockTransactions` | potwierdzone |
| 8 | Order -> Payment | `CheckCreditAsync` sprawdza konto dealera. | `DealerCreditAccounts` | potwierdzone |
| 9 | Order DB | Przy credit approved order przechodzi do `Processing` i zapisuje `OrderPlaced`. | `Orders`, `OrderLines`, `OutboxMessages` | potwierdzone |
| 10 | Payment DB | `AddOutstandingAsync` zwiększa outstanding po zapisie orderu. | `DealerCreditAccounts.CurrentOutstanding` | potwierdzone |
| 11 | Order DB | Saga przechodzi do `CompletedApproved`. | `OrderSagaStates` | potwierdzone |
| 12 | Angular | UI czyści koszyk i przechodzi do `/orders/{orderId}`. | `sc_cart` i `sc_checkout_draft` czyszczone | potwierdzone |

## Happy Path PrePaid

| Krok | Różnica wobec COD | Status |
|---:|---|---|
| 1 | UI pokazuje credit check tylko po wyborze `PrePaid`. | potwierdzone |
| 2 | UI ładuje `https://checkout.razorpay.com/v1/checkout.js`. | potwierdzone |
| 3 | UI tworzy gateway order przez `POST /payments/api/payment/gateway/orders`. | potwierdzone |
| 4 | UI weryfikuje płatność przez `POST /payments/api/payment/gateway/verify`. | potwierdzone |
| 5 | Po pozytywnej weryfikacji UI dopiero wysyła `POST /orders/api/orders`. | potwierdzone |
| 6 | Backend order wykonuje ten sam soft-lock i credit check co dla COD. | potwierdzone |

## Ścieżki Błędów I Kompensacje

| Sytuacja | Zachowanie | Dane / efekt | Status |
|---|---|---|---|
| Koszyk pusty | UI przekierowuje do `/cart`. | brak zapisu | potwierdzone |
| Produkt nieaktywny albo bez stocku | UI usuwa pozycję i blokuje bieżące złożenie orderu. | zmiana `sc_cart` | potwierdzone |
| Cena/min qty/stock zmienione | UI aktualizuje koszyk i każe ponownie zatwierdzić. | zmiana `sc_cart` | potwierdzone |
| Soft-lock nieudany | `OrderService` rzuca `InvalidOperationException`; order nie jest zapisany. | brak `Orders`; możliwe częściowe soft-locki zwalniane best-effort | potwierdzone |
| Częściowy soft-lock | `ReleaseSoftLocksBestEffortAsync` próbuje zwolnić już założone locki. | internal inventory release | potwierdzone |
| Credit rejected | order jest zapisany jako hold, outbox `AdminApprovalRequired`, saga `AwaitingManualApproval`. | `Orders`, `OutboxMessages`, `OrderSagaStates` | potwierdzone |
| Razorpay script/order/verify fail | UI pokazuje błąd i nie wysyła `POST /orders/api/orders`. | ewentualnie `PaymentFailed` w Payment outbox przy negatywnej weryfikacji | potwierdzone |
| `AddOutstandingAsync` fail po zapisie orderu | brak widocznej kompensacji orderu w `CreateOrderAsync`. | order może pozostać zapisany bez outstanding | ryzyko potwierdzone |

## Outbox I Saga

| Zdarzenie / stan | Kiedy powstaje | Tabela | Status |
|---|---|---|---|
| `OrderPlaced` | credit approved | Order DB `OutboxMessages` | potwierdzone |
| `AdminApprovalRequired` | credit rejected | Order DB `OutboxMessages` | potwierdzone |
| `PaymentCaptured` | pozytywna weryfikacja gateway | Payment DB `OutboxMessages` | potwierdzone |
| `PaymentFailed` | negatywna weryfikacja gateway | Payment DB `OutboxMessages` | potwierdzone |
| `StockSoftLocked` | soft-lock inventory | Catalog DB `OutboxMessages` | potwierdzone |
| `OrderSagaStates.CompletedApproved` | credit approved po starcie sagi | Order DB `OrderSagaStates` | potwierdzone |
| `OrderSagaStates.AwaitingManualApproval` | credit rejected | Order DB `OrderSagaStates` | potwierdzone |

## Luki Procesu

| Luka | Skutek | Rekomendacja | Priorytet |
|---|---|---|---|
| Brak transakcji rozproszonej między Order i Payment dla outstanding | order może być zapisany mimo błędu payment integration | opisać kompensację albo dodać test/monitoring integracji | P0 |
| `PaymentRecord.OrderId = Guid.Empty` przy gateway verify | trudne powiązanie płatności z późniejszym orderem | ustalić docelowy model korelacji payment-order | P0 |
| `idempotencyKey` bez widocznego użycia w order service | retry może utworzyć duplikat | potwierdzić zamiar i opisać/naprawić w osobnym zadaniu | P1 |
| Brak pełnego testu E2E checkout | regresje procesu nie są chronione | dodać test API/E2E dla COD i PrePaid | P0 |
