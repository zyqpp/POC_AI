# P-007-0010 Unit price

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | card display, currency |
| Źródło | `p.unitPrice` |
| Wymagalność | readonly; backend wymaga wartości dodatniej |
| Walidacje | create/update: `GreaterThan(0m)`; UI form w innych ekranach ma `min=0.01` |
| API/DTO | `ProductListItemDto.unitPrice` |
| Tabela SQL | `Products` |
| Kolumna SQL | `UnitPrice`, precision 18,2, odczyt `R` |
| Dane Do Test | `TD-007-0001` |
| Akcje | sortowanie po cenie |
