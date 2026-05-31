# ERR-009-0004 Failed To Submit Review

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | błąd `POST /catalog/api/products/{id}/reviews` |
| Komunikat UI | `Failed to submit review` |
| Backend | brak produktu zwraca `404`; brak poprawnego tokena `Unauthorized`; walidacja rating/title/comment |
| DB | review nie ma tabeli SQL; brak wpisu w `ReviewsById` |
| Dane testowe | `TD-009-0002`, `TD-009-0003`, `TD-009-0004`, `TD-009-0011` not found |
| Test | `TC-009-0007`, `TC-009-0009` |
