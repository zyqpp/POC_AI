# A-009-0007 Submit Review

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| UI | formularz review widoczny dla `Dealer`; submit disabled bez tytułu lub komentarza |
| Frontend | `submitReview()` wysyła rating, title, comment i ustawia `actionLoading` |
| API | `POST /catalog/api/products/{id}/reviews` |
| Backend | `ProductsController.AddReview`, `[Authorize(Roles = "Dealer")]`, `CreateProductReviewCommand` |
| Walidacje | rating 1-5, title required max 120, comment required max 1500 |
| DB | `brak kolumny SQL`; review trafia do statycznego `ReviewsById` w pamięci procesu |
| Testy | `TC-009-0007`, `TC-009-0009` |

Po sukcesie UI pokazuje `Review submitted for moderation`, czyści pola i odświeża listę reviews.
