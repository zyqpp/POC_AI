# TD-006-0004 Missing user

Status: `potwierdzone` jako wymagany zestaw danych testowych.

| Dane | Wartość |
|---|---|
| Access token | poprawny JWT z `sub` będącym `Guid` |
| `Users` | brak rekordu dla tego `Guid` |
| API | `GET /identity/api/users/profile` |

## Oczekiwany Wynik

Backend zwraca `404 NotFound`. UI ustawia `error` na `Failed to load profile.`.
