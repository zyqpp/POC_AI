# AOS_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS`, `E-008_PRODUCTS_NEW`, `E-009_PRODUCTS_ID`, `E-010_PRODUCTS_ID_EDIT`.

## Ekrany

| Ekran | Route | Status | Zakres |
|---|---|---|---|
| [E-007_PRODUCTS](EKRANY/E-007_PRODUCTS/E-007__README.md) | `/products` | `potwierdzone` | lista, search, filtry, quick add |
| [E-008_PRODUCTS_NEW](EKRANY/E-008_PRODUCTS_NEW/E-008__README.md) | `/products/new` | `potwierdzone` | tworzenie produktu, walidacje, zapis katalogu |
| [E-009_PRODUCTS_ID](EKRANY/E-009_PRODUCTS_ID/E-009__README.md) | `/products/:id` | `potwierdzone` | szczegół produktu, koszyk, restock, deactivate, reviews |
| [E-010_PRODUCTS_ID_EDIT](EKRANY/E-010_PRODUCTS_ID_EDIT/E-010__README.md) | `/products/:id/edit` | `potwierdzone` | edycja produktu, readonly SKU, brak update stocku, active checkbox |

## End-To-End

| Obszar | Dokument |
|---|---|
| API | [API_CATALOG](../04_API/API_CATALOG.md) |
| Model danych | [MODEL_DANYCH_CATALOG](../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Proces listy | [PROC-007_PRODUCTS](../06_PROCESY/PROC-007_PRODUCTS.md) |
| Proces tworzenia | [PROC-008_PRODUCTS_NEW](../06_PROCESY/PROC-008_PRODUCTS_NEW.md) |
| Proces szczegółu | [PROC-009_PRODUCTS_ID](../06_PROCESY/PROC-009_PRODUCTS_ID.md) |
| Proces edycji | [PROC-010_PRODUCTS_ID_EDIT](../06_PROCESY/PROC-010_PRODUCTS_ID_EDIT.md) |
| Role | [ROLE_CATALOG](../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md) |
| Testy | [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md) |

## Model Danych

`E-007` odczytuje `Products` i `Categories`. `E-008` zapisuje `Products` oraz `OutboxMessages`. `E-009` odczytuje szczegół produktu z `Products`, zapisuje restock do `Products`, `StockTransactions` i `OutboxMessages`, a recenzje obsługuje w pamięci procesu bez tabeli SQL. `E-010` aktualizuje wybrane kolumny `Products`, sprawdza `Categories`, zapisuje `OutboxMessages.ProductUpdated`, ale nie zmienia `Products.Sku`, `Products.TotalStock` ani `StockTransactions`.

## API I Kontrakty

Katalog używa endpointów produktowych opisanych w [API_CATALOG](../04_API/API_CATALOG.md). Dla E-010 krytyczny jest `API-010-0001`: `PUT /catalog/api/products/{id}` z `UpdateProductRequest`, rolą `Admin` i odpowiedzią `ProductDto`.

## Testy I Luki

Wymagania testowe są w [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md). Istnieją tylko wybrane testy domeny `Product`; brak testów komponentów, API i ról dla ekranów katalogu. Dla E-010 najważniejsze braki to test `Product.Update`, test API update oraz regresja potwierdzająca, że edit nie zmienia SKU i stocku.

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-CATALOG-007-001` | Quick add jest stanem frontendowym bez zapisu DB do czasu checkout. | `potwierdzone` |
| `RISK-CATALOG-008-001` | `ProductFormComponent.submit()` nie pokazuje użytkownikowi błędu API przy duplikacie SKU albo nieistniejącej kategorii. | `brak w kodzie` |
| `RISK-CATALOG-008-002` | `openingStock` ustawia stan magazynu, ale nie tworzy audytowalnej transakcji `StockTransactions`. | `brak w kodzie` |
| `RISK-CATALOG-009-001` | Recenzje są w pamięci procesu, bez tabeli SQL i bez trwałości po restarcie. | `brak w kodzie` |
| `RISK-CATALOG-009-002` | Restock/deactivate mają puste handlery błędów w UI. | `brak w kodzie` |
| `RISK-CATALOG-010-001` | Edit product ma pusty error handler submit i brak widocznego stanu 404. | `brak w kodzie` |
| `RISK-CATALOG-010-002` | Brak testu potwierdzającego, że E-010 nie zapisuje `Sku` i `TotalStock`. | `brak w kodzie` |
