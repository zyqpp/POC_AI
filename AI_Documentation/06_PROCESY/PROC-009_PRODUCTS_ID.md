# PROC-009 Szczegół Produktu

Status: `potwierdzone` dla śladu `UI -> API -> proces -> DB -> testy`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| Proces | `PROC-009_PRODUCTS_ID` |
| Ekran | [E-009_PRODUCTS_ID](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/E-009__README.md) |
| Route | `/products/:id` |
| Główne role | `Admin`, `Dealer`, `Warehouse` |
| API | [API_CATALOG](../04_API/API_CATALOG.md) |
| Model danych | [MODEL_DANYCH_CATALOG](../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Testy | [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md) |

## Przepływy

| ID | Przepływ | UI | API | DB / skutek |
|---|---|---|---|---|
| `PROC-009-FLOW-001` | załadowanie produktu | [A-009-0014](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/A-009_AKCJE/A-009-0014__load-product-and-reviews.md) | `GET /catalog/api/products/{id}` | odczyt `Products` |
| `PROC-009-FLOW-002` | dodanie do koszyka | [A-009-0005](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/A-009_AKCJE/A-009-0005__addtocart.md) | brak | `CartStore`, brak DB |
| `PROC-009-FLOW-003` | dezaktywacja | [A-009-0001](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/A-009_AKCJE/A-009-0001__deactivate.md) | `PUT /catalog/api/products/{id}/deactivate` | `Products.IsActive=false`, outbox |
| `PROC-009-FLOW-004` | restock | [A-009-0011](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/A-009_AKCJE/A-009-0011__restock.md) | `POST /catalog/api/products/{id}/restock` | `Products.TotalStock`, `StockTransactions`, outbox |
| `PROC-009-FLOW-005` | review Dealera | [A-009-0007](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/A-009_AKCJE/A-009-0007__submitreview.md) | `POST /catalog/api/products/{id}/reviews` | pamięć procesu, brak SQL |
| `PROC-009-FLOW-006` | moderacja review | [A-009-0008](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/A-009_AKCJE/A-009-0008__approvereview.md), [A-009-0009](../05_UI_AOS/EKRANY/E-009_PRODUCTS_ID/A-009_AKCJE/A-009-0009__rejectreview.md) | `PUT /catalog/api/products/reviews/{reviewId}/approve|reject` | pamięć procesu, brak SQL |

## Dane Krytyczne

| Dane | Źródło | Status |
|---|---|---|
| `AvailableStock` | `Products.TotalStock - Products.ReservedStock` | `potwierdzone` |
| `Restock` | `Products.TotalStock`, `StockTransactions`, `OutboxMessages` | `potwierdzone` |
| `Review` | `CatalogInventoryService.ReviewsById` | `potwierdzone`, `brak tabeli SQL` |
| `Cart` | `CartStore` i localStorage `sc_cart` | `wniosek z analizy frontendu` |

## Kryteria Zamknięcia

| Test | Kryterium |
|---|---|
| `TC-009-0001` | produkt i pola stock widoczne po `GET` |
| `TC-009-0004` | Dealer dodaje do `CartStore` albo dostaje właściwy toast |
| `TC-009-0005` | restock aktualizuje `Products`, `StockTransactions`, `OutboxMessages` |
| `TC-009-0010` | approve/reject review działa, a brak trwałości SQL jest opisany jako ryzyko |
