# AOS Shipment Detail I Order Tracking

Identyfikator: `AOS-SHIPMENT-DETAIL`
Status: `potwierdzone` dla śladu kodowego; `potwierdzone jako ryzyko` dla rozjazdów UI/API, localStorage i migracji.
Zakres: route `/shipments/:id`, route kontekstowy `/orders/:id/tracking`, szczegół przesyłki, tracking, assignment agenta, status dostawy, ops-state, retry, handover, ocena agenta i chatbot logistyczny.

## Cel Biznesowy

Pion logistyczny pozwala rolom operacyjnym i dealerowi śledzić przesyłkę od utworzenia do dostarczenia. `ShipmentDetailComponent` jest ekranem operacyjnym dla pojedynczej przesyłki, a `OrderTrackingComponent` jest widokiem agregującym status zamówienia i powiązane shipmenty. Proces obejmuje przypisanie agenta, decyzję agenta, przypisanie pojazdu, zmianę statusu, rejestrowanie zdarzeń, obsługę retry/handover, eskalację SLA, ocenę agenta po dostawie i pytania do chatbota logistycznego.

## Role I Dostęp

| Warstwa | Reguła | Status | Źródło |
|---|---|---|---|
| Angular shell | parent route wymaga `authGuard` | potwierdzone | `app.routes.ts:29-32` |
| Route shipment detail | `/shipments/:id`, `roleGuard`, role `Admin`, `Logistics`, `Agent`, `Dealer` | potwierdzone | `app.routes.ts:109-112` |
| Route order tracking | `/orders/:id/tracking`, `roleGuard`, role `Admin`, `Dealer`, `Logistics`, `Agent` | potwierdzone | `app.routes.ts:89-92` |
| Odczyt shipment detail | `GET /logistics/api/logistics/shipments/{id}`; backend `Admin`, `Logistics`, `Agent`, `Dealer` | potwierdzone | `logistics-api.service.ts:28-30`, `ShipmentsController.cs:27-58` |
| Data scope shipment detail | Dealer widzi tylko `shipment.DealerId == userId`; Agent tylko `shipment.AssignedAgentId == userId`; brak dostępu maskowany jako `404` | potwierdzone | `ShipmentsController.cs:40-55` |
| Assignment accept/reject | tylko przypisany `Agent`; backend sprawdza `AssignedAgentId == agentId` | potwierdzone | `ShipmentsController.cs:107-122`, `LogisticsService.cs:111-156` |
| Assign agent/vehicle | `Admin`, `Logistics` | potwierdzone | `ShipmentsController.cs:98-103`, `ShipmentsController.cs:145-150` |
| Update status | `Admin`, `Logistics`, `Agent`; Agent musi być przypisany i mieć accepted assignment | potwierdzone | `ShipmentsController.cs:154-175` |
| Ops-state GET/batch | `Admin`, `Logistics`, `Agent`, `Dealer` z data scope dla Agent/Dealer | potwierdzone | `ShipmentsController.cs:178-250` |
| Ops-state PUT | tylko `Admin`, `Logistics` | potwierdzone | `ShipmentsController.cs:254-261` |
| Chatbot | UI: `Admin`, `Logistics`, `Agent`, `Dealer`; backend dodatkowo dopuszcza `Warehouse` | konflikt potwierdzony | `shipment-detail.component.ts:156`, `ShipmentsController.cs:264-275` |

## UI: Pola, Stany I Akcje

