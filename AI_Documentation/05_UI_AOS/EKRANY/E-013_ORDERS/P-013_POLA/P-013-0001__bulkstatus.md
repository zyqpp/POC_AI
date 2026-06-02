# P-013-0001 bulkStatus

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i OrderApiService.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-013-0001` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `bulkStatus` |
| Typ detekcji | `[(ngModel)]` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Pole wyboru docelowego statusu w operacji masowej zmiany statusu zamówień (bulk status update). Renderowane jako `<select>` z opcjami z `ORDER_STATUS_LABELS`. Admin widzi wszystkie statusy; Logistics — tylko statusy zdefiniowane w `LOGISTICS_MANAGED_ORDER_STATUSES`.  
**Źródło danych:** Lokalny enum `OrderStatus` — lista opcji budowana w `bulkStatusOptions()` w komponencie; wartość wysyłana jako `BulkUpdateOrderStatusRequest.newStatus` do `POST /orders/api/admin/orders/bulk-status`.  
**Kiedy widoczne:** Tylko dla roli Admin lub Logistics (`isStatusManager() === true`).  
**Format:** Dropdown z etykietami tekstowymi statusów (np. "Processing", "Delivered").

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | do uzupełnienia | brak pełnej analizy formularza |
| Typ UI | do uzupełnienia | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Reguły walidacji | do uzupełnienia | brak pełnej analizy walidatorów |
| Komunikaty błędów | [ERR-013](../ERR-013_BLEDY/ERR-013__INDEX.md) | do uzupełnienia |

## Mapowanie Danych

| Warstwa | Artefakt | Przykład | Status |
|---|---|---|---|
| Frontend model/form | `OrderListComponent.bulkStatus` | `bulkStatus: OrderStatus \| null` | `wniosek z analizy` |
| Endpoint | `AdminOrderApiService.bulkUpdateStatus` | `POST /orders/api/admin/orders/bulk-status` | `potwierdzone` |
| DTO/kontrakt | `BulkUpdateOrderStatusRequest` | `public OrderStatus NewStatus { get; }` | `wniosek z analizy` |
| Tabela SQL | `Orders` | `Orders` | `wniosek z analizy` |
| Kolumna SQL | `Status` | `Status` | `wniosek z analizy` |
| Odczyt/zapis | Zapis (bulk update) | `UPDATE Orders SET Status = ...` | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-013_DANE_TESTOWE/TD-013-0001__bulkstatus.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-013__INDEX.md)
- [Akcje ekranu](../A-013_AKCJE/A-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
