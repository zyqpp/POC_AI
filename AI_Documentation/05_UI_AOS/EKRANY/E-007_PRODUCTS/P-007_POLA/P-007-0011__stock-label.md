# P-007-0011 Stock label

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | badge |
| Źródło | `stockLabel(p)` i `stockClass(p)` |
| Wymagalność | readonly; widoczne dla każdej karty produktu |
| Walidacje | frontend rozróżnia inactive, out-of-stock, low-stock `< 10`, in-stock |
| API/DTO | `ProductListItemDto.availableStock`, `ProductListItemDto.isActive` |
| Tabela SQL | `Products` |
| Kolumna SQL | `TotalStock`, `ReservedStock`, `IsActive`; `AvailableStock` jest wyliczone jako `TotalStock - ReservedStock` |
| Dane Do Test | `TD-007-0003` |
| Akcje | filtr stock, quick add |
