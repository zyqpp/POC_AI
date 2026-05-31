# TC-009 Testy

Status: `potwierdzone` jako wymagania testowe; automatyzacja UI/API ma status `brak w kodzie`.

| ID | Przypadek testowy | Dane | Typ | Status | Kryterium zamknięcia |
|---|---|---|---|---|---|
| `TC-009-0001` | Ekran ładuje produkt i podstawowe pola. | `TD-009-0011`, `TD-009-0013` | component/API integration | `brak w kodzie` | Widoczne name, SKU, cena, stock, min order, updated, image/fallback. |
| `TC-009-0002` | Produkt nie istnieje oraz akcje Admina są widoczne tylko dla Admina. | `TD-009-0011`, `TD-009-0012` | e2e/component | `brak w kodzie` | Empty state dla 404; Admin widzi edit/deactivate, inni nie. |
| `TC-009-0003` | Kontrola ilości normalizuje min/max/krok. | `TD-009-0001`, `TD-009-0013` | component | `brak w kodzie` | `qty` jest wielokrotnością `MinOrderQty` i nie przekracza `maxPurchasable`. |
| `TC-009-0004` | Dealer dodaje produkt do koszyka albo dostaje błędy stock. | `TD-009-0001`, `TD-009-0013` | component/store | `brak w kodzie` | `CartStore` zawiera pozycję albo pokazany jest `ERR-009-0001/2/3`. |
| `TC-009-0005` | Admin/Warehouse wykonuje restock. | `TD-009-0005`, `TD-009-0006` | API integration | `brak w kodzie` | `Products.TotalStock` wzrasta, `StockTransactions` i `OutboxMessages` zapisane. |
| `TC-009-0006` | Restock/deactivate obsługują błędy. | `TD-009-0005`, `TD-009-0006`, `TD-009-0011` | component/API | `brak w kodzie` | Obecnie luka: brak toastu błędu dla error handlerów. |
| `TC-009-0007` | Dealer wysyła review do moderacji. | `TD-009-0002`, `TD-009-0003`, `TD-009-0004` | API integration/component | `brak w kodzie` | Request `POST`, toast sukcesu, pola wyczyszczone; pending znika u Dealera po reload. |
| `TC-009-0008` | Lista reviews pokazuje approved dla Dealer i pending dla Admin. | `TD-009-0007`, `TD-009-0008`, `TD-009-0009`, `TD-009-0012` | API/component | `brak w kodzie` | `includePending=true` tylko dla Admina. |
| `TC-009-0009` | Walidacje review odrzucają rating/title/comment poza zakresem. | `TD-009-0002`, `TD-009-0003`, `TD-009-0004` | API validation | `brak w kodzie` | Walidator zwraca błąd, brak review w `ReviewsById`. |
| `TC-009-0010` | Admin zatwierdza i odrzuca review. | `TD-009-0007`, `TD-009-0010`, `TD-009-0012` | API/component | `brak w kodzie` | Badge zmienia się na `Approved` albo `Rejected`; brak tabeli SQL jest jawnie zweryfikowany jako luka trwałości. |

## Testy Istniejące

| Test | Pokrycie |
|---|---|
| `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | domena: create, restock, hard deduct insufficient stock, deactivate |
| `supply-chain-frontend/src/app/smoke.spec.ts` | brak pokrycia E-009 |
