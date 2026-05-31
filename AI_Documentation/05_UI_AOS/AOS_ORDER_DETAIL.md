# AOS Order Detail

Identyfikator: `AOS-ORDER-DETAIL`
Status: `potwierdzone` dla śladu kodowego; `potwierdzone jako ryzyko` dla rozjazdów ról i data scope.
Zakres: route `/orders/:id`, ekran szczegółu zamówienia, status lifecycle, anulowanie, zwrot, hold, notatki operacyjne i reorder.

## Cel Biznesowy

Ekran umożliwia użytkownikowi sprawdzenie pełnego stanu zamówienia i wykonanie akcji zależnych od roli: zmiana statusu, anulowanie, zgłoszenie/obsługa zwrotu, obsługa credit hold, przejście do trackingu dostawy, dodanie lokalnych notatek operacyjnych i ponowne dodanie pozycji do koszyka.

## Role I Dostęp

| Warstwa | Reguła | Status | Źródło |
|---|---|---|---|
| Angular route | parent `authGuard` i route `roleGuard`, `/orders/:id`, role `Admin`, `Dealer`, `Warehouse`, `Logistics` | potwierdzone | `app.routes.ts:29-32`, `app.routes.ts:95-98` |
| Load detail | `GET /orders/api/orders/{id}` wymaga dowolnego zalogowanego użytkownika; data scope w serwisie | potwierdzone | `OrdersController.cs:45-57`, `OrderService.cs:131-149` |
| Status lifecycle | UI: `Admin`, `Logistics`, `Warehouse`; kontroler: `Admin`, `Logistics`; serwis: `Admin`, `Logistics`, `Warehouse` | konflikt potwierdzony | `order-detail.component.ts:60-90`, `OrdersController.cs:142-146`, `OrderService.cs:608-626` |
| Cancel | UI: `Dealer` dla `Placed/OnHold`, `Admin` dla niezamkniętych; backend: `Dealer,Admin` | potwierdzone; data scope Dealera brak w cancel | `order-detail.component.ts:63-68`, `OrdersController.cs:108-119`, `OrderService.cs:368-394` |
| Return | UI i backend: `Dealer`; backend wymaga właściciela orderu | potwierdzone | `order-detail.component.ts:70-75`, `OrderService.cs:520-528` |
| Hold/Return review | tylko `Admin` | potwierdzone | `order-detail.component.ts:96-106`, `AdminOrdersController.cs:47-98` |
| Ops notes | `Admin`, `Warehouse`, `Logistics`; tylko localStorage | potwierdzone | `order-detail.component.ts:60`, `order-ops-notes.service.ts:12-18` |

## UI: Pola, Stany I Akcje

| Element UI | Dane / akcja | Ślad danych | Status |
|---|---|---|---|
| Header order | `orderNumber`, status i przyciski akcji | `OrderDto.OrderNumber`, `OrderDto.Status` -> `Orders.OrderNumber`, `Orders.Status` | potwierdzone |
| Track Delivery | link do `/orders/:id/tracking` | brak zapisu; przejście do LogisticsTracking | potwierdzone |
| Update Status | otwiera dialog wyboru statusu z `nextStatuses()` | `UpdateOrderStatusRequest.NewStatus` -> `Orders.Status`, `OrderStatusHistory` | potwierdzone |
| Cancel Order | dialog `cancelReason` | `CancelOrderRequest.Reason` -> `Orders.CancellationReason`, `Orders.Status=Cancelled` | potwierdzone |
| Request Return | dialog `returnReason`, okno 48h | `ReturnRequestDto.Reason` -> `ReturnRequests.Reason`, status `ReturnRequested` | potwierdzone |
| Reorder Items | odczyt produktów i zapis do koszyka | `OrderLines.ProductId` -> Catalog `Products`; lokalny `CartStore` | potwierdzone |
| Approve/Reject Hold | admin buttons dla `OnHold` | `Orders.CreditHoldStatus`, `Orders.Status`, `OrderStatusHistory` | potwierdzone |
| Summary cards | status, payment, credit hold, total, placed, dealer id, cancel reason | `Orders` | potwierdzone |
| Order Lines | product, SKU, qty, unit price, line total | `OrderLines`; `LineTotal` wyliczane | potwierdzone |
| Status History | timestamp, role, from/to status | `OrderStatusHistory` | potwierdzone |
| Operations Notes & Tags | tekst i tagi | localStorage `scp.order-ops-notes.v1`, brak tabeli SQL | potwierdzone |
| Return Request panel | reason, requested at, approved/rejected/reviewed | `ReturnRequests` | potwierdzone |

## End-To-End

