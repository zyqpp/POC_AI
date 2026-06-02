# Proces End-To-End: Shipment Detail I Tracking

Status: `potwierdzone` dla przepływów z kodu; `potwierdzone jako ryzyko` dla rozjazdów localStorage, migracji i filtracji po stronie klienta.
Zakres: `/shipments/:id`, `/orders/:id/tracking`, assignment, pojazd, statusy, ops-state, retry, handover, rating, chatbot i outbox.

## Cel

## Opis

Cykl życia wysyłki po przypisaniu do agenta: od Assigned przez PickedUp, InTransit, Delivered do Failed lub Returned — wszystkie operacje dostępne z ekranu E-017.

Opisuje cykl życia wysyłki po jej przypisaniu do agenta: od statusu `Assigned` przez `PickedUp`, `InTransit`, `Delivered` do `Failed`/`Returned`. Dokument pokrywa operacje widoczne na ekranie [E-017_SHIPMENTS_ID](../05_UI_AOS/EKRANY/E-017_SHIPMENTS_ID/E-017__README.md): assign agent, update ops-state, record attempt, complete delivery.

## Proces Główny: Odczyt Shipment Detail

| Krok | Warstwa | Działanie | Dane | Status |
|---:|---|---|---|---|
| 1 | UI routing | Użytkownik wchodzi na `/shipments/:id`; wymagany `authGuard` i `roleGuard`. | JWT, role `Admin`, `Logistics`, `Agent`, `Dealer` | potwierdzone |
| 2 | UI component | `ShipmentDetailComponent.loadShipment()` wywołuje `LogisticsApiService.getShipmentById(id)`. | `shipmentId` z route input | potwierdzone |
| 3 | Gateway | `/logistics/api/logistics/shipments/{id}` przechodzi przez Ocelot `/logistics/{everything}` do portu 8004. | Bearer token | potwierdzone |
| 4 | API | `ShipmentsController.GetById` pobiera shipment przez `GetShipmentQuery`. | `ShipmentDto` | potwierdzone |
| 5 | API data scope | Dealer/Agent przechodzą dodatkowe sprawdzenie `DealerId` albo `AssignedAgentId`; brak scope daje `404`. | `Shipments.DealerId`, `Shipments.AssignedAgentId` | potwierdzone |
| 6 | Repository | `ShipmentRepository.GetShipmentByIdAsync` ładuje shipment z `Include(Events)`. | `Shipments`, `ShipmentEvents` | potwierdzone |
| 7 | UI component | Po sukcesie UI zapisuje `shipment`, ładuje lokalne attempts i synchronizuje ops-state. | DTO + localStorage + `ShipmentOpsStates` | potwierdzone |
| 8 | UI refresh | Dla statusów `InTransit` i `OutForDelivery` ekran odświeża dane co 30 sekund. | odczyt API cykliczny | potwierdzone |

## Proces: Assignment Agenta

| Krok | Warstwa | Działanie | Dane / zapis | Status |
|---:|---|---|---|---|
| 1 | UI | `Admin` albo `Logistics` otwiera assign dialog; UI może pobrać aktywnych agentów z IdentityAuth lub przyjąć UUID. | `AdminApiService.getAgents` albo ręczny `agentId` | potwierdzone |
| 2 | UI | `assignAgent()` waliduje UUID i wywołuje `PUT .../assign-agent`. | `AssignAgentRequest.AgentId` | potwierdzone |
| 3 | API | `ShipmentsController.AssignAgent` wymaga `Admin,Logistics`. | `[Authorize(Roles = "Admin,Logistics")]` | potwierdzone |
| 4 | Application | `AssignAgentAsync` waliduje `AgentId`, pobiera shipment, wywołuje domenę. | `AssignAgentRequestValidator` | potwierdzone |
| 5 | Domain | `Shipment.AssignAgent` ustawia `AssignedAgentId`, `AssignmentDecisionStatus=Pending`, czyści reason/date, ewentualnie status `Assigned`, dodaje event. | `Shipments`, `ShipmentEvents` | potwierdzone |
| 6 | Application | `SyncOpsStateWithShipmentAsync` ustawia handover `Ready`, jeżeli są agent i pojazd, inaczej `Pending`. | `ShipmentOpsStates` | potwierdzone |
| 7 | Application | Dodaje outbox `ShipmentAssigned`. | `OutboxMessages` | potwierdzone |
| 8 | Ryzyko | Backend nie potwierdza w IdentityAuth, że UUID jest aktywnym agentem. | tylko `NotEmpty()` | potwierdzone |

## Proces: Decyzja Agenta

