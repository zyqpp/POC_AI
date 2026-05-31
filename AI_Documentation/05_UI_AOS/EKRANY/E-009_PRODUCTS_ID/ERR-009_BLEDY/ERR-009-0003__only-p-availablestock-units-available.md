# ERR-009-0003 Quantity Exceeds Available Stock

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | `normalizedQty > product.availableStock` podczas `addToCart()` |
| Komunikat UI | `Only {availableStock} units available` |
| API | brak |
| DB | `AvailableStock` wyliczone z `Products.TotalStock - Products.ReservedStock` |
| Dane testowe | `TD-009-0001`, `TD-009-0013` |
| Test | `TC-009-0004` |
