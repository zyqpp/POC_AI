# P-010-0006 Category

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-010-0006` |
| Ekran | [E-010](../E-010__README.md) |
| Nazwa UI | `Category *` |
| Typ UI | `select` z `option` i `optgroup` |
| Źródło | `product-form.component.html:39`, `product-form.component.ts:71` |

## Opis Pola

Wybór kategorii produktu. Lista kategorii pochodzi z `GET /catalog/api/products/categories`, a zapisywana wartość to `categoryId` w `UpdateProductRequest`.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagalność | wymagane | `Validators.required` |
| UI validator | regex GUID | `product-form.component.ts:71` |
| Backend validator | `RuleFor(x => x.CategoryId).NotEmpty()` oraz sprawdzenie istnienia kategorii | `CatalogValidators.cs:46`, `CatalogInventoryService.cs:108` |
| Komunikaty | [ERR-010-0006](../ERR-010_BLEDY/ERR-010-0006__could-not-load-categories-try-refreshing.md), [ERR-010-0007](../ERR-010_BLEDY/ERR-010-0007__no-categories-available.md), [ERR-010-0008](../ERR-010_BLEDY/ERR-010-0008__category-is-required.md) | template |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `form.controls.categoryId` | `potwierdzone` |
| Serwis API | `getCategories()`, `updateProduct()` | `potwierdzone` |
| Endpoint | `GET /catalog/api/products/categories`, `PUT /catalog/api/products/{id}` | `potwierdzone` |
| DTO/kontrakt | `CategoryDto.CategoryId`, `UpdateProductRequest.CategoryId` | `potwierdzone` |
| Encja/model | `Product.CategoryId`, `Category.CategoryId` | `potwierdzone` |
| DbContext | FK `Products.CategoryId` do `Categories.CategoryId` z `DeleteBehavior.Restrict` | `potwierdzone` |
| Tabela SQL | `Products`, `Categories` | `potwierdzone` |
| Kolumna SQL | `Products.CategoryId`, `Categories.CategoryId` | `potwierdzone` |
| Odczyt/zapis | `Categories R`; `Products.CategoryId R/W` | `potwierdzone` |

## Dane Do Testów

- [TD-010-0006](../TD-010_DANE_TESTOWE/TD-010-0006__categoryid.md)
- Poprawne: GUID istniejącej kategorii.
- Błędne: pusty GUID, nieistniejąca kategoria, niepoprawny format GUID.
