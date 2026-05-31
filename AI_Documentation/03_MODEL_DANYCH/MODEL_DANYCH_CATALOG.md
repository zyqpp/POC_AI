# MODEL_DANYCH_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS`; dokument będzie rozszerzany przy `E-008`-`E-010`.

## CatalogInventory

| Tabela | Kolumna | Typ/konfiguracja EF | Nullability | R/W w E-007 | Użycie |
|---|---|---|---|---|---|
| `Products` | `ProductId` | key `Guid` | `NOT NULL` | `R` | link do szczegółu i quick add |
| `Products` | `Sku` | max 60, unique index | `NOT NULL` | `R` | karta, search |
| `Products` | `Name` | max 200 | `NOT NULL` | `R` | karta, search, sort |
| `Products` | `Description` | max 2000 | `NOT NULL` | `brak na UI` | używane w szczególe/formie |
| `Products` | `CategoryId` | FK do `Categories` | `NOT NULL` | `R` | filtr kategorii |
| `Products` | `UnitPrice` | precision 18,2 | `NOT NULL` | `R` | cena, sort |
| `Products` | `MinOrderQty` | int | `NOT NULL` | `R po quick add` | normalizacja ilości w koszyku |
| `Products` | `TotalStock` | int | `NOT NULL` | `R` | wyliczenie stock |
| `Products` | `ReservedStock` | int | `NOT NULL` | `R` | wyliczenie stock |
| `Products` | `IsActive` | bool | `NOT NULL` | `R` | badge, quick add, inactive |
| `Products` | `ImageUrl` | max 500 | `NULL` | `R` | miniatura produktu |
| `Categories` | `CategoryId` | key `Guid` | `NOT NULL` | `R` | select kategorii |
| `Categories` | `Name` | max 140 | `NOT NULL` | `R` | nazwy kategorii |
| `Categories` | `ParentCategoryId` | FK self | `NULL` | `R` | hierarchia parent/child |

## Relacje

| Relacja | Typ | Źródło |
|---|---|---|
| `Products.CategoryId` -> `Categories.CategoryId` | fizyczny FK, `DeleteBehavior.Restrict` | `CatalogInventoryDbContext` |
| `Categories.ParentCategoryId` -> `Categories.CategoryId` | fizyczny self-FK, `DeleteBehavior.Restrict` | `CatalogInventoryDbContext` |

## Wyliczenia

| Pole | Definicja | DB |
|---|---|---|
| `AvailableStock` | `TotalStock - ReservedStock` | właściwość domenowa, nie osobna kolumna EF |

## Luki

| ID | Luka | Status |
|---|---|---|
| `GAP-DATA-007-001` | Quick add zapisuje tylko `CartStore`; nie ma zapisu DB do czasu checkout. | `potwierdzone` |