| Krok | Warstwa | Accept | Reject | Dane | Status |
|---:|---|---|---|---|---|
| 1 | UI | `canAcceptAssignment()` wymaga roli Agent, własnego `AssignedAgentId`, statusu niekońcowego i decision `Pending`. | ta sama reguła, dodatkowo powód wymagany w UI | `ShipmentDto` | potwierdzone |
| 2 | API | `PUT .../assignment/accept` bez body | `PUT .../assignment/reject` z `RejectAssignmentRequest` | JWT agenta | potwierdzone |
| 3 | Application | `AcceptAssignmentAsync` sprawdza `AssignedAgentId == agentId`. | `RejectAssignmentAsync` sprawdza agenta i reason validator. | `Shipments.AssignedAgentId` | potwierdzone |
| 4 | Domain | Ustawia `AssignmentDecisionStatus=Accepted`, date, event. | Ustawia `Rejected`, reason/date, czyści `AssignedAgentId`, status wraca do `Created` albo `Assigned`. | `Shipments`, `ShipmentEvents` | potwierdzone |
| 5 | Side effects | `ShipmentAssignmentAccepted`, sync ops-state. | `ShipmentAssignmentRejected`, sync ops-state. | `OutboxMessages`, `ShipmentOpsStates` | potwierdzone |
| 6 | Ryzyko | Błędy domenowe po zakończeniu shipmentu przechodzą przez middleware. | Tak samo. | status HTTP zależny od middleware | potwierdzone |

## Proces: Pojazd I Status Dostawy

| Krok | Warstwa | Działanie | Dane / zapis | Status |
|---:|---|---|---|---|
| 1 | UI | `Admin` albo `Logistics` przypisuje pojazd przez dialog. | `AssignVehicleRequest.VehicleNumber` | potwierdzone |
| 2 | Backend | Validator wymaga 5-32 znaków i wzorca liter/cyfr/spacji/myślników. | `VehicleNumber` normalizowany do uppercase | potwierdzone |
| 3 | Domain | `AssignVehicle` ustawia pojazd i ewentualnie status `Assigned`. | `Shipments.VehicleNumber`, `Shipments.Status`, event | potwierdzone |
| 4 | UI | Status update wymaga notatki; Agent może działać tylko po accepted assignment i dla własnego shipmentu. | `UpdateShipmentStatusRequest` | potwierdzone |
| 5 | API | Kontroler blokuje Agenta bez accepted assignment. | `409` z komunikatem | potwierdzone |
| 6 | Application | Dodatkowo Agent nie może ustawić `InTransit`, `OutForDelivery`, `Delivered` bez pojazdu. | `InvalidOperationException` | potwierdzone |
| 7 | Domain | `UpdateStatus` blokuje shipmenty `Delivered`/`Returned`, wymaga pojazdu dla `Delivered`, ustawia `DeliveredAtUtc` przy delivered i dodaje event. | `Shipments`, `ShipmentEvents` | potwierdzone |
| 8 | Side effects | `SyncOpsStateWithShipmentAsync`, outbox `ShipmentStatusUpdated`. | `ShipmentOpsStates`, `OutboxMessages` | potwierdzone |
| 9 | Ryzyko | Backend nie egzekwuje pełnej maszyny przejść statusów poza regułami powyżej. | można wysłać status spoza kolejności UI | potwierdzone |

## Proces: Ops-State, Handover I Retry

| Krok | Warstwa | Działanie | Dane / zapis | Status |
|---:|---|---|---|---|
| 1 | UI | Ekran czyta ops-state przez `ShipmentOpsQueueService.get`. | `GET .../ops-state` | potwierdzone |
| 2 | API | `GetShipmentOpsStateAsync` tworzy default, jeśli brakuje stanu, i synchronizuje go z shipmentem. | `ShipmentOpsStates` | potwierdzone |
| 3 | UI | `Admin`/`Logistics` może raise handover exception, schedule retry, mark complete, clear retry. | `UpsertShipmentOpsStateRequest` | potwierdzone |
| 4 | Backend | `UpsertShipmentOpsStateAsync` normalizuje handover, tekst max 300, daty UTC, retry count 0-99. | `ShipmentOpsState.Update` | potwierdzone |
| 5 | Sync | Po upsert serwis wywołuje `SyncWithShipment`; `Delivered` może wymusić `Completed`, agent+vehicle `Ready`, exception/completed nie są nadpisywane przez zwykły sync. | `ShipmentOpsStates.HandoverState` | potwierdzone |
| 6 | UI notification | Handover exception, retry i SLA escalation tworzą manual notification. | Notification API | potwierdzone jako efekt UI |
| 7 | Ryzyko | `ShipmentOpsQueueService.update()` po błędzie PUT zwraca lokalny stan `next`. | UI może pokazać sukces niezapisany w SQL | potwierdzone |

## Proces: Delivery Attempts

| Krok | Warstwa | Działanie | Dane | Status |
|---:|---|---|---|---|
| 1 | UI | `Log Attempt` dostępny dla `Admin`, `Logistics`, `Agent`. | reason, outcome | potwierdzone |
| 2 | Frontend service | `ShipmentDeliveryAttemptsService.add` tworzy `ShipmentDeliveryAttempt`. | `attemptId`, `shipmentId`, `reason`, `outcome`, `createdAtUtc`, `createdByRole` | potwierdzone |
| 3 | Persistence | Próba jest zapisana tylko do `window.localStorage` pod `scp.shipment-delivery-attempts.v1`. | brak tabeli SQL | potwierdzone |
| 4 | Retry | Wybrane outcome mogą automatycznie zaplanować retry na następny dzień przez ops-state. | `ShipmentOpsStates` | potwierdzone |
| 5 | Ryzyko | Błędy localStorage są ignorowane, próby nie są współdzielone i nie mają audytu backendowego. | brak API | potwierdzone |

