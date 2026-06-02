# P-013-0011 estimate.valid

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-013-0011` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `estimate.valid` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Liczba zaznaczonych zamówień, które mogą przejść do wybranego statusu bulk. Pochodzi z 	ransitionEstimate().valid.
**Źródło danych:** Lokalny computed 	ransitionEstimate — filtr po ORDER_STATUS_TRANSITIONS.
**Kiedy widoczne:** Gdy ulkStatus !== null && selectedCount > 0.
**Format:** Liczba całkowita.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | do uzupełnienia | brak pełnej analizy formularza |
| Typ UI | do uzupełnienia | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Reguły walidacji | do uzupełnienia | brak pełnej analizy walidatorów |
| Komunikaty błędów | [ERR-013](../ERR-013_BLEDY/ERR-013__INDEX.md) | do uzupełnienia |

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

- [TD dla pola](../TD-013_DANE_TESTOWE/TD-013-0011__estimate-valid.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-013__INDEX.md)
- [Akcje ekranu](../A-013_AKCJE/A-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
