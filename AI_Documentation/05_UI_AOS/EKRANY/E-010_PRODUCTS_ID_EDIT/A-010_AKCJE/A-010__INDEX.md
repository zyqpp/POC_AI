# A-010 Akcje UI

Status: `potwierdzone`.

| ID akcji | Nazwa | Element UI | Handler | API | DB | Dokument |
|---|---|---|---|---|---|---|
| `A-010-0001` | Update Product | submit button | `ProductFormComponent.submit()` | `PUT /catalog/api/products/{id}` | `Products`, `OutboxMessages` | [A-010-0001__submit](A-010-0001__submit.md) |
| `A-010-0002` | Cancel | link/button | `routerLink="/products"` | brak | brak zapisu | [A-010-0002__navigate-products](A-010-0002__navigate-products.md) |
| `A-010-0003` | Load product and categories | inicjalizacja ekranu | `ngOnInit()`, `loadCategories()` | `GET /catalog/api/products/{id}`, `GET /catalog/api/products/categories` | `Products`, `Categories` | [A-010-0003__load-product-and-categories](A-010-0003__load-product-and-categories.md) |

## Uwagi

- Submit w trybie edit nie wysyła `Sku` ani `OpeningStock`.
- Cancel działa bez API i nie ma potwierdzenia utraty zmian.
- Load produktu nie ma widocznego komunikatu błędu 404 w template.
