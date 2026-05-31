# ERR-009-0002 Minimum Order Quantity

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | `normalizedQty < product.minOrderQty` podczas `addToCart()` |
| Komunikat UI | `Minimum order quantity is {minOrderQty}` |
| API | brak |
| DB | odczyt `Products.MinOrderQty` |
| Dane testowe | `TD-009-0001`: ilość poniżej min |
| Test | `TC-009-0004` |