| Element UI | Dane / akcja | Ślad danych | Status |
|---|---|---|---|
| Header shipment | numer shipmentu, status, akcje kontekstowe | `ShipmentDto.ShipmentNumber`, `ShipmentDto.Status` -> `Shipments.ShipmentNumber`, `Shipments.Status` | potwierdzone |
| Link order | Agent prowadzi do `/orders/{orderId}/tracking`, pozostali do `/orders/{orderId}` | `ShipmentDto.OrderId` -> `Shipments.OrderId`; relacja logiczna do Order DB | potwierdzone |
| Summary | status, agent, assignment, vehicle, ETA, SLA, adres | `ShipmentDto`, `ShipmentEtaService` | potwierdzone |
| Tracking events | oś czasu zdarzeń shipmentu | `ShipmentDto.Events[]` -> `ShipmentEvents` | potwierdzone |
| Accept Assignment | przycisk dla przypisanego Agenta i statusu `Pending` | `PUT .../assignment/accept` -> `Shipments.AssignmentDecisionStatus`, `ShipmentEvents`, `OutboxMessages` | potwierdzone |
| Reject Assignment | dialog z powodem, max 500 w UI/backend | `PUT .../assignment/reject` -> `Shipments.AssignmentDecisionReason`, reset `AssignedAgentId`, event | potwierdzone |
| Assign Agent | wybór z aktywnych agentów albo ręczny UUID | `PUT .../assign-agent` -> `Shipments.AssignedAgentId`, `AssignmentDecisionStatus=Pending` | potwierdzone; brak backendowej weryfikacji Identity |
| Assign Vehicle | numer pojazdu, walidacja formatu | `PUT .../assign-vehicle` -> `Shipments.VehicleNumber` | potwierdzone |
| Update Status | dialog statusu i notatki | `PUT .../status` -> `Shipments.Status`, `DeliveredAtUtc`, `ShipmentEvents` | potwierdzone |
| Mark Out For Delivery | szybka akcja Agenta | `UpdateShipmentStatusRequest.Status=OutForDelivery` | potwierdzone |
| Approve Delivery | szybka akcja Agenta | `UpdateShipmentStatusRequest.Status=Delivered`; dodatkowo UI aktualizuje ops-state na completed | potwierdzone |
| Handover/Retry card | `handoverState`, wyjątek, retry, terminy retry | `ShipmentOpsStateDto` -> `ShipmentOpsStates` | potwierdzone |
| Raise Handover Exception | zapis exception i manual notification | `PUT .../ops-state`; `POST /notifications/api/notifications/manual` | potwierdzone |
| Schedule Retry | zapis retry i manual notification | `PUT .../ops-state`; `POST /notifications/api/notifications/manual` | potwierdzone |
| Mark Handover Complete | zmiana `handoverState=completed` | `PUT .../ops-state` -> `ShipmentOpsStates.HandoverState` | potwierdzone |
| Log Attempt | lokalna próba dostawy | `localStorage` klucz `scp.shipment-delivery-attempts.v1`; opcjonalnie retry przez ops-state | potwierdzone jako local-only |
| Rate Delivery Agent | Dealer po `Delivered` i z przypisanym agentem | `PUT .../agent-rating` -> rating w `Shipments` i event | potwierdzone |
| Logistics Chatbot | prompt, odpowiedź, źródła, sugestie | `POST .../chatbot/ask`; dane role-scoped z LogisticsTracking | potwierdzone |
| Order Tracking KPIs | liczba shipmentów, zdarzeń, latest update, delivery health | `OrderDto`, `ShipmentDto[]`; filtrowanie po `shipment.orderId === id()` w Angular | potwierdzone |

## End-To-End

| Krok | Frontend | Backend / proces | Dane | Status |
|---:|---|---|---|---|
| 1 | Route `/shipments/:id` ładuje `ShipmentDetailComponent` | `roleGuard` dopuszcza `Admin`, `Logistics`, `Agent`, `Dealer` | JWT | potwierdzone |
| 2 | `loadShipment()` wywołuje `getShipmentById(id)` | `GET api/logistics/shipments/{shipmentId}` | `Shipments`, `ShipmentEvents` | potwierdzone |
| 3 | Kontroler sprawdza data scope dla Dealer/Agent | Dealer po `DealerId`, Agent po `AssignedAgentId` | `Shipments.DealerId`, `Shipments.AssignedAgentId` | potwierdzone |
| 4 | UI synchronizuje ops-state | `ShipmentOpsQueueService.get()` -> `GET .../ops-state` | `ShipmentOpsStates` albo default z kontekstu | potwierdzone |
| 5 | Operator przypisuje agenta albo pojazd | `AssignAgentCommand`, `AssignVehicleCommand` | `Shipments`, `ShipmentEvents`, `OutboxMessages`, `ShipmentOpsStates` | potwierdzone |
| 6 | Agent akceptuje lub odrzuca assignment | `AcceptAssignmentCommand`, `RejectAssignmentCommand` | `AssignmentDecisionStatus`, `AssignmentDecisionReason`, event, outbox | potwierdzone |
| 7 | Agent/Admin/Logistics zmienia status | `UpdateShipmentStatusCommand` | `Shipments.Status`, `DeliveredAtUtc`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | potwierdzone |
| 8 | Dealer ocenia agenta po dostawie | `RateDeliveryAgentCommand` | rating fields w `Shipments`, `ShipmentEvents`, `OutboxMessages` | potwierdzone |
| 9 | Admin/Logistics obsługuje handover/retry | `UpsertShipmentOpsStateCommand` | `ShipmentOpsStates`; notification manual jako osobny efekt UI | potwierdzone |
| 10 | `/orders/:id/tracking` agreguje order i shipmenty | `GET /orders/{id}` plus lista shipmentów per rola; filtr klienta po `OrderId` | Order DB + LogisticsTracking DB | potwierdzone |

