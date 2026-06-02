# P-013-0018 o.dealerId

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i OrderListItemDto.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-013-0018` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `o.dealerId` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Identyfikator dealera (UUID) widoczny w tabeli listy zamówień. Używany do filtrowania klientowego (`dealerQuery`) i w eksporcie CSV. Dealer nie widzi tego pola (element jest widoczny tylko dla Admin/Logistics/Warehouse).  
**Źródło danych:** `OrderListItemDto.dealerId` → `Orders.DealerId`  
**Kiedy widoczne:** Dla ról Admin, Logistics, Warehouse — w każdym wierszu tabeli. Dealer widzi tylko własne zamówienia, więc pole jest zbędne, ale brak warunku ukrycia w kodzie.  
**Format:** UUID (GUID), np. `a1b2c3d4-...`.

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
| Frontend model/form | `OrderListItemDto.dealerId` | `dealerId: string` | `wniosek z analizy` |
| Endpoint | `GET /orders/api/admin/orders` | `PagedResult<OrderListItemDto>` | `potwierdzone` |
| DTO/kontrakt | `OrderListItemDto` | `public string DealerId { get; }` | `wniosek z analizy` |
| Tabela SQL | `Orders` | `Orders` | `wniosek z analizy` |
| Kolumna SQL | `DealerId` | `DealerId` (UNIQUEIDENTIFIER) | `wniosek z analizy` |
| Odczyt/zapis | Odczyt | `SELECT DealerId FROM Orders` | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-013_DANE_TESTOWE/TD-013-0018__o-dealerid.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-013__INDEX.md)
- [Akcje ekranu](../A-013_AKCJE/A-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
