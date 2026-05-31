# P-010-0008 Image URL

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-010-0008` |
| Ekran | [E-010](../E-010__README.md) |
| Nazwa UI | `Image URL` |
| Typ UI | `input type="url"` |
| Źródło | `product-form.component.html:69`, `product-form.component.ts:75` |

## Opis Pola

Opcjonalny URL obrazu produktu. Pusty string jest zamieniany przed wysłaniem na `undefined`, a domena zapisuje pustą wartość jako `null`.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagalność | opcjonalne | `UpdateProductRequest.ImageUrl` nullable |
| UI validator | max 500, pusty albo URL HTTP/HTTPS | `product-form.component.ts:75` |
| Backend validator | max 500, absolutny URL HTTP/HTTPS gdy podany | `CatalogValidators.cs:49` |
| Komunikat | [ERR-010-0010](../ERR-010_BLEDY/ERR-010-0010__image-url-must-be-valid-and-max-500-chars.md) | `product-form.component.html:71` |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `form.controls.imageUrl` | `potwierdzone` |
| Serwis API | `updateProduct(id, req)` | `potwierdzone` |
| Endpoint | `PUT /catalog/api/products/{id}` | `potwierdzone` |
| DTO/kontrakt | `UpdateProductRequest.ImageUrl`, `ProductDto.ImageUrl` | `potwierdzone` |
| Encja/model | `Product.ImageUrl` | `potwierdzone` |
| DbContext | `Property(x => x.ImageUrl).HasMaxLength(500)` | `potwierdzone` |
| Tabela SQL | `Products` | `potwierdzone` |
| Kolumna SQL | `ImageUrl` | `potwierdzone` |
| Odczyt/zapis | `R/W`, nullable | `potwierdzone` |

## Dane Do Testów

- [TD-010-0008](../TD-010_DANE_TESTOWE/TD-010-0008__imageurl.md)
- Poprawne: pusty string, `https://cdn.example.test/pump.png`.
- Błędne: `ftp://...`, tekst dłuższy niż 500 znaków.
