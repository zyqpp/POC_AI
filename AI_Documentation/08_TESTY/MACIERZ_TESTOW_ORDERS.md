# MACIERZ_TESTOW_ORDERS

Status: `potwierdzone` jako wymagania testowe dla `E-013_ORDERS_LIST`, `E-014_TRACKING`, `E-015_ORDER_DETAIL`.

## Testy Istniejące

| Test | Plik | Pokrycie | Luka |
|---|---|---|---|
| `Create_SetsPlacedStatusAndPaymentMode` | `tests/Order.Domain.Tests/UnitTest1.cs` | domena: tworzenie zamówienia, status Placed, PaymentMode | brak API, walidacji, credit check |
| `TransitionTo_AllowedTransition_UpdatesStatusAndHistory` | `tests/Order.Domain.Tests/UnitTest1.cs` | domena: dozwolona tranzycja statusu, historia | brak niedozwolonych przypadków API |
| `TransitionTo_InvalidTransition_ThrowsInvalidOperationException` | `tests/Order.Domain.Tests/UnitTest1.cs` | domena: niedozwolona tranzycja — wyjątek | brak testu API który to eksponuje |
| `AddLine_RecalculatesTotalAmount` | `tests/Order.Domain.Tests/UnitTest1.cs` | domena: linie zamówienia, kwota całkowita | brak API create order z liniami |
| `RaiseReturn_WhenDeliveredWithinWindow_CreatesReturnRequest` | `tests/Order.Domain.Tests/UnitTest1.cs` | domena: zwrot w oknie czasu od dostawy | brak API |
| `RaiseReturn_UsesDeliveryTimeForWindow_NotPlacedTime` | `tests/Order.Domain.Tests/UnitTest1.cs` | domena: okno zwrotu liczy od `DeliveredAtUtc`, nie `PlacedAtUtc` | ważna reguła biznesowa bez testu API |
| `MarkCreditRejected_CancelsOrderAndSetsReason` | `tests/Order.Domain.Tests/UnitTest1.cs` | domena: odrzucenie kredytu, anulowanie zamówienia | brak integracji z credit check flow |
| `ApproveReturnAsync_WhenCompensationSucceeds_...` | `tests/Order.Domain.Tests/OrderServiceReturnApprovalTests.cs` | serwis aplikacji: approve return — restock + settle credit + outbox | brak reject return, brak API layer |
| `ApproveReturnAsync_WhenRestockFails_ThrowsAndDoesNotSettle` | `tests/Order.Domain.Tests/OrderServiceReturnApprovalTests.cs` | serwis: rollback gdy restock fail | brak porównania z reject path |
| `ApproveReturnAsync_WhenCreditSettlementFails_Throws` | `tests/Order.Domain.Tests/OrderServiceReturnApprovalTests.cs` | serwis: rollback gdy settle fail, restock był wykonany | potencjalny wyciek stanu |

## Scenariusze do Przetestowania

