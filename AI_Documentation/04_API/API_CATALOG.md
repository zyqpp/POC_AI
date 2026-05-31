# API_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS`; dokument będzie rozszerzany przy `E-008`-`E-010`.

| ID | Metoda | Ścieżka frontend gateway | Kontroler backend | Role | Request | Response | Statusy | Użycie |
|---|---|---|---|---|---|---|---|---|
| `API-007-0001` | `GET` | `/catalog/api/products` | `ProductsController.GetPage` | `[AllowAnonymous]`, ale ekran wymaga `authGuard` | query: `page`, `size`, `includeInactive` | `PagedResult` of `ProductListItemDto` | `200` | lista i paginacja |
| `API-007-0002` | `GET` | `/catalog/api/products/categories` | `ProductsController.GetCategories` | `[AllowAnonymous]`, ale ekran wymaga `authGuard` | brak | lista `CategoryDto` | `200` | filtry kategorii |
| `API-007-0003` | `GET` | `/catalog/api/products/search` | `ProductsController.Search` | `[AllowAnonymous]`, ale ekran wymaga `authGuard` | query: `q`, `includeInactive` | lista `ProductListItemDto` | `200` | search |
| `API-007-0004` | `GET` | `/catalog/api/products/{id}` | `ProductsController.GetById` | `[AllowAnonymous]`, ale ekran wymaga `authGuard` | route `id:guid` | `ProductDto` | `200`, `404` | quick add i szczegół |

## Kontrakty Danych

| DTO | Pole | DB/źródło | Ekrany |
|---|---|---|---|
| `ProductListItemDto` | `productId` | `Products.ProductId` | `E-007` |
| `ProductListItemDto` | `sku` | `Products.Sku` | `E-007` |
| `ProductListItemDto` | `name` | `Products.Name` | `E-007` |
| `ProductListItemDto` | `categoryId` | `Products.CategoryId` | `E-007` |
| `ProductListItemDto` | `unitPrice` | `Products.UnitPrice` | `E-007` |
| `ProductListItemDto` | `availableStock` | `Product.AvailableStock` wyliczone z `TotalStock - ReservedStock` | `E-007` |
| `ProductListItemDto` | `isActive` | `Products.IsActive` | `E-007` |
| `ProductListItemDto` | `imageUrl` | `Products.ImageUrl` | `E-007` |
| `CategoryDto` | `categoryId`, `name`, `parentCategoryId` | `Categories` | `E-007` |

## Uwagi Autoryzacyjne

Endpointy listy i szczegółu są `[AllowAnonymous]`, ale route frontendu jest pod `authGuard`. `includeInactive` jest dodatkowo ograniczane w kontrolerze do użytkownika z rolą `Admin` albo `Warehouse`.
