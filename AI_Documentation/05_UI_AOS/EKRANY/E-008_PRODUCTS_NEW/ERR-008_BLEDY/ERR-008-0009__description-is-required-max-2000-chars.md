# ERR-008-0009 Walidacja Opisu

Status: `potwierdzone`.

| Warstwa | Warunek | Źródło |
|---|---|---|
| UI | `description` puste albo powyżej 2000 znaków | `product-form.component.ts/html` |
| Backend | `Description` `NotEmpty`, `MaximumLength(2000)` | `CreateProductRequestValidator` |
| DB | `Products.Description` max 2000, `NOT NULL` | `CatalogInventoryDbContext` |

Komunikat UI: `Description is required (max 2000 chars)`.

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0002` | `TD-008-0007` z pustym opisem i opisem 2001 znaków | formularz blokuje zapis |

## Linki

- [P-008-0007 Description](../P-008_POLA/P-008-0007__description.md)
- [A-008-0001 Submit](../A-008_AKCJE/A-008-0001__submit.md)
