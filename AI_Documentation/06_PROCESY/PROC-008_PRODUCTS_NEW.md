# PROC-008 Tworzenie Produktu

Status: `potwierdzone` dla śladu `UI -> API -> proces -> DB -> testy`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| Proces | `PROC-008_PRODUCTS_NEW` |
| Ekran | [E-008_PRODUCTS_NEW](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/E-008__README.md) |
| Route | `/products/new` |
| Rola | `Admin` |
| Główna akcja | [A-008-0001 Utwórz Produkt](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/A-008_AKCJE/A-008-0001__submit.md) |
| API | [API_CATALOG](../04_API/API_CATALOG.md) |
| Model danych | [MODEL_DANYCH_CATALOG](../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Testy | [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md) |

## Przepływ End-To-End

| Krok | Warstwa | Fakt | Status |
|---|---|---|---|
| 1 | Routing | `/products/new` ma `authGuard` z shell route i `roleGuard` z rolą `Admin`. | `potwierdzone` |
| 2 | UI init | `ProductFormComponent.ngOnInit()` wywołuje `loadCategories()`. | `potwierdzone` |
| 3 | API read | Frontend pobiera `GET /catalog/api/products/categories`. | `potwierdzone` |
| 4 | DB read | Backend odczytuje `Categories` i zwraca `CategoryDto`. | `potwierdzone` |
| 5 | UI form | Admin wypełnia pola [P-008](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/P-008_POLA/P-008__INDEX.md). | `potwierdzone` |
| 6 | UI validation | Reactive Forms blokuje submit przy błędach [ERR-008](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/ERR-008_BLEDY/ERR-008__INDEX.md). | `potwierdzone` |
| 7 | API write | `CatalogApiService.createProduct` wysyła `POST /catalog/api/products`. | `potwierdzone` |
| 8 | Backend auth | `ProductsController.Create` wymaga `[Authorize(Roles = "Admin")]`. | `potwierdzone` |
| 9 | Backend command | Controller wysyła `CreateProductCommand`. | `potwierdzone` |
| 10 | Walidacja | `CreateProductRequestValidator` sprawdza pola DTO. | `potwierdzone` |
| 11 | Biznes | Serwis sprawdza istnienie kategorii i unikalność SKU. | `potwierdzone` |
| 12 | Domena | `Product.Create` normalizuje SKU, trimuje teksty, ustawia stock i aktywność. | `potwierdzone` |
| 13 | DB write | Repozytorium zapisuje `Products` i `OutboxMessages(ProductCreated)`. | `potwierdzone` |
| 14 | Cache | `InvalidateProductReadCachesAsync` czyści cache list/search/detail. | `potwierdzone` |
| 15 | UI success | Frontend pokazuje toast `Product created` i przechodzi do `/products/{productId}`. | `potwierdzone` |

## Dane I Transakcje

| Obszar | Odczyt | Zapis |
|---|---|---|
| Kategorie | `Categories.CategoryId`, `Categories.Name`, `Categories.ParentCategoryId` | brak |
| Produkt | duplikat po `Products.Sku`; FK przez `Products.CategoryId` | `Products` z polami formularza |
| Outbox | brak | `OutboxMessages.EventType=ProductCreated` |
| StockTransactions | brak | `brak w kodzie` dla `OpeningStock` |

## Błędy Procesu

| ID | Warunek | Efekt |
|---|---|---|
| [ERR-008-0001](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/ERR-008_BLEDY/ERR-008-0001__sku-is-required-letters-numbers-hyphen-underscore-max-60-chars.md) | niepoprawne albo duplikujące się SKU | brak zapisu produktu |
| [ERR-008-0006](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/ERR-008_BLEDY/ERR-008-0006__could-not-load-categories-try-refreshing.md) | błąd pobierania kategorii | użytkownik nie ma poprawnego wyboru kategorii |
| [ERR-008-0008](../05_UI_AOS/EKRANY/E-008_PRODUCTS_NEW/ERR-008_BLEDY/ERR-008-0008__category-is-required.md) | pusta albo nieistniejąca kategoria | brak zapisu produktu |

## Testy I Kryteria Zamknięcia

| Test | Kryterium |
|---|---|
| `TC-008-0001` | happy path zapisuje `Products`, `OutboxMessages`, wraca `201` i nawigacja idzie do szczegółu produktu |
| `TC-008-0002` | walidacje UI blokują request |
| `TC-008-0004` | duplikat SKU i nieistniejąca kategoria są odrzucone po stronie backendu |

## Luki

| ID | Luka | Status |
|---|---|---|
| `GAP-PROC-008-001` | Brak testu integracyjnego procesu create. | `brak w kodzie` |
| `GAP-PROC-008-002` | Brak komunikatu UI dla błędu API po submit. | `brak w kodzie` |
| `GAP-PROC-008-003` | Brak `StockTransactions` dla `OpeningStock`. | `brak w kodzie` |
