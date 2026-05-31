# P-009-0005 Restock Quantity

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | input number `[(ngModel)]="restockQty"`, `min="1"` w modalu restock |
| Wymagalność | wymagane dla `Admin` i `Warehouse` przy [A-009-0011](../A-009_AKCJE/A-009-0011__restock.md) |
| Walidacje | UI blokuje przy wartości mniejszej niż `1`; backend wymaga wartości większej od `0`; domena `Product.Restock` wymaga dodatniej ilości |
| API/DTO | `RestockProductRequest.Quantity` |
| Tabela SQL | `Products`, `StockTransactions`, `OutboxMessages` |
| Kolumna SQL | `Products.TotalStock` W, `StockTransactions.Quantity` W, outbox `Payload` W |
| Dane Do Test | `TD-009-0005`: 1, 25, 0, -1 |
| Testy | `TC-009-0005`, `TC-009-0006` |
