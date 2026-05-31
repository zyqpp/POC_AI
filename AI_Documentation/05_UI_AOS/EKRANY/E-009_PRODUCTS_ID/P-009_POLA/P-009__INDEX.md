# P-009 Pola UI

Status: `potwierdzone`.

| ID | Pole | Typ UI | API/DTO | DB / źródło | Dokument |
|---|---|---|---|---|---|
| `P-009-0001` | Order quantity | input number | brak requestu API w tej akcji | `CartStore`, odczyt `Products.MinOrderQty`, `Products.TotalStock`, `Products.ReservedStock` | [P-009-0001__qty.md](P-009-0001__qty.md) |
| `P-009-0002` | Review rating | select | `CreateProductReviewRequest.Rating` | `brak kolumny SQL`, review w pamięci procesu | [P-009-0002__reviewrating.md](P-009-0002__reviewrating.md) |
| `P-009-0003` | Review title | input text | `CreateProductReviewRequest.Title` | `brak kolumny SQL`, review w pamięci procesu | [P-009-0003__reviewtitle.md](P-009-0003__reviewtitle.md) |
| `P-009-0004` | Review comment | textarea | `CreateProductReviewRequest.Comment` | `brak kolumny SQL`, review w pamięci procesu | [P-009-0004__reviewcomment.md](P-009-0004__reviewcomment.md) |
| `P-009-0005` | Restock quantity | input number | `RestockProductRequest.Quantity` | `StockTransactions.Quantity`, `Products.TotalStock` W | [P-009-0005__restockqty.md](P-009-0005__restockqty.md) |
| `P-009-0006` | Restock reference ID | input text | `RestockProductRequest.ReferenceId` | `StockTransactions.ReferenceId` W | [P-009-0006__restockref.md](P-009-0006__restockref.md) |
| `P-009-0007` | Review title display | text | `ProductReviewDto.Title` | `brak kolumny SQL`, review w pamięci procesu | [P-009-0007__r-title.md](P-009-0007__r-title.md) |
| `P-009-0008` | Review created date | text/date pipe | `ProductReviewDto.CreatedAtUtc` | `brak kolumny SQL`, review w pamięci procesu | [P-009-0008__r-createdatutc.md](P-009-0008__r-createdatutc.md) |
| `P-009-0009` | Review comment display | text | `ProductReviewDto.Comment` | `brak kolumny SQL`, review w pamięci procesu | [P-009-0009__r-comment.md](P-009-0009__r-comment.md) |
| `P-009-0010` | Moderation note | text | `ProductReviewDto.ModerationNote` | `brak kolumny SQL`, review w pamięci procesu | [P-009-0010__r-moderationnote.md](P-009-0010__r-moderationnote.md) |
| `P-009-0011` | Product name | text H1 | `ProductDto.Name` | `Products.Name` R | [P-009-0011__product-name.md](P-009-0011__product-name.md) |
| `P-009-0012` | SKU | text | `ProductDto.Sku` | `Products.Sku` R | [P-009-0012__sku.md](P-009-0012__sku.md) |
| `P-009-0013` | Description | text | `ProductDto.Description` | `Products.Description` R | [P-009-0013__description.md](P-009-0013__description.md) |
| `P-009-0014` | Unit price | currency | `ProductDto.UnitPrice` | `Products.UnitPrice` R | [P-009-0014__unitprice.md](P-009-0014__unitprice.md) |
| `P-009-0015` | Available stock | number/badge | `ProductDto.AvailableStock` | wyliczone z `Products.TotalStock - Products.ReservedStock` | [P-009-0015__available-stock.md](P-009-0015__available-stock.md) |
| `P-009-0016` | Reserved stock | number | `ProductDto.ReservedStock` | `Products.ReservedStock` R | [P-009-0016__reserved-stock.md](P-009-0016__reserved-stock.md) |
| `P-009-0017` | Total stock | number | `ProductDto.TotalStock` | `Products.TotalStock` R | [P-009-0017__total-stock.md](P-009-0017__total-stock.md) |
| `P-009-0018` | Min order | number | `ProductDto.MinOrderQty` | `Products.MinOrderQty` R | [P-009-0018__min-order.md](P-009-0018__min-order.md) |
| `P-009-0019` | Updated at | relative time text | `ProductDto.UpdatedAtUtc` | `Products.UpdatedAtUtc` R | [P-009-0019__updated-at.md](P-009-0019__updated-at.md) |
| `P-009-0020` | Product status badges | badges | `ProductDto.IsActive`, `AvailableStock` | `Products.IsActive`, stock wyliczony | [P-009-0020__status-badges.md](P-009-0020__status-badges.md) |
| `P-009-0021` | Product image | image | `ProductDto.ImageUrl` | `Products.ImageUrl` R, fallback frontend | [P-009-0021__product-image.md](P-009-0021__product-image.md) |
