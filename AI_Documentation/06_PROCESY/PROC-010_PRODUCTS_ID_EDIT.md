# PROC-010 Edycja Produktu

Status: `potwierdzone` dla procesu `E-010_PRODUCTS_ID_EDIT`.

## Cel

Administrator zmienia dane istniejącego produktu bez zmiany SKU i bez zmiany stocku początkowego. Proces kończy się aktualizacją rekordu `Products`, utworzeniem komunikatu outbox `ProductUpdated`, unieważnieniem cache i przejściem na szczegół produktu.

## Widok Procesu

```text
Admin
  |
  v
/products/:id/edit
  |
  +-- GET /catalog/api/products/{id} -----------> Products
  |
  +-- GET /catalog/api/products/categories -----> Categories
  |
  v
formularz edit: SKU readonly, Opening Stock hidden, Active visible
  |
  v
Update Product
  |
  v
PUT /catalog/api/products/{id}
  |
  v
ProductsController.Update
  |
  v
UpdateProductCommand -> CatalogInventoryService.UpdateProductAsync
  |
  +-- validate UpdateProductRequest
  +-- verify Category exists
  +-- Product.Update(...)
  +-- OutboxMessages: ProductUpdated
  +-- invalidate product/list/search cache
  |
  v
200 ProductDto -> toast Product updated -> /products/{productId}
```

## Ślad UI -> API -> Proces -> DB -> Testy

| Krok | UI / kod | API / proces | DB | Test |
|---|---|---|---|---|
| Wejście | route `/products/:id/edit`, `roleGuard Admin` | brak API | brak | `TC-010-0005` |
| Load produktu | [A-010-0003](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/A-010_AKCJE/A-010-0003__load-product-and-categories.md) | `GET /catalog/api/products/{id}` | `Products R` | `TC-010-0001` |
| Load kategorii | [P-010-0006](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0006__categoryid.md) | `GET /catalog/api/products/categories` | `Categories R` | `TC-010-0007` |
| Walidacja formularza | pola `P-010-*` | `UpdateProductRequestValidator` | brak zapisu przy błędzie | `TC-010-0004` |
| Zapis | [A-010-0001](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/A-010_AKCJE/A-010-0001__submit.md) | `PUT /catalog/api/products/{id}` | `Products W`, `OutboxMessages W` | `TC-010-0002` |
| Ochrona SKU i stocku | [P-010-0001](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0001__sku.md), [P-010-0005](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0005__openingstock.md) | brak pól w `UpdateProductRequest` | `Products.Sku` i `Products.TotalStock` bez zmian | `TC-010-0003` |
| Cancel | [A-010-0002](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/A-010_AKCJE/A-010-0002__navigate-products.md) | brak API | brak | `TC-010-0008` |

## Mapowanie Pól Do Bazy

| Pole | DTO | Tabela.Kolumna | R/W |
|---|---|---|---|
| `SKU` | `ProductDto.Sku` | `Products.Sku` | `R` |
| `Name` | `UpdateProductRequest.Name` | `Products.Name` | `R/W` |
| `Description` | `UpdateProductRequest.Description` | `Products.Description` | `R/W` |
| `Category` | `UpdateProductRequest.CategoryId` | `Products.CategoryId`; `Categories.CategoryId` | `R/W` |
| `Unit Price` | `UpdateProductRequest.UnitPrice` | `Products.UnitPrice` | `R/W` |
| `Min Order Qty` | `UpdateProductRequest.MinOrderQty` | `Products.MinOrderQty` | `R/W` |
| `Opening Stock` | brak w update | `Products.TotalStock` | brak zapisu |
| `Image URL` | `UpdateProductRequest.ImageUrl` | `Products.ImageUrl` | `R/W` |
| `Active` | `UpdateProductRequest.IsActive` | `Products.IsActive` | `R/W` |

## Błędy Procesu

| ID | Warunek | HTTP | Akcja kompensująca | Status |
|---|---|---|---|---|
| `ERR-PROC-010-001` | Produkt nie istnieje (404 przy ładowaniu) | 404 | komponent pokazuje komunikat błędu; powrót do listy | `do uzupełnienia` |
| `ERR-PROC-010-002` | Brak uprawnień (nie Admin) | 403 | `roleGuard` blokuje route; backend zwraca 403 | `potwierdzone` |
| `ERR-PROC-010-003` | Nieistniejąca kategoria w update | 422 | `UpdateProductRequestValidator` odrzuca; toast z komunikatem | `wniosek z analizy` |
| `ERR-PROC-010-004` | Backend niedostępny przy zapisie | 503 | zapis nie dochodzi; dane formularza nadal w UI; brak rollbacku | `wniosek z analizy` |

## Luki

| ID | Luka | Kryterium zamknięcia |
|---|---|---|
| `GAP-PROC-010-001` | Brak widocznego komunikatu dla błędu update i 404. | Test komponentu/API potwierdza komunikat błędu dla `404` i walidacji API. |
| `GAP-PROC-010-002` | Brak testów update produktu. | Dodać test domenowy `Product.Update`, test walidatora, test API auth i test komponentu. |
