# A-009-0008 Approve Review

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| UI | przycisk `Approve` widoczny dla `Admin` tylko przy review pending |
| Frontend | `approveReview(reviewId)` |
| API | `PUT /catalog/api/products/reviews/{reviewId}/approve` z pustym body `{}` |
| Backend | `[Authorize(Roles = "Admin")]`, `ApproveProductReviewCommand` |
| Walidacje | opcjonalny note max 500; UI w E-009 nie podaje note |
| DB | `brak kolumny SQL`; zmiana statusu w `ReviewsById` |
| Testy | `TC-009-0010` |
