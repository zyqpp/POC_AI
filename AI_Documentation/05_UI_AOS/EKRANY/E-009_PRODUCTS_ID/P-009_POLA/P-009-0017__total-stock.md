# P-009-0017 Total Stock

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | liczba `Total` w stock grid |
| Wymagalność | wymagane w `ProductDto` |
| Walidacje | restock zwiększa total stock dodatnią ilością |
| API/DTO | `ProductDto.TotalStock`, `RestockProductRequest.Quantity` wpływa na wartość |
| Tabela SQL | `Products` |
| Kolumna SQL | `Products.TotalStock` R, W przez [A-009-0011](../A-009_AKCJE/A-009-0011__restock.md) |
| Dane Do Test | `TD-009-0013`, `TD-009-0005` |
| Testy | `TC-009-0001`, `TC-009-0005` |
