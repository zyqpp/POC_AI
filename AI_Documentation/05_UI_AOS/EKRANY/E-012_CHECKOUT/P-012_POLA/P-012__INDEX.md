# P-012 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-012-0001` | paymentMode | [(ngModel)] | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` | [P-012-0001__paymentmode.md](P-012-0001__paymentmode.md) |
| `P-012-0002` | item.productName | interpolation | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` | [P-012-0002__item-productname.md](P-012-0002__item-productname.md) |
| `P-012-0003` | item.sku | interpolation | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` | [P-012-0003__item-sku.md](P-012-0003__item-sku.md) |
| `P-012-0004` | item.quantity | interpolation | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` | [P-012-0004__item-quantity.md](P-012-0004__item-quantity.md) |
| `P-012-0005` | item.note | interpolation | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` | [P-012-0005__item-note.md](P-012-0005__item-note.md) |
| `P-012-0006` | item.lineTotal | interpolation | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` | [P-012-0006__item-linetotal.md](P-012-0006__item-linetotal.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
