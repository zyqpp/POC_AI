# TD-009-0005 Restock Quantity

Status: `potwierdzone`.

| Typ | Dane | Oczekiwany rezultat |
|---|---|---|
| minimalne | `1` | restock zwiększa `Products.TotalStock` o 1 |
| typowe | `25` | restock zwiększa stock i zapisuje `StockTransactions.Quantity=25` |
| zero | `0` | UI disabled i backend odrzuca |
| ujemne | `-1` | UI disabled i backend odrzuca |
