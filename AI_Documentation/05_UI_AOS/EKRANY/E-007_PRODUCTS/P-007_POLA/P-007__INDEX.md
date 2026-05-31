# P-007 Pola

Status: `potwierdzone`.

| ID | Pole | Typ UI | Źródło danych | DB | Dokument |
|---|---|---|---|---|---|
| `P-007-0001` | Search query | input search | lokalny model `searchQuery` | brak DB | [P-007-0001__searchquery.md](P-007-0001__searchquery.md) |
| `P-007-0002` | Parent category filter | select | `CategoryDto[]` | `Categories` R | [P-007-0002__parentcategoryfilter.md](P-007-0002__parentcategoryfilter.md) |
| `P-007-0003` | Child category filter | select | `CategoryDto[]` | `Categories` R | [P-007-0003__childcategoryfilter.md](P-007-0003__childcategoryfilter.md) |
| `P-007-0004` | Stock filter | select | lokalny enum UI | `Products.TotalStock`, `Products.ReservedStock` R | [P-007-0004__stockfilter.md](P-007-0004__stockfilter.md) |
| `P-007-0005` | Sort by | select | lokalny enum UI | pola produktu R | [P-007-0005__sortby.md](P-007-0005__sortby.md) |
| `P-007-0006` | Parent category name | option/display | `CategoryDto.name` | `Categories.Name` R | [P-007-0006__parent-name.md](P-007-0006__parent-name.md) |
| `P-007-0007` | Child category name | option/display | `CategoryDto.name` | `Categories.Name` R | [P-007-0007__child-name.md](P-007-0007__child-name.md) |
| `P-007-0008` | Product name | card display | `ProductListItemDto.name` | `Products.Name` R | [P-007-0008__p-name.md](P-007-0008__p-name.md) |
| `P-007-0009` | Product SKU | card display | `ProductListItemDto.sku` | `Products.Sku` R | [P-007-0009__p-sku.md](P-007-0009__p-sku.md) |
| `P-007-0010` | Unit price | card display | `ProductListItemDto.unitPrice` | `Products.UnitPrice` R | [P-007-0010__p-unitprice.md](P-007-0010__p-unitprice.md) |
| `P-007-0011` | Stock label | badge | `availableStock`, `isActive` | `Products.TotalStock`, `Products.ReservedStock`, `Products.IsActive` R | [P-007-0011__stock-label.md](P-007-0011__stock-label.md) |
| `P-007-0012` | Result count | display | `products().length`, `totalCount()` | brak bezpośredniej kolumny | [P-007-0012__result-count.md](P-007-0012__result-count.md) |
