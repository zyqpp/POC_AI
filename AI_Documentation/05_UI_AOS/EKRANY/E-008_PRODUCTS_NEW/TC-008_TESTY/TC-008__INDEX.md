# TC-008 Testy

Status: `potwierdzone` jako wymagania testowe; automatyzacja UI/API ma status `brak w kodzie`.

| ID | Przypadek testowy | Dane | Typ | Obecny status | Kryterium zamknięcia |
|---|---|---|---|---|---|
| `TC-008-0001` | Admin tworzy poprawny produkt i trafia do szczegółu. | `TD-008-0001` do `TD-008-0008` | e2e/API integration | `brak w kodzie` | `201`, toast `Product created`, route `/products/{productId}`, `Products` i `OutboxMessages` zapisane. |
| `TC-008-0002` | Formularz blokuje niepoprawne SKU, nazwę, cenę, ilość, stock, opis i URL. | `TD-008-0001` do `TD-008-0008` | component | `brak w kodzie` | Widoczny komunikat `ERR-008-*`, brak requestu POST. |
| `TC-008-0003` | Kategorie ładują się jako parent/child albo pokazują stan błędu/pusty. | `TD-008-0006`, `TD-008-0010`, `TD-008-0011` | component/API mock | `brak w kodzie` | Select poprawnie grupuje kategorie; błąd API i pusta lista blokują wybór. |
| `TC-008-0004` | Backend odrzuca duplikat SKU i nieistniejącą kategorię. | `TD-008-0001`, `TD-008-0006` | API integration | `brak w kodzie` | Brak insertu `Products`, błąd walidacji/biznesowy widoczny w odpowiedzi. |
| `TC-008-0005` | Użytkownik bez Admin nie ma dostępu do route `/products/new` i endpointu POST. | `TD-008-0009` | e2e/API auth | `brak w kodzie` | Frontend przekierowuje/blokuje route, backend zwraca brak autoryzacji. |
| `TC-008-0006` | Cancel opuszcza formularz bez zapisu. | dowolny rozpoczęty formularz | component/e2e | `brak w kodzie` | Route `/products`, brak `POST /catalog/api/products`. |

## Testy Istniejące

| Test | Pokrycie | Luka |
|---|---|---|
| `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | `Product.Create` i operacje stock w domenie | brak testu `ProductsController.Create`, walidatora requestu, duplikatu SKU, kategorii i UI |
| `supply-chain-frontend/src/app/smoke.spec.ts` | smoke frontendu | nie pokrywa `E-008` |
