# P-007-0003 Child category filter

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | select warunkowy |
| Źródło | `childCategoryFilter`, `selectedParentChildren()` |
| Wymagalność | opcjonalne; widoczne tylko gdy wybrana kategoria parent ma dzieci |
| Walidacje | wartość musi odpowiadać dziecku wybranego parent albo `all` |
| API/DTO | `GET /catalog/api/products/categories`, `CategoryDto[]` |
| Tabela SQL | `Categories` |
| Kolumna SQL | `CategoryId`, `Name`, `ParentCategoryId`, odczyt `R` |
| Dane Do Test | `TD-007-0002` |
| Akcje | lokalne `onChildCategoryFilterChange()` i `applyView()` |
