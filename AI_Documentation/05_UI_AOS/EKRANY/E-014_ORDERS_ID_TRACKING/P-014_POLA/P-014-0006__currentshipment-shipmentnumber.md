# P-014-0006 currentShipment.shipmentNumber

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i ShipmentDto.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-014-0006` |
| Ekran | [E-014](../E-014__README.md) |
| Nazwa wykryta | `currentShipment.shipmentNumber` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Numer wybranego shipmentu w szczegółach śledzenia.
**Źródło danych:** ShipmentDto.shipmentNumber → Shipments.ShipmentNumber  
**Kiedy widoczne:** Gdy selectedShipment() !== null.
**Format:** Ciąg znaków (np. SHP-2024-000123).

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | do uzupełnienia | brak pełnej analizy formularza |
| Typ UI | do uzupełnienia | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` |
| Reguły walidacji | do uzupełnienia | brak pełnej analizy walidatorów |
| Komunikaty błędów | [ERR-014](../ERR-014_BLEDY/ERR-014__INDEX.md) | do uzupełnienia |

## Mapowanie Danych

| Warstwa | Artefakt | Przykład | Status |
|---|---|---|---|
| Frontend model/form | ShipmentDto.shipmentNumber | `shipmentNumber: string` | `wniosek z analizy` |
| Endpoint | LogisticsApiService | `GET /logistics/api/logistics/shipments/...` | `potwierdzone` |
| DTO/kontrakt | ShipmentDto | `public string ShipmentNumber { get; }` | `wniosek z analizy` |
| Tabela SQL | Shipments | `Shipments` | `wniosek z analizy` |
| Kolumna SQL | ShipmentNumber | `ShipmentNumber` | `wniosek z analizy` |
| Odczyt/zapis | Odczyt | `SELECT` | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-014_DANE_TESTOWE/TD-014-0006__currentshipment-shipmentnumber.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-014__INDEX.md)
- [Akcje ekranu](../A-014_AKCJE/A-014__INDEX.md)
- [Ślad ekranu](../E-014__LINKI.md)
