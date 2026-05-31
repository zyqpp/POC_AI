# MACIERZ_TESTOW_CATALOG

Status: `potwierdzone` jako wymagania testowe dla `E-007` i `E-008`; będzie rozszerzana przy `E-009`-`E-010`.

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

## Testy Istniejące

| Test | Pokrycie | Luka |
|---|---|---|
| `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | domena produktu: create, restock, hard deduct, deactivate | brak API, walidatorów, autoryzacji i UI katalogu |
| `supply-chain-frontend/src/app/smoke.spec.ts` | smoke frontendu | nie pokrywa katalogu |
