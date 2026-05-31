# ERR-009-0006 Failed To Reject Review

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | błąd `PUT /catalog/api/products/reviews/{reviewId}/reject` |
| Komunikat UI | `Failed to reject review` |
| Backend | brak review zwraca `404`; brak poprawnego tokena `Unauthorized`; rola wymagana `Admin` |
| DB | review nie ma tabeli SQL; status zmieniany w `ReviewsById` |
| Dane testowe | `TD-009-0007`, `TD-009-0012` |
| Test | `TC-009-0010` |
