# P-007-0001 Search query

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | input `type=search` |
| Źródło | `product-list.component.html`, `product-list.component.ts` |
| Wymagalność | opcjonalne; puste pole ładuje listę stronicowaną |
| Walidacje | brak walidatora; `trim()` decyduje o użyciu search |
| API/DTO | `GET /catalog/api/products/search?q=...`, `ProductListItemDto[]` |
| Tabela SQL | `Products` |
| Kolumna SQL | `Name` i `Sku`, odczyt `R`; dokładny predykat search jest w `CatalogInventoryService` |
| Dane Do Test | `TD-007-0001`; wartości: pusty string, fragment nazwy, fragment SKU |
| Akcje | [A-007-0005](../A-007_AKCJE/A-007-0005__search-products.md) |
