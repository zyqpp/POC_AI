# P-007-0007 Child category name

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | option/display |
| Źródło | `CategoryDto.name`, `categoryChildrenMap()` |
| Wymagalność | readonly; opcjonalne, zależne od hierarchii kategorii |
| Walidacje | backend `Category.Name` ma max 140 i `NOT NULL` |
| API/DTO | `CategoryDto.name` |
| Tabela SQL | `Categories` |
| Kolumna SQL | `Name`, `ParentCategoryId`, odczyt `R` |
| Dane Do Test | `TD-007-0002` |
| Akcje | filtr kategorii child |
