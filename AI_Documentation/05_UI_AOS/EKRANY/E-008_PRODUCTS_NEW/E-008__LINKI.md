# E-008 Linki Śladu

Status: `potwierdzone`.

| Typ | Ścieżka | Użycie |
|---|---|---|
| Route | `supply-chain-frontend/src/app/app.routes.ts` | `/products/new`, `roleGuard Admin` |
| Komponent | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.ts` | formularz create |
| Template | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | pola, walidacje UI |
| API Angular | `supply-chain-frontend/src/app/core/api/catalog-api.service.ts` | `createProduct`, `getCategories` |
| Kontroler | `services/CatalogInventory/CatalogInventory.API/Controllers/ProductsController.cs` | `Create`, `GetCategories` |
| DTO | `services/CatalogInventory/CatalogInventory.Application/DTOs/CatalogDtos.cs` | `CreateProductRequest`, `ProductDto`, `CategoryDto` |
| Walidatory | `services/CatalogInventory/CatalogInventory.Application/Validation/CatalogValidators.cs` | `CreateProductRequestValidator` |
| Serwis | `services/CatalogInventory/CatalogInventory.Application/Services/CatalogInventoryService.cs` | `CreateProductAsync` |
| DbContext | `services/CatalogInventory/CatalogInventory.Infrastructure/Persistence/CatalogInventoryDbContext.cs` | `Products`, `Categories`, `OutboxMessages` |
| Encja | `services/CatalogInventory/CatalogInventory.Domain/Entities/Product.cs` | `Product.Create` |

## Powiązane Dokumenty

| Typ | Link |
|---|---|
| Pola | [P-008_POLA/P-008__INDEX.md](P-008_POLA/P-008__INDEX.md) |
| Akcje | [A-008_AKCJE/A-008__INDEX.md](A-008_AKCJE/A-008__INDEX.md) |
| Błędy | [ERR-008_BLEDY/ERR-008__INDEX.md](ERR-008_BLEDY/ERR-008__INDEX.md) |
| Dane testowe | [TD-008_DANE_TESTOWE/TD-008__INDEX.md](TD-008_DANE_TESTOWE/TD-008__INDEX.md) |
| Testy | [TC-008_TESTY/TC-008__INDEX.md](TC-008_TESTY/TC-008__INDEX.md) |
| API | [../../../04_API/API_CATALOG.md](../../../04_API/API_CATALOG.md) |
| Proces | [../../../06_PROCESY/PROC-008_PRODUCTS_NEW.md](../../../06_PROCESY/PROC-008_PRODUCTS_NEW.md) |
