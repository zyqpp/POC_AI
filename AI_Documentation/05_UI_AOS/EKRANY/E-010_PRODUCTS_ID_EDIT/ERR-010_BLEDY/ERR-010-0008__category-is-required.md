# ERR-010-0008 Category Is Required

Status: `potwierdzone`.

| Atrybut | Wartość |
|---|---|
| Pole | [P-010-0006](../P-010_POLA/P-010-0006__categoryid.md) |
| Komunikat UI | `Category is required` |
| Warunek UI | pusty albo niepoprawny `categoryId` |
| Backend | `CategoryId` required oraz sprawdzenie istnienia kategorii |
| DB | brak zapisu `Products.CategoryId` przy błędzie |
| Dane testowe | [TD-010-0006](../TD-010_DANE_TESTOWE/TD-010-0006__categoryid.md) |
