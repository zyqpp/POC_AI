# ERR-009-0005 Failed To Approve Review

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | błąd `PUT /catalog/api/products/reviews/{reviewId}/approve` |
| Komunikat UI | `Failed to approve review` |
| Backend | brak review zwraca `404`; brak poprawnego tokena `Unauthorized`; rola wymagana `Admin` |
| DB | review nie ma tabeli SQL; status zmieniany w `ReviewsById` |
| Dane testowe | `TD-009-0007`, `TD-009-0012` |
| Test | `TC-009-0010` |
