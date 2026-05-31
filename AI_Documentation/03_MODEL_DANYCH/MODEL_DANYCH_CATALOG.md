# MODEL_DANYCH_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS` i `E-008_PRODUCTS_NEW`; dokument będzie rozszerzany przy `E-009`-`E-010`.

## CatalogInventory

| Tabela | Kolumna | Typ/konfiguracja EF | Nullability | R/W w E-007 | R/W w E-008 | Użycie |
|---|---|---|---|---|---|---|
| `Products` | `ProductId` | key `Guid` | `NOT NULL` | `R` | `W`, generowane w domenie | link, response `ProductDto` |
| `Products` | `Sku` | max 60, unique index | `NOT NULL` | `R` | `W` | karta, search, formularz create |
| `Products` | `Name` | max 200 | `NOT NULL` | `R` | `W` | nazwa produktu |
| `Products` | `Description` | max 2000 | `NOT NULL` | `brak na UI listy` | `W` | opis w formularzu i szczególe |
| `Products` | `CategoryId` | FK do `Categories` | `NOT NULL` | `R` | `W`, walidacja FK | filtr i formularz |
| `Products` | `UnitPrice` | precision 18,2 | `NOT NULL` | `R` | `W` | cena |
| `Products` | `MinOrderQty` | int | `NOT NULL` | `R po quick add` | `W` | minimalna ilość zamówienia |
| `Products` | `TotalStock` | int | `NOT NULL` | `R` | `W` z `OpeningStock` | stan całkowity |
| `Products` | `ReservedStock` | int | `NOT NULL` | `R` | `W domyślne 0` | rezerwacje |
| `Products` | `IsActive` | bool | `NOT NULL` | `R` | `W domyślne true` | aktywność produktu |
| `Products` | `ImageUrl` | max 500 | `NULL` | `R` | `W` albo `NULL` | obraz produktu |
| `Products` | `CreatedAtUtc` | `DateTime` | `NOT NULL` | `brak na UI` | `W domyślne DateTime.UtcNow` | audyt domenowy |
| `Products` | `UpdatedAtUtc` | `DateTime` | `NOT NULL` | `brak na UI listy` | `W DateTime.UtcNow` | audyt domenowy |
| `Categories` | `CategoryId` | key `Guid` | `NOT NULL` | `R` | `R`, walidacja `CategoryExistsAsync` | select kategorii |
| `Categories` | `Name` | max 140 | `NOT NULL` | `R` | `R` | nazwy parent/child |
| `Categories` | `ParentCategoryId` | FK self | `NULL` | `R` | `R` | hierarchia parent/child |
| `OutboxMessages` | `MessageId` | key `Guid` | `NOT NULL` | brak | `W` | event `ProductCreated` |
| `OutboxMessages` | `EventType` | max 200 | `NOT NULL` | brak | `W` | `ProductCreated` |
| `OutboxMessages` | `Payload` | required | `NOT NULL` | brak | `W` | `ProductId`, `Sku`, `Name`, `occurredAtUtc` |
| `OutboxMessages` | `Status` | string max 32 | provider/default zależny od encji | brak | `W domyślne encji` | dispatch outbox |
| `OutboxMessages` | `Error` | max 2000 | `NULL` | brak | brak bez błędu dispatchera | diagnostyka outbox |
| `StockTransactions` | `TxId`, `ProductId`, `TransactionType`, `Quantity`, `ReferenceId` | tabela istnieje | `NOT NULL` dla głównych pól | brak | `brak w kodzie` | create nie tworzy transakcji opening stock |

## Relacje

| Relacja | Typ | Źródło |
|---|---|---|
| `Products.CategoryId` -> `Categories.CategoryId` | fizyczny FK, `DeleteBehavior.Restrict` | `CatalogInventoryDbContext` |
| `Categories.ParentCategoryId` -> `Categories.CategoryId` | fizyczny self-FK, `DeleteBehavior.Restrict` | `CatalogInventoryDbContext` |
| `StockTransactions.ProductId` -> `Products.ProductId` | fizyczny FK, `DeleteBehavior.Cascade` | `CatalogInventoryDbContext` |

## Mapowanie E-008 Pole UI -> DTO -> DB

| Pole UI | DTO | Encja/domena | Tabela.Kolumna | R/W |
|---|---|---|---|---|
| [P-008-0001 SKU](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0001__sku.md) | `CreateProductRequest.Sku` | `Product.Create`, trim i uppercase | `Products.Sku` | `W` |
| [P-008-0002 Name](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0002__name.md) | `CreateProductRequest.Name` | `Product.Create`, trim | `Products.Name` | `W` |
| [P-008-0003 Unit Price](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0003__unitprice.md) | `CreateProductRequest.UnitPrice` | `Product.Create` | `Products.UnitPrice` | `W` |
| [P-008-0004 Min Order Qty](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0004__minorderqty.md) | `CreateProductRequest.MinOrderQty` | `Product.Create` | `Products.MinOrderQty` | `W` |
| [P-008-0005 Opening Stock](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0005__openingstock.md) | `CreateProductRequest.OpeningStock` | `Product.Create` | `Products.TotalStock` | `W` |
| [P-008-0006 Category](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0006__categoryid.md) | `CreateProductRequest.CategoryId` | `CategoryExistsAsync` i FK | `Products.CategoryId`, `Categories.CategoryId` | `R/W` |
| [P-008-0007 Description](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0007__description.md) | `CreateProductRequest.Description` | `Product.Create`, trim | `Products.Description` | `W` |
| [P-008-0008 Image URL](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008-0008__imageurl.md) | `CreateProductRequest.ImageUrl` | null dla pustej wartości | `Products.ImageUrl` | `W` |

## Wyliczenia

| Pole | Definicja | DB |
|---|---|---|
| `AvailableStock` | `TotalStock - ReservedStock` | właściwość domenowa, nie osobna kolumna EF |

## Luki

| ID | Luka | Status |
|---|---|---|
| `GAP-DATA-007-001` | Quick add zapisuje tylko `CartStore`; nie ma zapisu DB do czasu checkout. | `potwierdzone` |
| `GAP-DATA-008-001` | `OpeningStock` nie tworzy rekordu `StockTransactions`, więc początkowy stan nie ma osobnej transakcji audytowej. | `brak w kodzie` |
