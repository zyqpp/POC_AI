# P-010-0007 Description

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-010-0007` |
| Ekran | [E-010](../E-010__README.md) |
| Nazwa UI | `Description *` |
| Typ UI | `textarea` |
| Źródło | `product-form.component.html:64`, `product-form.component.ts:70` |

## Opis Pola

Opis produktu widoczny później na szczególe produktu. W E-010 jest edytowany i zapisywany do `Products.Description`.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagalność | wymagane | `Validators.required` |
| Limit | max 2000 znaków | `product-form.component.ts:70`, `CatalogValidators.cs:45` |
| Backend validator | `RuleFor(x => x.Description).NotEmpty().MaximumLength(2000)` | `CatalogValidators.cs:45` |
| Komunikat | [ERR-010-0009](../ERR-010_BLEDY/ERR-010-0009__description-is-required-max-2000-chars.md) | `product-form.component.html:65` |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `form.controls.description` | `potwierdzone` |
| Serwis API | `updateProduct(id, req)` | `potwierdzone` |
| Endpoint | `PUT /catalog/api/products/{id}` | `potwierdzone` |
| DTO/kontrakt | `UpdateProductRequest.Description`, `ProductDto.Description` | `potwierdzone` |
| Encja/model | `Product.Description` | `potwierdzone` |
| DbContext | `Property(x => x.Description).HasMaxLength(2000).IsRequired()` | `potwierdzone` |
| Tabela SQL | `Products` | `potwierdzone` |
| Kolumna SQL | `Description` | `potwierdzone` |
| Odczyt/zapis | `R/W` | `potwierdzone` |

## Dane Do Testów

- [TD-010-0007](../TD-010_DANE_TESTOWE/TD-010-0007__description.md)
- Poprawne: opis techniczny produktu.
- Błędne: pusty opis i tekst dłuższy niż 2000 znaków.