## Proces: Order Tracking

| Krok | Warstwa | Działanie | Dane | Status |
|---:|---|---|---|---|
| 1 | UI routing | `/orders/:id/tracking` dopuszcza `Admin`, `Dealer`, `Logistics`, `Agent`. | JWT | potwierdzone |
| 2 | UI | Komponent równolegle ładuje order i listę shipmentów. | `OrderDto`, `ShipmentDto[]` | potwierdzone |
| 3 | Order API | `GET /orders/api/orders/{id}` ma data scope w OrderService; Agent zwykle dostaje brak order details. | `Orders` | potwierdzone |
| 4 | Logistics API | Dealer używa `/my`, Agent `/assigned`, Admin/Logistics `/shipments`. | `Shipments`, `ShipmentEvents` | potwierdzone |
| 5 | UI filtering | Komponent filtruje `allShipments` po `shipment.orderId === id()`. | `Shipments.OrderId` | potwierdzone |
| 6 | Agent actions | Agent może accept/reject i ustawić `OutForDelivery`/`Delivered` z poziomu tracking. | te same endpointy Logistics | potwierdzone |
| 7 | Ryzyko | Brak endpointu serwerowego po `orderId`; Admin/Logistics pobiera pełną listę shipmentów do przeglądarki. | koszt i nadmiar danych | potwierdzone |
| 8 | Ryzyko | Tracking agent actions nie sprawdzają `vehicleNumber`, backend może odrzucić request. | rozjazd UI/backend | potwierdzone |

## Outbox I Integracje

| Event | Kiedy powstaje | Payload krytyczny | Konsument / efekt | Status |
|---|---|---|---|---|
| `ShipmentCreated` | tworzenie shipmentu | `ShipmentId`, `OrderId`, `DealerId`, `ShipmentNumber`, `Status` | RabbitMQ `logistics.shipmentcreated` | potwierdzone |
| `ShipmentAssigned` | assign agent | `ShipmentId`, `OrderId`, `DealerId`, `AssignedAgentId`, decision/status | Notification i inne integracje | potwierdzone |
| `ShipmentAssignmentAccepted` | agent accept | `AssignedAgentId`, decision | Notification email dla assignment decision | potwierdzone |
| `ShipmentAssignmentRejected` | agent reject | `rejectedAgentId`, reason | Notification email dla assignment decision | potwierdzone |
| `ShipmentVehicleAssigned` | assign vehicle | `VehicleNumber`, status | operacyjne integracje | potwierdzone |
| `ShipmentStatusUpdated` | update status | `Status`, note | tracking/notification | potwierdzone |
| `ShipmentAgentRated` | dealer rating | `AssignedAgentId`, `RecipientUserId`, rating, comment | notification do agenta | potwierdzone |

Dispatcher publikuje pending outbox do exchange `supplychain.events` z routing key `logistics.{eventType.ToLowerInvariant()}`. Po sukcesie ustawia `Published`, po 5 próbach `Failed`.

## Walidatory Backendu Logistyki (FluentValidation)

Plik: `services/LogisticsTracking/LogisticsTracking.Application/Validation/LogisticsValidators.cs`

| Walidator | Reguły | Powiązany endpoint |
|---|---|---|
| `CreateShipmentRequestValidator` | `OrderId`/`DealerId`: NotEmpty; `DeliveryAddress`: NotEmpty, max 500; `City`: NotEmpty, max 100; `State`: NotEmpty, max 100; `PostalCode`: NotEmpty, max 12 | `POST /logistics/api/logistics/shipments` |
| `AssignAgentRequestValidator` | `AgentId`: NotEmpty | `PUT .../assign-agent` |
| `AssignVehicleRequestValidator` | `VehicleNumber`: NotEmpty, min 5, max 32; regex `^[A-Za-z0-9][A-Za-z0-9\\- ]{4,31}$` (tylko litery, cyfry, spacje, myślniki) | `PUT .../assign-vehicle` |
| `RejectAssignmentRequestValidator` | `Reason`: NotEmpty, MaximumLength(500) | `PUT .../assignment/reject` |
| `RateDeliveryAgentRequestValidator` | `Rating`: InclusiveBetween(1, 5); `Comment`: MaximumLength(500) gdy niepuste | `PUT .../agent-rating` |
| `UpdateShipmentStatusRequestValidator` | `Note`: NotEmpty, MaximumLength(500) | `PUT .../status` |

## Kryteria Akceptacji Dokumentacyjnej

| Kryterium | Status |
|---|---|
| Route UI ma komponent, guardy i role | spełnione |
| Każda akcja ma endpoint, DTO, role i handler | spełnione |
| Każde pole UI ma tabelę/kolumnę albo jawny brak kolumny | spełnione |
| Proces pokazuje UI -> API -> logika -> DB -> outbox/testy | spełnione |
| Luki są jawne i nie są naprawiane w kodzie | spełnione |
