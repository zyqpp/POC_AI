# TD-010-0005 Opening Stock

| Atrybut | Wartość |
|---|---|
| Pole | [P-010-0005](../P-010_POLA/P-010-0005__openingstock.md) |
| Precondition | produkt ma `Products.TotalStock = 40` przed edycją |
| Poprawne | brak pola w edit |
| Błędne | próba wysłania `OpeningStock` w request update |
| Oczekiwane | `Products.TotalStock` pozostaje `40`; update nie tworzy `StockTransactions` |
| Status testu | `brak w kodzie` |
