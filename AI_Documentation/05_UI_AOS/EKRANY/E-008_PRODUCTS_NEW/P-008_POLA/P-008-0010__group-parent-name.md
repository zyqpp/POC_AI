# P-008-0010 Group parent name

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | `optgroup` label |
| Wymagalność | readonly; opcjonalne zależnie od kategorii |
| Walidacje | backend `Category.Name` max 140, `NOT NULL` |
| API/DTO | `CategoryDto.name` |
| Tabela SQL | `Categories` |
| Kolumna SQL | `Name`, `ParentCategoryId`, odczyt `R` |
| Dane Do Test | `TD-008-0010` |
| Błędy | category load failed/no categories |
