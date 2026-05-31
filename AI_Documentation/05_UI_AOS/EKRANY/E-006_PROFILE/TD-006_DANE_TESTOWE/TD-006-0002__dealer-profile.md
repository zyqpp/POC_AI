# TD-006-0002 Dealer profile

Status: `potwierdzone` jako wymagany zestaw danych testowych.

| Pole | Wartość |
|---|---|
| `Users.UserId` | stabilny `Guid` testowy |
| `Users.Email` | `dealer@example.com` |
| `Users.FullName` | `Demo Dealer` |
| `Users.Role` | `Dealer` |
| `Users.Status` | `Active` albo `Pending` zależnie od scenariusza |
| `Users.CreditLimit` | `500000.00` |
| `DealerProfiles.BusinessName` | `Demo Traders` |
| `DealerProfiles.GstNumber` | `37ABCDE1234F1Z5` |
| `DealerProfiles.IsInterstate` | `true` |

## Oczekiwany Wynik

Widoczne są pola wspólne i sekcja dealera: credit limit, business name, GST number, interstate.
