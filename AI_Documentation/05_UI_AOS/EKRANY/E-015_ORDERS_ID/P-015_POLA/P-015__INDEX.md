# P-015 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-015-0001` | opsNoteText | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0001__opsnotetext.md](P-015-0001__opsnotetext.md) |
| `P-015-0002` | opsNoteTags | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0002__opsnotetags.md](P-015-0002__opsnotetags.md) |
| `P-015-0003` | cancelReason | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0003__cancelreason.md](P-015-0003__cancelreason.md) |
| `P-015-0004` | returnReason | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0004__returnreason.md](P-015-0004__returnreason.md) |
| `P-015-0005` | newStatus | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0005__newstatus.md](P-015-0005__newstatus.md) |
| `P-015-0006` | rejectHoldReason | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0006__rejectholdreason.md](P-015-0006__rejectholdreason.md) |
| `P-015-0007` | rejectReturnReason | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0007__rejectreturnreason.md](P-015-0007__rejectreturnreason.md) |
| `P-015-0008` | line.productName | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0008__line-productname.md](P-015-0008__line-productname.md) |
| `P-015-0009` | line.sku | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0009__line-sku.md](P-015-0009__line-sku.md) |
| `P-015-0010` | line.quantity | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0010__line-quantity.md](P-015-0010__line-quantity.md) |
| `P-015-0011` | line.unitPrice | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0011__line-unitprice.md](P-015-0011__line-unitprice.md) |
| `P-015-0012` | line.lineTotal | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0012__line-linetotal.md](P-015-0012__line-linetotal.md) |
| `P-015-0013` | h.changedAtUtc | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0013__h-changedatutc.md](P-015-0013__h-changedatutc.md) |
| `P-015-0014` | h.changedByRole | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0014__h-changedbyrole.md](P-015-0014__h-changedbyrole.md) |
| `P-015-0015` | n.createdAtUtc | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0015__n-createdatutc.md](P-015-0015__n-createdatutc.md) |
| `P-015-0016` | n.createdByRole | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0016__n-createdbyrole.md](P-015-0016__n-createdbyrole.md) |
| `P-015-0017` | tag | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0017__tag.md](P-015-0017__tag.md) |
| `P-015-0018` | n.text | interpolation | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [P-015-0018__n-text.md](P-015-0018__n-text.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
