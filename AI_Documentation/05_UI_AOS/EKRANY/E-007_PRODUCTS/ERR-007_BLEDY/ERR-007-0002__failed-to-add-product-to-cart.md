# ERR-007-0002 Failed to add product to cart

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | `getProductById(productId)` kończy się błędem |
| Komunikat UI | `Failed to add product to cart` |
| Warstwa | frontend/API |
| Status HTTP | np. `404` z `GET /catalog/api/products/{id}` |
| Wpływ na dane | brak zapisu w `CartStore`, brak zapisu DB |
| Dane Do Test | `TD-007-0005` |
| Test | `TC-007-0005` |
