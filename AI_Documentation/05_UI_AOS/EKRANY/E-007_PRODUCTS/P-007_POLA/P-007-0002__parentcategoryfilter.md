# P-007-0002 Parent category filter

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | select |
| Źródło | `parentCategoryFilter`, `topLevelCategories()` |
| Wymagalność | opcjonalne; domyślnie `all` |
| Walidacje | wartość musi odpowiadać `CategoryDto.categoryId` albo `all` |
| API/DTO | `GET /catalog/api/products/categories`, `CategoryDto[]` |
| Tabela SQL | `Categories` |
| Kolumna SQL | `CategoryId`, `Name`, `ParentCategoryId`, odczyt `R` |
| Dane Do Test | `TD-007-0002` |
| Akcje | lokalne `onParentCategoryFilterChange()` i `applyView()` |
