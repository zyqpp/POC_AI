# MACIERZ_TESTOW_CATALOG

Status: `potwierdzone` jako wymagania testowe dla `E-007`; będzie rozszerzana przy `E-008`-`E-010`.

| ID | Scenariusz | Typ testu | Dane | Obecny status | Kryterium zamknięcia |
|---|---|---|---|---|---|
| `TC-007-0001` | Lista ładuje produkty i kategorie. | component/API integration | `TD-007-0001`, `TD-007-0002` | `brak w kodzie` | Widoczne karty produktów, kategorie i licznik wyników. |
| `TC-007-0002` | Search po nazwie i SKU. | component/API | `TD-007-0001`, `TD-007-0009` | `brak w kodzie` | Wywołany endpoint search po debounce i widok zawężony. |
| `TC-007-0003` | Filtry kategorii, stock i sort. | component | `TD-007-0002` do `TD-007-0005` | `brak w kodzie` | Lokalny widok odpowiada filtrom. |
| `TC-007-0004` | Dealer wykonuje quick add. | component | `TD-007-0011` | `brak w kodzie` | `CartStore` zawiera produkt z ilością znormalizowaną do `minOrderQty`. |
| `TC-007-0005` | Quick add niedostępnego produktu pokazuje błąd. | component | `TD-007-0004` | `brak w kodzie` | Toast ostrzegawczy lub błędu i brak wpisu w koszyku. |
| `TC-007-0006` | Widoczność akcji Admin/Dealer. | e2e/component | `TD-007-0006`, `TD-007-0011` | `brak w kodzie` | Admin widzi `Add Product`, Dealer widzi quick add. |

## Testy Istniejące

| Test | Pokrycie |
|---|---|
| `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | domena produktu: create, restock, hard deduct, deactivate |
| `supply-chain-frontend/src/app/smoke.spec.ts` | nie pokrywa katalogu |
