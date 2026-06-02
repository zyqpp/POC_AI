# P-016-0006 s.orderId

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i ShipmentDto.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-016-0006` |
| Ekran | [E-016](../E-016__README.md) |
| Nazwa wykryta | `s.orderId` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** ID zamówienia powiązanego z shipmentem. Widoczne w tabeli; umożliwia identyfikację zamówienia.
**Źródło danych:** ShipmentDto.orderId → Shipments.OrderId  
**Kiedy widoczne:** W każdym wierszu tabeli.
**Format:** UUID string.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | do uzupełnienia | brak pełnej analizy formularza |
| Typ UI | do uzupełnienia | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` |
| Reguły walidacji | do uzupełnienia | brak pełnej analizy walidatorów |
| Komunikaty błędów | [ERR-016](../ERR-016_BLEDY/ERR-016__INDEX.md) | do uzupełnienia |

## Mapowanie Danych

| Warstwa | Artefakt | Przykład | Status |
|---|---|---|---|
| Frontend model/form | ShipmentDto.orderId | `orderId: string` | `wniosek z analizy` |
| Endpoint | LogisticsApiService (rola-zależny) | `GET /logistics/api/logistics/shipments[/my|/assigned]` | `potwierdzone` |
| DTO/kontrakt | ShipmentDto | `public string OrderId { get; }` | `wniosek z analizy` |
| Tabela SQL | Shipments | `Shipments` | `wniosek z analizy` |
| Kolumna SQL | OrderId | `OrderId` | `wniosek z analizy` |
| Odczyt/zapis | Odczyt | `SELECT` | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-016_DANE_TESTOWE/TD-016-0006__s-orderid.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-016__INDEX.md)
- [Akcje ekranu](../A-016_AKCJE/A-016__INDEX.md)
- [Ślad ekranu](../E-016__LINKI.md)
