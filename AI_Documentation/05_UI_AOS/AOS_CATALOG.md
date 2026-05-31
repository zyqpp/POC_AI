# AOS_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS`, `E-008_PRODUCTS_NEW`, `E-009_PRODUCTS_ID`; dokument będzie rozszerzany przy `E-010`.

## Ekrany

| Ekran | Route | Status | Zakres |
|---|---|---|---|
| [E-007_PRODUCTS](EKRANY/E-007_PRODUCTS/E-007__README.md) | `/products` | `potwierdzone` | lista, search, filtry, quick add |
| [E-008_PRODUCTS_NEW](EKRANY/E-008_PRODUCTS_NEW/E-008__README.md) | `/products/new` | `potwierdzone` | tworzenie produktu, walidacje, zapis katalogu |
| [E-009_PRODUCTS_ID](EKRANY/E-009_PRODUCTS_ID/E-009__README.md) | `/products/:id` | `potwierdzone` | szczegół produktu, koszyk, restock, deactivate, reviews |
| `E-010_PRODUCTS_ID_EDIT` | `/products/:id/edit` | `planowane po E-009` | edycja produktu |

## End-To-End

| Obszar | Dokument |
|---|---|
| API | [API_CATALOG](../04_API/API_CATALOG.md) |
| Model danych | [MODEL_DANYCH_CATALOG](../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Proces listy | [PROC-007_PRODUCTS](../06_PROCESY/PROC-007_PRODUCTS.md) |
| Proces tworzenia | [PROC-008_PRODUCTS_NEW](../06_PROCESY/PROC-008_PRODUCTS_NEW.md) |
| Proces szczegółu | [PROC-009_PRODUCTS_ID](../06_PROCESY/PROC-009_PRODUCTS_ID.md) |
| Role | [ROLE_CATALOG](../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md) |
| Testy | [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md) |

## Model Danych

`E-007` odczytuje `Products` i `Categories`. `E-008` zapisuje `Products` oraz `OutboxMessages`. `E-009` odczytuje szczegół produktu z `Products`, zapisuje restock do `Products`, `StockTransactions` i `OutboxMessages`, a recenzje obsługuje w pamięci procesu bez tabeli SQL.

## API I Kontrakty

Katalog używa endpointów produktów, stocku i recenzji opisanych w [API_CATALOG](../04_API/API_CATALOG.md). Szczególnie istotne ryzyko E-009: endpointy review istnieją, ale trwałość review nie jest oparta o SQL.

## Testy I Luki

Wymagania testowe są w [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md). Istnieją tylko wybrane testy domeny `Product`; brak testów komponentów, API i ról dla ekranów katalogu.

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-CATALOG-007-001` | Quick add jest stanem frontendowym bez zapisu DB do czasu checkout. | `potwierdzone` |
| `RISK-CATALOG-008-001` | `ProductFormComponent.submit()` nie pokazuje użytkownikowi błędu API przy duplikacie SKU albo nieistniejącej kategorii. | `brak w kodzie` |
| `RISK-CATALOG-008-002` | `openingStock` ustawia stan magazynu, ale nie tworzy audytowalnej transakcji `StockTransactions`. | `brak w kodzie` |
| `RISK-CATALOG-009-001` | Recenzje są w pamięci procesu, bez tabeli SQL i bez trwałości po restarcie. | `brak w kodzie` |
| `RISK-CATALOG-009-002` | Restock/deactivate mają puste handlery błędów w UI. | `brak w kodzie` |
