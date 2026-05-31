# P-008-0004 Min order qty

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | input number |
| Wymagalność | required |
| Walidacje | Angular: min `1`; backend: `GreaterThan(0)` |
| API/DTO | `CreateProductRequest.minOrderQty` |
| Tabela SQL | `Products` |
| Kolumna SQL | `MinOrderQty`, int, zapis `W` |
| Dane Do Test | `TD-008-0004`: `1`, `10`, `0` |
| Błędy | [ERR-008-0004](../ERR-008_BLEDY/ERR-008-0004__positive-integer-required.md) |
