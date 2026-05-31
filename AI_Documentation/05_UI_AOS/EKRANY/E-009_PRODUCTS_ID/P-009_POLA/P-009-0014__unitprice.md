# P-009-0014 Unit Price

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | `currency:'INR'` w sekcji ceny |
| Wymagalność | wymagane w `ProductDto` |
| Walidacje | create/update większe od 0 |
| API/DTO | `ProductDto.UnitPrice` |
| Tabela SQL | `Products` |
| Kolumna SQL | `Products.UnitPrice` R, precision 18,2 |
| Dane Do Test | `TD-009-0011`: `1299.99` |
| Testy | `TC-009-0001`, `TC-009-0003` |
