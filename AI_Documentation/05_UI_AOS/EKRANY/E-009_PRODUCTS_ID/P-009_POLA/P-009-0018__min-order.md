# P-009-0018 Min Order

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | liczba `Min Order`, tekst `Step ...`, przycisk `Min` |
| Wymagalność | wymagane w `ProductDto` |
| Walidacje | `normalizeQty`, `stepQty`, `setQtyToMin`, `addToCart` |
| API/DTO | `ProductDto.MinOrderQty` |
| Tabela SQL | `Products` |
| Kolumna SQL | `Products.MinOrderQty` R |
| Dane Do Test | `TD-009-0001`: min 1, min 5, dostępny stock poniżej min |
| Testy | `TC-009-0003`, `TC-009-0004` |
