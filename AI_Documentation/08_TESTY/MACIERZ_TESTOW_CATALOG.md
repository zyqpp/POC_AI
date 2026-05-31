# MACIERZ_TESTOW_CATALOG

Status: `potwierdzone` jako wymagania testowe dla `E-007`, `E-008`, `E-009`, `E-010`.

| ID | Scenariusz | Typ testu | Dane | Obecny status | Kryterium zamknięcia |
|---|---|---|---|---|---|
| `TC-007-0001` | Lista ładuje produkty i kategorie. | component/API integration | `TD-007-0001`, `TD-007-0002` | `brak w kodzie` | Widoczne karty produktów, kategorie i licznik wyników. |
| `TC-007-0002` | Search po nazwie i SKU. | component/API | `TD-007-0001`, `TD-007-0009` | `brak w kodzie` | Wywołany endpoint search po debounce i widok zawężony. |
| `TC-007-0003` | Filtry kategorii, stock i sort. | component | `TD-007-0002` do `TD-007-0005` | `brak w kodzie` | Lokalny widok odpowiada filtrom. |
| `TC-007-0004` | Dealer wykonuje quick add. | component | `TD-007-0011` | `brak w kodzie` | `CartStore` zawiera produkt z ilością znormalizowaną do `minOrderQty`. |
| `TC-007-0005` | Quick add niedostępnego produktu pokazuje błąd. | component | `TD-007-0004` | `brak w kodzie` | Toast ostrzegawczy lub błędu i brak wpisu w koszyku. |
| `TC-007-0006` | Widoczność akcji Admin/Dealer. | e2e/component | `TD-007-0006`, `TD-007-0011` | `brak w kodzie` | Admin widzi `Add Product`, Dealer widzi quick add. |
| `TC-008-0001` | Admin tworzy poprawny produkt i trafia do szczegółu. | e2e/API integration | `TD-008-0001` do `TD-008-0008` | `brak w kodzie` | `201`, toast `Product created`, route `/products/{productId}`, `Products` i `OutboxMessages` zapisane. |
| `TC-008-0002` | Formularz blokuje niepoprawne pola. | component | `TD-008-0001` do `TD-008-0008` | `brak w kodzie` | Widoczny błąd `ERR-008-*`, brak requestu POST. |
| `TC-008-0003` | Kategorie ładują się jako parent/child albo pokazują stan błędu/pusty. | component/API mock | `TD-008-0006`, `TD-008-0010`, `TD-008-0011` | `brak w kodzie` | Select poprawnie grupuje kategorie; błąd i pusta lista są obsłużone. |
| `TC-008-0004` | Backend odrzuca duplikat SKU i nieistniejącą kategorię. | API integration | `TD-008-0001`, `TD-008-0006` | `brak w kodzie` | Brak insertu `Products`; błąd walidacji/biznesowy widoczny w odpowiedzi. |
| `TC-008-0005` | Użytkownik bez Admin nie ma dostępu do create. | e2e/API auth | `TD-008-0009` | `brak w kodzie` | Frontend blokuje route; backend blokuje POST. |
| `TC-008-0006` | Cancel opuszcza formularz bez zapisu. | component/e2e | rozpoczęty formularz | `brak w kodzie` | Route `/products`, brak `POST /catalog/api/products`. |
| `TC-009-0001` | Ekran ładuje produkt i podstawowe pola. | component/API integration | `TD-009-0011`, `TD-009-0013` | `brak w kodzie` | Widoczne name, SKU, cena, stock, min order, updated, image/fallback. |
| `TC-009-0002` | Produkt nie istnieje oraz akcje Admina są widoczne tylko dla Admina. | e2e/component | `TD-009-0011`, `TD-009-0012` | `brak w kodzie` | Empty state dla 404; Admin widzi edit/deactivate, inni nie. |
| `TC-009-0003` | Kontrola ilości normalizuje min/max/krok. | component | `TD-009-0001`, `TD-009-0013` | `brak w kodzie` | `qty` jest wielokrotnością `MinOrderQty` i nie przekracza `maxPurchasable`. |
| `TC-009-0004` | Dealer dodaje produkt do koszyka albo dostaje błędy stock. | component/store | `TD-009-0001`, `TD-009-0013` | `brak w kodzie` | `CartStore` zawiera pozycję albo pokazany jest `ERR-009-0001/2/3`. |
| `TC-009-0005` | Admin/Warehouse wykonuje restock. | API integration | `TD-009-0005`, `TD-009-0006` | `brak w kodzie` | `Products.TotalStock` wzrasta, `StockTransactions` i `OutboxMessages` zapisane. |
| `TC-009-0006` | Restock/deactivate obsługują błędy. | component/API | `TD-009-0005`, `TD-009-0006`, `TD-009-0011` | `brak w kodzie` | Obecnie luka: brak toastu błędu dla error handlerów. |
| `TC-009-0007` | Dealer wysyła review do moderacji. | API integration/component | `TD-009-0002`, `TD-009-0003`, `TD-009-0004` | `brak w kodzie` | Request `POST`, toast sukcesu, pola wyczyszczone; pending znika u Dealera po reload. |
| `TC-009-0008` | Lista reviews pokazuje approved dla Dealer i pending dla Admin. | API/component | `TD-009-0007`, `TD-009-0008`, `TD-009-0009`, `TD-009-0012` | `brak w kodzie` | `includePending=true` tylko dla Admina. |
| `TC-009-0009` | Walidacje review odrzucają rating/title/comment poza zakresem. | API validation | `TD-009-0002`, `TD-009-0003`, `TD-009-0004` | `brak w kodzie` | Walidator zwraca błąd, brak review w `ReviewsById`. |
| `TC-009-0010` | Admin zatwierdza i odrzuca review. | API/component | `TD-009-0007`, `TD-009-0010`, `TD-009-0012` | `brak w kodzie` | Badge zmienia się na `Approved` albo `Rejected`; brak SQL opisany jako ryzyko. |
| `TC-010-0001` | Admin ładuje formularz edit. | component/API integration | `TD-010-0001`, `TD-010-0006`, `TD-010-0010`, `TD-010-0011` | `brak w kodzie` | Formularz ma dane z `ProductDto`, SKU disabled, kategorie pogrupowane. |
| `TC-010-0002` | Admin zapisuje poprawną edycję. | e2e/API integration | `TD-010-0002` do `TD-010-0009` | `brak w kodzie` | `200`, toast `Product updated`, route `/products/{productId}`, update `Products`, outbox `ProductUpdated`. |
| `TC-010-0003` | SKU i opening stock nie są zapisywane w edit. | API/component regression | `TD-010-0001`, `TD-010-0005` | `brak w kodzie` | Request nie zawiera `Sku` ani `OpeningStock`; `Products.Sku` i `Products.TotalStock` bez zmian. |
| `TC-010-0004` | Walidacje blokują niepoprawne pola. | component/API validation | `TD-010-0002` do `TD-010-0008` | `brak w kodzie` | Widoczne `ERR-010-*`, brak requestu PUT dla błędów UI; API odrzuca błędny payload. |
| `TC-010-0005` | Użytkownik bez Admin nie ma dostępu. | e2e/API auth | konto Dealer/Warehouse | `brak w kodzie` | Frontend blokuje route; backend blokuje `PUT`. |
| `TC-010-0006` | Produkt nie istnieje albo update zwraca błąd. | component/API | nieistniejący `productId` | `brak w kodzie` | API zwraca `404`; obecna luka UI: brak widocznego komunikatu. |
| `TC-010-0007` | Kategorie nie ładują się albo są puste. | component/API mock | `TD-010-0006`, `TD-010-0010`, `TD-010-0011` | `brak w kodzie` | Komunikat `ERR-010-0006` albo `ERR-010-0007`, select disabled. |
| `TC-010-0008` | Cancel wraca do listy bez zapisu. | component/e2e | zmieniony formularz | `brak w kodzie` | Route `/products`, brak `PUT /catalog/api/products/{id}`. |

## Testy Istniejące

| Test | Pokrycie | Luka |
|---|---|---|
| `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | domena produktu: create, restock, hard deduct, deactivate | brak API, walidatorów, autoryzacji, review, UI katalogu i update produktu |
| `supply-chain-frontend/src/app/smoke.spec.ts` | smoke frontendu | nie pokrywa katalogu |
