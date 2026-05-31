# E-008 Tworzenie Produktu

Status: `potwierdzone` dla śladu UI -> API -> CatalogInventory DB -> testy.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-008` |
| Route | `/products/new` |
| Komponent | `ProductFormComponent` |
| Guardy | `authGuard` z shell route oraz `roleGuard` na route |
| Role frontendu | `Admin` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` |
| API | `POST /catalog/api/products`, `GET /catalog/api/products/categories` |
| Backend | `ProductsController.Create`, `CatalogInventoryService.CreateProductAsync` |
| Model danych | `Products`, `Categories`, `OutboxMessages`; `StockTransactions` przy create: `brak w kodzie` |
| Dokument API | [API_CATALOG](../../../../04_API/API_CATALOG.md) |
| Model danych | [MODEL_DANYCH_CATALOG](../../../../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Proces | [PROC-008_PRODUCTS_NEW](../../../../06_PROCESY/PROC-008_PRODUCTS_NEW.md) |
| Role | [ROLE_CATALOG](../../../../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md) |
| Testy | [MACIERZ_TESTOW_CATALOG](../../../../08_TESTY/MACIERZ_TESTOW_CATALOG.md) |

## Cel Ekranu

Ekran pozwala administratorowi utworzyć nowy produkt katalogowy. Formularz pobiera kategorie, waliduje pola po stronie Angular i wysyła `CreateProductRequest`. Po sukcesie pokazuje toast `Product created` i przechodzi do `/products/{productId}`.

## Widok

```text
+----------------------------------------------------------------------------+
| Create Product                                                  [Cancel]    |
+----------------------------------------------------------------------------+
| +------------------------------------------------------------------------+ |
| | SKU * [____________________]   Name * [______________________________] | |
| | Unit Price * [__________]     Min Order Qty * [____]                  | |
| | Opening Stock * [________]   Category * [Select category v]           | |
| |   Parent category / child option labels from Categories                | |
| | Description *                                                         | |
| | [______________________________________________________________]       | |
| | Image URL                                                             | |
| | [https://........................................................]    | |
| |                                                        [Cancel] [Create Product] |
| +------------------------------------------------------------------------+ |
| [category loading] [category empty/error] [field validation errors]        |
+----------------------------------------------------------------------------+
```

## Dokumenty Atomowe

- [Pola UI](P-008_POLA/P-008__INDEX.md)
- [Akcje UI](A-008_AKCJE/A-008__INDEX.md)
- [Błędy i komunikaty](ERR-008_BLEDY/ERR-008__INDEX.md)
- [Dane testowe](TD-008_DANE_TESTOWE/TD-008__INDEX.md)
- [Testy](TC-008_TESTY/TC-008__INDEX.md)
- [Linki śladu](E-008__LINKI.md)

## Ślad End-To-End

| Krok | Fakt | Źródło | Status |
|---|---|---|---|
| Wejście | Route `/products/new` wymaga `roleGuard` z rolą `Admin`. | `app.routes.ts` | `potwierdzone` |
| Kategorie | `loadCategories()` pobiera `GET /catalog/api/products/categories`. | `product-form.component.ts` | `potwierdzone` |
| Submit | `submit()` waliduje Reactive Form i wywołuje `catalogApi.createProduct(...)`. | `product-form.component.ts` | `potwierdzone` |
| Backend | `ProductsController.Create` wymaga `[Authorize(Roles = "Admin")]`. | `ProductsController.cs` | `potwierdzone` |
| Walidacje | `CreateProductRequestValidator` sprawdza SKU, name, description, category, price, min qty, stock i image URL. | `CatalogValidators.cs` | `potwierdzone` |
| DB | `Product.Create(...)` tworzy rekord `Products`; serwis dodaje outbox `ProductCreated`. | `CatalogInventoryService.cs`, `Product.cs` | `potwierdzone` |
| StockTransaction | Create nie dodaje `StockTransactions` dla `openingStock`. | `CatalogInventoryService.CreateProductAsync` | `brak w kodzie` |

## Luki I Ryzyka

| ID | Luka | Wpływ | Następny krok |
|---|---|---|---|
| `GAP-E-008-001` | Brak testu API create dla konfliktu SKU i nieistniejącej kategorii. | Regresja walidacji backendu może zostać niezauważona. | Dodać testy integracyjne Catalog API. |
| `GAP-E-008-002` | `openingStock` ustawia `Products.TotalStock`, ale nie powstaje `StockTransactions`. | Brakuje audytu początkowego stanu magazynu w tabeli transakcji. | Dopisać ryzyko do backlogu danych, bez zmiany kodu w tym trybie. |
