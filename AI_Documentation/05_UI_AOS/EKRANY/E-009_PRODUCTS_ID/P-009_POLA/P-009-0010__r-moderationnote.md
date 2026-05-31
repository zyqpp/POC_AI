# P-009-0010 Moderation Note

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | tekst warunkowy `Moderation note: ...` |
| Wymagalność | opcjonalne; widoczne tylko gdy `r.moderationNote` ma wartość |
| Walidacje | backend `ModerateProductReviewRequest.Note` max 500, gdy podany |
| API/DTO | `ProductReviewDto.ModerationNote`, `ModerateProductReviewRequest.Note` |
| Tabela SQL | brak tabeli SQL dla review |
| Kolumna SQL | `brak kolumny SQL`; review w pamięci procesu |
| Dane Do Test | `TD-009-0010`: null, krótka nota, 500 znaków |
| Testy | `TC-009-0010` |
