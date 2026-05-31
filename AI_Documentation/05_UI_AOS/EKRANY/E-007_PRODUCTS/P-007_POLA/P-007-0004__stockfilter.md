# P-007-0004 Stock filter

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | select |
| Źródło | `stockFilter` |
| Wymagalność | opcjonalne; domyślnie `all` |
| Walidacje | frontendowy zbiór: `all`, `in-stock`, `low-stock`, `out-of-stock`, `inactive` |
| API/DTO | filtr lokalny na `ProductListItemDto` |
| Tabela SQL | `Products` |
| Kolumna SQL | `TotalStock`, `ReservedStock`, `IsActive`; `AvailableStock` jest wyliczone, odczyt `R` |
| Dane Do Test | `TD-007-0003` |
| Akcje | `onStockFilterChange()` -> `applyView()` |
