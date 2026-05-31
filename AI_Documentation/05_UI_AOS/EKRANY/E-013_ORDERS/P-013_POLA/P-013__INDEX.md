# P-013 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-013-0001` | bulkStatus | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0001__bulkstatus.md](P-013-0001__bulkstatus.md) |
| `P-013-0002` | statusFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0002__statusfilter.md](P-013-0002__statusfilter.md) |
| `P-013-0003` | slaFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0003__slafilter.md](P-013-0003__slafilter.md) |
| `P-013-0004` | searchQuery | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0004__searchquery.md](P-013-0004__searchquery.md) |
| `P-013-0005` | dealerQuery | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0005__dealerquery.md](P-013-0005__dealerquery.md) |
| `P-013-0006` | fromDate | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0006__fromdate.md](P-013-0006__fromdate.md) |
| `P-013-0007` | toDate | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0007__todate.md](P-013-0007__todate.md) |
| `P-013-0008` | allVisibleSelected() | [checked] | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0008__allvisibleselected.md](P-013-0008__allvisibleselected.md) |
| `P-013-0009` | isSelected(o.orderId) | [checked] | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0009__isselected-o-orderid.md](P-013-0009__isselected-o-orderid.md) |
| `P-013-0010` | s.label | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0010__s-label.md](P-013-0010__s-label.md) |
| `P-013-0011` | estimate.valid | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0011__estimate-valid.md](P-013-0011__estimate-valid.md) |
| `P-013-0012` | estimate.invalid | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0012__estimate-invalid.md](P-013-0012__estimate-invalid.md) |
| `P-013-0013` | estimate.unknown | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0013__estimate-unknown.md](P-013-0013__estimate-unknown.md) |
| `P-013-0014` | precheck.validCount | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0014__precheck-validcount.md](P-013-0014__precheck-validcount.md) |
| `P-013-0015` | precheck.invalidCount | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0015__precheck-invalidcount.md](P-013-0015__precheck-invalidcount.md) |
| `P-013-0016` | precheck.appliedCount | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0016__precheck-appliedcount.md](P-013-0016__precheck-appliedcount.md) |
| `P-013-0017` | o.orderNumber | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0017__o-ordernumber.md](P-013-0017__o-ordernumber.md) |
| `P-013-0018` | o.dealerId | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0018__o-dealerid.md](P-013-0018__o-dealerid.md) |
| `P-013-0019` | step.label | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0019__step-label.md](P-013-0019__step-label.md) |
| `P-013-0020` | o.totalAmount | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0020__o-totalamount.md](P-013-0020__o-totalamount.md) |
| `P-013-0021` | o.placedAtUtc | interpolation | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [P-013-0021__o-placedatutc.md](P-013-0021__o-placedatutc.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
