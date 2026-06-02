# P-016 Pola UI

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i ShipmentDto.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-016-0001` | statusFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` | [P-016-0001__statusfilter.md](P-016-0001__statusfilter.md) |
| `P-016-0002` | slaFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` | [P-016-0002__slafilter.md](P-016-0002__slafilter.md) |
| `P-016-0003` | opsFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` | [P-016-0003__opsfilter.md](P-016-0003__opsfilter.md) |
| `P-016-0004` | s.label | interpolation | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` | [P-016-0004__s-label.md](P-016-0004__s-label.md) |
| `P-016-0005` | s.shipmentNumber | interpolation | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` | [P-016-0005__s-shipmentnumber.md](P-016-0005__s-shipmentnumber.md) |
| `P-016-0006` | s.orderId | interpolation | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` | [P-016-0006__s-orderid.md](P-016-0006__s-orderid.md) |
| `P-016-0007` | s.deliveryAddress | interpolation | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` | [P-016-0007__s-deliveryaddress.md](P-016-0007__s-deliveryaddress.md) |
| `P-016-0008` | s.city | interpolation | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` | [P-016-0008__s-city.md](P-016-0008__s-city.md) |
| `P-016-0009` | s.createdAtUtc | interpolation | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` | [P-016-0009__s-createdatutc.md](P-016-0009__s-createdatutc.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
