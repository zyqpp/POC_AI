# P-010-0009 Active

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-010-0009` |
| Ekran | [E-010](../E-010__README.md) |
| Nazwa UI | `Active` |
| Typ UI | checkbox |
| Źródło | `product-form.component.html:74`, `product-form.component.ts:76` |

## Opis Pola

Checkbox aktywności produktu. Jest widoczny tylko w trybie edit. Pozwala ustawić `Products.IsActive` na `true` albo `false`, więc jest funkcjonalnie szerszy niż akcja dezaktywacji z E-009.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagalność | wymagane przez typ bool, domyślnie `true` | `product-form.component.ts:76` |
| UI validator | brak dodatkowego walidatora | `brak w kodzie` |
| Backend validator | brak jawnej reguły, bool w DTO jest nie-nullowalny | `UpdateProductRequest` |
| Komunikat | brak dedykowanego komunikatu | `brak w kodzie` |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `form.controls.isActive` | `potwierdzone` |
| Serwis API | `updateProduct(id, req)` | `potwierdzone` |
| Endpoint | `PUT /catalog/api/products/{id}` | `potwierdzone` |
| DTO/kontrakt | `UpdateProductRequest.IsActive`, `ProductDto.IsActive` | `potwierdzone` |
| Encja/model | `Product.IsActive` | `potwierdzone` |
| DbContext | bool, wymagane przez typ encji | `potwierdzone` |
| Tabela SQL | `Products` | `potwierdzone` |
| Kolumna SQL | `IsActive` | `potwierdzone` |
| Odczyt/zapis | `R/W` | `potwierdzone` |

## Dane Do Testów

- [TD-010-0009](../TD-010_DANE_TESTOWE/TD-010-0009__isactive.md)
- Poprawne: `true`, `false`.
- Test regresji: odznaczenie checkboxa zapisuje produkt nieaktywny; ponowne zaznaczenie reaktywuje produkt.
