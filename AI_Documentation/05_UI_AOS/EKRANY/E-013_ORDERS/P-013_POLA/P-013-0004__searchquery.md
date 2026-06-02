# P-013-0004 searchQuery

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-013-0004` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `searchQuery` |
| Typ detekcji | `[(ngModel)]` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Pole tekstowe wyszukiwania. Filtruje listę zamówień po stronie klienta (Angular) po `orderNumber` i `orderId` (case-insensitive, contains).  
**Źródło danych:** Brak — lokalna operacja `applyClientFilters()` na załadowanej stronie danych.  
**Kiedy widoczne:** Zawsze.  
**Format:** Text input; wartość pusta = brak filtrowania.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | do uzupełnienia | brak pełnej analizy formularza |
| Typ UI | do uzupełnienia | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Reguły walidacji | do uzupełnienia | brak pełnej analizy walidatorów |
| Komunikaty błędów | [ERR-013](../ERR-013_BLEDY/ERR-013__INDEX.md) | do uzupełnienia |

## Mapowanie Danych

| Warstwa | Artefakt | Przykład | Status |
|---|---|---|---|
| Frontend model/form | `OrderListComponent.searchQuery` | `searchQuery: string` | `wniosek z analizy` |
| Endpoint | Brak — filtr kliencki | n/d | `potwierdzone` |
| DTO/kontrakt | `OrderListItemDto.orderNumber`, `orderId` | `public string OrderNumber { get; }` | `wniosek z analizy` |
| Tabela SQL | `Orders` | `Orders` | `wniosek z analizy` |
| Kolumna SQL | `OrderNumber`, `OrderId` | `OrderNumber`, `OrderId` | `wniosek z analizy` |
| Odczyt/zapis | Odczyt (filtr kliencki) | `includes()` w TS | `potwierdzone` |

## Dane Do Testów

- [TD dla pola](../TD-013_DANE_TESTOWE/TD-013-0004__searchquery.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-013__INDEX.md)
- [Akcje ekranu](../A-013_AKCJE/A-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
