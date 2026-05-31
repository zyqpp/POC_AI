# P-009-0019 Updated At

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | tekst względny `Updated ...` generowany przez `relativeTime(product.updatedAtUtc)` |
| Wymagalność | wymagane w `ProductDto` |
| Walidacje | brak walidacji wejścia użytkownika |
| API/DTO | `ProductDto.UpdatedAtUtc` |
| Tabela SQL | `Products` |
| Kolumna SQL | `Products.UpdatedAtUtc` R, aktualizowane przez create/update/restock/deactivate |
| Dane Do Test | `TD-009-0011`: teraz, godzina temu, dzień temu |
| Testy | `TC-009-0001`, `TC-009-0005` |
