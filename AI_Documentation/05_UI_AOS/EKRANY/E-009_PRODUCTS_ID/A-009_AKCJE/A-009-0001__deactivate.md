# A-009-0001 Deactivate Product

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| UI | przycisk `Deactivate`, widoczny dla `isAdmin()`, disabled gdy `!product.isActive` |
| Frontend | `ProductDetailComponent.deactivate()` |
| API | `CatalogApiService.deactivateProduct(id)` -> `PUT /catalog/api/products/{id}/deactivate` |
| Backend | `ProductsController.Deactivate`, `[Authorize(Roles = "Admin")]`, `DeactivateProductCommand` |
| Proces | `CatalogInventoryService.DeactivateProductAsync` pobiera produkt, ustawia inactive, dodaje outbox |
| DB | `Products.IsActive=false`, `Products.UpdatedAtUtc`, `OutboxMessages.EventType=ProductDeactivated` |
| Testy | `TC-009-0002`; domenowy test `Deactivate_SetsProductInactive` istnieje, brak testu API/UI |

Po sukcesie UI pokazuje toast `Product deactivated` i aktualizuje lokalny stan produktu bez ponownego pobrania z API.
