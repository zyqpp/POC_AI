# Macierz Testów: Shipment Detail I Tracking

Status: `potwierdzone` dla istniejących testów odnalezionych w repo; `brak w kodzie` dla braków testowych.
Zakres: `/shipments/:id`, `/orders/:id/tracking`, LogisticsTracking, Notification i frontend.

## Źródła

| Obszar | Źródło |
|---|---|
| Testy domenowe LogisticsTracking | `tests/LogisticsTracking.Domain.Tests/UnitTest1.cs:8-105` |
| Testy Notification | `tests/Notification.Domain.Tests/UnitTest1.cs:26-29` |
| Frontend specs | `supply-chain-frontend/src/**/*.spec.ts` |
| Wymagane SDK | `global.json:3` |

## Istniejące Pokrycie

| Test | Obszar | Co potwierdza | Powiązane ryzyko | Status |
|---|---|---|---|---|
| `Create_InitializesCreatedStateAndFirstEvent` | domena `Shipment.Create` | status `Created`, pierwszy event, normalizacja numeru | tworzenie shipmentu | potwierdzone |
| `AssignAgent_FromCreated_MovesToAssignedAndAddsEvent` | domena assign agent | `AssignedAgentId`, status `Assigned`, event | assignment lifecycle | potwierdzone |
| `AssignVehicle_BlankValue_Throws` | domena vehicle | pusty pojazd jest błędem | walidacja pojazdu | potwierdzone |
| `UpdateStatus_ToDelivered_SetsDeliveredTimestamp` | domena status | `Delivered` ustawia `DeliveredAtUtc` | finalizacja dostawy | potwierdzone |
| `UpdateStatus_ToDelivered_WithoutVehicle_Throws` | domena status | `Delivered` wymaga pojazdu | spójność UI/backend | potwierdzone |
| `RateDeliveryAgent_AfterDelivery_PersistsRatingDetails` | domena rating | rating, komentarz, aktor i data są zapisane | ocena agenta | potwierdzone |
| `RateDeliveryAgent_BeforeDelivery_Throws` | domena rating | rating przed dostawą jest błędem | reguła ratingu | potwierdzone |
| Notification domain assignment decisions | Notification | `ShipmentAssignmentAccepted` i `ShipmentAssignmentRejected` używają email channel | powiadomienia assignment | potwierdzone |

## Braki Testowe P0/P1

| Priorytet | Luka | Minimalny test | Warstwa | Status |
|---|---|---|---|---|
| P0 | Brak testów API auth/data scope `ShipmentsController.GetById`. | Dealer nie może odczytać cudzego shipmentu; Agent nie może odczytać nieprzypisanego shipmentu; odpowiedź `404`. | API integration/controller | brak w kodzie |
| P0 | Brak testu migracji/skryptu Logistics EF vs SQL. | Test lub walidator wykrywa, że `scripts/migrations/LogisticsTracking.sql` nie zawiera `ShipmentOpsStates`, `VehicleNumber`, assignment/rating. | migration/docs gate | brak w kodzie |
| P0 | Brak testu podwójnego dodania kolumn `AssignmentDecision*` w migracjach EF. | Test migracji na pustej bazie albo statyczny gate nazw kolumn. | migration | brak w kodzie |
| P1 | Brak testów API assignment accept/reject. | Tylko przypisany Agent może accept/reject; rejection reason required; completed shipment blokuje decyzję. | API/application | brak w kodzie |
| P1 | Brak testów `LogisticsService` dla outbox payloadów. | Każda akcja zapisuje oczekiwany `EventType` i krytyczny payload. | application | brak w kodzie |
| P1 | Brak testów `ShipmentOpsState`. | default, sync ready/pending/completed, exception nie jest nadpisywane przez sync. | domain/application | brak w kodzie |
| P1 | Brak testów Angular `ShipmentDetailComponent`. | Widoczność przycisków per rola, wymóg pojazdu dla agenta, rating tylko Dealer po delivered. | frontend | brak w kodzie |
| P1 | Brak testów Angular `OrderTrackingComponent`. | Filtr po `orderId`, Agent bez order detail nadal widzi assigned shipments, button statusu uwzględnia pojazd. | frontend | brak w kodzie |
| P1 | Brak testu `ShipmentDeliveryAttemptsService`. | Zapis, odczyt, sortowanie, ignorowanie błędnego JSON i brak API. | frontend service | brak w kodzie |
| P1 | Brak testu `ShipmentOpsQueueService.update()` przy błędzie PUT. | Fallback lokalny nie powinien być mylony z sukcesem trwałego zapisu. | frontend service | brak w kodzie |
| P1 | Brak testu chatbota dla rozjazdu Warehouse. | Backend dopuszcza Warehouse; UI nie pokazuje chatbota Warehouse. | auth/UX | brak w kodzie |

