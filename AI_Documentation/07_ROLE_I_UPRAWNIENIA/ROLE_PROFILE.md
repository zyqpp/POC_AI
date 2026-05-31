# ROLE_PROFILE

Status: `potwierdzone`.

| Obszar | Mechanizm | Role | Efekt |
|---|---|---|---|
| Route `/profile` | `authGuard` na shell route | każdy zalogowany użytkownik | dostęp do ekranu |
| API `GET /api/users/profile` | `[Authorize]` | każdy zalogowany użytkownik | dostęp do własnego profilu |
| Sekcja dealera | `ProfileComponent.isDealer()` | `Dealer` | pokazuje pola `creditLimit`, `dealerBusinessName`, `dealerGstNumber`, `isInterstate` |
| Data scope | user id z JWT claim | własny użytkownik | backend nie przyjmuje `userId` z requestu |

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-ROLE-006-001` | Testy guardów i claim parsing nie istnieją, więc regresja autoryzacji profilu nie ma automatycznej osłony. | `potwierdzone` |
