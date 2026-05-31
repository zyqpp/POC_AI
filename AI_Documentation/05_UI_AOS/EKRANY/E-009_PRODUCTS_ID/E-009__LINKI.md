# E-009 Linki Śladu

Status: `potwierdzone`.

| Typ | Ścieżka | Użycie |
|---|---|---|
| Route | `supply-chain-frontend/src/app/app.routes.ts` | `/products/:id` |
| Komponent | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.ts` | load, qty, cart, restock, reviews, moderation |
| Template | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | pola, akcje, role UI |
| API Angular | `supply-chain-frontend/src/app/core/api/catalog-api.service.ts` | product detail, restock, deactivate, reviews |
| Cart store | `supply-chain-frontend/src/app/core/stores/cart.store.ts` | lokalny koszyk Dealera |
| Kontroler | `services/CatalogInventory/CatalogInventory.API/Controllers/ProductsController.cs` | endpointy produktów i reviews |
| DTO | `services/CatalogInventory/CatalogInventory.Application/DTOs/CatalogDtos.cs` | `ProductDto`, `RestockProductRequest`, `ProductReviewDto` |
| Walidatory | `services/CatalogInventory/CatalogInventory.Application/Validation/CatalogValidators.cs` | restock, create review, moderate review |
| Serwis | `services/CatalogInventory/CatalogInventory.Application/Services/CatalogInventoryService.cs` | szczegół, restock, deactivate, reviews |
| DbContext | `services/CatalogInventory/CatalogInventory.Infrastructure/Persistence/CatalogInventoryDbContext.cs` | `Products`, `StockTransactions`, `OutboxMessages` |
| Encja Product | `services/CatalogInventory/CatalogInventory.Domain/Entities/Product.cs` | stock, active, available stock |
| Encja StockTransaction | `services/CatalogInventory/CatalogInventory.Domain/Entities/StockTransaction.cs` | restock transaction |
| Testy istniejące | `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | domena product restock/deactivate |

## Powiązane Dokumenty

| Typ | Link |
|---|---|
| Pola | [P-009_POLA/P-009__INDEX.md](P-009_POLA/P-009__INDEX.md) |
| Akcje | [A-009_AKCJE/A-009__INDEX.md](A-009_AKCJE/A-009__INDEX.md) |
| Błędy | [ERR-009_BLEDY/ERR-009__INDEX.md](ERR-009_BLEDY/ERR-009__INDEX.md) |
| Dane testowe | [TD-009_DANE_TESTOWE/TD-009__INDEX.md](TD-009_DANE_TESTOWE/TD-009__INDEX.md) |
| Testy | [TC-009_TESTY/TC-009__INDEX.md](TC-009_TESTY/TC-009__INDEX.md) |
| API | [../../../../04_API/API_CATALOG.md](../../../../04_API/API_CATALOG.md) |
| Model danych | [../../../../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md](../../../../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Proces | [../../../../06_PROCESY/PROC-009_PRODUCTS_ID.md](../../../../06_PROCESY/PROC-009_PRODUCTS_ID.md) |
| Role | [../../../../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md](../../../../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md) |