| Krok | Frontend | Backend / proces | Dane | Status |
|---:|---|---|---|---|
| 1 | Route `/orders/:id` ładuje `OrderDetailComponent` | `roleGuard` dopuszcza `Admin`, `Dealer`, `Warehouse`, `Logistics` | token JWT | potwierdzone |
| 2 | `ngOnInit()` wywołuje `loadOrder()` | `GET /orders/api/orders/{id}` | `Orders`, `OrderLines`, `OrderStatusHistory`, `ReturnRequests`, `OrderSagaStates` | potwierdzone |
| 3 | Backend sprawdza data scope odczytu | `GetOrderAsync`: Dealer tylko własne, admin-like wszystkie | `Orders.DealerId` | potwierdzone |
| 4 | UI wylicza widoczność akcji według roli i statusu | `canCancel`, `canReturn`, `canUpdateStatus`, `canApproveHold`, `canReviewReturn` | `OrderDto.Status`, `ReturnRequest` | potwierdzone |
| 5 | Akcja lifecycle wysyła odpowiedni DTO | `UpdateOrderStatusCommand`, `CancelOrderCommand`, `RequestReturnCommand`, admin commands | request DTO | potwierdzone |
| 6 | Serwis domenowy zmienia agregat i zapisuje historię | `OrderAggregate.TransitionTo`, `Cancel`, `RaiseReturn`, `ApproveReturn`, `RejectReturn` | `Orders`, `OrderStatusHistory`, `ReturnRequests` | potwierdzone |
| 7 | Proces zapisuje outbox i aktualizuje sagę tam, gdzie dotyczy | `AddOutboxMessageAsync`, `OrderSagaCoordinator` | `OutboxMessages`, `OrderSagaStates` | potwierdzone |
| 8 | UI po sukcesie odświeża order | `loadOrder()` po toast success | odczyt aktualnego DTO | potwierdzone |

## API I Kontrakty

Pełny kontrakt jest w `AI_Documentation/04_API/API_ORDER_DETAIL.md`.

| Akcja | Endpoint | DTO | Role backend | Status |
|---|---|---|---|---|
| Load detail | `GET /orders/api/orders/{id}` | `OrderDto` | `[Authorize]` + data scope w serwisie | potwierdzone |
| Update status | `PUT /orders/api/orders/{id}/status` | `UpdateOrderStatusRequest` | kontroler `Admin/Logistics`; serwis też `Warehouse` | konflikt potwierdzony |
| Cancel | `POST /orders/api/orders/{id}/cancel` | `CancelOrderRequest` | `Dealer,Admin` | potwierdzone; brak data scope Dealera |
| Request return | `POST /orders/api/orders/{id}/returns` | `ReturnRequestDto` | `Dealer` + owner check | potwierdzone |
| Approve hold | `PUT /orders/api/admin/orders/{id}/approve-hold` | `{}` | `Admin` | potwierdzone |
| Reject hold | `PUT /orders/api/admin/orders/{id}/reject-hold` | `AdminDecisionRequest` | `Admin` | potwierdzone |
| Approve return | `PUT /orders/api/admin/orders/{id}/approve-return` | `{}` | `Admin` | potwierdzone |
| Reject return | `PUT /orders/api/admin/orders/{id}/reject-return` | `AdminDecisionRequest` | `Admin` | potwierdzone |

## Walidacje I Błędy

| Warstwa | Walidacja / błąd | Zachowanie | Status |
|---|---|---|---|
| UI | `cancelReason.trim()` wymagany do przycisku | przycisk disabled | potwierdzone |
| UI/API | textarea cancel ma `maxlength=500`, backend dopuszcza max 400 | możliwy błąd walidacji przy 401-500 znakach | potwierdzone jako rozjazd |
| UI | `returnReason.trim()` wymagany i okno zwrotu nie może być przekroczone | przycisk disabled lub toast o wygaśnięciu | potwierdzone |
| UI | `newStatus` musi należeć do `nextStatuses()` | błąd toast, brak requestu | potwierdzone |
| Backend | `UpdateOrderStatusRequest.NewStatus` musi być enumem | `400 validation.failed` | potwierdzone |
| Backend | `CancelOrderRequest.Reason` wymagany, max 400 | `400 validation.failed` | potwierdzone |
| Backend | `ReturnRequestDto.Reason` wymagany, max 500 | `400 validation.failed` | potwierdzone |
| Domena | niedozwolone przejście statusu | `409 business.conflict` | potwierdzone |
| Domena | return tylko dla `Delivered`, w oknie 48h, bez istniejącego returnu | `400 business.rule-violation` albo konflikt zależnie komunikatu | potwierdzone |
| Integracje | brak restock/settle/deduct/release | `400/409/503/504` według middleware | potwierdzone |

## Model Danych

Pełny lineage jest w `AI_Documentation/03_MODEL_DANYCH/MODEL_DANYCH_ORDER_DETAIL.md`.

