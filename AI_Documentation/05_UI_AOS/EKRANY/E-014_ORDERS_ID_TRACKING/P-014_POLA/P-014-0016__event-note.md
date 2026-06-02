# P-014-0016 event.note

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i ShipmentDto.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-014-0016` |
| Ekran | [E-014](../E-014__README.md) |
| Nazwa wykryta | `event.note` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Notatka do zdarzenia trackingowego.
**Źródło danych:** ShipmentEventDto.note → ShipmentEvents.Note  
**Kiedy widoczne:** W liście zdarzeń gdy 
ote istnieje.
**Format:** Ciąg znaków (max 500).

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
| Frontend model/form | ShipmentEventDto.note | `note: string` | `wniosek z analizy` |
| Endpoint | LogisticsApiService | `GET /logistics/api/logistics/shipments/...` | `potwierdzone` |
| DTO/kontrakt | ShipmentEventDto | `public string Note { get; }` | `wniosek z analizy` |
| Tabela SQL | ShipmentEvents | `ShipmentEvents` | `wniosek z analizy` |
| Kolumna SQL | Note | `Note` | `wniosek z analizy` |
| Odczyt/zapis | Odczyt | `SELECT` | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-014_DANE_TESTOWE/TD-014-0016__event-note.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-014__INDEX.md)
- [Akcje ekranu](../A-014_AKCJE/A-014__INDEX.md)
- [Ślad ekranu](../E-014__LINKI.md)
