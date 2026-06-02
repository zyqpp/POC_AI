# A-013-0004 runBulkPrecheck

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-013-0004` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `runBulkPrecheck` |
| Typ detekcji | `click` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Walidacja wstępna masowej zmiany statusu. Wysyła te same `orderIds` i `newStatus` co `applyBulkStatus`, ale z `validateOnly: true`. Wynik zapisywany w `bulkPrecheck`. Jeśli precheck nie jest aktualny (zmienił się wybór lub status), przycisk Apply jest zablokowany.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | Przycisk "Validate Selection" | `wniosek z analizy` |
| Metoda komponentu | `OrderListComponent.runBulkPrecheck()` | `potwierdzone` |
| Serwis frontend | `AdminOrderApiService.bulkUpdateStatus()` | `potwierdzone` |
| Endpoint API | `POST /orders/api/admin/orders/bulk-status` | `potwierdzone` |
| Komenda/zapytanie | `BulkUpdateOrderStatusRequest { validateOnly: true }` | `potwierdzone` |
| Walidacje | Guard: `bulkStatus !== null && selectedCount > 0 && isStatusManager()` | `potwierdzone` |
| Skutek w bazie | Brak zapisu — tylko walidacja | `potwierdzone` |

## Diagram Przepływu

```mermaid
sequenceDiagram
    U->>C: Klik "Validate Selection"
    C->>C: runBulkPrecheck() - guards
    C->>S: AdminOrderApiService.bulkUpdateStatus({validateOnly:true})
    S->>G: POST /orders/api/admin/orders/bulk-status
    G->>H: BulkUpdateOrderStatusRequest (validateOnly=true)
    H->>DB: SELECT Orders WHERE Id IN (...)
    DB-->>H: wynik walidacji przejść
    H-->>C: BulkUpdateOrderStatusResultDto
    C-->>U: bulkPrecheck.set(result); toast
```

## Testy

- [Macierz testów ekranu](../TC-013_TESTY/TC-013__INDEX.md)
- Dane wejściowe: do uzupełnienia.
- Oczekiwany rezultat: do uzupełnienia.

## Linki

- [Indeks akcji](A-013__INDEX.md)
- [Pola ekranu](../P-013_POLA/P-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
