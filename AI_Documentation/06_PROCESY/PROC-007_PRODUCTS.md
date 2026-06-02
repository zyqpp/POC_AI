# PROC-007 Lista Produktów

Status: `potwierdzone`.

## Cel

Dealer i Admin przeglądają katalog produktów z możliwością wyszukiwania, filtrowania po kategorii, dostępności i sortowania. Dealer może szybko dodać produkt do koszyka lokalnego (CartStore, bez zapisu DB). Admin widzi dodatkowe opcje zarządzania. Proces jest tylko do odczytu po stronie bazy danych — koszyk istnieje wyłącznie w pamięci przeglądarki.

## Przepływy

| ID | Przepływ | Ślad |
|---|---|---|
| `PROC-007-0001` | Ładowanie listy | `/products` -> `ngOnInit()` -> `getCategories()` + `loadPage(1)` -> Catalog API -> `Products`, `Categories` |
| `PROC-007-0002` | Search | `searchQuery` -> `search$` -> debounce 300 ms -> `searchProducts(q)` -> `ProductsController.Search` |
| `PROC-007-0003` | Filtry lokalne | selecty kategorii/stock/sort -> `applyView()` -> widok bez dodatkowego zapisu DB |
| `PROC-007-0004` | Quick add | `+ Add to Cart` -> `getProductById()` -> `CartStore.addItem()` -> brak zapisu DB |

## Granice Procesu

`E-007` nie tworzy zamówienia. Koszyk jest stanem frontendowym; zapis biznesowy zaczyna się dopiero w procesie checkout.

## Błędy Procesu

| ID | Warunek | HTTP | Akcja kompensująca | Status |
|---|---|---|---|---|
| `ERR-PROC-007-001` | Backend katalog niedostępny przy ładowaniu listy | 503 | komponent pokazuje pusty stan z komunikatem błędu | `wniosek z analizy` |
| `ERR-PROC-007-002` | Brak produktów pasujących do wyszukiwania | — | komponent pokazuje "No products found"; brak błędu HTTP | `potwierdzone` |
| `ERR-PROC-007-003` | Błąd pobierania kategorii | 503 | filtry kategorii nie działają; lista produktów może się załadować | `wniosek z analizy` |
