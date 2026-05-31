# Macierz Testów: `/orders/:id`

Status: `potwierdzone` dla istniejących testów znalezionych w repo; luki oznaczone priorytetem.
Zakres: szczegół zamówienia, lifecycle statusów, anulowanie, return, hold, role i UI.

## Istniejące Testy

| Test | Pokrywa | Źródło | Status |
|---|---|---|---|
| `OrderAggregateTests` | tworzenie orderu, dozwolone i niedozwolone przejścia statusów, `TotalAmount`, return po dostawie, okno return od dostawy, `MarkCreditRejected` | `tests/Order.Domain.Tests/UnitTest1.cs:10`, `UnitTest1.cs:65`, `UnitTest1.cs:94` | potwierdzone |
| `ApproveReturnAsync_WhenCompensationSucceeds_RestocksGroupedLinesSettlesCreditAndApproves` | approve return: restock, settle outstanding, status `ReturnApproved`, outbox, save | `tests/Order.Domain.Tests/OrderServiceReturnApprovalTests.cs:12-40` | potwierdzone |
| `ApproveReturnAsync_WhenRestockFails_ThrowsAndDoesNotSettleOrApprove` | approve return: błąd restock, brak settle, brak outbox, brak save | `tests/Order.Domain.Tests/OrderServiceReturnApprovalTests.cs:42-59` | potwierdzone |
| `ApproveReturnAsync_WhenCreditSettlementFails_ThrowsAndKeepsReturnRequested` | approve return: błąd settlement, status zostaje `ReturnRequested` | `tests/Order.Domain.Tests/OrderServiceReturnApprovalTests.cs:61-78` | potwierdzone |
| `OrderSlaService` frontend | SLA listy zamówień, nie szczegół `/orders/:id` | `supply-chain-frontend/src/app/core/services/order-sla.service.spec.ts` | potwierdzone jako poza zakresem |
| `smoke.spec.ts` frontend | smoke aplikacji, nie lifecycle zamówienia | `supply-chain-frontend/src/app/smoke.spec.ts` | potwierdzone jako poza zakresem |

## Luki P0

| Obszar | Brakujący test | Ryzyko, które zamyka | Kryterium akceptacji |
|---|---|---|---|
| API security | Dealer próbuje `POST /orders/{otherDealerOrderId}/cancel` i dostaje `404/403`, nie `200`. | Dealer cancel bez owner check. | Test najpierw powinien ujawnić lukę; po poprawce przechodzi. |
| Role consistency | `Warehouse` próbuje update status do `ReadyForDispatch`: UI/backend muszą być spójne. | UI pokazuje akcję, kontroler zwraca `403`. | Test definiuje oczekiwaną decyzję: albo UI nie pokazuje, albo API przepuszcza. |
| E2E order lifecycle | Od `Processing` do `Delivered`, request return i admin approve return przez API lub Playwright. | Brak pełnego procesu `/orders/:id`. | Test sprawdza statusy, historię, return request i outbox. |
| Cancel lifecycle | Admin cancel i Dealer own cancel zapisują `CancellationReason`, `OrderStatusHistory`, `OutboxMessages`, sagę. | Regresja danych przy anulowaniu. | DB/asercje serwisowe obejmują zapis i event. |

## Luki P1

| Obszar | Brakujący test | Ryzyko, które zamyka | Kryterium akceptacji |
|---|---|---|---|
| UI buttons | Test komponentu `OrderDetailComponent` dla widoczności przycisków per rola/status. | Regresja UX i niezgodność ról. | Macierz `Admin/Dealer/Warehouse/Logistics` x statusy krytyczne. |
| Request return | Dealer nie może zgłosić returnu po 48h, dla nie-Delivered i przy istniejącym returnie. | Błędy reguł zwrotu. | Testy domenowe lub API sprawdzają wszystkie trzy blokady. |
| Reject hold | Historia statusu przy reject hold wskazuje `System`, nie admina. | Luka audytu aktora. | Test opisuje obecne zachowanie i oczekiwaną decyzję. |
| Credit hold | `MarkCreditHold()` ustawia `OnHold` bez wpisu `OrderStatusHistory`. | Luka audytu wejścia w hold. | Test potwierdza oczekiwany wpis historii albo świadomy wyjątek. |
| Bulk status | `GetOrdersByIdsAsync` nie ładuje `Lines`, a inventory side-effecty bazują na liniach. | Możliwe pominięcie hard deduct/release soft-lock przy bulk. | Test bulk status z order lines i inventory gateway. |
| Ops notes | Dodanie/usunięcie notatki zapisuje wyłącznie localStorage. | Mylenie notatek z danymi serwerowymi. | Test frontendu potwierdza local-only albo po decyzji backendowy endpoint. |
| Reorder | Nieaktywny produkt/brak stocku nie trafia do koszyka; aktywny produkt trafia z normalizacją ilości. | Regresja koszyka po reorder. | Test `reorderItems()` na mockach Catalog API. |

## Macierz Śladu Testowego

| Funkcja | API/proces | Dane | Test istniejący | Test brakujący | Priorytet |
|---|---|---|---|---|---|
| Load detail | `GET /orders/{id}` | `Orders`, `OrderLines`, `StatusHistory`, `ReturnRequests`, `OrderSagaStates` | brak | data scope Dealer/Admin-like | P1 |
| Update status | `PUT /orders/{id}/status` | `Orders.Status`, `OrderStatusHistory`, outbox, saga | brak | role `Warehouse`, transition matrix, inventory side effects | P0 |
| Cancel | `POST /orders/{id}/cancel` | `CancellationReason`, status, history, outbox, saga | brak | owner check, admin/dealer allowed statuses | P0 |
| Request return | `POST /orders/{id}/returns` | `ReturnRequests`, status/history/outbox | częściowo przez setup approve return | owner, 48h, duplicate, non-delivered | P1 |
| Approve return | admin endpoint | restock, settlement, return flags, status/outbox | istnieje serwisowo | controller/auth + API payload | P1 |
| Reject return | admin endpoint | return flags, status/outbox | brak | reason validation, status change | P1 |
| Approve/reject hold | admin endpoints | `CreditHoldStatus`, status/history/outbox/saga | brak | hold status, actor audit | P1 |
| Ops notes | localStorage | brak DB | brak | local persistence and no API | P1 |

## Komendy Weryfikacyjne

| Cel | Komenda | Status |
|---|---|---|
| Testy .NET dla istniejącego return approval | `dotnet test tests/Order.Domain.Tests/Order.Domain.Tests.csproj` | do uruchomienia przy zmianach kodu/testów |
| Frontend unit tests | `npm test -- --run` w `supply-chain-frontend` | do uruchomienia przy zmianach UI/testów |
| Dokumentacja | `powershell -ExecutionPolicy Bypass -File AI_Agent_scripts/Test-Podejscie2DocumentationQuality.ps1` | obowiązkowe przed commitem dokumentacji |
