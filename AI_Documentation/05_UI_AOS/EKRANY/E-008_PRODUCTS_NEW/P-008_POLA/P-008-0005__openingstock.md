# P-008-0005 Opening stock

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | input number, widoczne tylko w create |
| Wymagalność | required |
| Walidacje | Angular/backend: `>= 0`; domena rzuca błąd dla wartości ujemnej |
| API/DTO | `CreateProductRequest.openingStock` |
| Tabela SQL | `Products`; `StockTransactions` dla create: `brak w kodzie` |
| Kolumna SQL | `Products.TotalStock`, int, zapis `W`; `ReservedStock` pozostaje domyślne `0` |
| Dane Do Test | `TD-008-0005`: `0`, `100`, `-1` |
| Błędy | [ERR-008-0005](../ERR-008_BLEDY/ERR-008-0005__non-negative-integer-required.md) |
