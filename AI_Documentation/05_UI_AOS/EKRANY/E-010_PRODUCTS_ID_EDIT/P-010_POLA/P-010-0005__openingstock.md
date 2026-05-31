# P-010-0005 Opening Stock

Status: `potwierdzone` jako pole współdzielonego formularza, `brak zapisu` w trybie edit.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-010-0005` |
| Ekran | [E-010](../E-010__README.md) |
| Nazwa UI | `Opening Stock *` |
| Typ UI | `input type="number"`, ale ukryty w edit |
| Źródło | `product-form.component.html:31`, `product-form.component.ts:74` |

## Opis Pola

Pole istnieje w `ProductFormComponent`, ale template pokazuje je tylko wtedy, gdy `!isEdit()`. W E-010 użytkownik go nie widzi, a submit edit nie wysyła `openingStock`. Zmiana stocku po utworzeniu produktu jest realizowana przez restock opisany w E-009, nie przez edycję produktu.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagalność | nie dotyczy edit, ukryte | `product-form.component.html:31` |
| UI validator | odziedziczone minimum `0`, ale nieużywane w edit | `product-form.component.ts:74` |
| Backend validator | brak w `UpdateProductRequestValidator` | `CatalogValidators.cs:40` |
| Komunikat | [ERR-010-0005](../ERR-010_BLEDY/ERR-010-0005__non-negative-integer-required.md), nieosiągalny w typowym edit | `product-form.component.html:35` |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `form.controls.openingStock` | `potwierdzone` |
| Serwis API | brak w `updateProduct()` request | `potwierdzone` |
| Endpoint | `PUT /catalog/api/products/{id}` bez pola | `potwierdzone` |
| DTO/kontrakt | brak w `UpdateProductRequest`; obecne tylko w `CreateProductRequest` | `potwierdzone` |
| Encja/model | `Product.TotalStock` | `potwierdzone` |
| DbContext | `Products.TotalStock` | `potwierdzone` |
| Tabela SQL | `Products` | `potwierdzone` |
| Kolumna SQL | `TotalStock` | `potwierdzone` |
| Odczyt/zapis | brak `W` w E-010 | `potwierdzone` |

## Dane Do Testów

- [TD-010-0005](../TD-010_DANE_TESTOWE/TD-010-0005__openingstock.md)
- Test regresji: po edycji produktu `Products.TotalStock` pozostaje bez zmian.
