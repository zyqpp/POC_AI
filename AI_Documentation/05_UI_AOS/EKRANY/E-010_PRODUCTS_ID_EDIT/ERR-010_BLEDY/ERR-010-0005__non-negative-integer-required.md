# ERR-010-0005 Non-Negative Opening Stock

Status: `potwierdzone` jako komunikat formularza create; w E-010 `brak widoczności`.

| Atrybut | Wartość |
|---|---|
| Pole | [P-010-0005](../P-010_POLA/P-010-0005__openingstock.md) |
| Komunikat UI | `Non-negative integer required` |
| Warunek | dotyczy `openingStock`, ale pole jest ukryte w edit przez `!isEdit()` |
| Backend | brak w `UpdateProductRequestValidator` |
| DB | E-010 nie zapisuje `Products.TotalStock` |
| Dane testowe | [TD-010-0005](../TD-010_DANE_TESTOWE/TD-010-0005__openingstock.md) |
