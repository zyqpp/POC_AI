# A-013-0005 applyBulkStatus

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-013-0005` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `applyBulkStatus` |
| Typ detekcji | `click` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Faktyczna masowa zmiana statusu zamówień po pozytywnym precheck. Wysyła `validateOnly: false`. Backend waliduje i stosuje zmiany. Limit: 200 orderIds na jedno żądanie (`BulkUpdateOrderStatusRequestValidator`). Po zakończeniu czyści selekcję i odświeża listę.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | Przycisk "Apply Bulk Status" | `wniosek z analizy` |
| Metoda komponentu | `OrderListComponent.applyBulkStatus()` | `potwierdzone` |
| Serwis frontend | `AdminOrderApiService.bulkUpdateStatus()` | `potwierdzone` |
| Endpoint API | `POST /orders/api/admin/orders/bulk-status` | `potwierdzone` |
| Komenda/zapytanie | `BulkUpdateOrderStatusRequest { validateOnly: false, orderIds max 200 }` | `potwierdzone` |
| Walidacje | `canApplyBulkStatus()`: precheck aktualny, validCount>0, isStatusManager | `potwierdzone` |
| Skutek w bazie | `UPDATE Orders SET Status = @newStatus WHERE Id IN (...)` + `OrderStatusHistory` + Outbox | `wniosek z analizy` |

## Diagram Przepływu

```mermaid
sequenceDiagram
    U->>C: Klik "Apply Bulk Status"
    C->>C: canApplyBulkStatus() guards
    C->>S: AdminOrderApiService.bulkUpdateStatus({validateOnly:false})
    S->>G: POST /orders/api/admin/orders/bulk-status
    G->>H: BulkUpdateOrderStatusRequest
    H->>DB: UPDATE Orders SET Status + INSERT OrderStatusHistory + OutboxMessages
    DB-->>H: wynik
    H-->>C: BulkUpdateOrderStatusResultDto (appliedCount, failedCount)
    C-->>U: toast.success/warning; lista przeładowana
```

## Testy

- [Macierz testów ekranu](../TC-013_TESTY/TC-013__INDEX.md)
- Dane wejściowe: do uzupełnienia.
- Oczekiwany rezultat: do uzupełnienia.

## Linki

- [Indeks akcji](A-013__INDEX.md)
- [Pola ekranu](../P-013_POLA/P-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