## API I Kontrakty

Pełny kontrakt jest w `AI_Documentation/04_API/API_SHIPMENT_DETAIL.md`.

| Akcja | Endpoint gateway | DTO | Role backend | Status |
|---|---|---|---|---|
| Load shipment | `GET /logistics/api/logistics/shipments/{id}` | response `ShipmentDto` | `Admin`, `Logistics`, `Agent`, `Dealer` + data scope | potwierdzone |
| Accept assignment | `PUT /logistics/api/logistics/shipments/{id}/assignment/accept` | pusty body | `Agent` + przypisanie | potwierdzone |
| Reject assignment | `PUT /logistics/api/logistics/shipments/{id}/assignment/reject` | `RejectAssignmentRequest` | `Agent` + przypisanie | potwierdzone |
| Assign agent | `PUT /logistics/api/logistics/shipments/{id}/assign-agent` | `AssignAgentRequest` | `Admin`, `Logistics` | potwierdzone |
| Assign vehicle | `PUT /logistics/api/logistics/shipments/{id}/assign-vehicle` | `AssignVehicleRequest` | `Admin`, `Logistics` | potwierdzone |
| Update status | `PUT /logistics/api/logistics/shipments/{id}/status` | `UpdateShipmentStatusRequest` | `Admin`, `Logistics`, `Agent` + warunki runtime | potwierdzone |
| Rate agent | `PUT /logistics/api/logistics/shipments/{id}/agent-rating` | `RateDeliveryAgentRequest` | `Dealer` + owner check | potwierdzone |
| Ops state read | `GET /logistics/api/logistics/shipments/{id}/ops-state` | response `ShipmentOpsStateDto` | `Admin`, `Logistics`, `Agent`, `Dealer` + data scope | potwierdzone |
| Ops state upsert | `PUT /logistics/api/logistics/shipments/{id}/ops-state` | `UpsertShipmentOpsStateRequest` | `Admin`, `Logistics` | potwierdzone |
| Ops state batch | `POST /logistics/api/logistics/shipments/ops-states/batch` | `GetShipmentOpsStatesRequest` | `Admin`, `Logistics`, `Agent`, `Dealer` + filtrowanie allowed IDs | potwierdzone |
| Chatbot | `POST /logistics/api/logistics/shipments/chatbot/ask` | `LogisticsChatbotRequest` | `Admin`, `Logistics`, `Agent`, `Dealer`, `Warehouse` | konflikt UI/backend |
| Order tracking order read | `GET /orders/api/orders/{id}` | response `OrderDto` | `[Authorize]` + OrderService scope | potwierdzone |

## Walidacje I Błędy

