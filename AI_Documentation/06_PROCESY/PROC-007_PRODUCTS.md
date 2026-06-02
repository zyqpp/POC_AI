# PROC-007 Lista Produktów

Status: `potwierdzone`.

## Opis

Użytkownik przegląda produkty ładowane przez `CatalogApiService.getProducts` → `GET /catalog/api/products` → `GetProductListQueryHandler` odczytujący `Products` i `Categories`; filtry kategorii/stocku/sortowania działają lokalnie w przeglądarce bez dodatkowych żądań HTTP.

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

## Powiązane Dokumenty

| Typ | Plik | Opis powiązania |
|---|---|---|
| Ekran | [E-007_PRODUCTS](../05_UI_AOS/EKRANY/E-007_PRODUCTS/E-007__README.md) | główny ekran listy produktów |
| API | [API_CATALOG](../04_API/API_CATALOG.md) | endpointy katalogu używane w procesie |
| Role | [ROLE_CATALOG](../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md) | macierz uprawnień dla katalogu |
| Model | [MODEL_DANYCH_CATALOG](../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) | encje Products i Categories |
| Testy | [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md) | przypadki testowe dla katalogu |