## Scenariusze Akceptacyjne

| ID | Scenariusz | Kroki | Oczekiwany wynik | Priorytet |
|---|---|---|---|---|
| SHP-API-001 | Dealer czyta tylko własny shipment | Token Dealera A, shipment Dealera B, `GET /shipments/{id}` | `404`, brak danych shipmentu B | P0 |
| SHP-API-002 | Agent czyta tylko przypisany shipment | Token Agenta A, shipment przypisany do B | `404` | P0 |
| SHP-API-003 | Agent acceptuje assignment | Shipment przypisany do Agenta, status aktywny, `PUT assignment/accept` | decision `Accepted`, event, outbox | P1 |
| SHP-API-004 | Agent nie może status update bez accepted | Shipment przypisany, decision `Pending`, `PUT status` | `409` z komunikatem | P1 |
| SHP-API-005 | Delivered wymaga pojazdu | Agent/Admin próbuje `Delivered` bez `VehicleNumber` | błąd biznesowy | P1 |
| SHP-API-006 | Rating tylko po delivered | Dealer rating przed delivered | błąd biznesowy | P1 |
| SHP-OPS-001 | Ops-state default | Shipment bez state, `GET ops-state` | powstaje state `Pending` albo `Ready` według agent+vehicle | P1 |
| SHP-OPS-002 | Handover exception | `PUT ops-state` z exception reason | `ShipmentOpsStates.HandoverState=Exception` | P1 |
| SHP-UI-001 | Shipment detail role buttons | Render dla Admin/Logistics/Agent/Dealer | widoczne tylko dozwolone akcje | P1 |
| SHP-UI-002 | Tracking filtruje shipmenty po orderId | Lista zawiera shipmenty wielu orderów | UI pokazuje tylko `shipment.orderId === id()` | P1 |
| SHP-UI-003 | Agent tracking bez order detail | Order API zwraca `404`, Logistics assigned zwraca shipment | komunikat o braku order details i działający tracker | P1 |
| SHP-UI-004 | Delivery attempts local-only | Dodanie próby i odświeżenie listy | próba jest w localStorage, brak API requestu | P1 |

## Powiązanie Test -> Ryzyko

| Ryzyko | Test domykający | Status |
|---|---|---|
| SQL Logistics nieaktualny względem EF | migracja/skrypt gate dla `ShipmentOpsStates`, `VehicleNumber`, assignment, rating | brak w kodzie |
| Podwójne kolumny `AssignmentDecision*` w migracjach | migracja na pustej bazie albo statyczny skaner migracji | brak w kodzie |
| Delivery attempts local-only | test usługi i decyzja produktowa | brak w kodzie |
| Ops-state PUT fallback jako lokalny sukces | test `ShipmentOpsQueueService.update()` z błędem HTTP | brak w kodzie |
| Tracking pobiera wszystkie shipmenty i filtruje w UI | test komponentu i ewentualny test wydajności | brak w kodzie |
| Assign agent bez Identity check | test application/API dla nieistniejącego Agenta | brak w kodzie |
| Chatbot Warehouse UI/backend mismatch | test macierzy ról albo decyzja UX | brak w kodzie |

## Weryfikacja Lokalna

| Komenda | Wynik | Status |
|---|---|---|
| `dotnet test` | nieuruchomione w tym inkremencie; subagent wskazał, że środowisko nie ma SDK z `global.json` | ograniczenie środowiska |
| `global.json` | wymaga SDK `10.0.104` | potwierdzone |
| `AI_Agent_scripts/Test-Podejscie2DocumentationQuality.ps1` | uruchamiane po aktualizacji dokumentacji | do wykonania w quality gate |

## Minimalny Plan Testów Do Dodania W Kodzie

| Kolejność | Test | Uzasadnienie |
|---:|---|---|
| 1 | API data scope `ShipmentsController` dla Dealer/Agent | bezpieczeństwo danych jest P0 |
| 2 | EF migration smoke test albo statyczny gate Logistics SQL | aktualny skrypt może nie wdrożyć potrzebnego modelu |
| 3 | `ShipmentOpsState` sync i upsert | ops-state steruje retry/handover |
| 4 | `OrderTrackingComponent` filtr i Agent fallback | tracking jest kompozycją UI, bez backendowego endpointu |
| 5 | Outbox payloady LogisticsService | eventy są kontraktem integracyjnym |
