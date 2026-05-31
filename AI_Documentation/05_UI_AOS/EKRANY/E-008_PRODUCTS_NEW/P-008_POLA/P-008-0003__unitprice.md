# P-008-0003 Unit price

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | input number, step `0.01` |
| Wymagalność | required |
| Walidacje | Angular: min `0.01`; backend: `GreaterThan(0m)` |
| API/DTO | `CreateProductRequest.unitPrice` |
| Tabela SQL | `Products` |
| Kolumna SQL | `UnitPrice`, precision 18,2, zapis `W` |
| Dane Do Test | `TD-008-0003`: `12500.50`, `0`, `-1` |
| Błędy | [ERR-008-0003](../ERR-008_BLEDY/ERR-008-0003__positive-price-required.md) |
