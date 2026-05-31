# TC-010 Testy Ekranu

Status: `potwierdzone` jako wymagania testowe; implementacja testów w kodzie `brak w kodzie`.

| ID | Scenariusz | Typ | Dane | Oczekiwany wynik | Obecny status |
|---|---|---|---|---|---|
| `TC-010-0001` | Admin ładuje formularz edit. | component/API integration | `TD-010-0001`, `TD-010-0006`, `TD-010-0010`, `TD-010-0011` | Pola są wypełnione z `ProductDto`, SKU disabled, kategorie pogrupowane. | `brak w kodzie` |
| `TC-010-0002` | Admin zapisuje poprawną edycję. | e2e/API integration | `TD-010-0002` do `TD-010-0009` | `200`, toast `Product updated`, route `/products/{productId}`, update `Products`, outbox `ProductUpdated`. | `brak w kodzie` |
| `TC-010-0003` | SKU i opening stock nie są zapisywane w edit. | API/component regression | `TD-010-0001`, `TD-010-0005` | Request nie zawiera `Sku` ani `OpeningStock`; `Products.Sku` i `Products.TotalStock` bez zmian. | `brak w kodzie` |
| `TC-010-0004` | Walidacje blokują niepoprawne pola. | component/API validation | `TD-010-0002` do `TD-010-0008` | Widoczne `ERR-010-*`, brak requestu PUT dla błędów UI; API odrzuca błędny payload. | `brak w kodzie` |
| `TC-010-0005` | Użytkownik bez Admin nie ma dostępu. | e2e/API auth | konto Dealer/Warehouse | Frontend blokuje route; backend blokuje `PUT`. | `brak w kodzie` |
| `TC-010-0006` | Produkt nie istnieje albo update zwraca błąd. | component/API | nieistniejący `productId` | API zwraca `404`; obecna luka UI: brak widocznego komunikatu. | `brak w kodzie` |
| `TC-010-0007` | Kategorie nie ładują się albo są puste. | component/API mock | `TD-010-0006`, `TD-010-0010`, `TD-010-0011` | Komunikat [ERR-010-0006](../ERR-010_BLEDY/ERR-010-0006__could-not-load-categories-try-refreshing.md) albo [ERR-010-0007](../ERR-010_BLEDY/ERR-010-0007__no-categories-available.md), select disabled. | `brak w kodzie` |
| `TC-010-0008` | Cancel wraca do listy bez zapisu. | component/e2e | zmieniony formularz | Route `/products`, brak `PUT /catalog/api/products/{id}`. | `brak w kodzie` |

## Testy Istniejące

| Test | Pokrycie | Luka |
|---|---|---|
| `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | create, restock, hard deduct, deactivate encji `Product` | brak testu `Product.Update`, walidatora update, API update, roli Admin i komponentu E-010 |
| `supply-chain-frontend/src/app/smoke.spec.ts` | smoke frontendu | nie pokrywa E-010 |
