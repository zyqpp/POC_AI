# P-009-0009 Review Comment Display

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | tekst review `r.comment` |
| Wymagalność | wymagane w requestcie tworzenia review |
| Walidacje | max 1500 w `CreateProductReviewRequestValidator` |
| API/DTO | `ProductReviewDto.Comment` |
| Tabela SQL | brak tabeli SQL dla review |
| Kolumna SQL | `brak kolumny SQL`; review w pamięci procesu |
| Dane Do Test | `TD-009-0009`: komentarz typowy i graniczny |
| Testy | `TC-009-0008`, `TC-009-0010` |
