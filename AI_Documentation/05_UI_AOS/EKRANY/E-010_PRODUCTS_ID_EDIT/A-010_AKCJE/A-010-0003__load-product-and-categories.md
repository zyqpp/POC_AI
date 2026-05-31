# A-010-0003 Load Product And Categories

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-010-0003` |
| Ekran | [E-010](../E-010__README.md) |
| Moment | inicjalizacja komponentu |
| Handler | `ngOnInit()`, `loadCategories()` |
| Źródło | `product-form.component.ts:81`, `product-form.component.ts:91` |

## Opis Akcji

Po wejściu na ekran komponent ładuje kategorie i, ponieważ `isEdit()` jest prawdziwe, pobiera produkt po `id`. Po sukcesie patchuje formularz danymi produktu, zamienia pusty `imageUrl` na pusty string i wyłącza kontrolkę `sku`.

## API I Dane

| Krok | Endpoint | DTO | DB |
|---|---|---|---|
| Load product | `GET /catalog/api/products/{id}` | `ProductDto` | `Products` |
| Load categories | `GET /catalog/api/products/categories` | lista `CategoryDto` | `Categories` |
| Patch form | brak API | `ProductDto` do formularza | brak zapisu |

## Błędy

| Stan | Obsługa |
|---|---|
| Nie udało się pobrać kategorii | template pokazuje [ERR-010-0006](../ERR-010_BLEDY/ERR-010-0006__could-not-load-categories-try-refreshing.md) |
| Lista kategorii pusta | template pokazuje [ERR-010-0007](../ERR-010_BLEDY/ERR-010-0007__no-categories-available.md) |
| Produkt nie istnieje | API zwraca `404`, ale template nie ma dedykowanego komunikatu; opisane w [ERR-010-0011](../ERR-010_BLEDY/ERR-010-0011__product-not-found.md) |

## Testy

- [TC-010-0001](../TC-010_TESTY/TC-010__INDEX.md) load formularza.
- [TC-010-0007](../TC-010_TESTY/TC-010__INDEX.md) błędy kategorii.
