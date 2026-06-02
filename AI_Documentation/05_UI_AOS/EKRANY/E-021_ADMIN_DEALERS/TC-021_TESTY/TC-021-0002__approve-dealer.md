# TC-021-0002 Approve Dealer → Status Zmienia się na Active, Outbox Email

| Atrybut | Wartość |
|---|---|
| ID | `TC-021-0002` |
| Ekran | [E-021](../E-021__README.md) |
| Typ | happy path |
| Priorytet | P0 |
| Powiązane | P-021-0006 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Admin`.
- Na liście dealerów widoczny jest dealer X ze statusem `Pending`.
- API `PUT /identity/api/admin/dealers/{id}/approve` jest dostępne.
- Backend obsługuje outbox pattern — po zatwierdzeniu generowany jest email do dealera.

## When (Akcja)

- Użytkownik klika przycisk `"Approve"` (lub podobny) w wierszu dealera X.
- Potwierdza akcję (jeśli jest dialog potwierdzenia).

## Then (Oczekiwany rezultat)

- Frontend wysyła `PUT /identity/api/admin/dealers/{id}/approve`.
- API zwraca `200 OK`.
- Status dealera X w tabeli zmienia się z `Pending` na `Active` (odświeżenie listy lub aktualizacja lokalna).
- Wyświetla się komunikat sukcesu (toast lub inline).
- Backend zapisuje zdarzenie w outbox — email powitalny do dealera zostanie wysłany asynchronicznie.
- Dealer X może teraz zalogować się do systemu.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| dealerId | ID dealera ze statusem `Pending` | ID dealera ze statusem `Active` (błąd logiczny) |
| status przed | `Pending` | `Active`, `Rejected` |
| status po | `Active` | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
