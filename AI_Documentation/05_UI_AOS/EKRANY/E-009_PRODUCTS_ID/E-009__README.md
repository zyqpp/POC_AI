# E-009 Szczegół Produktu

Status: `potwierdzone` dla śladu `UI -> API -> proces -> DB -> testy`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-009` |
| Route | `/products/:id` |
| Komponent | `ProductDetailComponent` |
| Guardy | `authGuard` na shell route; brak osobnego `roleGuard` na route produktu |
| Role w UI | `Admin`, `Dealer`, `Warehouse` przez `AuthStore.hasRole(...)` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` |
| Backend | `ProductsController`, `CatalogInventoryService` |
| Model danych | `Products`, `StockTransactions`, `OutboxMessages`; recenzje: `brak tabeli SQL` |

## Cel Ekranu

Ekran pokazuje szczegół produktu, dostępny stock i recenzje. Dealer może dobrać ilość i dodać produkt do lokalnego koszyka, Admin może dezaktywować produkt i moderować recenzje, a Admin lub Warehouse mogą wykonać restock.

## Dokumenty Atomowe

- [Pola UI](P-009_POLA/P-009__INDEX.md)
- [Akcje UI](A-009_AKCJE/A-009__INDEX.md)
- [Błędy i komunikaty](ERR-009_BLEDY/ERR-009__INDEX.md)
- [Dane testowe](TD-009_DANE_TESTOWE/TD-009__INDEX.md)
- [Testy](TC-009_TESTY/TC-009__INDEX.md)
- [Linki śladu](E-009__LINKI.md)

## Ślad End-To-End

| Krok | Fakt | Źródło | Status |
|---|---|---|---|
| Load product | `ngOnInit()` wywołuje `GET /catalog/api/products/{id}`. | `ProductDetailComponent`, `CatalogApiService` | `potwierdzone` |
| Product DB | `ProductDto` mapuje się na `Products`; `AvailableStock` jest wyliczone. | `Product.cs`, `CatalogInventoryService` | `potwierdzone` |
| Load reviews | Po załadowaniu produktu ekran pobiera reviews z `includePending=isAdmin()`. | `loadReviews()` | `potwierdzone` |
| Reviews storage | Reviews są w statycznym `ConcurrentDictionary`, bez tabeli SQL. | `CatalogInventoryService` | `potwierdzone` |
| Add to cart | Dealer zapisuje produkt do `CartStore`, bez API i bez DB. | `CartStore` | `potwierdzone` |
| Restock | Admin/Warehouse zapisuje `Products.TotalStock`, `StockTransactions`, `OutboxMessages`. | `RestockProductAsync` | `potwierdzone` |
| Deactivate | Admin ustawia `Products.IsActive=false` i outbox `ProductDeactivated`. | `DeactivateProductAsync` | `potwierdzone` |
| Review moderation | Admin approve/reject zmienia status review w pamięci procesu. | `ApproveProductReviewAsync`, `RejectProductReviewAsync` | `potwierdzone` |

## Luki I Ryzyka

| ID | Luka | Wpływ | Status |
|---|---|---|---|
| `GAP-E-009-001` | Recenzje produktu nie mają trwałości w SQL. | Utrata/niespójność review po restarcie lub wielu instancjach API. | `brak w kodzie` |
| `GAP-E-009-002` | Ekran nie ma pola noty moderacyjnej, choć backend przyjmuje `Note`. | Admin nie może podać powodu approve/reject z tego ekranu. | `brak w kodzie` |
| `GAP-E-009-003` | Po dodaniu review przez Dealera pending review znika po reload, bo `includePending=false`. | Użytkownik może uznać, że recenzja nie została zapisana. | `potwierdzone` |
| `GAP-E-009-004` | Błędy restock/deactivate mają puste handlery w UI. | Brak informacji o niepowodzeniu. | `brak w kodzie` |
| `GAP-E-009-005` | Brak testów komponentu, API, ról, walidatorów i cache invalidation. | Regresje E-009 mogą przejść niezauważone. | `brak w kodzie` |
