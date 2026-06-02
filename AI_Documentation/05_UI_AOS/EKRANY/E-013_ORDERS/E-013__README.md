# E-013 OrderListComponent

Status: `wniosek z analizy`; źródło startowe: routing i komponent Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-013` |
| Route | `/orders` |
| Komponent | `OrderListComponent` |
| Guardy | `roleGuard` |
| Role frontendu | `Admin, Dealer, Warehouse, Logistics` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` |
| Status faktów | `do uzupełnienia` |

## Dokumenty Atomowe

- [Pola UI](P-013_POLA/P-013__INDEX.md)
- [Akcje UI](A-013_AKCJE/A-013__INDEX.md)
- [Błędy i komunikaty](ERR-013_BLEDY/ERR-013__INDEX.md)
- [Dane testowe](TD-013_DANE_TESTOWE/TD-013__INDEX.md)
- [Testy](TC-013_TESTY/TC-013__INDEX.md)
- [Linki śladu](E-013__LINKI.md)

## Cel Ekranu

Lista zamówień złożonych przez zalogowanego dealera (lub wszystkich zamówień dla Admina). Umożliwia filtrowanie po statusie, wyszukiwanie i przejście do szczegółu. Dealer widzi tylko swoje zamówienia (filtr po DealerId na backendzie). Powiązany proces: [ORDER_DETAIL_LIFECYCLE](../../../../06_PROCESY/ORDER_DETAIL_LIFECYCLE.md)

Główne funkcje:
- Przeglądanie listy zamówień z paginacją (20 na stronę; przy filtrach klienckich: 200 na stronę)
- Filtrowanie po statusie zamówienia (server-side), po SLA, po zakresie dat, po numerze zamówienia/orderId, po dealerId (Admin/Logistics)
- Wizualizacja pipeline'u statusów zamówienia (Placed → Process → Dispatch → Transit → Delivered)
- Zaznaczanie zamówień (checkbox per wiersz, zaznacz wszystkie na stronie, zaznacz wszystkie pasujące do filtrów)
- Masowa zmiana statusu zamówień z walidacją wstępną (precheck) — tylko Admin i Logistics
- Eksport listy do CSV
- Nawigacja do szczegółu zamówienia (`/orders/:id`) i do tworzenia zamówienia (`/products`)

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.ts` | Komponent Angular — logika ładowania, filtrów, bulk-status, export CSV |
| `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | Template z listą, filtrami, pipeline i checkboxami |
| `supply-chain-frontend/src/app/core/api/order-api.service.ts` | `OrderApiService` (dealer: `GET /orders/api/orders/my`) i `AdminOrderApiService` (admin/logistics: `GET /orders/api/admin/orders`, `POST /orders/api/admin/orders/bulk-status`) |
| `supply-chain-frontend/src/app/core/models/order.models.ts` | `OrderListItemDto`, `BulkUpdateOrderStatusRequest`, `BulkUpdateOrderStatusResultDto` |
| `supply-chain-frontend/src/app/core/services/order-sla.service.ts` | `OrderSlaService` — oblicza stan SLA zamówienia |
| `services/Order/Order.Application/Features/Orders/Queries/OrderQueries.cs` | `GetDealerOrdersQueryHandler`, `GetAllOrdersQueryHandler` |

## Główne Wywołania API

| Rola | Metoda | Endpoint | Parametry | Odpowiedź |
|---|---|---|---|---|
| Dealer | `GET` | `/orders/api/orders/my` | `page`, `pageSize`, `status?` | `PagedResult<OrderListItemDto>` |
| Admin / Warehouse / Logistics | `GET` | `/orders/api/admin/orders` | `page`, `pageSize`, `status?` | `PagedResult<OrderListItemDto>` |
| Admin / Logistics (precheck) | `POST` | `/orders/api/admin/orders/bulk-status` | `{ newStatus, orderIds, validateOnly: true }` | `BulkUpdateOrderStatusResultDto` |
| Admin / Logistics (apply) | `POST` | `/orders/api/admin/orders/bulk-status` | `{ newStatus, orderIds, validateOnly: false }` | `BulkUpdateOrderStatusResultDto` |

Filtrowanie po `searchQuery`, `dealerQuery`, `fromDate`, `toDate` i `slaFilter` odbywa się po stronie klienta (Angular), nie jako parametry HTTP.

## Stany Ekranu

| Stan | Warunek | UI |
|---|---|---|
| Ładowanie | `loading() === true` | Spinner / skeleton |
| Lista zamówień | `loading() === false && orders().length > 0` | Tabela z wierszami zamówień |
| Pusta lista | `loading() === false && orders().length === 0` | Komunikat "brak zamówień", link do `/products` |
| Błąd HTTP | Błąd z subscribe error handler | `loading.set(false)`; brak toast — ekran pozostaje pusty |

## Zasada Uzupełniania

Każde pole `P-013-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
