# P-008-0006 Category

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | select, optgroup dla kategorii parent |
| Wymagalność | required |
| Walidacje | Angular: required + regex GUID; backend: `NotEmpty`, `CategoryExistsAsync` |
| API/DTO | `CreateProductRequest.categoryId`; źródło opcji `CategoryDto[]` |
| Tabela SQL | zapis `Products.CategoryId`; odczyt `Categories` |
| Kolumna SQL | `Products.CategoryId`, FK restrict, zapis `W`; `Categories.CategoryId/Name/ParentCategoryId` odczyt `R` |
| Dane Do Test | `TD-008-0006`: istniejący GUID, pusty, nieistniejący GUID |
| Błędy | [ERR-008-0006](../ERR-008_BLEDY/ERR-008-0006__could-not-load-categories-try-refreshing.md), [ERR-008-0007](../ERR-008_BLEDY/ERR-008-0007__no-categories-available.md), [ERR-008-0008](../ERR-008_BLEDY/ERR-008-0008__category-is-required.md) |
