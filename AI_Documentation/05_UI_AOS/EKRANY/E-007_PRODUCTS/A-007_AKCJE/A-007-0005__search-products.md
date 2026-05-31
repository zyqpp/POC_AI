# A-007-0005 Search produktów

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Trigger | `ngModelChange` pola search |
| Handler | `onSearch(query)` -> `search$` -> `debounceTime(300)` -> `switchMap(...)` |
| API | `GET /catalog/api/products/search?q=...&includeInactive=...` albo `GET /catalog/api/products` dla pustego query |
| DTO | lista `ProductListItemDto` albo `PagedResult` of `ProductListItemDto` |
| Dane | odczyt `Products`; opcjonalnie inactive tylko dla Admin/Warehouse po stronie backendu |
| Błędy | [ERR-007-0003](../ERR-007_BLEDY/ERR-007-0003__products-load-failed.md) |
| Testy | `TC-007-0002` |
