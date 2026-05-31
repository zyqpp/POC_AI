# ERR-010-0003 Positive Price Required

Status: `potwierdzone`.

| Atrybut | Wartość |
|---|---|
| Pole | [P-010-0003](../P-010_POLA/P-010-0003__unitprice.md) |
| Komunikat UI | `Positive price required` |
| Warunek UI | `unitPrice` puste albo mniejsze niż `0.01` |
| Backend | `UnitPrice` musi być większe od zera |
| DB | brak zapisu `Products.UnitPrice` przy błędzie |
| Dane testowe | [TD-010-0003](../TD-010_DANE_TESTOWE/TD-010-0003__unitprice.md) |
