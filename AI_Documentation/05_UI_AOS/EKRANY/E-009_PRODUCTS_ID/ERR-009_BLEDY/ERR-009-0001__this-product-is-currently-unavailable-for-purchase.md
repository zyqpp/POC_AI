# ERR-009-0001 Product Unavailable For Purchase

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | `canPurchase()` zwraca false: produkt inactive, `AvailableStock <= 0` albo `maxPurchasable() == 0` |
| Komunikat UI | `This product is currently unavailable for purchase` |
| API | brak; błąd lokalny przed zapisem do `CartStore` |
| DB | odczyt `Products.IsActive`, `Products.TotalStock`, `Products.ReservedStock`, `Products.MinOrderQty` |
| Dane testowe | `TD-009-0013`: inactive, out of stock, stock poniżej min |
| Test | `TC-009-0004` |
