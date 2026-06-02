# P-014 Pola UI

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i ShipmentDto/OrderDto.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-014-0001` | selectedShipmentId() | [ngModel] | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0001__selectedshipmentid.md](P-014-0001__selectedshipmentid.md) |
| `P-014-0002` | assignmentResponseNote | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0002__assignmentresponsenote.md](P-014-0002__assignmentresponsenote.md) |
| `P-014-0003` | deliveryNote | [(ngModel)] | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0003__deliverynote.md](P-014-0003__deliverynote.md) |
| `P-014-0004` | currentOrder.orderNumber | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0004__currentorder-ordernumber.md](P-014-0004__currentorder-ordernumber.md) |
| `P-014-0005` | stage | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0005__stage.md](P-014-0005__stage.md) |
| `P-014-0006` | currentShipment.shipmentNumber | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0006__currentshipment-shipmentnumber.md](P-014-0006__currentshipment-shipmentnumber.md) |
| `P-014-0007` | shipment.shipmentNumber | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0007__shipment-shipmentnumber.md](P-014-0007__shipment-shipmentnumber.md) |
| `P-014-0008` | currentShipment.deliveryAddress | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0008__currentshipment-deliveryaddress.md](P-014-0008__currentshipment-deliveryaddress.md) |
| `P-014-0009` | currentShipment.city | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0009__currentshipment-city.md](P-014-0009__currentshipment-city.md) |
| `P-014-0010` | currentShipment.state | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0010__currentshipment-state.md](P-014-0010__currentshipment-state.md) |
| `P-014-0011` | currentShipment.postalCode | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0011__currentshipment-postalcode.md](P-014-0011__currentshipment-postalcode.md) |
| `P-014-0012` | currentShipment.vehicleNumber | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0012__currentshipment-vehiclenumber.md](P-014-0012__currentshipment-vehiclenumber.md) |
| `P-014-0013` | currentShipment.assignmentDecisionReason | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0013__currentshipment-assignmentdecisionreason.md](P-014-0013__currentshipment-assignmentdecisionreason.md) |
| `P-014-0014` | event.createdAtUtc | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0014__event-createdatutc.md](P-014-0014__event-createdatutc.md) |
| `P-014-0015` | event.updatedByRole | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0015__event-updatedbyrole.md](P-014-0015__event-updatedbyrole.md) |
| `P-014-0016` | event.note | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0016__event-note.md](P-014-0016__event-note.md) |
| `P-014-0017` | history.changedAtUtc | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0017__history-changedatutc.md](P-014-0017__history-changedatutc.md) |
| `P-014-0018` | history.changedByRole | interpolation | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | [P-014-0018__history-changedbyrole.md](P-014-0018__history-changedbyrole.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
