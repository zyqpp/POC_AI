# ERR-008-0006 Błąd Ładowania Kategorii

Status: `potwierdzone`.

| Warstwa | Warunek | Źródło |
|---|---|---|
| UI/API | `CatalogApiService.getCategories()` zwraca błąd HTTP lub sieciowy | `ProductFormComponent.loadCategories()` |
| Stan UI | `categories=[]`, `categoryLoadFailed=true`, `categoriesLoading=false` | `product-form.component.ts` |
| DB | brak odczytanych kategorii z `Categories` po stronie UI | `wniosek z analizy` |

Komunikat UI: `Could not load categories. Try refreshing.`

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0003` | mock błędu dla `GET /catalog/api/products/categories` | widoczny komunikat błędu, select zablokowany, brak submitu |

## Linki

- [A-008-0003 Load Categories](../A-008_AKCJE/A-008-0003__load-categories.md)
- [P-008-0006 Category](../P-008_POLA/P-008-0006__categoryid.md)
