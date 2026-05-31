# P-019 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-019-0001` | workflowDueDate | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0001__workflowduedate.md](P-019-0001__workflowduedate.md) |
| `P-019-0002` | workflowStatus | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0002__workflowstatus.md](P-019-0002__workflowstatus.md) |
| `P-019-0003` | promiseToPayDate | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0003__promisetopaydate.md](P-019-0003__promisetopaydate.md) |
| `P-019-0004` | workflowNote | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0004__workflownote.md](P-019-0004__workflownote.md) |
| `P-019-0005` | item.createdAtUtc | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0005__item-createdatutc.md](P-019-0005__item-createdatutc.md) |
| `P-019-0006` | item.createdByRole | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0006__item-createdbyrole.md](P-019-0006__item-createdbyrole.md) |
| `P-019-0007` | item.message | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0007__item-message.md](P-019-0007__item-message.md) |
| `P-019-0008` | l.productName | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0008__l-productname.md](P-019-0008__l-productname.md) |
| `P-019-0009` | l.sku | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0009__l-sku.md](P-019-0009__l-sku.md) |
| `P-019-0010` | l.hsnCode | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0010__l-hsncode.md](P-019-0010__l-hsncode.md) |
| `P-019-0011` | l.quantity | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0011__l-quantity.md](P-019-0011__l-quantity.md) |
| `P-019-0012` | l.unitPrice | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0012__l-unitprice.md](P-019-0012__l-unitprice.md) |
| `P-019-0013` | l.lineTotal | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | [P-019-0013__l-linetotal.md](P-019-0013__l-linetotal.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
