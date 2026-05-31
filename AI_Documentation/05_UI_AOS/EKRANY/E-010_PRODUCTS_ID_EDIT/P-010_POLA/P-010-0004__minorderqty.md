# P-010-0004 Min Order Qty

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-010-0004` |
| Ekran | [E-010](../E-010__README.md) |
| Nazwa UI | `Min Order Qty *` |
| Typ UI | `input type="number"` |
| Źródło | `product-form.component.html:25`, `product-form.component.ts:73` |

## Opis Pola

Minimalna ilość zamówienia dla produktu. Zmiana wpływa na późniejsze obliczenia koszyka i ograniczenia ilości na ekranach listy oraz szczegółu produktu.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagalność | wymagane | `Validators.required` |
| UI validator | minimum `1` | `product-form.component.ts:73` |
| Backend validator | `GreaterThan(0)` | `CatalogValidators.cs:48` |
| Komunikat | [ERR-010-0004](../ERR-010_BLEDY/ERR-010-0004__positive-integer-required.md) | `product-form.component.html:26` |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `form.controls.minOrderQty` | `potwierdzone` |
| Serwis API | `updateProduct(id, req)` | `potwierdzone` |
| Endpoint | `PUT /catalog/api/products/{id}` | `potwierdzone` |
| DTO/kontrakt | `UpdateProductRequest.MinOrderQty` | `potwierdzone` |
| Encja/model | `Product.MinOrderQty` | `potwierdzone` |
| DbContext | int, wymagane przez typ encji | `potwierdzone` |
| Tabela SQL | `Products` | `potwierdzone` |
| Kolumna SQL | `MinOrderQty` | `potwierdzone` |
| Odczyt/zapis | `R/W` | `potwierdzone` |

## Dane Do Testów

- [TD-010-0004](../TD-010_DANE_TESTOWE/TD-010-0004__minorderqty.md)
- Poprawne: `1`, `5`.
- Błędne: `0`, liczba ujemna, wartość pusta.