| Warstwa | Walidacja / błąd | Zachowanie | Status |
|---|---|---|---|
| UI | `assignAgent()` wymaga poprawnego UUID | toast, brak requestu | potwierdzone |
| Backend | `AssignAgentRequest.AgentId` `NotEmpty()` | `400 validation.failed` przy pustym GUID | potwierdzone |
| UI/Backend | `RejectAssignmentRequest.Reason` wymagany, max 500 | UI wymaga trim; backend `NotEmpty().MaximumLength(500)` | potwierdzone |
| UI/Backend | `AssignVehicleRequest.VehicleNumber` 5-32, litery/cyfry/spacje/myślniki | UI i backend walidują format; backend normalizuje uppercase | potwierdzone |
| Backend | `UpdateShipmentStatusRequest.Note` wymagany, max 500 | `400 validation.failed` | potwierdzone |
| Backend | Agent nie może zmienić statusu bez accepted assignment | `409` z message kontrolera | potwierdzone |
| Backend | Agent dla `InTransit`, `OutForDelivery`, `Delivered` musi mieć pojazd | `InvalidOperationException` przez middleware | potwierdzone |
| Domena | `Delivered` wymaga pojazdu | wyjątek domenowy | potwierdzone |
| Domena | zakończone shipmenty `Delivered`/`Returned` nie mogą być aktualizowane | wyjątek domenowy | potwierdzone |
| Domena | rating tylko po `Delivered`, rating 1-5, komentarz max 500 | wyjątek domenowy albo walidacja | potwierdzone |
| Ops queue | `ShipmentOpsQueueService.update()` przy błędzie PUT zwraca lokalny stan | UI może pokazać stan niezapisany w DB | potwierdzone jako ryzyko |
| Order tracking | Agent może wejść na `/orders/:id/tracking`, ale `GET /orders/{id}` może zwrócić `404` | UI pokazuje komunikat, tracking shipmentów działa dalej | potwierdzone |

## Model Danych

Pełny lineage jest w `AI_Documentation/03_MODEL_DANYCH/MODEL_DANYCH_SHIPMENT_DETAIL.md`.

| Pole / akcja | Tabela | Kolumna | R/W | Status |
|---|---|---|---|---|
| Shipment header | `Shipments` | `ShipmentId`, `ShipmentNumber`, `OrderId`, `DealerId`, `Status` | R | potwierdzone |
| Adres dostawy | `Shipments` | `DeliveryAddress`, `City`, `State`, `PostalCode` | R | potwierdzone |
| Assignment | `Shipments` | `AssignedAgentId`, `AssignmentDecisionStatus`, `AssignmentDecisionReason`, `AssignmentDecisionAtUtc` | R/W | potwierdzone |
| Pojazd | `Shipments` | `VehicleNumber` | R/W | potwierdzone |
| Dostawa | `Shipments` | `Status`, `DeliveredAtUtc` | R/W | potwierdzone |
| Ocena agenta | `Shipments` | `DeliveryAgentRating`, `DeliveryAgentRatingComment`, `DeliveryAgentRatedAtUtc`, `DeliveryAgentRatedByUserId` | R/W | potwierdzone |
| Timeline | `ShipmentEvents` | `ShipmentEventId`, `ShipmentId`, `Status`, `Note`, `UpdatedByUserId`, `UpdatedByRole`, `CreatedAtUtc` | R/W | potwierdzone |
| Ops-state | `ShipmentOpsStates` | `HandoverState`, `HandoverExceptionReason`, `RetryRequired`, `RetryCount`, `RetryReason`, daty retry | R/W | potwierdzone |
| Outbox | `OutboxMessages` w Logistics DB | `EventType`, `Payload`, `Status`, `RetryCount`, `Error` | W backend | potwierdzone |
| Delivery attempts | brak tabeli SQL | brak | localStorage | potwierdzone jako local-only |
| ETA/SLA | brak tabeli SQL | brak | wyliczane z `CreatedAtUtc` i statusu | potwierdzone |
| Order tracking | `Orders` plus `Shipments` | `Orders.OrderId`, `Shipments.OrderId` | R | potwierdzone; relacja logiczna między DB |

## Testy I Luki

Pełna macierz jest w `AI_Documentation/08_TESTY/MACIERZ_TESTOW_SHIPMENT_DETAIL.md`.

