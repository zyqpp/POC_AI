# P-013-0021 o.placedAtUtc

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i OrderListItemDto.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-013-0021` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `o.placedAtUtc` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Data i godzina złożenia zamówienia (UTC). Wyświetlana w tabeli listy i eksportowana do CSV. Używana jako filtr kliencki (`fromDate`, `toDate`) — porównywana przez `new Date(order.placedAtUtc)`.  
**Źródło danych:** `OrderListItemDto.placedAtUtc` → `Orders.PlacedAtUtc`  
**Kiedy widoczne:** Zawsze (w każdym wierszu tabeli).  
**Format:** ISO 8601 string UTC (np. `2024-03-15T10:30:00Z`); w CSV wypisywana surowo.

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
| Frontend model/form | `OrderListItemDto.placedAtUtc` | `placedAtUtc: string` | `wniosek z analizy` |
| Endpoint | `GET /orders/api/orders/my` lub `/admin/orders` | `PagedResult<OrderListItemDto>` | `potwierdzone` |
| DTO/kontrakt | `OrderListItemDto` | `public string PlacedAtUtc { get; }` | `wniosek z analizy` |
| Tabela SQL | `Orders` | `Orders` | `wniosek z analizy` |
| Kolumna SQL | `PlacedAtUtc` | `PlacedAtUtc` (DATETIME2) | `wniosek z analizy` |
| Odczyt/zapis | Odczyt | `SELECT PlacedAtUtc FROM Orders` | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-013_DANE_TESTOWE/TD-013-0021__o-placedatutc.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-013__INDEX.md)
- [Akcje ekranu](../A-013_AKCJE/A-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
