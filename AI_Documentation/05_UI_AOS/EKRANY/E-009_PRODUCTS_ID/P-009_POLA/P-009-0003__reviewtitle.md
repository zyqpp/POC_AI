# P-009-0003 Review Title

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | input text `[(ngModel)]="reviewTitle"`, `maxlength="120"` |
| Wymagalność | wymagane dla Dealera; przycisk submit disabled, gdy `!reviewTitle.trim()` |
| Walidacje | backend `Title` required i max 120 |
| API/DTO | `CreateProductReviewRequest.Title`, `ProductReviewDto.Title` |
| Tabela SQL | brak tabeli SQL dla review |
| Kolumna SQL | `brak kolumny SQL`; review jest przechowywane w pamięci procesu |
| Dane Do Test | `TD-009-0003`: pusty, typowy, 120 znaków, 121 znaków |
| Testy | `TC-009-0007`, `TC-009-0009` |
