# AOS_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS` i `E-008_PRODUCTS_NEW`; dokument będzie rozszerzany przy `E-009` i `E-010`.

## Ekrany

| Ekran | Route | Status | Zakres |
|---|---|---|---|
| [E-007_PRODUCTS](EKRANY/E-007_PRODUCTS/E-007__README.md) | `/products` | `potwierdzone` | lista, search, filtry, quick add |
| [E-008_PRODUCTS_NEW](EKRANY/E-008_PRODUCTS_NEW/E-008__README.md) | `/products/new` | `potwierdzone` | tworzenie produktu, walidacje, zapis katalogu |
| `E-009_PRODUCTS_ID` | `/products/:id` | `planowane w następnym commicie` | szczegół produktu, restock, deactivate, reviews |
| `E-010_PRODUCTS_ID_EDIT` | `/products/:id/edit` | `planowane po E-009` | edycja produktu |

## End-To-End

| Obszar | Dokument |
|---|---|
| API | [API_CATALOG](../04_API/API_CATALOG.md) |
| Model danych | [MODEL_DANYCH_CATALOG](../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Proces listy | [PROC-007_PRODUCTS](../06_PROCESY/PROC-007_PRODUCTS.md) |
| Proces tworzenia | [PROC-008_PRODUCTS_NEW](../06_PROCESY/PROC-008_PRODUCTS_NEW.md) |
| Role | [ROLE_CATALOG](../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md) |
| Testy | [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md) |

## Model Danych

`E-007` odczytuje `Products` i `Categories`. `E-008` zapisuje `Products` oraz `OutboxMessages`, a `Categories` wykorzystuje do wyboru i walidacji `CategoryId`. Pole `AvailableStock` jest wyliczane w domenie jako `TotalStock - ReservedStock`. W trybie create `openingStock` zapisuje się do `Products.TotalStock`, ale nie powstaje rekord `StockTransactions`; status tej transakcji: `brak w kodzie`.

## API I Kontrakty

`E-007` używa endpointów listy, kategorii, search i szczegółu produktu. `E-008` używa `GET /catalog/api/products/categories` oraz `POST /catalog/api/products` z `CreateProductRequest`. Szczegóły kontraktów są w [API_CATALOG](../04_API/API_CATALOG.md).

## Testy I Luki

Brak testów komponentu i testów integracyjnych API dla `E-007` i `E-008`. Wymagane scenariusze są w [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md).

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-CATALOG-007-001` | Quick add jest stanem frontendowym bez zapisu DB do czasu checkout. | `potwierdzone` |
| `RISK-CATALOG-008-001` | `ProductFormComponent.submit()` nie pokazuje użytkownikowi błędu API przy duplikacie SKU albo nieistniejącej kategorii. | `brak w kodzie` |
| `RISK-CATALOG-008-002` | `openingStock` ustawia stan magazynu, ale nie tworzy audytowalnej transakcji `StockTransactions`. | `brak w kodzie` |
