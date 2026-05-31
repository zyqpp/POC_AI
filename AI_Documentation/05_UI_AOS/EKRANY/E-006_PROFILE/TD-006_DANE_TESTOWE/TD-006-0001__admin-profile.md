# TD-006-0001 Admin profile

Status: `potwierdzone` jako wymagany zestaw danych testowych.

| Pole | Wartość |
|---|---|
| `Users.UserId` | stabilny `Guid` testowy |
| `Users.Email` | `admin@example.com` |
| `Users.FullName` | `Admin User` |
| `Users.Role` | `Admin` |
| `Users.Status` | `Active` |
| `Users.CreditLimit` | `500000.00` |
| `DealerProfiles` | brak rekordu |

## Oczekiwany Wynik

Widoczne są pola wspólne: initial `A`, full name, status, email, role i user id. Pola dealera są niewidoczne.
