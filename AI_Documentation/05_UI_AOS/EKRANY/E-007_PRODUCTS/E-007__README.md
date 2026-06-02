# E-007 Lista Produktów

Status: `potwierdzone` dla śladu UI -> Catalog API -> CatalogInventory DB -> testy.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-007` |
| Route | `/products` |
| Komponent | `ProductListComponent` |
| Guardy | `authGuard` dziedziczony z shell route |
| Role frontendu | brak roleGuard na route; UI rozróżnia `Admin` i `Dealer` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` |
| Serwis Angular | `CatalogApiService`, `CartStore`, `ToastService` |
| API | [API_CATALOG](../../../04_API/API_CATALOG.md) |
| Model danych | [MODEL_DANYCH_CATALOG](../../../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Proces | [PROC-007_PRODUCTS](../../../06_PROCESY/PROC-007_PRODUCTS.md) |
| Role | [ROLE_CATALOG](../../../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md) |
| Testy | [MACIERZ_TESTOW_CATALOG](../../../08_TESTY/MACIERZ_TESTOW_CATALOG.md) |

## Cel Ekranu

Ekran pozwala przeglądać katalog produktów, filtrować po kategorii i stanie magazynowym, sortować listę, wyszukiwać po nazwie lub SKU oraz przejść do szczegółu produktu. Dla `Admin` pokazuje akcję utworzenia produktu, a dla `Dealer` akcję szybkiego dodania do koszyka.

## Widok

```text
+----------------------------------------------------------------------------+
| Products                                                    [Add Product]*  |
+----------------------------------------------------------------------------+
| Search [________________________] Category [select v] Stock [select v]      |
| Sort [select v]                                                            |
+----------------------------------------------------------------------------+
| +----------------------+ +----------------------+ +----------------------+ |
| | image / fallback     | | image / fallback     | | image / fallback     | |
| | Name / SKU           | | Name / SKU           | | Name / SKU           | |
| | Price / Available    | | Price / Available    | | Price / Available    | |
| | [View] [Quick Add]*  | | [View] [Quick Add]*  | | [View] [Quick Add]*  | |
| +----------------------+ +----------------------+ +----------------------+ |
|                                                                            |
| [pagination / result count] [loading] [empty] [error]                      |
+----------------------------------------------------------------------------+
```

`Add Product` jest akcją Admin. `Quick Add` jest akcją Dealer i zapisuje tylko lokalny koszyk frontendu.

## Ślad End-To-End

| Krok | Fakt | Źródło | Status |
|---|---|---|---|
| Wejście | Route `/products` jest chroniony tylko przez shell `authGuard`. | `app.routes.ts` | `potwierdzone` |
| Ładowanie | `ngOnInit()` pobiera kategorie i pierwszą stronę produktów. | `product-list.component.ts` | `potwierdzone` |
| Kategorie | `CatalogApiService.getCategories()` -> `GET /catalog/api/products/categories`. | `catalog-api.service.ts`, `ProductsController.cs` | `potwierdzone` |
| Lista | `CatalogApiService.getProducts(page, 20, includeInactive)` -> `GET /catalog/api/products`. | `catalog-api.service.ts`, `ProductsController.cs` | `potwierdzone` |
| Search | `search$` z debounce 300 ms używa `GET /catalog/api/products/search?q=...`. | `product-list.component.ts` | `potwierdzone` |
| Quick add | UI pobiera pełny produkt przez `GET /catalog/api/products/{id}` i zapisuje pozycję w `CartStore`. | `product-list.component.ts` | `potwierdzone` |
| DB | Lista czyta `Products` i `Categories`; quick add nie zapisuje DB. | `CatalogInventoryDbContext.cs` | `potwierdzone` |

## Dokumenty Atomowe

- [Pola UI](P-007_POLA/P-007__INDEX.md)
- [Akcje UI](A-007_AKCJE/A-007__INDEX.md)
- [Błędy i komunikaty](ERR-007_BLEDY/ERR-007__INDEX.md)
- [Dane testowe](TD-007_DANE_TESTOWE/TD-007__INDEX.md)
- [Testy](TC-007_TESTY/TC-007__INDEX.md)
- [Linki śladu](E-007__LINKI.md)

## Luki I Ryzyka

| ID | Luka | Wpływ | Następny krok |
|---|---|---|---|
| `GAP-E-007-001` | Brak testu komponentu dla filtrów, sortowania i debounce search. | Regresja listy produktów może przejść niezauważona. | Dodać component/e2e testy katalogu. |
| `GAP-E-007-002` | `CartStore` zapisuje koszyk lokalnie po stronie frontendu; quick add nie ma śladu DB do momentu checkout. | Dokumentacja musi jasno oddzielić katalog od procesu zamówienia. | Powiązać z `E-011_CART` i `E-012_CHECKOUT`. |
