# P-013-0002 statusFilter

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i OrderApiService.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-013-0002` |
| Ekran | [E-013](../E-013__README.md) |
| Nazwa wykryta | `statusFilter` |
| Typ detekcji | `[(ngModel)]` |
| Źródło | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

**Co wyświetla / zbiera:** Filtr po statusie zamówienia. Dropdown z wartościami enum `OrderStatus`. Wybór powoduje przeładowanie listy z serwera (server-side filter parametrem `status`).  
**Źródło danych:** Lokalny enum `OrderStatus`; lista opcji z `ORDER_STATUS_LABELS`. Wartość `null` = brak filtrowania.  
**Kiedy widoczne:** Zawsze.  
**Format:** Dropdown; domyślnie "Wszystkie statusy" (null).

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
| Frontend model/form | `OrderListComponent.statusFilter` | `statusFilter: OrderStatus \| null` | `wniosek z analizy` |
| Endpoint (dealer) | `OrderApiService.getMyOrders` | `GET /orders/api/orders/my?status=2` | `potwierdzone` |
| Endpoint (admin) | `AdminOrderApiService.getAllOrders` | `GET /orders/api/admin/orders?status=2` | `potwierdzone` |
| DTO/kontrakt | `GetAllOrdersQuery.Status` | `int? Status` | `wniosek z analizy` |
| Tabela SQL | `Orders` | `Orders` | `wniosek z analizy` |
| Kolumna SQL | `Status` | `Status` (int enum) | `wniosek z analizy` |
| Odczyt/zapis | Odczyt (filtr WHERE) | `WHERE Status = @status` | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-013_DANE_TESTOWE/TD-013-0002__statusfilter.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-013__INDEX.md)
- [Akcje ekranu](../A-013_AKCJE/A-013__INDEX.md)
- [Ślad ekranu](../E-013__LINKI.md)
