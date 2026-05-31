# ERR-008-0002 Walidacja Nazwy

Status: `potwierdzone`.

| Warstwa | Warunek | Źródło |
|---|---|---|
| UI | `name` puste albo powyżej 200 znaków | `product-form.component.ts/html` |
| Backend | `Name` `NotEmpty`, `MaximumLength(200)` | `CreateProductRequestValidator` |
| DB | `Products.Name` max 200, `NOT NULL` | `CatalogInventoryDbContext` |

Komunikat UI: `Name is required (max 200 chars)`.

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0002` | `TD-008-0002` z pustą nazwą i nazwą 201 znaków | formularz nie wysyła `POST /catalog/api/products` |

## Linki

- [P-008-0002 Name](../P-008_POLA/P-008-0002__name.md)
- [A-008-0001 Submit](../A-008_AKCJE/A-008-0001__submit.md)
