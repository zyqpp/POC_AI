# P-010-0003 Unit Price

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-010-0003` |
| Ekran | [E-010](../E-010__README.md) |
| Nazwa UI | `Unit Price *` |
| Typ UI | `input type="number"` |
| Źródło | `product-form.component.html:21`, `product-form.component.ts:72` |

## Opis Pola

Cena jednostkowa produktu. Frontend pozwala na krok `0.01`, a backend wymaga wartości większej od zera.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagalność | wymagane | `Validators.required` |
| UI validator | minimum `0.01` | `product-form.component.ts:72` |
| Backend validator | `GreaterThan(0m)` | `CatalogValidators.cs:47` |
| Komunikat | [ERR-010-0003](../ERR-010_BLEDY/ERR-010-0003__positive-price-required.md) | `product-form.component.html:22` |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `form.controls.unitPrice` | `potwierdzone` |
| Serwis API | `updateProduct(id, req)` | `potwierdzone` |
| Endpoint | `PUT /catalog/api/products/{id}` | `potwierdzone` |
| DTO/kontrakt | `UpdateProductRequest.UnitPrice` | `potwierdzone` |
| Encja/model | `Product.UnitPrice` | `potwierdzone` |
| DbContext | `HasPrecision(18, 2)` | `potwierdzone` |
| Tabela SQL | `Products` | `potwierdzone` |
| Kolumna SQL | `UnitPrice` | `potwierdzone` |
| Odczyt/zapis | `R/W` | `potwierdzone` |

## Dane Do Testów

- [TD-010-0003](../TD-010_DANE_TESTOWE/TD-010-0003__unitprice.md)
- Poprawne: `1250.50`.
- Błędne: `0`, liczba ujemna, wartość pusta.
