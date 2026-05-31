# A-009-0003 Set Quantity To Minimum

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| UI | przycisk `Min {minOrderQty}` widoczny dla Dealera |
| Frontend | `setQtyToMin()` ustawia `qty = normalizeQty(product.minOrderQty)` |
| API | brak |
| DB | brak zapisu; odczyt `Products.MinOrderQty` |
| Testy | `TC-009-0003` |
