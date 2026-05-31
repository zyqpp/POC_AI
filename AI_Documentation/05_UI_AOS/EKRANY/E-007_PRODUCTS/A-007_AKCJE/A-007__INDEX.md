# A-007 Akcje

Status: `potwierdzone`.

| ID | Akcja | UI/trigger | API | Dokument |
|---|---|---|---|---|
| `A-007-0001` | Reset filtrów | `Reset Filters` | `GET /catalog/api/products` | [A-007-0001__clearfilters.md](A-007-0001__clearfilters.md) |
| `A-007-0002` | Quick add do koszyka | `+ Add to Cart` | `GET /catalog/api/products/{id}` | [A-007-0002__quickadd.md](A-007-0002__quickadd.md) |
| `A-007-0003` | Przejście do tworzenia produktu | `Add Product` | brak API | [A-007-0003__navigate-products-new.md](A-007-0003__navigate-products-new.md) |
| `A-007-0004` | Przejście do szczegółu produktu | klik karty produktu | brak API w akcji, docelowy ekran ładuje produkt | [A-007-0004__navigate.md](A-007-0004__navigate.md) |
| `A-007-0005` | Search produktów | zmiana `searchQuery` | `GET /catalog/api/products/search` | [A-007-0005__search-products.md](A-007-0005__search-products.md) |
| `A-007-0006` | Zmiana strony | pagination | `GET /catalog/api/products?page=...` | [A-007-0006__change-page.md](A-007-0006__change-page.md) |
