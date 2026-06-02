# E-014 OrderTrackingComponent

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular, LogisticsApiService i OrderApiService.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-014` |
| Route | `/orders/:id/tracking` |
| Komponent | `OrderTrackingComponent` |
| Guardy | `roleGuard` |
| Role frontendu | `Admin, Dealer, Logistics, Agent` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` |
| Status faktów | `do uzupełnienia` |

## Dokumenty Atomowe

- [Pola UI](P-014_POLA/P-014__INDEX.md)
- [Akcje UI](A-014_AKCJE/A-014__INDEX.md)
- [Błędy i komunikaty](ERR-014_BLEDY/ERR-014__INDEX.md)
- [Dane testowe](TD-014_DANE_TESTOWE/TD-014__INDEX.md)
- [Testy](TC-014_TESTY/TC-014__INDEX.md)
- [Linki śladu](E-014__LINKI.md)

## Cel Ekranu

Widok śledzenia wysyłki powiązanej z zamówieniem. Pokazuje aktualny status shipmentu, historię zdarzeń i lokalizację agenta. UWAGA: backend pobiera WSZYSTKIE shipments (lub przypisane do roli) i filtruje po `orderId` po stronie klienta — ryzyko wydajnościowe przy dużej liczbie shipmentów (zidentyfikowane w RYZYKA.md). Powiązane procesy: [SHIPMENT_DETAIL_LIFECYCLE](../../../../06_PROCESY/SHIPMENT_DETAIL_LIFECYCLE.md)

Główne funkcje:
- Wyświetlenie szczegółów zamówienia (numer, status, historia statusów)
- Wyświetlenie listy shipmentów powiązanych z zamówieniem (filtr kliencki po `orderId`)
- Pasek postępu zamówienia (5 etapów) i shipmentu (6 etapów)
- Wybór aktywnego shipmentu z listy (select dropdown)
- Akcje agenta: Accept/Reject Assignment, Mark Out For Delivery, Approve Delivery
- Linki nawigacji wstecznej (zależne od roli)

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.ts` | Komponent — logika ładowania, akcji agenta, wyboru shipmentu |
| `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.html` | Template widoku |
| `supply-chain-frontend/src/app/core/api/order-api.service.ts` | `OrderApiService.getOrderById` → `GET /orders/api/orders/{id}` |
| `supply-chain-frontend/src/app/core/api/logistics-api.service.ts` | `LogisticsApiService` — `getMyShipments`, `getAssignedShipments`, `getAllShipments`, `acceptAssignment`, `rejectAssignment`, `updateStatus` |
| `supply-chain-frontend/src/app/core/models/logistics.models.ts` | `ShipmentDto`, `ShipmentEventDto` |
| `services/LogisticsTracking/LogisticsTracking.Application/Features/Shipments/Queries/ShipmentQueries.cs` | `GetDealerShipmentsQueryHandler`, `GetAgentShipmentsQueryHandler`, `GetAllShipmentsQueryHandler` |

## Główne Wywołania API

| Rola | Metoda | Endpoint | Opis |
|---|---|---|---|
| Wszystkie | `GET` | `/orders/api/orders/{id}` | Szczegóły zamówienia → `OrderDto` |
| Dealer | `GET` | `/logistics/api/logistics/shipments/my` | Shipment dealera → `ShipmentDto[]` |
| Agent | `GET` | `/logistics/api/logistics/shipments/assigned` | Przypisane shipments agenta → `ShipmentDto[]` |
| Admin / Logistics | `GET` | `/logistics/api/logistics/shipments` | Wszystkie shipments → `ShipmentDto[]` |
| Agent (accept) | `PUT` | `/logistics/api/logistics/shipments/{id}/assignment/accept` | Akceptacja przypisania |
| Agent (reject) | `PUT` | `/logistics/api/logistics/shipments/{id}/assignment/reject` | Odrzucenie z powodem |
| Agent (status) | `PUT` | `/logistics/api/logistics/shipments/{id}/status` | Zmiana statusu `OutForDelivery` / `Delivered` |

Filtrowanie po `orderId` odbywa się wyłącznie po stronie klienta: `allShipments.filter(s => s.orderId === this.id())`.

## Stany Ekranu

| Stan | Warunek | UI |
|---|---|---|
| Ładowanie | `loading() === true` | Spinner |
| Widok trackingu | `loading() === false && order() !== null` | Szczegóły zamówienia + lista shipmentów |
| Brak wysyłki | `loading() === false && shipments().length === 0` | Komunikat o braku shipmentu |
| Błąd | error handler z `subscribe` | `loading.set(false)`; stan pozostaje pusty |

## Zasada Uzupełniania

Każde pole `P-014-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
