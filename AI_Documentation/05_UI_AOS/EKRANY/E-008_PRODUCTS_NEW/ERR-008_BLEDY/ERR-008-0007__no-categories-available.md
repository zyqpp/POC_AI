# ERR-008-0007 Brak Kategorii

Status: `potwierdzone`.

| Warstwa | Warunek | Źródło |
|---|---|---|
| UI | `categoriesLoading=false` oraz `categories().length === 0` | `product-form.component.html` |
| API | `GET /catalog/api/products/categories` zwraca pustą listę | `ProductsController.GetCategories` |
| DB | brak rekordów w `Categories` albo filtr/repozytorium zwróciło pustą listę | `wniosek z analizy` |

Komunikat UI: `No categories available.`

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0003` | `TD-008-0006` z pustą listą kategorii | komunikat widoczny, select zablokowany, produkt nie może być zapisany |

## Linki

- [A-008-0003 Load Categories](../A-008_AKCJE/A-008-0003__load-categories.md)
- [P-008-0006 Category](../P-008_POLA/P-008-0006__categoryid.md)
