# A-009-0005 Add To Cart

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| UI | przycisk `Add to Cart`, widoczny dla `Dealer`, disabled gdy `!canPurchase()` |
| Frontend | `addToCart()` normalizuje `qty`, waliduje min i available stock |
| Store | `CartStore.addItem({ productId, productName, sku, quantity, unitPrice, minOrderQty, availableStock })` |
| API | brak wywołania API |
| DB | brak zapisu; koszyk jest stanem frontendowym do czasu checkout |
| Testy | `TC-009-0004` |

Komunikaty błędów: [ERR-009-0001](../ERR-009_BLEDY/ERR-009-0001__this-product-is-currently-unavailable-for-purchase.md), [ERR-009-0002](../ERR-009_BLEDY/ERR-009-0002__minimum-order-quantity-is-p-minorderqty.md), [ERR-009-0003](../ERR-009_BLEDY/ERR-009-0003__only-p-availablestock-units-available.md).
