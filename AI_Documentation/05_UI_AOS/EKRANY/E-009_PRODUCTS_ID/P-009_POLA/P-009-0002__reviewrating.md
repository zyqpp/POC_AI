# P-009-0002 Review Rating

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | select `[(ngModel)]="reviewRating"` z wartościami 1-5 |
| Wymagalność | wymagane przy [A-009-0007](../A-009_AKCJE/A-009-0007__submitreview.md), domyślnie `5` |
| Walidacje | backend `CreateProductReviewRequestValidator`: `Rating` w zakresie 1-5 |
| API/DTO | `CreateProductReviewRequest.Rating`, response `ProductReviewDto.Rating` |
| Tabela SQL | brak tabeli SQL dla review |
| Kolumna SQL | `brak kolumny SQL`; review jest przechowywane w statycznym `ConcurrentDictionary` w `CatalogInventoryService` |
| Dane Do Test | `TD-009-0002`: 1, 5, 0, 6 |
| Testy | `TC-009-0007`, `TC-009-0009` |
