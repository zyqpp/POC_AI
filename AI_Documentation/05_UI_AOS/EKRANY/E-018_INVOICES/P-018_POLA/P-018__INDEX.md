# P-018 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-018-0001` | dealerIdInput | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0001__dealeridinput.md](P-018-0001__dealeridinput.md) |
| `P-018-0002` | searchQuery | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0002__searchquery.md](P-018-0002__searchquery.md) |
| `P-018-0003` | gstFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0003__gstfilter.md](P-018-0003__gstfilter.md) |
| `P-018-0004` | fromDate | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0004__fromdate.md](P-018-0004__fromdate.md) |
| `P-018-0005` | toDate | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0005__todate.md](P-018-0005__todate.md) |
| `P-018-0006` | minAmount | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0006__minamount.md](P-018-0006__minamount.md) |
| `P-018-0007` | maxAmount | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0007__maxamount.md](P-018-0007__maxamount.md) |
| `P-018-0008` | workflowFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0008__workflowfilter.md](P-018-0008__workflowfilter.md) |
| `P-018-0009` | agingFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0009__agingfilter.md](P-018-0009__agingfilter.md) |
| `P-018-0010` | selectAllVisibleChecked() | [checked] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0010__selectallvisiblechecked.md](P-018-0010__selectallvisiblechecked.md) |
| `P-018-0011` | isSelected(inv.invoiceId) | [checked] | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0011__isselected-inv-invoiceid.md](P-018-0011__isselected-inv-invoiceid.md) |
| `P-018-0012` | inv.invoiceNumber | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0012__inv-invoicenumber.md](P-018-0012__inv-invoicenumber.md) |
| `P-018-0013` | inv.orderId | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0013__inv-orderid.md](P-018-0013__inv-orderid.md) |
| `P-018-0014` | inv.gstType | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0014__inv-gsttype.md](P-018-0014__inv-gsttype.md) |
| `P-018-0015` | inv.grandTotal | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0015__inv-grandtotal.md](P-018-0015__inv-grandtotal.md) |
| `P-018-0016` | inv.createdAtUtc | interpolation | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | [P-018-0016__inv-createdatutc.md](P-018-0016__inv-createdatutc.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
