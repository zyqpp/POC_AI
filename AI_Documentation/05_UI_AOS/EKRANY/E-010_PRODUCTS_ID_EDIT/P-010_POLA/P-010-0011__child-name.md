# P-010-0011 Child Category Label

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-010-0011` |
| Ekran | [E-010](../E-010__README.md) |
| Nazwa UI | etykieta opcji kategorii podrzędnej |
| Typ UI | `option` |
| Źródło | `product-form.component.html:46`, `product-form.component.ts:59` |

## Opis Pola

Nazwa kategorii podrzędnej w select. Kliknięcie opcji ustawia wartość `categoryId`, ale sama nazwa jest tylko etykietą czytaną z `Categories.Name`.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagalność | display only | template |
| UI validator | walidowany jest wybrany `categoryId`, nie tekst etykiety | `P-010-0006` |
| Backend validator | sprawdzane jest istnienie `CategoryId` | `CatalogInventoryService.cs:108` |
| Komunikat | błędy kategorii są w [ERR-010-0006](../ERR-010_BLEDY/ERR-010-0006__could-not-load-categories-try-refreshing.md), [ERR-010-0007](../ERR-010_BLEDY/ERR-010-0007__no-categories-available.md), [ERR-010-0008](../ERR-010_BLEDY/ERR-010-0008__category-is-required.md) | `potwierdzone` |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `group.children[].name` | `potwierdzone` |
| Serwis API | `getCategories()` | `potwierdzone` |
| Endpoint | `GET /catalog/api/products/categories` | `potwierdzone` |
| DTO/kontrakt | `CategoryDto.Name` | `potwierdzone` |
| Encja/model | `Category.Name` | `potwierdzone` |
| DbContext | `Categories.Name` max 140 | `potwierdzone` |
| Tabela SQL | `Categories` | `potwierdzone` |
| Kolumna SQL | `Name` | `potwierdzone` |
| Odczyt/zapis | `R` | `potwierdzone` |

## Dane Do Testów

- [TD-010-0011](../TD-010_DANE_TESTOWE/TD-010-0011__child-name.md)
- Seed: kategoria podrzędna `Pumps`.
