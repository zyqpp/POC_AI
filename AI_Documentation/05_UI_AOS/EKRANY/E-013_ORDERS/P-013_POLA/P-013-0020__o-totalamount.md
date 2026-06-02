# P-013-0020 o.totalAmount

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i OrderListItemDto.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-013-0020` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `o.totalAmount` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Łączna wartość zamówienia wyświetlana w tabeli listy. W eksporcie CSV formatowana jako `toFixed(2)`.  
**Źródło danych:** `OrderListItemDto.totalAmount` → `Orders.TotalAmount`  
**Kiedy widoczne:** Zawsze (widoczne w każdym wierszu tabeli).  
**Format:** Liczba dziesiętna; w CSV: `toFixed(2)` (np. `1234.50`).

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
| Frontend model/form | `OrderListItemDto.totalAmount` | `totalAmount: number` | `wniosek z analizy` |
| Endpoint | `GET /orders/api/orders/my` lub `/admin/orders` | `PagedResult<OrderListItemDto>` | `potwierdzone` |
| DTO/kontrakt | `OrderListItemDto` | `public decimal TotalAmount { get; }` | `wniosek z analizy` |
| Tabela SQL | `Orders` | `Orders` | `wniosek z analizy` |
| Kolumna SQL | `TotalAmount` | `TotalAmount` | `wniosek z analizy` |
| Odczyt/zapis | Odczyt | `SELECT TotalAmount FROM Orders` | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-013_DANE_TESTOWE/TD-013-0020__o-totalamount.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-013__INDEX.md)
- [Akcje ekranu](../A-013_AKCJE/A-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
