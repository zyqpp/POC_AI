# P-009-0008 Review Created Date

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | Angular date pipe `date:'dd MMM yyyy'` |
| Wymagalność | zawsze ustawiane przy utworzeniu review |
| Walidacje | brak walidacji wejścia użytkownika; wartość generowana w serwisie |
| API/DTO | `ProductReviewDto.CreatedAtUtc` |
| Tabela SQL | brak tabeli SQL dla review |
| Kolumna SQL | `brak kolumny SQL`; wartość w `ProductReviewState.CreatedAtUtc` |
| Dane Do Test | `TD-009-0008`: bieżąca data, sortowanie malejące po `CreatedAtUtc` |
| Testy | `TC-009-0008`, `TC-009-0010` |
