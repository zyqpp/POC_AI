# P-013-0009 isSelected(o.orderId)

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-013-0009` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `isSelected(o.orderId)` |
| Typ detekcji | `[checked]` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Stan checkboxa per wiersz zamówienia. isSelected(o.orderId) sprawdza czy orderId jest w selectedOrderIds.
**Źródło danych:** Lokalny state komponentu (selectedOrderIds signal).
**Kiedy widoczne:** W każdym wierszu tabeli.
**Format:** Boolean (checked/unchecked).

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

- [TD dla pola](../TD-013_DANE_TESTOWE/TD-013-0009__isselected-o-orderid.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-013__INDEX.md)
- [Akcje ekranu](../A-013_AKCJE/A-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
