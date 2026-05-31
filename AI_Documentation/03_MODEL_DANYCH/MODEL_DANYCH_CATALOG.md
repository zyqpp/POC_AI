# MODEL_DANYCH_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS`, `E-008_PRODUCTS_NEW`, `E-009_PRODUCTS_ID`; dokument będzie rozszerzany przy `E-010`.

## CatalogInventory

| Tabela | Kolumna | Typ/konfiguracja EF | Nullability | R/W E-007 | R/W E-008 | R/W E-009 | Użycie |
|---|---|---|---|---|---|---|---|
| `Products` | `ProductId` | key `Guid` | `NOT NULL` | `R` | `W` | `R` | identyfikator produktu |
| `Products` | `Sku` | max 60, unique index | `NOT NULL` | `R` | `W` | `R` | SKU |
| `Products` | `Name` | max 200 | `NOT NULL` | `R` | `W` | `R` | nazwa |
| `Products` | `Description` | max 2000 | `NOT NULL` | brak na liście | `W` | `R` | opis |
| `Products` | `CategoryId` | FK do `Categories` | `NOT NULL` | `R` | `W` | `R` | kategoria |
| `Products` | `UnitPrice` | precision 18,2 | `NOT NULL` | `R` | `W` | `R` | cena |
| `Products` | `MinOrderQty` | int | `NOT NULL` | `R` | `W` | `R` | krok i minimum koszyka |
| `Products` | `TotalStock` | int | `NOT NULL` | `R` | `W` z opening stock | `R/W` przez restock | stock |
| `Products` | `ReservedStock` | int | `NOT NULL` | `R` | domyślne 0 | `R` | rezerwacje |
| `Products` | `IsActive` | bool | `NOT NULL` | `R` | domyślne true | `R/W` przez deactivate | status |
| `Products` | `ImageUrl` | max 500 | `NULL` | `R` | `W` | `R` | obraz |
| `Products` | `CreatedAtUtc` | `DateTime` | `NOT NULL` | brak | `W` | brak na UI | audyt |
| `Products` | `UpdatedAtUtc` | `DateTime` | `NOT NULL` | brak | `W` | `R/W` restock/deactivate | audyt |
| `Categories` | `CategoryId` | key `Guid` | `NOT NULL` | `R` | `R` | logiczny R | wybór kategorii |
| `Categories` | `Name` | max 140 | `NOT NULL` | `R` | `R` | brak na E-009 | nazwy |
| `Categories` | `ParentCategoryId` | FK self | `NULL` | `R` | `R` | brak na E-009 | hierarchia |
| `StockTransactions` | `TxId` | key `Guid` | `NOT NULL` | brak | brak | `W` | restock |
| `StockTransactions` | `ProductId` | FK do `Products` | `NOT NULL` | brak | brak | `W` | produkt transakcji |
| `StockTransactions` | `TransactionType` | string max 40 | `NOT NULL` | brak | brak | `W`, `Restock` | typ transakcji |
| `StockTransactions` | `Quantity` | int | `NOT NULL` | brak | brak | `W` | ilość restock |
| `StockTransactions` | `ReferenceId` | max 120 | `NOT NULL` | brak | brak | `W` | referencja restock |
| `StockTransactions` | `CreatedAtUtc` | `DateTime` | `NOT NULL` | brak | brak | `W` | czas transakcji |
| `OutboxMessages` | `MessageId`, `EventType`, `Payload`, `Status`, `Error` | outbox | zależne od kolumny | brak | `W ProductCreated` | `W ProductDeactivated`, `W StockRestored` | integracje/eventy |

## Relacje

| Relacja | Typ | Źródło |
|---|---|---|
| `Products.CategoryId` -> `Categories.CategoryId` | fizyczny FK, `DeleteBehavior.Restrict` | `CatalogInventoryDbContext` |
| `Categories.ParentCategoryId` -> `Categories.CategoryId` | fizyczny self-FK, `DeleteBehavior.Restrict` | `CatalogInventoryDbContext` |
| `StockTransactions.ProductId` -> `Products.ProductId` | fizyczny FK, `DeleteBehavior.Cascade` | `CatalogInventoryDbContext` |

## Mapowanie E-009

| Obszar | UI | API/DTO | Tabela.Kolumna |
|---|---|---|---|
| dane produktu | [P-009-0011](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/P-009_POLA/P-009-0011__product-name.md) do [P-009-0021](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/P-009_POLA/P-009-0021__product-image.md) | `ProductDto` | `Products.*`, `AvailableStock` wyliczone |
| koszyk | [P-009-0001](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/P-009_POLA/P-009-0001__qty.md) | brak API | brak DB, `CartStore` |
| restock | [P-009-0005](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/P-009_POLA/P-009-0005__restockqty.md), [P-009-0006](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/P-009_POLA/P-009-0006__restockref.md) | `RestockProductRequest` | `Products.TotalStock`, `StockTransactions`, `OutboxMessages` |
| deactivate | [A-009-0001](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/A-009_AKCJE/A-009-0001__deactivate.md) | `DeactivateProductCommand` | `Products.IsActive`, `OutboxMessages` |
| reviews | [P-009-0002](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/P-009_POLA/P-009-0002__reviewrating.md) do [P-009-0010](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/P-009_POLA/P-009-0010__r-moderationnote.md) | `ProductReviewDto` | `brak tabeli SQL`, `ReviewsById` |

## Wyliczenia

| Pole | Definicja | DB |
|---|---|---|
| `AvailableStock` | `TotalStock - ReservedStock` | właściwość domenowa, nie osobna kolumna EF |
| `maxPurchasable` | największa wielokrotność `MinOrderQty` nieprzekraczająca `AvailableStock` | frontend, brak kolumny |

## Luki

| ID | Luka | Status |
|---|---|---|
| `GAP-DATA-007-001` | Quick add zapisuje tylko `CartStore`; nie ma zapisu DB do czasu checkout. | `potwierdzone` |
| `GAP-DATA-008-001` | `OpeningStock` nie tworzy rekordu `StockTransactions`, więc początkowy stan nie ma osobnej transakcji audytowej. | `brak w kodzie` |
| `GAP-DATA-009-001` | Reviews nie mają tabeli SQL ani trwałości. | `brak w kodzie` |
