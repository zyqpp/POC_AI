# A-007-0006 Zmiana strony

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Trigger | `PaginationComponent.pageChange` |
| Handler | `loadPage(nextPage)` |
| API | `GET /catalog/api/products?page={nextPage}&size=20&includeInactive=...` |
| DTO | `PagedResult` of `ProductListItemDto` |
| Dane | odczyt `Products` i total count |
| Warunek | paginacja widoczna tylko bez aktywnych filtrów lokalnych/search |
| Testy | `TC-007-0001` |
