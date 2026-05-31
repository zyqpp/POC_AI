# A-009-0009 Reject Review

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| UI | przycisk `Reject` widoczny dla `Admin` tylko przy review pending |
| Frontend | `rejectReview(reviewId)` |
| API | `PUT /catalog/api/products/reviews/{reviewId}/reject` z pustym body `{}` |
| Backend | `[Authorize(Roles = "Admin")]`, `RejectProductReviewCommand` |
| Walidacje | opcjonalny note max 500; UI w E-009 nie podaje note |
| DB | `brak kolumny SQL`; zmiana statusu w `ReviewsById` |
| Testy | `TC-009-0010` |
