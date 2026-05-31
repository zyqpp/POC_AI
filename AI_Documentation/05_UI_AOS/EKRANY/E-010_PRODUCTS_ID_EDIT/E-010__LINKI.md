# E-010 Linki Śladu

Status: `potwierdzone`.

## Dokumenty Ekranu

| Obszar | Dokument |
|---|---|
| Ekran | [E-010__README](E-010__README.md) |
| Pola | [P-010__INDEX](P-010_POLA/P-010__INDEX.md) |
| Akcje | [A-010__INDEX](A-010_AKCJE/A-010__INDEX.md) |
| Błędy | [ERR-010__INDEX](ERR-010_BLEDY/ERR-010__INDEX.md) |
| Dane testowe | [TD-010__INDEX](TD-010_DANE_TESTOWE/TD-010__INDEX.md) |
| Testy | [TC-010__INDEX](TC-010_TESTY/TC-010__INDEX.md) |

## Dokumenty Agregujące

| Obszar | Dokument |
|---|---|
| AOS katalogu | [AOS_CATALOG](../../AOS_CATALOG.md) |
| API katalogu | [API_CATALOG](../../../04_API/API_CATALOG.md) |
| Model danych katalogu | [MODEL_DANYCH_CATALOG](../../../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Proces E2E | [PROC-010_PRODUCTS_ID_EDIT](../../../06_PROCESY/PROC-010_PRODUCTS_ID_EDIT.md) |
| Role | [ROLE_CATALOG](../../../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md) |
| Testy | [MACIERZ_TESTOW_CATALOG](../../../08_TESTY/MACIERZ_TESTOW_CATALOG.md) |

## Źródła Kodu

| Warstwa | Źródło |
|---|---|
| Routing | `supply-chain-frontend/src/app/app.routes.ts:61` |
| Komponent | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.ts` |
| Template | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` |
| Serwis Angular | `supply-chain-frontend/src/app/core/api/catalog-api.service.ts:50` |
| Kontroler API | `services/CatalogInventory/CatalogInventory.API/Controllers/ProductsController.cs:28` |
| DTO | `services/CatalogInventory/CatalogInventory.Application/DTOs/CatalogDtos.cs:13` |
| Walidator | `services/CatalogInventory/CatalogInventory.Application/Validation/CatalogValidators.cs:40` |
| Komenda | `services/CatalogInventory/CatalogInventory.Application/Features/Catalog/Commands/CatalogCommands.cs:16` |
| Serwis aplikacyjny | `services/CatalogInventory/CatalogInventory.Application/Services/CatalogInventoryService.cs:104` |
| Encja | `services/CatalogInventory/CatalogInventory.Domain/Entities/Product.cs:54` |
| DbContext | `services/CatalogInventory/CatalogInventory.Infrastructure/Persistence/CatalogInventoryDbContext.cs` |
| Testy istniejące | `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` |
