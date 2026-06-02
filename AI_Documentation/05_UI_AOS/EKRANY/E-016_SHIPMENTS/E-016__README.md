# E-016 ShipmentListComponent

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i LogisticsApiService.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-016` |
| Route | `/shipments` |
| Komponent | `ShipmentListComponent` |
| Guardy | `roleGuard` |
| Role frontendu | `Admin, Logistics, Agent, Dealer` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` |
| Status faktów | `do uzupełnienia` |

## Dokumenty Atomowe

- [Pola UI](P-016_POLA/P-016__INDEX.md)
- [Akcje UI](A-016_AKCJE/A-016__INDEX.md)
- [Błędy i komunikaty](ERR-016_BLEDY/ERR-016__INDEX.md)
- [Dane testowe](TD-016_DANE_TESTOWE/TD-016__INDEX.md)
- [Testy](TC-016_TESTY/TC-016__INDEX.md)
- [Linki śladu](E-016__LINKI.md)

## Cel Ekranu

Lista wysyłek widoczna dla roli Agent (jego przypisane przesyłki) i Logistics Coordinator/Admin (wszystkie). Dealer widzi tylko własne shipments. Umożliwia filtrowanie po statusie, SLA i stanie operacyjnym (ops queue) oraz przejście do szczegółu. Powiązany proces: [SHIPMENT_DETAIL_LIFECYCLE](../../../../06_PROCESY/SHIPMENT_DETAIL_LIFECYCLE.md)

Główne funkcje:
- Przeglądanie listy shipmentów posortowanych malejąco po `createdAtUtc`
- Filtrowanie po `ShipmentStatus` (klienckie), SLA state (`on-track`, `at-risk`, `delayed`, `exception`) i ops filter (`handover-pending`, `exception-queue`, `retry-required`)
- Wskaźniki licznikowe ops queue (Handover Pending, Exception Queue, Retry Required)
- Kolumny: numer shipmentu, orderId, adres dostawy, miasto, data utworzenia, status, ETA/SLA badge
- Nawigacja do szczegółu shipmentu

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.ts` | Komponent — logika ładowania, filtrów, ops queue |
| `supply-chain-frontend/src/app/features/logistics/shipment-list/shipment-list.component.html` | Template z listą i filtrami |
| `supply-chain-frontend/src/app/core/api/logistics-api.service.ts` | `LogisticsApiService` — `getMyShipments`, `getAssignedShipments`, `getAllShipments`, `getShipmentOpsStatesBatch` |
| `supply-chain-frontend/src/app/core/services/shipment-eta.service.ts` | `ShipmentEtaService` — oblicza ETA i SLA state shipmentu |
| `supply-chain-frontend/src/app/core/services/shipment-ops-queue.service.ts` | `ShipmentOpsQueueService` — batch ops states |
| `supply-chain-frontend/src/app/core/models/logistics.models.ts` | `ShipmentDto`, `ShipmentOpsStateDto` |
| `services/LogisticsTracking/LogisticsTracking.Application/Features/Shipments/Queries/ShipmentQueries.cs` | `GetAllShipmentsQueryHandler`, `GetDealerShipmentsQueryHandler`, `GetAgentShipmentsQueryHandler` |

## Główne Wywołania API

| Rola | Metoda | Endpoint | Odpowiedź |
|---|---|---|---|
| Dealer | `GET` | `/logistics/api/logistics/shipments/my` | `ShipmentDto[]` |
| Agent | `GET` | `/logistics/api/logistics/shipments/assigned` | `ShipmentDto[]` |
| Admin / Logistics | `GET` | `/logistics/api/logistics/shipments` | `ShipmentDto[]` |
| Wszystkie (po załadowaniu) | `POST` | `/logistics/api/logistics/shipments/ops-states/batch` | `ShipmentOpsStateDto[]` |

Filtrowanie po `statusFilter`, `slaFilter`, `opsFilter` odbywa się po stronie klienta w `applyFilter()`. Brak paginacji.

## Stany Ekranu

| Stan | Warunek | UI |
|---|---|---|
| Ładowanie | `loading() === true` | Spinner |
| Lista shipmentów | `loading() === false && filtered().length > 0` | Tabela shipmentów |
| Pusta lista | `loading() === false && filtered().length === 0` | Komunikat o braku shipmentów |
| Błąd | error handler | `loading.set(false)`, lista pusta |

## Zasada Uzupełniania

Każde pole `P-016-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
