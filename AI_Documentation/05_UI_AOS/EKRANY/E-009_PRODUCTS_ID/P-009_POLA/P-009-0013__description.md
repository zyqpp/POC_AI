# P-009-0013 Description

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | paragraf opisu produktu |
| Wymagalność | wymagane w `ProductDto` |
| Walidacje | create/update required i max 2000 |
| API/DTO | `ProductDto.Description` |
| Tabela SQL | `Products` |
| Kolumna SQL | `Products.Description` R, max 2000, `NOT NULL` |
| Dane Do Test | `TD-009-0011`: opis typowy i graniczny |
| Testy | `TC-009-0001` |
