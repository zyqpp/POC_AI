# P-008-0011 Child category name

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | `option` w `optgroup` |
| Wymagalność | readonly; opcjonalne zależnie od kategorii |
| Walidacje | backend `Category.Name` max 140, `NOT NULL` |
| API/DTO | `CategoryDto.name` |
| Tabela SQL | `Categories` |
| Kolumna SQL | `Name`, `ParentCategoryId`, odczyt `R` |
| Dane Do Test | `TD-008-0011` |
| Błędy | category load failed/no categories |
