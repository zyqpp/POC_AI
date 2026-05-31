# A-009-0014 Load Product And Reviews

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| Trigger | `ngOnInit()` |
| Frontend | `catalogApi.getProductById(id)`; po sukcesie `loadReviews()` |
| API produkt | `GET /catalog/api/products/{id}` -> `ProductDto` |
| API reviews | `GET /catalog/api/products/{id}/reviews?includePending={isAdmin()}` -> lista `ProductReviewDto` |
| Backend produkt | `ProductsController.GetById`, `[AllowAnonymous]`, `GetProductDetailQuery` |
| Backend reviews | `ProductsController.GetReviews`, `[AllowAnonymous]`, pending tylko gdy `User.IsInRole("Admin")` |
| DB produkt | odczyt `Products` |
| DB reviews | `brak kolumny SQL`; odczyt statycznego `ReviewsById` |
| Testy | `TC-009-0001`, `TC-009-0008` |

Gdy produkt nie istnieje, komponent ustawia `product=null` i pokazuje empty state `Product not found`.
