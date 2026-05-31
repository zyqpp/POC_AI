# API_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS`, `E-008_PRODUCTS_NEW`, `E-009_PRODUCTS_ID`; dokument będzie rozszerzany przy `E-010`.

| ID | Metoda | Ścieżka frontend gateway | Kontroler backend | Role | Request | Response | Statusy | Użycie |
|---|---|---|---|---|---|---|---|---|
| `API-007-0001` | `GET` | `/catalog/api/products` | `ProductsController.GetPage` | `[AllowAnonymous]`, ekran wymaga `authGuard` | query: `page`, `size`, `includeInactive` | `PagedResult` of `ProductListItemDto` | `200` | lista i paginacja |
| `API-007-0002` | `GET` | `/catalog/api/products/categories` | `ProductsController.GetCategories` | `[AllowAnonymous]`, ekran wymaga `authGuard` | brak | lista `CategoryDto` | `200` | filtry i formularz create |
| `API-007-0003` | `GET` | `/catalog/api/products/search` | `ProductsController.Search` | `[AllowAnonymous]`, ekran wymaga `authGuard` | query: `q`, `includeInactive` | lista `ProductListItemDto` | `200` | search |
| `API-007-0004` | `GET` | `/catalog/api/products/{id}` | `ProductsController.GetById` | `[AllowAnonymous]`, ekran wymaga `authGuard` | route `id:guid` | `ProductDto` | `200`, `404` | quick add i szczegół E-009 |
| `API-008-0001` | `POST` | `/catalog/api/products` | `ProductsController.Create` | `[Authorize(Roles = "Admin")]` | `CreateProductRequest` | `ProductDto` | `201`; błędy walidacji/biznesowe zależne od middleware | tworzenie produktu |
| `API-009-0001` | `PUT` | `/catalog/api/products/{id}/deactivate` | `ProductsController.Deactivate` | `[Authorize(Roles = "Admin")]` | route `id:guid` | `{ message }` | `200`, `404` | dezaktywacja |
| `API-009-0002` | `POST` | `/catalog/api/products/{id}/restock` | `ProductsController.Restock` | `[Authorize(Roles = "Admin,Warehouse")]` | `RestockProductRequest` | `{ message }` | `200`, `404` | restock |
| `API-009-0003` | `GET` | `/catalog/api/products/{id}/reviews` | `ProductsController.GetReviews` | `[AllowAnonymous]`; pending tylko `Admin` | query `includePending` | lista `ProductReviewDto` | `200` | lista reviews |
| `API-009-0004` | `POST` | `/catalog/api/products/{id}/reviews` | `ProductsController.AddReview` | `[Authorize(Roles = "Dealer")]` | `CreateProductReviewRequest` | `ProductReviewDto` | `201`, `401`, `404` | dodanie review |
| `API-009-0005` | `PUT` | `/catalog/api/products/reviews/{reviewId}/approve` | `ProductsController.ApproveReview` | `[Authorize(Roles = "Admin")]` | `ModerateProductReviewRequest` | `ProductReviewDto` | `200`, `401`, `404` | zatwierdzenie review |
| `API-009-0006` | `PUT` | `/catalog/api/products/reviews/{reviewId}/reject` | `ProductsController.RejectReview` | `[Authorize(Roles = "Admin")]` | `ModerateProductReviewRequest` | `ProductReviewDto` | `200`, `401`, `404` | odrzucenie review |

## Kontrakty Danych

| DTO | Pole | DB/Źródło | Ekrany |
|---|---|---|---|
| `ProductListItemDto` | `productId`, `sku`, `name`, `categoryId`, `unitPrice`, `availableStock`, `isActive`, `imageUrl` | `Products`; `availableStock` wyliczone | `E-007` |
| `CategoryDto` | `categoryId`, `name`, `parentCategoryId` | `Categories` | `E-007`, `E-008` |
| `CreateProductRequest` | `Sku`, `Name`, `Description`, `CategoryId`, `UnitPrice`, `MinOrderQty`, `OpeningStock`, `ImageUrl` | zapis `Products`, walidacja `Categories` | `E-008` |
| `ProductDto` | `productId`, `sku`, `name`, `description`, `categoryId`, `unitPrice`, `minOrderQty`, `totalStock`, `reservedStock`, `availableStock`, `isActive`, `imageUrl`, `updatedAtUtc` | `Products` i właściwość domenowa `AvailableStock` | `E-008`, `E-009`, `E-010` |
| `RestockProductRequest` | `Quantity`, `ReferenceId` | zapis `Products.TotalStock`, `StockTransactions`, `OutboxMessages` | `E-009` |
| `CreateProductReviewRequest` | `Rating`, `Title`, `Comment` | `CatalogInventoryService.ReviewsById`, brak SQL | `E-009` |
| `ModerateProductReviewRequest` | `Note` | `CatalogInventoryService.ReviewsById`, brak SQL | `E-009` |
| `ProductReviewDto` | `ReviewId`, `ProductId`, `DealerId`, `Rating`, `Title`, `Comment`, `IsApproved`, `IsRejected`, `ModerationNote`, `CreatedAtUtc`, `ModeratedAtUtc`, `ModeratedByUserId` | `CatalogInventoryService.ReviewsById`, brak SQL | `E-009` |

## Walidacje

| Endpoint | Walidacje |
|---|---|
| `API-008-0001` | create product: SKU, name, description, category, price, min qty, opening stock, image URL |
| `API-009-0002` | restock: `Quantity > 0`, `ReferenceId` required max 120 |
| `API-009-0004` | review: rating 1-5, title required max 120, comment required max 1500 |
| `API-009-0005` / `API-009-0006` | moderation note max 500, gdy podany |

## Uwagi Autoryzacyjne

Route frontendu katalogu jest pod `authGuard`. Backend dla listy, kategorii, search, detail i get reviews ma `[AllowAnonymous]`, ale gateway i frontend ograniczają dostęp do zalogowanego użytkownika. Operacje zapisu mają role backendowe: create/deactivate `Admin`, restock `Admin,Warehouse`, create review `Dealer`, moderation `Admin`.
