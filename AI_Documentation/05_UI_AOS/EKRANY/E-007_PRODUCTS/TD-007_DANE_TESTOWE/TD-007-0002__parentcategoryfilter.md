# TD-007-0002 Parent category filter

Status: `potwierdzone`.

| Pole | Wartość |
|---|---|
| `Categories.CategoryId` | stabilny `Guid` parent |
| `Categories.Name` | `Industrial Pumps` |
| `Categories.ParentCategoryId` | `null` |

Oczekiwany wynik: parent pojawia się w select `Category`, a wybór zawęża produkty po parent lub jego dzieciach.
