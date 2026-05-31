# A-007-0001 Reset filtrów

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Trigger | przycisk `Reset Filters` |
| Handler | `clearFilters()` |
| Wejście | `searchQuery`, `parentCategoryFilter`, `childCategoryFilter`, `stockFilter`, `sortBy` |
| API | `GET /catalog/api/products?page=1&size=20&includeInactive=...` |
| Dane | odczyt `Products`, `Categories`; brak zapisu DB |
| Role | wszyscy zalogowani; `includeInactive` tylko gdy `isAdmin()` |
| Błędy | [ERR-007-0003](../ERR-007_BLEDY/ERR-007-0003__products-load-failed.md) |
| Testy | `TC-007-0003` |