| Pole / akcja | Tabela | Kolumna | R/W | Status |
|---|---|---|---|---|
| Status orderu | `Orders` | `Status` | R/W | potwierdzone |
| Credit hold | `Orders` | `CreditHoldStatus` | R/W | potwierdzone |
| Powód anulowania | `Orders` | `CancellationReason` | R/W | potwierdzone |
| Linie | `OrderLines` | `ProductId`, `ProductName`, `Sku`, `Quantity`, `UnitPrice` | R | potwierdzone |
| Line total | brak kolumny | brak | wyliczane | potwierdzone |
| Historia statusu | `OrderStatusHistory` | `FromStatus`, `ToStatus`, `ChangedByUserId`, `ChangedByRole`, `ChangedAtUtc` | R/W | potwierdzone |
| Zwrot | `ReturnRequests` | `Reason`, `RequestedAtUtc`, `IsApproved`, `IsRejected`, `ReviewedAtUtc` | R/W | potwierdzone |
| Saga | `OrderSagaStates` | `CurrentState`, `LastMessage`, daty | R/W backend | potwierdzone |
| Notatki ops | brak tabeli SQL | brak | localStorage | potwierdzone |
| Reorder | `Products` | `ProductId`, `IsActive`, `AvailableStock`, `MinOrderQty`, `UnitPrice` | R, potem lokalny koszyk | potwierdzone |

## Testy I Luki

Pełna macierz jest w `AI_Documentation/08_TESTY/MACIERZ_TESTOW_ORDER_DETAIL.md`.

| Obszar | Istniejące pokrycie | Luka | Priorytet |
|---|---|---|---|
| Approve return | testy `OrderServiceReturnApprovalTests` pokrywają sukces, restock failure, credit settlement failure | brak testów API/controller auth | P1 |
| Cancel | brak znalezionego testu data scope Dealera | możliwe anulowanie cudzego orderu przez API | P0 |
| Warehouse status | brak testu spójności UI/backend | UI pokazuje akcję, backend kontrolera blokuje | P0 |
| UI role buttons | brak testu komponentu `OrderDetailComponent` | regresja widoczności akcji | P1 |
| E2E order detail | brak pełnego testu `/orders/:id` | lifecycle orderu bez ścieżki end-to-end | P0 |

## Ryzyka

| Priorytet | Ryzyko | Dowód | Skutek | Status |
|---|---|---|---|---|
| P0 | Dealer może anulować cudze zamówienie przez API, jeśli zna `OrderId`. | `OrdersController.cs:108-119`, `OrderService.cs:368-394` | naruszenie data scope i integralności biznesowej | potwierdzone |
| P0 | `Warehouse` widzi możliwość zmiany statusu w UI, ale kontroler statusu zwróci `403`. | `order-detail.component.ts:60-90`, `OrdersController.cs:142-146` | niespójny UX i błędne wymagania testowe | potwierdzone |
| P1 | `Agent` jest dopuszczony w `canTrackDelivery()`, ale nie ma dostępu do route'u `/orders/:id`. | `order-detail.component.ts:93-95`, `app.routes.ts:95-98` | martwy warunek UI dla Agent na tym ekranie | potwierdzone |
| P1 | `Cancel Order` ma limit 500 znaków w UI i 400 w backendzie. | `order-detail.component.html:155`, `OrderValidators.cs:25-30` | użytkownik może wpisać powód, który UI akceptuje, a API odrzuci | potwierdzone |
| P1 | Notatki ops są tylko lokalne. | `order-ops-notes.service.ts:12-18`, `order-ops-notes.service.ts:77-84` | brak audytu, brak synchronizacji między użytkownikami | potwierdzone |
| P1 | Backend DTO zwraca `Saga`, ale TS model jej nie opisuje. | `OrderDtos.cs:93-106`, `order.models.ts:85-98` | UI nie korzysta z dostępnego stanu sagi | potwierdzone |
| P1 | `MarkCreditHold()` ustawia `OnHold` bez wpisu w `OrderStatusHistory`. | `OrderAggregate.cs:76-80` | historia statusu może nie pokazać wejścia w hold | potwierdzone |

## Źródła Kodowe

| Obszar | Plik |
|---|---|
| Route | `supply-chain-frontend/src/app/app.routes.ts:95-98` |
| Komponent | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` |
| Template | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` |
| Angular API | `supply-chain-frontend/src/app/core/api/order-api.service.ts:13-79` |
| Local ops notes | `supply-chain-frontend/src/app/core/services/order-ops-notes.service.ts:12-104` |
| Kontrolery | `services/Order/Order.API/Controllers/OrdersController.cs`, `services/Order/Order.API/Controllers/AdminOrdersController.cs` |
| Serwis domenowy | `services/Order/Order.Application/Services/OrderService.cs` |
| Agregat | `services/Order/Order.Domain/Entities/OrderAggregate.cs` |
| DbContext | `services/Order/Order.Infrastructure/Persistence/OrderDbContext.cs` |
