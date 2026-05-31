# A-009-0011 Restock Product

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| UI | przycisk `Restock` w modalu, disabled gdy `restockQty < 1` albo `!restockRef` |
| Frontend | `ProductDetailComponent.restock()` |
| API | `POST /catalog/api/products/{id}/restock` |
| Backend | `ProductsController.Restock`, `[Authorize(Roles = "Admin,Warehouse")]`, `RestockProductCommand` |
| Walidacje | `Quantity > 0`, `ReferenceId` required max 120 |
| Domena | `Product.Restock(quantity)` zwiększa `TotalStock` i `UpdatedAtUtc` |
| DB | `Products.TotalStock` W, `StockTransactions` W z typem `Restock`, `OutboxMessages.EventType=StockRestored` |
| Testy | `TC-009-0005`, `TC-009-0006`; istnieje domenowy test `Restock_IncreasesTotalStock` |

Po sukcesie UI pokazuje toast `Product restocked`, zamyka modal i ponownie pobiera szczegół produktu.
