# ERR-009 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-009-0001` | This product is currently unavailable for purchase | toast.warning | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.ts` | [ERR-009-0001__this-product-is-currently-unavailable-for-purchase.md](ERR-009-0001__this-product-is-currently-unavailable-for-purchase.md) |
| `ERR-009-0002` | `Minimum order quantity is ${p.minOrderQty}` | toast.warning | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.ts` | [ERR-009-0002__minimum-order-quantity-is-p-minorderqty.md](ERR-009-0002__minimum-order-quantity-is-p-minorderqty.md) |
| `ERR-009-0003` | `Only ${p.availableStock} units available` | toast.warning | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.ts` | [ERR-009-0003__only-p-availablestock-units-available.md](ERR-009-0003__only-p-availablestock-units-available.md) |
| `ERR-009-0004` | Failed to submit review | toast.error | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.ts` | [ERR-009-0004__failed-to-submit-review.md](ERR-009-0004__failed-to-submit-review.md) |
| `ERR-009-0005` | Failed to approve review | toast.error | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.ts` | [ERR-009-0005__failed-to-approve-review.md](ERR-009-0005__failed-to-approve-review.md) |
| `ERR-009-0006` | Failed to reject review | toast.error | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.ts` | [ERR-009-0006__failed-to-reject-review.md](ERR-009-0006__failed-to-reject-review.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
