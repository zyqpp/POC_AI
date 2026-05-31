# ERR-010-0004 Positive Integer Required

Status: `potwierdzone`.

| Atrybut | Wartość |
|---|---|
| Pole | [P-010-0004](../P-010_POLA/P-010-0004__minorderqty.md) |
| Komunikat UI | `Positive integer required` |
| Warunek UI | `minOrderQty` puste albo mniejsze niż `1` |
| Backend | `MinOrderQty` musi być większe od zera |
| DB | brak zapisu `Products.MinOrderQty` przy błędzie |
| Dane testowe | [TD-010-0004](../TD-010_DANE_TESTOWE/TD-010-0004__minorderqty.md) |
