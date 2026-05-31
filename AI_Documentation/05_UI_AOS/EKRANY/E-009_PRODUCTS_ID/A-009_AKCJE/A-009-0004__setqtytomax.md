# A-009-0004 Set Quantity To Maximum

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| UI | przycisk `Max {maxPurchasable()}` widoczny dla Dealera |
| Frontend | `setQtyToMax()` ustawia `qty = maxPurchasable()` |
| API | brak |
| DB | brak zapisu; limit wyliczany z `Products.TotalStock`, `Products.ReservedStock`, `Products.MinOrderQty` |
| Testy | `TC-009-0003` |