| ID | Scenariusz | Typ testu | Dane | Obecny status | Kryterium zamknięcia |
|---|---|---|---|---|---|
| `TC-ORDERS-0001` | Dealer tworzy zamówienie z poprawnymi liniami — status `Placed`. | API integration | `{dealerId, lines: [{productId, qty, price}], paymentMode}` | `brak w kodzie` | `201`, zamówienie w DB, `OutboxMessages` zawiera `OrderPlaced`. |
| `TC-ORDERS-0002` | `CancelOrderRequestValidator` odrzuca pusty powód anulowania. | unit — walidator | `{reason: ""}` | `brak w kodzie` | Walidacja zwraca błąd, brak `POST /cancel`. |
| `TC-ORDERS-0003` | `BulkUpdateOrderStatusRequestValidator` odrzuca pustą listę orderIds. | unit — walidator | `{orderIds: [], newStatus: 2}` | `brak w kodzie` | Walidacja zwraca błąd. |
| `TC-ORDERS-0004` | Dealer anuluje zamówienie w statusie `Placed` — sukces. | API integration | zamówienie Placed, JWT Dealer | `brak w kodzie` | `200`, status `Cancelled`, historia zmiany statusu zapisana. |
| `TC-ORDERS-0005` | Dealer nie może anulować zamówienia w statusie `Delivered`. | API integration | zamówienie Delivered, JWT Dealer | `brak w kodzie` | `400`/`409`, status bez zmian. |
| `TC-ORDERS-0006` | Admin wykonuje bulk-status update na liście zamówień. | API integration | lista orderIds, JWT Admin | `brak w kodzie` | `200`, `BulkUpdateOrderStatusResultDto` z liczbą sukcesu/błędów. |
| `TC-ORDERS-0007` | Warehouse może odczytać listę zamówień przez `/admin/orders`. | API auth | JWT Warehouse | `brak w kodzie` | `200`, lista zamówień. |
| `TC-ORDERS-0008` | Warehouse nie może wykonać bulk-status update. | API auth | JWT Warehouse | `brak w kodzie` | `403`. |
| `TC-ORDERS-0009` | Dealer nie może pobrać zamówienia innego dealera przez `GET /orders/{id}`. | API integration | JWT Dealer A, orderId Dealer B | `brak w kodzie` | `404` (backend zwraca 404, nie 403 dla izolacji). |
| `TC-ORDERS-0010` | Admin może zatwierdzić zamówienie on-hold (`approve-hold`). | API integration | zamówienie OnHold, JWT Admin | `brak w kodzie` | `200`, status zamówienia zmieniony. |
| `TC-ORDERS-0011` | Admin odrzuca zamówienie on-hold z powodem (`reject-hold`). | API integration | zamówienie OnHold, JWT Admin | `brak w kodzie` | `200`, `CancellationReason` zapisany. |
| `TC-ORDERS-0012` | Dealer zgłasza zwrot dostarczonego zamówienia w oknie czasu. | API integration | zamówienie Delivered, JWT Dealer | `brak w kodzie` | `200`, status `ReturnRequested`, `ReturnRequest` w DB. |
| `TC-ORDERS-0013` | Dealer zgłasza zwrot po wygaśnięciu okna — odmowa. | API integration | zamówienie Delivered dawno, JWT Dealer | `brak w kodzie` | `400`/`409`, status bez zmian. |
| `TC-ORDERS-0014` | Pobieranie sagi zamówienia zwraca kroki i aktualny status. | API integration | zamówienie z sagą, JWT dowolny | `brak w kodzie` | `200`, `OrderSagaDto` z historią kroków. |
| `TC-ORDERS-0015` | Logistics może zmienić status zamówienia przez `PUT /orders/{id}/status`. | API auth | JWT Logistics | `brak w kodzie` | `200`, status zmieniony. |
| `TC-ORDERS-0016` | Agent nie może zmienić statusu zamówienia przez `PUT /orders/{id}/status`. | API auth | JWT Agent | `brak w kodzie` | `403` (runtime check `CanManageOrderStatus`). |

## Luki Testowe

| Luka | Opis | Priorytet |
|---|---|---|
| `CancelOrderRequestValidator` | Brak testu jednostkowego walidatora. Walidator jest wstrzykiwany do `OrderService`, ale nie ma osobnych testów scenariuszy edge-case. | WYSOKI |
| `BulkUpdateOrderStatusRequestValidator` | Brak testu jednostkowego. Bulk update na dużych listach bez walidacji może skutkować nieprzewidzianymi błędami w DB. | WYSOKI |
| Izolacja dealerów | Brak testu E2E weryfikującego że Dealer nie widzi zamówień innego Dealera. | KRYTYCZNY |
| Bulk-status autoryzacja | Brak testu weryfikującego że Warehouse nie może wywoływać `bulk-status` (tylko Admin i Logistics). | WYSOKI |
| Return window | Reguła okna zwrotu (od `DeliveredAtUtc`) ma test domenowy, ale brak testu API który potwierdza zachowanie w kontekście pełnego flow. | SREDNI |
| Reject return | `ApproveReturnAsync` ma 3 testy, ale `RejectReturnAsync` nie ma żadnego testu domenowego ani serwisowego. | WYSOKI |
| Credit hold flow | `MarkCreditRejected` ma test domenowy, ale brak integracyjnego testu całego flow credit-check saga (saga coordinator). | WYSOKI |
