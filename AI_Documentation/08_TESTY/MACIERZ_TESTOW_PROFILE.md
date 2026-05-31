# MACIERZ_TESTOW_PROFILE

Status: `potwierdzone` jako wymagania testowe; większość testów nie istnieje w kodzie.

| ID | Scenariusz | Typ testu | Dane | Obecny status | Kryterium zamknięcia |
|---|---|---|---|---|---|
| `TC-006-0001` | Admin widzi pola wspólne profilu. | component/e2e | `TD-006-0001` | `brak w kodzie` | Test sprawdza full name, email, role, status, user id i brak pól dealera. |
| `TC-006-0002` | Dealer widzi pola wspólne i pola dealera. | component/e2e | `TD-006-0002` | `brak w kodzie` | Test sprawdza credit limit, business name, GST i interstate. |
| `TC-006-0003` | Brak lub niepoprawny token blokuje profil. | API/e2e | `TD-006-0003` | `brak w kodzie` | API zwraca 401 albo aplikacja przekierowuje do loginu. |
| `TC-006-0004` | User z tokenu nie istnieje. | API integration | `TD-006-0004` | `brak w kodzie` | `GET /profile` zwraca 404. |
| `TC-006-0005` | Link dashboard działa. | component/e2e | `TD-006-0001` | `brak w kodzie` | Kliknięcie linku przechodzi do `/dashboard`. |

## Testy Istniejące

| Test | Pokrycie |
|---|---|
| `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | częściowo potwierdza statusy i dane dealera w domenie |
| `supply-chain-frontend/src/app/smoke.spec.ts` | nie pokrywa profilu; tylko smoke placeholder |
