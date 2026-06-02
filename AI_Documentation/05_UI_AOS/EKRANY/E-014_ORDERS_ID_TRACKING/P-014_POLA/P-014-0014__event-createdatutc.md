# P-014-0014 event.createdAtUtc

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i ShipmentDto.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-014-0014` |
| Ekran | [E-014](../E-014__README.md) |
| Nazwa wykryta | `event.createdAtUtc` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Timestamp zdarzenia trackingowego (ShipmentEvent).
**Źródło danych:** ShipmentEventDto.createdAtUtc → ShipmentEvents.CreatedAtUtc  
**Kiedy widoczne:** W liście zdarzeń wybranego shipmentu.
**Format:** ISO 8601 UTC; wyświetlany przez 	oLocaleString.

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
| Frontend model/form | ShipmentEventDto.createdAtUtc | `createdAtUtc: string` | `wniosek z analizy` |
| Endpoint | LogisticsApiService | `GET /logistics/api/logistics/shipments/...` | `potwierdzone` |
| DTO/kontrakt | ShipmentEventDto | `public string CreatedAtUtc { get; }` | `wniosek z analizy` |
| Tabela SQL | ShipmentEvents | `ShipmentEvents` | `wniosek z analizy` |
| Kolumna SQL | CreatedAtUtc | `CreatedAtUtc` | `wniosek z analizy` |
| Odczyt/zapis | Odczyt | `SELECT` | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-014_DANE_TESTOWE/TD-014-0014__event-createdatutc.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-014__INDEX.md)
- [Akcje ekranu](../A-014_AKCJE/A-014__INDEX.md)
- [Ślad ekranu](../E-014__LINKI.md)
