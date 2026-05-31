# ERR-012 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-012-0001` | errorMsg( | angular-if-error-view | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` | [ERR-012-0001__errormsg.md](ERR-012-0001__errormsg.md) |
| `ERR-012-0002` | errorMsg() | error-css-class | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` | [ERR-012-0002__errormsg.md](ERR-012-0002__errormsg.md) |
| `ERR-012-0003` | Cart updated with latest stock and pricing. Please review and place order again. | toast.warning | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.ts` | [ERR-012-0003__cart-updated-with-latest-stock-and-pricing-please-review-and-place-order-again.md](ERR-012-0003__cart-updated-with-latest-stock-and-pricing-please-review-and-place-order-again.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
