# A-023-0001 approve

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-023-0001` |
| Ekran | [E-023](../E-023__README.md) |
| Nazwa wykryta | `approve` |
| Typ detekcji | `click` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Zatwierdzenie dealera przez administratora. Zmienia status dealera z `Pending` na `Active`. Po sukcesie lokalnie aktualizuje `dealer().status = 'Active'` bez przeładowania strony. Toast "Dealer approved". Powiązany proces: [PROC-001_AUTH](../../../../06_PROCESY/PROC-001_AUTH.md).

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | Przycisk "Approve" (visible gdy status !== 'Active') | `wniosek z analizy` |
| Metoda komponentu | `DealerDetailComponent.approve()` | `wniosek z analizy` |
| Serwis frontend | `AdminApiService.approveDealer(dealerId)` | `wniosek z analizy` |
| Endpoint API | `PUT /identity/api/admin/dealers/{id}/approve` z body `{}` | `wniosek z analizy` |
| Komenda/zapytanie | `ApproveDealerCommand` → `ApproveDealerCommandHandler` | `wniosek z analizy` |
| Walidacje | brak (status zmieniany server-side) | `wniosek z analizy` |
| Skutek w bazie | `Users.Status = 'Active'` lub `DealerProfiles.Status = 'Active'` (szacowane) | `wniosek z analizy` |

## Diagram Przepływu

```mermaid
sequenceDiagram
    actor A as Admin
    participant C as DealerDetailComponent
    participant API as AdminApiService
    participant BE as ApproveDealerCommandHandler
    A->>C: Klik "Approve"
    C->>C: actionLoading = true
    C->>API: PUT /identity/api/admin/dealers/{id}/approve
    API->>BE: ApproveDealerCommand(dealerId)
    BE-->>API: 200 OK
    API-->>C: success
    C->>C: dealer.status = 'Active'; toast.success("Dealer approved")
    C->>C: actionLoading = false
```

## Przykład HTTP

```http
PUT /identity/api/admin/dealers/{id}/approve
Content-Type: application/json
Authorization: Bearer {token}

{}

Response: 200 OK
```

## Testy

- [Macierz testów ekranu](../TC-023_TESTY/TC-023__INDEX.md)
- Dane wejściowe: `dealerId` z trasy URL.
- Oczekiwany rezultat: `dealer().status === 'Active'`; badge zielony "Active"; toast "Dealer approved".

## Linki

- [Indeks akcji](A-023__INDEX.md)
- [Pola ekranu](../P-023_POLA/P-023__INDEX.md)
- [Ślad ekranu](../E-023__LINKI.md)
