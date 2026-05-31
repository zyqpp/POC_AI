# P-010 Pola UI

Status: `potwierdzone` dla trybu edit ekranu `E-010`.

| ID pola | Nazwa UI | Typ UI | Wymagalność | DTO/API | Tabela.Kolumna | R/W | Dokument |
|---|---|---|---|---|---|---|---|
| `P-010-0001` | SKU | input text readonly/disabled | widoczne, nieedytowalne | `ProductDto.Sku`; brak w `UpdateProductRequest` | `Products.Sku` | `R` | [P-010-0001__sku](P-010-0001__sku.md) |
| `P-010-0002` | Name | input text | wymagane, max 200 | `UpdateProductRequest.Name` | `Products.Name` | `R/W` | [P-010-0002__name](P-010-0002__name.md) |
| `P-010-0003` | Unit Price | input number | wymagane, dodatnia cena | `UpdateProductRequest.UnitPrice` | `Products.UnitPrice` | `R/W` | [P-010-0003__unitprice](P-010-0003__unitprice.md) |
| `P-010-0004` | Min Order Qty | input number | wymagane, dodatnia liczba całkowita | `UpdateProductRequest.MinOrderQty` | `Products.MinOrderQty` | `R/W` | [P-010-0004__minorderqty](P-010-0004__minorderqty.md) |
| `P-010-0005` | Opening Stock | input number ukryty w edit | nie dotyczy trybu edit | brak w `UpdateProductRequest` | `Products.TotalStock` | brak zapisu w E-010 | [P-010-0005__openingstock](P-010-0005__openingstock.md) |
| `P-010-0006` | Category | select | wymagane, GUID istniejącej kategorii | `UpdateProductRequest.CategoryId` | `Products.CategoryId`; `Categories.CategoryId` | `R/W` | [P-010-0006__categoryid](P-010-0006__categoryid.md) |
| `P-010-0007` | Description | textarea | wymagane, max 2000 | `UpdateProductRequest.Description` | `Products.Description` | `R/W` | [P-010-0007__description](P-010-0007__description.md) |
| `P-010-0008` | Image URL | input url | opcjonalne, max 500, HTTP/HTTPS | `UpdateProductRequest.ImageUrl` | `Products.ImageUrl` | `R/W` | [P-010-0008__imageurl](P-010-0008__imageurl.md) |
| `P-010-0009` | Active | checkbox | widoczne w edit, bool | `UpdateProductRequest.IsActive` | `Products.IsActive` | `R/W` | [P-010-0009__isactive](P-010-0009__isactive.md) |
| `P-010-0010` | Parent category label | optgroup label | display only | `CategoryDto.Name` | `Categories.Name` | `R` | [P-010-0010__group-parent-name](P-010-0010__group-parent-name.md) |
| `P-010-0011` | Child category label | option label | display only | `CategoryDto.Name` | `Categories.Name` | `R` | [P-010-0011__child-name](P-010-0011__child-name.md) |

## Zasady

- Każdy dokument pola zawiera osobną sekcję `Wymagalność I Walidacje`, `Mapowanie Danych` oraz `Dane Do Testów`.
- `SKU` i `Opening Stock` są opisane jawnie jako elementy współdzielonego formularza, które w trybie edit nie są zapisywane.
- Kategoria ma dwa typy pól: wartość zapisywana `categoryId` oraz etykiety parent/child czytane z `Categories`.
