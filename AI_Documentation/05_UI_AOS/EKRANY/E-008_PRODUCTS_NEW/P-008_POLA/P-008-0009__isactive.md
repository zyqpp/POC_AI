# P-008-0009 Active

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | checkbox w komponencie współdzielonym, ale niewidoczny w create |
| Wymagalność | `brak na UI` dla `E-008`; domyślnie produkt jest aktywny |
| Walidacje | brak w create |
| API/DTO | brak pola w `CreateProductRequest` |
| Tabela SQL | `Products` |
| Kolumna SQL | `IsActive`, bool, zapis przez domenowy default `true` |
| Dane Do Test | `TD-008-0009`: potwierdzić, że nowy produkt ma `IsActive=true` |
| Błędy | brak lokalnego błędu |
