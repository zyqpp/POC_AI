# ERR-010-0011 Product Not Found

Status: `potwierdzone` jako odpowiedź API, `brak w kodzie` jako widoczny komunikat UI.

| Atrybut | Wartość |
|---|---|
| Akcje | [A-010-0001](../A-010_AKCJE/A-010-0001__submit.md), [A-010-0003](../A-010_AKCJE/A-010-0003__load-product-and-categories.md) |
| Warunek | produkt o route `id` nie istnieje |
| API | `GET /catalog/api/products/{id}` albo `PUT /catalog/api/products/{id}` zwraca `404` |
| UI | brak dedykowanego stanu 404 w template formularza |
| DB | brak update `Products` |
| Test | [TC-010-0006](../TC-010_TESTY/TC-010__INDEX.md) |
