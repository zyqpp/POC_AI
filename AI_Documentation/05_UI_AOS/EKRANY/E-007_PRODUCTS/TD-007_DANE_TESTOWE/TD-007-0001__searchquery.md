# TD-007-0001 Search query

Status: `potwierdzone`.

| Wariant | Wartość | Oczekiwany wynik |
|---|---|---|
| puste | `` | `GET /products` i stronicowanie |
| nazwa | `pump` | `GET /products/search?q=pump` |
| SKU | `SKU-001` | search po SKU |

DB seed: co najmniej dwa aktywne rekordy `Products` z różnymi `Name` i `Sku`.
