# E-007 Linki Śladu

Status: `potwierdzone`.

## Źródła Kodu

| Typ | Ścieżka | Użycie |
|---|---|---|
| Route | `supply-chain-frontend/src/app/app.routes.ts` | `/products` |
| Komponent | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.ts` | logika listy, filtrów, search, quick add |
| Template | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | pola, karty produktu, akcje |
| API Angular | `supply-chain-frontend/src/app/core/api/catalog-api.service.ts` | `getProducts`, `searchProducts`, `getCategories`, `getProductById` |
| Koszyk | `supply-chain-frontend/src/app/core/stores/cart.store.ts` | zapis quick add w stanie frontendu |
| Kontroler | `services/CatalogInventory/CatalogInventory.API/Controllers/ProductsController.cs` | endpointy produktów |
| DTO | `services/CatalogInventory/CatalogInventory.Application/DTOs/CatalogDtos.cs` | `ProductListItemDto`, `ProductDto`, `CategoryDto` |
| DbContext | `services/CatalogInventory/CatalogInventory.Infrastructure/Persistence/CatalogInventoryDbContext.cs` | `Products`, `Categories` |
| Encja | `services/CatalogInventory/CatalogInventory.Domain/Entities/Product.cs` | pola produktu i `AvailableStock` |
| Testy | `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | częściowe testy domeny produktu |

## Powiązane Dokumenty

| Typ | Link |
|---|---|
| Pola | [P-007_POLA/P-007__INDEX.md](P-007_POLA/P-007__INDEX.md) |
| Akcje | [A-007_AKCJE/A-007__INDEX.md](A-007_AKCJE/A-007__INDEX.md) |
| Błędy | [ERR-007_BLEDY/ERR-007__INDEX.md](ERR-007_BLEDY/ERR-007__INDEX.md) |
| Dane testowe | [TD-007_DANE_TESTOWE/TD-007__INDEX.md](TD-007_DANE_TESTOWE/TD-007__INDEX.md) |
| Testy | [TC-007_TESTY/TC-007__INDEX.md](TC-007_TESTY/TC-007__INDEX.md) |
| API | [../../../../04_API/API_CATALOG.md](../../../../04_API/API_CATALOG.md) |
| Model danych | [../../../../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md](../../../../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Proces | [../../../../06_PROCESY/PROC-007_PRODUCTS.md](../../../../06_PROCESY/PROC-007_PRODUCTS.md) |
| Role | [../../../../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md](../../../../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md) |
| Testy przekrojowe | [../../../../08_TESTY/MACIERZ_TESTOW_CATALOG.md](../../../../08_TESTY/MACIERZ_TESTOW_CATALOG.md) |
