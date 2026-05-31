# ERR-008-0008 Walidacja Kategorii

Status: `potwierdzone`.

| Warstwa | Warunek | Źródło |
|---|---|---|
| UI | `categoryId` puste albo niezgodne z regex GUID | `product-form.component.ts/html` |
| Backend | `CategoryId` `NotEmpty` | `CreateProductRequestValidator` |
| Biznes | `CategoryExistsAsync` zwraca `false` | `CatalogInventoryService.CreateProductAsync` |
| DB | FK `Products.CategoryId` do `Categories.CategoryId` | `CatalogInventoryDbContext` |

Komunikat UI: `Category is required`. Backend może zwrócić problem `Category does not exist.`

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0002` | pusty `categoryId` | formularz nie wysyła requestu |
| `TC-008-0004` | GUID kategorii nieistniejącej w `Categories` | backend odrzuca zapis, brak rekordu `Products` |

## Linki

- [P-008-0006 Category](../P-008_POLA/P-008-0006__categoryid.md)
- [A-008-0001 Submit](../A-008_AKCJE/A-008-0001__submit.md)
