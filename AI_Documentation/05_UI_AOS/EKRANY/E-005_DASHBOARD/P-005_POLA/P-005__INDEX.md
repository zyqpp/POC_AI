# P-005 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-005-0001` | low-stock-threshold | id | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0001__low-stock-threshold.md](P-005-0001__low-stock-threshold.md) |
| `P-005-0002` | includeOutOfStock() | [checked] | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0002__includeoutofstock.md](P-005-0002__includeoutofstock.md) |
| `P-005-0003` | dashboardChatPrompt | [(ngModel)] | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0003__dashboardchatprompt.md](P-005-0003__dashboardchatprompt.md) |
| `P-005-0004` | s.value | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0004__s-value.md](P-005-0004__s-value.md) |
| `P-005-0005` | s.trend | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0005__s-trend.md](P-005-0005__s-trend.md) |
| `P-005-0006` | s.label | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0006__s-label.md](P-005-0006__s-label.md) |
| `P-005-0007` | s.sub | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0007__s-sub.md](P-005-0007__s-sub.md) |
| `P-005-0008` | o.orderNumber | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0008__o-ordernumber.md](P-005-0008__o-ordernumber.md) |
| `P-005-0009` | o.totalAmount | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0009__o-totalamount.md](P-005-0009__o-totalamount.md) |
| `P-005-0010` | o.placedAtUtc | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0010__o-placedatutc.md](P-005-0010__o-placedatutc.md) |
| `P-005-0011` | p.name | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0011__p-name.md](P-005-0011__p-name.md) |
| `P-005-0012` | p.sku | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0012__p-sku.md](P-005-0012__p-sku.md) |
| `P-005-0013` | p.unitPrice | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0013__p-unitprice.md](P-005-0013__p-unitprice.md) |
| `P-005-0014` | s.shipmentNumber | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0014__s-shipmentnumber.md](P-005-0014__s-shipmentnumber.md) |
| `P-005-0015` | s.city | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0015__s-city.md](P-005-0015__s-city.md) |
| `P-005-0016` | s.createdAtUtc | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0016__s-createdatutc.md](P-005-0016__s-createdatutc.md) |
| `P-005-0017` | sl.label | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0017__sl-label.md](P-005-0017__sl-label.md) |
| `P-005-0018` | sl.value | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0018__sl-value.md](P-005-0018__sl-value.md) |
| `P-005-0019` | dealer.displayName | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0019__dealer-displayname.md](P-005-0019__dealer-displayname.md) |
| `P-005-0020` | dealer.orderCount | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0020__dealer-ordercount.md](P-005-0020__dealer-ordercount.md) |
| `P-005-0021` | dealer.totalAmount | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0021__dealer-totalamount.md](P-005-0021__dealer-totalamount.md) |
| `P-005-0022` | product.productName | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0022__product-productname.md](P-005-0022__product-productname.md) |
| `P-005-0023` | product.unitsSold | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0023__product-unitssold.md](P-005-0023__product-unitssold.md) |
| `P-005-0024` | product.sku | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0024__product-sku.md](P-005-0024__product-sku.md) |
| `P-005-0025` | product.revenue | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0025__product-revenue.md](P-005-0025__product-revenue.md) |
| `P-005-0026` | item.name | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0026__item-name.md](P-005-0026__item-name.md) |
| `P-005-0027` | msg.intent | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0027__msg-intent.md](P-005-0027__msg-intent.md) |
| `P-005-0028` | msg.text | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0028__msg-text.md](P-005-0028__msg-text.md) |
| `P-005-0029` | prompt | interpolation | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` | [P-005-0029__prompt.md](P-005-0029__prompt.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
