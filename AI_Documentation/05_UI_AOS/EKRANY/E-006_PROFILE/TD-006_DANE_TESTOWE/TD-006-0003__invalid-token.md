# TD-006-0003 Invalid token

Status: `potwierdzone` jako wymagany zestaw danych testowych.

| Dane | Wartość |
|---|---|
| Access token | brak, wygasły JWT albo JWT bez poprawnego `sub`/`NameIdentifier` |
| Route | `/profile` |
| API | `GET /identity/api/users/profile` |

## Oczekiwany Wynik

Frontend nie powinien pokazać danych profilu. Backend zwraca `401 Unauthorized`, a guard/interceptor może przekierować użytkownika do `/login`.
