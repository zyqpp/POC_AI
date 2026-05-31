# P-007-0006 Parent category name

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | option/display |
| Źródło | `CategoryDto.name`, `topLevelCategories()` |
| Wymagalność | readonly; wymagane dla opcji kategorii |
| Walidacje | backend `Category.Name` ma max 140 i `NOT NULL` |
| API/DTO | `CategoryDto.name` |
| Tabela SQL | `Categories` |
| Kolumna SQL | `Name`, max 140, `NOT NULL`, odczyt `R` |
| Dane Do Test | `TD-007-0002` |
| Akcje | filtr kategorii parent |
