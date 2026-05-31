# P-009-0004 Review Comment

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | textarea `[(ngModel)]="reviewComment"`, `maxlength="1500"` |
| Wymagalność | wymagane dla Dealera; submit disabled, gdy `!reviewComment.trim()` |
| Walidacje | backend `Comment` required i max 1500 |
| API/DTO | `CreateProductReviewRequest.Comment`, `ProductReviewDto.Comment` |
| Tabela SQL | brak tabeli SQL dla review |
| Kolumna SQL | `brak kolumny SQL`; review jest przechowywane w pamięci procesu |
| Dane Do Test | `TD-009-0004`: pusty, typowy, 1500 znaków, 1501 znaków |
| Testy | `TC-009-0007`, `TC-009-0009` |
