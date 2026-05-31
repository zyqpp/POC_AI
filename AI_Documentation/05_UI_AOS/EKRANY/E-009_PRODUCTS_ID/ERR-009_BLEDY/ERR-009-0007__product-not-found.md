# ERR-009-0007 Product Not Found

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | `GET /catalog/api/products/{id}` zwraca błąd lub produkt nie istnieje |
| Komunikat UI | empty state `Product not found` oraz link `Back to Products` |
| Backend | `ProductsController.GetById` zwraca `404`, gdy `GetProductDetailQuery` zwróci null |
| DB | brak rekordu `Products.ProductId` |
| Dane testowe | `TD-009-0011`: nieistniejący GUID |
| Test | `TC-009-0002` |
