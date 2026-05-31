# P-008 Pola

Status: `potwierdzone`.

| ID | Pole | Typ UI | DTO | DB | Dokument |
|---|---|---|---|---|---|
| `P-008-0001` | SKU | input text | `CreateProductRequest.sku` | `Products.Sku` W | [P-008-0001__sku.md](P-008-0001__sku.md) |
| `P-008-0002` | Name | input text | `CreateProductRequest.name` | `Products.Name` W | [P-008-0002__name.md](P-008-0002__name.md) |
| `P-008-0003` | Unit price | input number | `CreateProductRequest.unitPrice` | `Products.UnitPrice` W | [P-008-0003__unitprice.md](P-008-0003__unitprice.md) |
| `P-008-0004` | Min order qty | input number | `CreateProductRequest.minOrderQty` | `Products.MinOrderQty` W | [P-008-0004__minorderqty.md](P-008-0004__minorderqty.md) |
| `P-008-0005` | Opening stock | input number | `CreateProductRequest.openingStock` | `Products.TotalStock` W | [P-008-0005__openingstock.md](P-008-0005__openingstock.md) |
| `P-008-0006` | Category | select | `CreateProductRequest.categoryId` | `Products.CategoryId` W, `Categories` R | [P-008-0006__categoryid.md](P-008-0006__categoryid.md) |
| `P-008-0007` | Description | textarea | `CreateProductRequest.description` | `Products.Description` W | [P-008-0007__description.md](P-008-0007__description.md) |
| `P-008-0008` | Image URL | input url | `CreateProductRequest.imageUrl` | `Products.ImageUrl` W | [P-008-0008__imageurl.md](P-008-0008__imageurl.md) |
| `P-008-0009` | Active | checkbox | brak w create | `Products.IsActive` default `true` | [P-008-0009__isactive.md](P-008-0009__isactive.md) |
| `P-008-0010` | Group parent name | optgroup label | `CategoryDto.name` | `Categories.Name` R | [P-008-0010__group-parent-name.md](P-008-0010__group-parent-name.md) |
| `P-008-0011` | Child category name | option | `CategoryDto.name` | `Categories.Name` R | [P-008-0011__child-name.md](P-008-0011__child-name.md) |
