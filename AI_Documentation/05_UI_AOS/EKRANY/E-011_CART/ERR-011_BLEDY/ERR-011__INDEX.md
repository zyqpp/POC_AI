# ERR-011 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-011-0001` | Item is no longer available in stock | toast.warning | `supply-chain-frontend/src/app/features/cart/cart.component.ts` | [ERR-011-0001__item-is-no-longer-available-in-stock.md](ERR-011-0001__item-is-no-longer-available-in-stock.md) |
| `ERR-011-0002` | Cannot exceed available stock | toast.warning | `supply-chain-frontend/src/app/features/cart/cart.component.ts` | [ERR-011-0002__cannot-exceed-available-stock.md](ERR-011-0002__cannot-exceed-available-stock.md) |
| `ERR-011-0003` | `Minimum order quantity is ${minOrderQty}` | toast.warning | `supply-chain-frontend/src/app/features/cart/cart.component.ts` | [ERR-011-0003__minimum-order-quantity-is-minorderqty.md](ERR-011-0003__minimum-order-quantity-is-minorderqty.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