| Obszar | Istniejące pokrycie | Luka | Priorytet |
|---|---|---|---|
| Domena Shipment | testy create, assign agent, assign vehicle, delivered, rating | brak testów accept/reject assignment i ops-state | P1 |
| ShipmentsController | brak znalezionych testów API auth/data scope | ryzyko regresji ról i maskowania `404` | P0 |
| LogisticsService outbox | brak testów payloadów outbox | eventy logistyczne bez ochrony kontraktu | P1 |
| Order tracking | brak testów Angular | brak ochrony filtrowania `shipment.orderId === id()` | P1 |
| Delivery attempts | brak testów | localStorage może znikać albo nie synchronizować retry | P1 |
| EF vs SQL | brak testu migracji/skryptu | skrypt SQL jest nieaktualny względem EF | P0 |

## Ryzyka

| Priorytet | Ryzyko | Dowód | Skutek | Status |
|---|---|---|---|---|
| P0 | `scripts/migrations/LogisticsTracking.sql` jest nieaktualny względem EF modelu runtime. | `LogisticsTracking.sql` kończy na `20260328174620_InitialCreate`; EF snapshot ma `VehicleNumber`, assignment decision, rating i `ShipmentOpsStates` | wdrożenie z SQL może nie mieć wymaganych kolumn/tabel | potwierdzone |
| P0 | Migracje EF mogą próbować dodać te same kolumny `AssignmentDecision*` dwa razy. | `20260411063723_SyncPendingModelChanges.cs`, `20260411123000_AddShipmentAssignmentDecision.cs` | ryzyko błędu migracji na czystej lub częściowej bazie | potwierdzone |
| P0 | Delivery attempts nie są autorytatywnym zapisem backendowym. | `ShipmentDeliveryAttemptsService` zapisuje tylko `localStorage` | brak audytu, brak współdzielenia między użytkownikami | potwierdzone |
| P1 | `ShipmentOpsQueueService.update()` maskuje błąd zapisu ops-state. | `catchError(() => of(next))` po PUT | UI może pokazać stan, którego nie ma w SQL | potwierdzone |
| P1 | `/orders/:id/tracking` pobiera wszystkie shipmenty dla Admin/Logistics i filtruje w przeglądarce. | `OrderTrackingComponent.loadShipments()` | koszt i ekspozycja nadmiarowych danych po stronie klienta | potwierdzone |
| P1 | `OrderTrackingComponent` nie sprawdza `vehicleNumber` przy szybkich akcjach Agenta. | `canMarkOutForDelivery`, `canApproveDelivery`; backend wymaga pojazdu | aktywny przycisk może kończyć się błędem API | potwierdzone |
| P1 | Backend assign agent nie potwierdza, że `AgentId` istnieje i jest aktywnym agentem. | validator sprawdza tylko niepusty GUID | możliwe przypisanie niepoprawnego użytkownika | potwierdzone |
| P1 | Chatbot ma szerszą rolę backendową niż UI. | backend dopuszcza `Warehouse`, UI nie | niespójna macierz dostępu | potwierdzone |

## Źródła Kodowe

| Obszar | Źródło |
|---|---|
| Routing Angular | `supply-chain-frontend/src/app/app.routes.ts:89-112` |
| Shipment detail TS/HTML | `supply-chain-frontend/src/app/features/logistics/shipment-detail/shipment-detail.component.ts`, `shipment-detail.component.html` |
| Order tracking TS/HTML | `supply-chain-frontend/src/app/features/orders/order-tracking/order-tracking.component.ts`, `order-tracking.component.html` |
| Frontend Logistics API | `supply-chain-frontend/src/app/core/api/logistics-api.service.ts:22-82` |
| Frontend models | `supply-chain-frontend/src/app/core/models/logistics.models.ts:3-111` |
| Kontroler Logistics | `services/LogisticsTracking/LogisticsTracking.API/Controllers/ShipmentsController.cs:12-297` |
| DTO i walidatory | `services/LogisticsTracking/LogisticsTracking.Application/DTOs/LogisticsDtos.cs`, `Validation/LogisticsValidators.cs` |
| Serwis aplikacyjny | `services/LogisticsTracking/LogisticsTracking.Application/Services/LogisticsService.cs` |
| Encje i DbContext | `Shipment.cs`, `ShipmentEvent.cs`, `ShipmentOpsState.cs`, `LogisticsTrackingDbContext.cs` |
| Testy | `tests/LogisticsTracking.Domain.Tests/UnitTest1.cs` |
