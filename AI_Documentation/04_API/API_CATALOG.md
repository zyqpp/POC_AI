# API_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS` i `E-008_PRODUCTS_NEW`; dokument będzie rozszerzany przy `E-009`-`E-010`.

| ID | Metoda | Ścieżka frontend gateway | Kontroler backend | Role | Request | Response | Statusy | Użycie |
|---|---|---|---|---|---|---|---|---|
| `API-007-0001` | `GET` | `/catalog/api/products` | `ProductsController.GetPage` | `[AllowAnonymous]`, ale ekran wymaga `authGuard` | query: `page`, `size`, `includeInactive` | `PagedResult` of `ProductListItemDto` | `200` | lista i paginacja |
| `API-007-0002` | `GET` | `/catalog/api/products/categories` | `ProductsController.GetCategories` | `[AllowAnonymous]`, ale ekran wymaga `authGuard` | brak | lista `CategoryDto` | `200` | filtry i formularz create |
| `API-007-0003` | `GET` | `/catalog/api/products/search` | `ProductsController.Search` | `[AllowAnonymous]`, ale ekran wymaga `authGuard` | query: `q`, `includeInactive` | lista `ProductListItemDto` | `200` | search |
| `API-007-0004` | `GET` | `/catalog/api/products/{id}` | `ProductsController.GetById` | `[AllowAnonymous]`, ale ekran wymaga `authGuard` | route `id:guid` | `ProductDto` | `200`, `404` | quick add i szczegół |
| `API-008-0001` | `POST` | `/catalog/api/products` | `ProductsController.Create` | `[Authorize(Roles = "Admin")]` | `CreateProductRequest` | `ProductDto` | `201`; błędy walidacji/biznesowe zależne od middleware | tworzenie produktu |

## Kontrakty Danych

| DTO | Pole | DB/Źródło | Ekrany |
|---|---|---|---|
| `ProductListItemDto` | `productId` | `Products.ProductId` | `E-007` |
| `ProductListItemDto` | `sku` | `Products.Sku` | `E-007` |
| `ProductListItemDto` | `name` | `Products.Name` | `E-007` |
| `ProductListItemDto` | `categoryId` | `Products.CategoryId` | `E-007` |
| `ProductListItemDto` | `unitPrice` | `Products.UnitPrice` | `E-007` |
| `ProductListItemDto` | `availableStock` | `Product.AvailableStock` wyliczone z `TotalStock - ReservedStock` | `E-007` |
| `ProductListItemDto` | `isActive` | `Products.IsActive` | `E-007` |
| `ProductListItemDto` | `imageUrl` | `Products.ImageUrl` | `E-007` |
| `CategoryDto` | `categoryId`, `name`, `parentCategoryId` | `Categories` | `E-007`, `E-008` |
| `CreateProductRequest` | `Sku` | zapis `Products.Sku` | `E-008` |
| `CreateProductRequest` | `Name` | zapis `Products.Name` | `E-008` |
| `CreateProductRequest` | `Description` | zapis `Products.Description` | `E-008` |
| `CreateProductRequest` | `CategoryId` | zapis `Products.CategoryId`, walidacja w `Categories.CategoryId` | `E-008` |
| `CreateProductRequest` | `UnitPrice` | zapis `Products.UnitPrice` | `E-008` |
| `CreateProductRequest` | `MinOrderQty` | zapis `Products.MinOrderQty` | `E-008` |
| `CreateProductRequest` | `OpeningStock` | zapis `Products.TotalStock` | `E-008` |
| `CreateProductRequest` | `ImageUrl` | zapis `Products.ImageUrl` lub `NULL` | `E-008` |
| `ProductDto` | `productId`, `sku`, `name`, `description`, `categoryId`, `unitPrice`, `minOrderQty`, `totalStock`, `reservedStock`, `availableStock`, `isActive`, `imageUrl`, `updatedAtUtc` | `Products` i właściwość domenowa `AvailableStock` | `E-008`, później `E-009`, `E-010` |

## Walidacje `API-008-0001`

| Pole | Walidacja backend | Pole UI |
|---|---|---|
| `Sku` | required, max 60, regex liter/cyfr/myślnika/underscore, unikalność SKU | [P-008-0001](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0001__sku.md) |
| `Name` | required, max 200 | [P-008-0002](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0002__name.md) |
| `Description` | required, max 2000 | [P-008-0007](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0007__description.md) |
| `CategoryId` | required, musi istnieć w `Categories` | [P-008-0006](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0006__categoryid.md) |
| `UnitPrice` | większe od 0 | [P-008-0003](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0003__unitprice.md) |
| `MinOrderQty` | większe od 0 | [P-008-0004](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0004__minorderqty.md) |
| `OpeningStock` | większe lub równe 0 | [P-008-0005](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0005__openingstock.md) |
| `ImageUrl` | max 500 i absolutny URL `http` lub `https`, jeśli podany | [P-008-0008](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0008__imageurl.md) |

## Uwagi Autoryzacyjne

Endpointy listy i szczegółu są `[AllowAnonymous]`, ale route frontendu jest pod `authGuard`. `includeInactive` jest dodatkowo ograniczane w kontrolerze do użytkownika z rolą `Admin` albo `Warehouse`. Tworzenie produktu jest chronione podwójnie: route `/products/new` ma `roleGuard Admin`, a `ProductsController.Create` ma `[Authorize(Roles = "Admin")]`.
