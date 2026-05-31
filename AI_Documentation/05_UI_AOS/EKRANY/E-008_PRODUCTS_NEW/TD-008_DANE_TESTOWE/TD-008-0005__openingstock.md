# TD-008-0005 Dane Testowe Dla Stanu Początkowego

Status: `potwierdzone`.

| Typ | Wartość | Oczekiwany rezultat |
|---|---|---|
| poprawne zero | `0` | `Products.TotalStock=0`, `Products.ReservedStock=0`, `AvailableStock=0` |
| poprawne typowe | `25` | `Products.TotalStock=25`, brak `StockTransactions` |
| ujemne | `-1` | [ERR-008-0005](../ERR-008_BLEDY/ERR-008-0005__non-negative-integer-required.md) |

Powiązane testy: `TC-008-0001`, `TC-008-0002`. Brak transakcji stock dla create jest luką `GAP-E-008-002`.
