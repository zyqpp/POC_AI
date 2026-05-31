# ERR-010-0009 Description Required Or Too Long

Status: `potwierdzone`.

| Atrybut | Wartość |
|---|---|
| Pole | [P-010-0007](../P-010_POLA/P-010-0007__description.md) |
| Komunikat UI | `Description is required (max 2000 chars)` |
| Warunek UI | pusty opis albo przekroczenie 2000 znaków |
| Backend | `Description` required, max 2000 |
| DB | brak zapisu `Products.Description` przy błędzie |
| Dane testowe | [TD-010-0007](../TD-010_DANE_TESTOWE/TD-010-0007__description.md) |
