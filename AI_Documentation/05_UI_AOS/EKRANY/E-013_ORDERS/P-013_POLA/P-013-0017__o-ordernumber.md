# P-013-0017 o.orderNumber

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i OrderListItemDto.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-013-0017` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `o.orderNumber` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Numer zamówienia wyświetlany w tabeli listy i używany w wyszukiwaniu oraz eksporcie CSV. Czytelny identyfikator zamówienia dla użytkownika.  
**Źródło danych:** `OrderListItemDto.orderNumber` → `Orders.OrderNumber`  
**Kiedy widoczne:** Zawsze (w każdym wierszu tabeli).  
**Format:** Ciąg znaków (np. `ORD-2024-001234`).

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
| Frontend model/form | `OrderListItemDto.orderNumber` | `orderNumber: string` | `wniosek z analizy` |
| Endpoint | `GET /orders/api/orders/my` lub `/admin/orders` | `PagedResult<OrderListItemDto>` | `potwierdzone` |
| DTO/kontrakt | `OrderListItemDto` | `public string OrderNumber { get; }` | `wniosek z analizy` |
| Tabela SQL | `Orders` | `Orders` | `wniosek z analizy` |
| Kolumna SQL | `OrderNumber` | `OrderNumber` | `wniosek z analizy` |
| Odczyt/zapis | Odczyt | `SELECT OrderNumber FROM Orders` | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-013_DANE_TESTOWE/TD-013-0017__o-ordernumber.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-013__INDEX.md)
- [Akcje ekranu](../A-013_AKCJE/A-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
