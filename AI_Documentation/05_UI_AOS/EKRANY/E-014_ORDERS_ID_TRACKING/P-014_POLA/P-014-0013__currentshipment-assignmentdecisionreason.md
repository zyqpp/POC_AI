# P-014-0013 currentShipment.assignmentDecisionReason

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i ShipmentDto.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-014-0013` |
| Ekran | [E-014](../E-014__README.md) |
| Nazwa wykryta | `currentShipment.assignmentDecisionReason` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Powód odrzucenia przypisania przez agenta.
**Źródło danych:** ShipmentDto.assignmentDecisionReason → Shipments.AssignmentDecisionReason  
**Kiedy widoczne:** Gdy ssignmentDecisionStatus === Rejected && assignmentDecisionReason.
**Format:** Ciąg znaków.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | do uzupełnienia | brak pełnej analizy formularza |
| Typ UI | do uzupełnienia | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` |
| Reguły walidacji | do uzupełnienia | brak pełnej analizy walidatorów |
| Komunikaty błędów | [ERR-014](../ERR-014_BLEDY/ERR-014__INDEX.md) | do uzupełnienia |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | do uzupełnienia | `do uzupełnienia` |
| Serwis API | do uzupełnienia | `do uzupełnienia` |
| Endpoint | do uzupełnienia | `do uzupełnienia` |
| DTO/kontrakt | do uzupełnienia | `do uzupełnienia` |
| Encja/model | do uzupełnienia | `do uzupełnienia` |
| DbContext | do uzupełnienia | `do uzupełnienia` |
| Schemat SQL | do uzupełnienia | `do uzupełnienia` |
| Tabela SQL | do uzupełnienia | `do uzupełnienia` |
| Kolumna SQL | do uzupełnienia | `do uzupełnienia` |
| Odczyt/zapis | do uzupełnienia | `do uzupełnienia` |

## Dane Do Testów

- [TD dla pola](../TD-014_DANE_TESTOWE/TD-014-0013__currentshipment-assignmentdecisionreason.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-014__INDEX.md)
- [Akcje ekranu](../A-014_AKCJE/A-014__INDEX.md)
- [Ślad ekranu](../E-014__LINKI.md)
