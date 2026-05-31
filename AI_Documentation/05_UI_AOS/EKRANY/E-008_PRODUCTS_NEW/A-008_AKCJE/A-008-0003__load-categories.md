# A-008-0003 Załaduj Kategorie

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-008-0003` |
| Ekran | [E-008](../E-008__README.md) |
| Trigger | `ngOnInit()` komponentu |
| Metoda | `ProductFormComponent.loadCategories()` |
| API | `GET /catalog/api/products/categories` |
| Źródła | `product-form.component.ts`, `catalog-api.service.ts`, `ProductsController.GetCategories` |

## Opis Akcji

Po wejściu na ekran komponent pobiera kategorie i buduje grupy rodzic-dziecko do selecta `Category`. W trakcie pobierania select jest zablokowany przez `categoriesLoading()`. Przy błędzie lista jest czyszczona, ustawiany jest `categoryLoadFailed` i pokazywany komunikat `Could not load categories. Try refreshing.`

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Komponent | `loadCategories()` ustawia `categoriesLoading`, `categoryLoadFailed`, `categories` | `potwierdzone` |
| Serwis frontend | `CatalogApiService.getCategories()` | `potwierdzone` |
| Endpoint | `GET /catalog/api/products/categories` | `potwierdzone` |
| Kontroler | `ProductsController.GetCategories`, `[AllowAnonymous]` | `potwierdzone` |
| Query | `GetCategoriesQuery` | `potwierdzone` |
| Repozytorium | `CatalogInventoryRepository.GetCategoriesAsync` | `potwierdzone` |
| DB | odczyt `Categories.CategoryId`, `Categories.Name`, `Categories.ParentCategoryId` | `potwierdzone` |

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| [TC-008-0003](../TC-008_TESTY/TC-008__INDEX.md) | `TD-008-0006`, `TD-008-0010`, `TD-008-0011` | select zawiera grupy kategorii albo pokazuje komunikat błędu/braku kategorii |

## Linki

- [A-008 Akcje](A-008__INDEX.md)
- [P-008-0006 Category](../P-008_POLA/P-008-0006__categoryid.md)
- [ERR-008-0006](../ERR-008_BLEDY/ERR-008-0006__could-not-load-categories-try-refreshing.md)
- [ERR-008-0007](../ERR-008_BLEDY/ERR-008-0007__no-categories-available.md)
