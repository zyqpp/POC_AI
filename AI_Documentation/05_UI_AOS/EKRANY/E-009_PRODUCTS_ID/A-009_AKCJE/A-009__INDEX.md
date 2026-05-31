# A-009 Akcje UI

Status: `potwierdzone`.

| ID | Akcja | Role | API / skutek | Dokument |
|---|---|---|---|---|
| `A-009-0001` | Deactivate | `Admin` | `PUT /catalog/api/products/{id}/deactivate`, `Products.IsActive=false` | [A-009-0001__deactivate.md](A-009-0001__deactivate.md) |
| `A-009-0002` | Step quantity | `Dealer` | UI only, normalizacja ilości | [A-009-0002__stepqty.md](A-009-0002__stepqty.md) |
| `A-009-0003` | Set min quantity | `Dealer` | UI only | [A-009-0003__setqtytomin.md](A-009-0003__setqtytomin.md) |
| `A-009-0004` | Set max quantity | `Dealer` | UI only | [A-009-0004__setqtytomax.md](A-009-0004__setqtytomax.md) |
| `A-009-0005` | Add to cart | `Dealer` | `CartStore`, brak API | [A-009-0005__addtocart.md](A-009-0005__addtocart.md) |
| `A-009-0006` | Open restock dialog | `Admin`, `Warehouse` | UI only | [A-009-0006__showrestockdialog-set.md](A-009-0006__showrestockdialog-set.md) |
| `A-009-0007` | Submit review | `Dealer` | `POST /catalog/api/products/{id}/reviews`, review w pamięci procesu | [A-009-0007__submitreview.md](A-009-0007__submitreview.md) |
| `A-009-0008` | Approve review | `Admin` | `PUT /catalog/api/products/reviews/{reviewId}/approve`, review w pamięci procesu | [A-009-0008__approvereview.md](A-009-0008__approvereview.md) |
| `A-009-0009` | Reject review | `Admin` | `PUT /catalog/api/products/reviews/{reviewId}/reject`, review w pamięci procesu | [A-009-0009__rejectreview.md](A-009-0009__rejectreview.md) |
| `A-009-0010` | Close modal / stop propagation | `Admin`, `Warehouse` | UI only | [A-009-0010__event-stoppropagation.md](A-009-0010__event-stoppropagation.md) |
| `A-009-0011` | Restock | `Admin`, `Warehouse` | `POST /catalog/api/products/{id}/restock`, `Products`, `StockTransactions`, `OutboxMessages` | [A-009-0011__restock.md](A-009-0011__restock.md) |
| `A-009-0012` | Back to products | każdy zalogowany | route `/products`, brak API | [A-009-0012__navigate-products.md](A-009-0012__navigate-products.md) |
| `A-009-0013` | Edit product | `Admin` | route `/products/{id}/edit`, opis w `E-010` | [A-009-0013__navigate.md](A-009-0013__navigate.md) |
| `A-009-0014` | Load product and reviews | każdy zalogowany; pending reviews tylko `Admin` | `GET /catalog/api/products/{id}`, `GET /catalog/api/products/{id}/reviews` | [A-009-0014__load-product-and-reviews.md](A-009-0014__load-product-and-reviews.md) |
