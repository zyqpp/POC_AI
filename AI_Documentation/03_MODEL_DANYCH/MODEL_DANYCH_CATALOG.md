# MODEL_DANYCH_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS`, `E-008_PRODUCTS_NEW`, `E-009_PRODUCTS_ID`, `E-010_PRODUCTS_ID_EDIT`.

## CatalogInventory

| Tabela | Kolumna | Typ/konfiguracja EF | Nullability | R/W E-007 | R/W E-008 | R/W E-009 | R/W E-010 | Użycie |
|---|---|---|---|---|---|---|---|---|
| `Products` | `ProductId` | key `Guid` | `NOT NULL` | `R` | `W` | `R` | `R` | identyfikator produktu |
| `Products` | `Sku` | max 60, unique index | `NOT NULL` | `R` | `W` | `R` | `R`, readonly | SKU |
| `Products` | `Name` | max 200 | `NOT NULL` | `R` | `W` | `R` | `R/W` | nazwa |
| `Products` | `Description` | max 2000 | `NOT NULL` | brak na liście | `W` | `R` | `R/W` | opis |
| `Products` | `CategoryId` | FK do `Categories` | `NOT NULL` | `R` | `W` | `R` | `R/W` | kategoria |
| `Products` | `UnitPrice` | precision 18,2 | `NOT NULL` | `R` | `W` | `R` | `R/W` | cena |
| `Products` | `MinOrderQty` | int | `NOT NULL` | `R` | `W` | `R` | `R/W` | minimum zamówienia |
| `Products` | `TotalStock` | int | `NOT NULL` | `R` | `W` z opening stock | `R/W` przez restock | `R`, brak zapisu w edit | stock |
| `Products` | `ReservedStock` | int | `NOT NULL` | `R` | domyślne 0 | `R` | `R`, brak zapisu w edit | rezerwacje |
| `Products` | `IsActive` | bool | `NOT NULL` | `R` | domyślne true | `R/W` przez deactivate | `R/W` przez checkbox | status |
| `Products` | `ImageUrl` | max 500 | `NULL` | `R` | `W` | `R` | `R/W` | obraz |
| `Products` | `CreatedAtUtc` | `DateTime` | `NOT NULL` | brak | `W` | brak na UI | brak na UI | audyt |
| `Products` | `UpdatedAtUtc` | `DateTime` | `NOT NULL` | brak | `W` | `R/W` restock/deactivate | `W` przez `Product.Update` | audyt |
| `Categories` | `CategoryId` | key `Guid` | `NOT NULL` | `R` | `R` | logiczny R | `R`, walidacja FK | wybór kategorii |
| `Categories` | `Name` | max 140 | `NOT NULL` | `R` | `R` | brak na E-009 | `R` | nazwy |
| `Categories` | `ParentCategoryId` | FK self | `NULL` | `R` | `R` | brak na E-009 | `R` | hierarchia |
| `StockTransactions` | `TxId` | key `Guid` | `NOT NULL` | brak | brak | `W` | brak | restock |
| `StockTransactions` | `ProductId` | FK do `Products` | `NOT NULL` | brak | brak | `W` | brak | produkt transakcji |
| `StockTransactions` | `TransactionType` | string max 40 | `NOT NULL` | brak | brak | `W`, `Restock` | brak | typ transakcji |
| `StockTransactions` | `Quantity` | int | `NOT NULL` | brak | brak | `W` | brak | ilość restock |
| `StockTransactions` | `ReferenceId` | max 120 | `NOT NULL` | brak | brak | `W` | brak | referencja restock |
| `StockTransactions` | `CreatedAtUtc` | `DateTime` | `NOT NULL` | brak | brak | `W` | brak | czas transakcji |
| `OutboxMessages` | `MessageId`, `EventType`, `Payload`, `Status`, `Error` | outbox | zależne od kolumny | brak | `W ProductCreated` | `W ProductDeactivated`, `W StockRestored` | `W ProductUpdated` | integracje/eventy |

## Relacje

| Relacja | Typ | Źródło |
|---|---|---|
| `Products.CategoryId` -> `Categories.CategoryId` | fizyczny FK, `DeleteBehavior.Restrict` | `CatalogInventoryDbContext` |
| `Categories.ParentCategoryId` -> `Categories.CategoryId` | fizyczny self-FK, `DeleteBehavior.Restrict` | `CatalogInventoryDbContext` |
| `StockTransactions.ProductId` -> `Products.ProductId` | fizyczny FK, `DeleteBehavior.Cascade` | `CatalogInventoryDbContext` |

## Mapowanie E-010

| Obszar | UI | API/DTO | Tabela.Kolumna |
|---|---|---|---|
| SKU readonly | [P-010-0001](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0001__sku.md) | `ProductDto.Sku`, brak w `UpdateProductRequest` | `Products.Sku` tylko `R` |
| dane edytowane | [P-010-0002](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0002__name.md), [P-010-0003](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0003__unitprice.md), [P-010-0004](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0004__minorderqty.md), [P-010-0007](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0007__description.md), [P-010-0008](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0008__imageurl.md), [P-010-0009](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0009__isactive.md) | `UpdateProductRequest` | `Products.Name`, `UnitPrice`, `MinOrderQty`, `Description`, `ImageUrl`, `IsActive`, `UpdatedAtUtc` |
| kategoria | [P-010-0006](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0006__categoryid.md), [P-010-0010](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0010__group-parent-name.md), [P-010-0011](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0011__child-name.md) | `CategoryDto`, `UpdateProductRequest.CategoryId` | `Categories R`, `Products.CategoryId W` |
| stock | [P-010-0005](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/P-010_POLA/P-010-0005__openingstock.md) | brak w update | `Products.TotalStock` bez zapisu, `StockTransactions` brak |
| outbox | [A-010-0001](../05_UI_AOS/EKRANY/E-010_PRODUCTS_ID_EDIT/A-010_AKCJE/A-010-0001__submit.md) | `ProductUpdated` | `OutboxMessages W` |

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
| `GAP-DATA-010-001` | Brak testu potwierdzającego, że E-010 nie zmienia `Products.Sku`, `Products.TotalStock` i nie tworzy `StockTransactions`. | `brak w kodzie` |
