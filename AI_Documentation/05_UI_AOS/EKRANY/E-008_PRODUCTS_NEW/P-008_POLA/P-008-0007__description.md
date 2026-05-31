# P-008-0007 Description

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | textarea |
| Wymagalność | required |
| Walidacje | Angular/backend: required, max 2000 |
| API/DTO | `CreateProductRequest.description` |
| Tabela SQL | `Products` |
| Kolumna SQL | `Description`, max 2000, `NOT NULL`, zapis `W` |
| Dane Do Test | `TD-008-0007`: opis poprawny, pusty, >2000 znaków |
| Błędy | [ERR-008-0009](../ERR-008_BLEDY/ERR-008-0009__description-is-required-max-2000-chars.md) |
