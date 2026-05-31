# ERR-010-0007 No Categories Available

Status: `potwierdzone`.

| Atrybut | Wartość |
|---|---|
| Akcja | [A-010-0003](../A-010_AKCJE/A-010-0003__load-product-and-categories.md) |
| Pole | [P-010-0006](../P-010_POLA/P-010-0006__categoryid.md) |
| Komunikat UI | `No categories available.` |
| Warunek | `categoriesLoading=false` i `categories().length === 0` |
| DB | odczyt `Categories` zwrócił pustą listę |
| Dane testowe | [TD-010-0006](../TD-010_DANE_TESTOWE/TD-010-0006__categoryid.md) |
