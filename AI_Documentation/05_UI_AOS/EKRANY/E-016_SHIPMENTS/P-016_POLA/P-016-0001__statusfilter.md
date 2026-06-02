# P-016-0001 statusFilter

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i ShipmentDto.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-016-0001` |
| Ekran | [E-016](../E-016__README.md) |
| Nazwa wykryta | `statusFilter` |
| Typ detekcji | `[(ngModel)]` |
| Źródło | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Filtr po statusie shipmentu (kliencki). Dropdown z wartościami ShipmentStatus enum z SHIPMENT_STATUS_LABELS.
**Źródło danych:** Lokalny enum ShipmentStatus; wartość null = wszystkie.
**Kiedy widoczne:** Zawsze.
**Format:** Dropdown; domyślnie null (wszystkie statusy).

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | do uzupełnienia | brak pełnej analizy formularza |
| Typ UI | do uzupełnienia | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` |
| Reguły walidacji | do uzupełnienia | brak pełnej analizy walidatorów |
| Komunikaty błędów | [ERR-016](../ERR-016_BLEDY/ERR-016__INDEX.md) | do uzupełnienia |

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

- [TD dla pola](../TD-016_DANE_TESTOWE/TD-016-0001__statusfilter.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-016__INDEX.md)
- [Akcje ekranu](../A-016_AKCJE/A-016__INDEX.md)
- [Ślad ekranu](../E-016__LINKI.md)
