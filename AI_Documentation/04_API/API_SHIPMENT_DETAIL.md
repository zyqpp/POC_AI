# API: Shipment Detail I Order Tracking

Status: `potwierdzone` na podstawie kontrolerów .NET, serwisów Angular, DTO, walidatorów i gateway.
Zakres: endpointy używane przez `/shipments/:id` oraz przez `/orders/:id/tracking`.

## Źródła

| Obszar | Źródło |
|---|---|
| Angular Logistics API | `supply-chain-frontend/src/app/core/api/logistics-api.service.ts:22-82` |
| Angular Order API | `supply-chain-frontend/src/app/core/api/order-api.service.ts:13-42` |
| Angular modele logistics | `supply-chain-frontend/src/app/core/models/logistics.models.ts:3-111` |
| Kontroler Logistics | `services/LogisticsTracking/LogisticsTracking.API/Controllers/ShipmentsController.cs:12-297` |
| DTO backend Logistics | `services/LogisticsTracking/LogisticsTracking.Application/DTOs/LogisticsDtos.cs:5-88` |
| Walidatory Logistics | `services/LogisticsTracking/LogisticsTracking.Application/Validation/LogisticsValidators.cs:6-70` |
| Komendy i zapytania | `services/LogisticsTracking/LogisticsTracking.Application/Features/Shipments` |
| Serwis Logistics | `services/LogisticsTracking/LogisticsTracking.Application/Services/LogisticsService.cs` |
| Gateway Ocelot | `gateway/OcelotGateway/ocelot.json:523-581` |

## Gateway

| Warstwa | Reguła | Status |
|---|---|---|
| Frontend base | `LogisticsApiService.base = /logistics/api/logistics/shipments` | potwierdzone |
| Ocelot upstream | `/logistics/{everything}` dla GET/POST/PUT/PATCH/DELETE | potwierdzone |
| Ocelot downstream | `/{everything}` do `localhost:8004` | potwierdzone |
| Auth gateway | `AuthenticationProviderKey = Bearer` | potwierdzone |
| Route backend | `ShipmentsController` ma `[Route("api/logistics/shipments")]` | potwierdzone |

## Endpointy Używane Przez `/shipments/:id`

| Akcja UI | Frontend | Endpoint gateway | Endpoint backend | Role / warunki | DTO | Backend | Statusy / błędy | Status |
|---|---|---|---|---|---|---|---|---|
| Wczytaj shipment | `getShipmentById(id)` | `GET /logistics/api/logistics/shipments/{id}` | `GET api/logistics/shipments/{shipmentId:guid}` | `Admin`, `Logistics`, `Agent`, `Dealer`; Agent/Dealer data scope | response `ShipmentDto` | `GetShipmentQuery -> LogisticsService.GetShipmentAsync` | `200`, `401`, `404` | potwierdzone |
| Assign agent | `assignAgent(id, { agentId })` | `PUT /logistics/api/logistics/shipments/{id}/assign-agent` | `PUT api/logistics/shipments/{shipmentId:guid}/assign-agent` | `Admin`, `Logistics` | `AssignAgentRequest` | `AssignAgentCommand -> AssignAgentAsync` | `200`, `401`, `403`, `404`, `400 validation` | potwierdzone |
| Accept assignment | `acceptAssignment(id)` | `PUT /logistics/api/logistics/shipments/{id}/assignment/accept` | `PUT api/logistics/shipments/{shipmentId:guid}/assignment/accept` | `Agent`; musi być przypisany | pusty body | `AcceptAssignmentCommand -> AcceptAssignmentAsync` | `200`, `401`, `403`, `404`, `400/409 business` | potwierdzone |
| Reject assignment | `rejectAssignment(id, { reason })` | `PUT /logistics/api/logistics/shipments/{id}/assignment/reject` | `PUT api/logistics/shipments/{shipmentId:guid}/assignment/reject` | `Agent`; musi być przypisany | `RejectAssignmentRequest` | `RejectAssignmentCommand -> RejectAssignmentAsync` | `200`, `401`, `403`, `404`, `400 validation`, `400/409 business` | potwierdzone |
| Assign vehicle | `assignVehicle(id, { vehicleNumber })` | `PUT /logistics/api/logistics/shipments/{id}/assign-vehicle` | `PUT api/logistics/shipments/{shipmentId:guid}/assign-vehicle` | `Admin`, `Logistics` | `AssignVehicleRequest` | `AssignVehicleCommand -> AssignVehicleAsync` | `200`, `401`, `403`, `404`, `400 validation` | potwierdzone |
| Update status | `updateStatus(id, { status, note })` | `PUT /logistics/api/logistics/shipments/{id}/status` | `PUT api/logistics/shipments/{shipmentId:guid}/status` | `Admin`, `Logistics`, `Agent`; Agent musi być przypisany i accepted | `UpdateShipmentStatusRequest` | `UpdateShipmentStatusCommand -> UpdateShipmentStatusAsync` | `200`, `401`, `403`, `404`, `400 validation`, `409 assignment not accepted`, business errors | potwierdzone |
| Rate delivery agent | `rateDeliveryAgent(id, { rating, comment })` | `PUT /logistics/api/logistics/shipments/{id}/agent-rating` | `PUT api/logistics/shipments/{shipmentId:guid}/agent-rating` | `Dealer`; owner check `shipment.DealerId == dealerId` | `RateDeliveryAgentRequest` | `RateDeliveryAgentCommand -> RateDeliveryAgentAsync` | `200`, `401`, `403`, `404`, `400 validation`, business errors | potwierdzone |
| Read ops state | `getShipmentOpsState(id)` | `GET /logistics/api/logistics/shipments/{id}/ops-state` | `GET api/logistics/shipments/{shipmentId:guid}/ops-state` | `Admin`, `Logistics`, `Agent`, `Dealer`; Agent/Dealer data scope | response `ShipmentOpsStateDto` | `GetShipmentOpsStateQuery -> GetShipmentOpsStateAsync` | `200`, `401`, `403`, `404` | potwierdzone |
| Upsert ops state | `upsertShipmentOpsState(id, req)` | `PUT /logistics/api/logistics/shipments/{id}/ops-state` | `PUT api/logistics/shipments/{shipmentId:guid}/ops-state` | `Admin`, `Logistics` | `UpsertShipmentOpsStateRequest` | `UpsertShipmentOpsStateCommand -> UpsertShipmentOpsStateAsync` | `200`, `401`, `403`, `404` | potwierdzone |
| Chatbot | `askChatbot({ message })` | `POST /logistics/api/logistics/shipments/chatbot/ask` | `POST api/logistics/shipments/chatbot/ask` | `Admin`, `Logistics`, `Agent`, `Dealer`, `Warehouse`; UI bez Warehouse | `LogisticsChatbotRequest` | `AskLogisticsChatbotQuery -> AskChatbotAsync` | `200`, `400 Message is required`, `401`, `403` | konflikt UI/backend |
| Manual notification | `notificationApi.createManual(req)` | `POST /notifications/api/notifications/manual` | Notification API | wywoływane z UI przy handover/retry/escalate | `CreateManualNotificationRequest` | poza LogisticsTracking | zależne od Notification API | potwierdzone jako efekt uboczny UI |

## Endpointy Używane Przez `/orders/:id/tracking`

| Akcja UI | Frontend | Endpoint gateway | Endpoint backend | Role / warunki | DTO | Backend | Status |
|---|---|---|---|---|---|---|---|
| Wczytaj order | `getOrderById(id)` | `GET /orders/api/orders/{id}` | `GET api/orders/{id:guid}` | `[Authorize]`; OrderService dopuszcza Admin/Warehouse/Logistics albo Dealera właściciela | response `OrderDto` | `GetOrderQuery -> OrderService.GetOrderAsync` | potwierdzone |
| Shipmenty dealera | `getMyShipments()` | `GET /logistics/api/logistics/shipments/my` | `GET api/logistics/shipments/my` | `Dealer` | response `ShipmentDto[]` | `GetDealerShipmentsQuery` | potwierdzone |
| Shipmenty agenta | `getAssignedShipments()` | `GET /logistics/api/logistics/shipments/assigned` | `GET api/logistics/shipments/assigned` | `Agent` | response `ShipmentDto[]` | `GetAgentShipmentsQuery` | potwierdzone |
| Wszystkie shipmenty | `getAllShipments()` | `GET /logistics/api/logistics/shipments` | `GET api/logistics/shipments` | `Admin`, `Logistics` | response `ShipmentDto[]` | `GetAllShipmentsQuery` | potwierdzone |
| Agent delivery approval | `acceptAssignment`, `rejectAssignment`, `updateStatus` | jak w tabeli shipment detail | jak w tabeli shipment detail | Agent przypisany | `RejectAssignmentRequest`, `UpdateShipmentStatusRequest` | LogisticsTracking | potwierdzone |

Nie istnieje osobny endpoint backendowy `/orders/{id}/tracking` ani `shipments?orderId=...`. `OrderTrackingComponent` pobiera listę shipmentów zależnie od roli i filtruje po `shipment.orderId === id()` po stronie klienta.

## DTO

| DTO | Pola | Walidacja | Status |
|---|---|---|---|
| `ShipmentDto` | `ShipmentId`, `OrderId`, `DealerId`, `ShipmentNumber`, adres, `AssignedAgentId`, `VehicleNumber`, assignment decision, rating, `Status`, daty, `Events` | response | potwierdzone |
| `ShipmentEventDto` | `ShipmentEventId`, `Status`, `Note`, `UpdatedByUserId`, `UpdatedByRole`, `CreatedAtUtc` | response | potwierdzone |
| `AssignAgentRequest` | `AgentId` | `NotEmpty()` | potwierdzone |
| `AssignVehicleRequest` | `VehicleNumber` | `NotEmpty`, min 5, max 32, regex znaków | potwierdzone |
| `RejectAssignmentRequest` | `Reason` | `NotEmpty`, max 500 | potwierdzone |
| `RateDeliveryAgentRequest` | `Rating`, `Comment?` | rating 1-5, komentarz max 500 | potwierdzone |
| `UpdateShipmentStatusRequest` | `Status`, `Note` | `Note` required max 500; brak walidatora maszyny statusów | potwierdzone |
| `GetShipmentOpsStatesRequest` | `ShipmentIds` | serwis usuwa `Guid.Empty` i duplikaty | potwierdzone |
| `UpsertShipmentOpsStateRequest` | `HandoverState`, `HandoverExceptionReason`, `RetryRequired`, `RetryCount`, `RetryReason`, daty retry | normalizacja w serwisie; tekst max 300 | potwierdzone |
| `LogisticsChatbotRequest` | `Message` | kontroler blokuje pusty; serwis normalizuje do 500 znaków | potwierdzone |

## Reguły Runtime

| Reguła | Implementacja | Status |
|---|---|---|
| Dealer/Agent nie dostają `403` przy cudzym shipmencie, tylko `404` | `ShipmentsController.GetById`, `GetOpsState`, `GetOpsStatesBatch` | potwierdzone |
| `AcceptAssignmentAsync` i `RejectAssignmentAsync` zwracają false, jeśli shipment nie istnieje albo agent nie jest przypisany | `LogisticsService.cs:115-156` | potwierdzone |
| Assign agent ustawia decision na `Pending`, czyści reason/date i status `Assigned`, jeśli był `Created` | `Shipment.AssignAgent` | potwierdzone |
| Reject assignment czyści `AssignedAgentId`; status wraca do `Created` bez pojazdu albo `Assigned` z pojazdem | `Shipment.RejectAssignment` | potwierdzone |
| Assign vehicle normalizuje uppercase; jeśli status był `Created`, zmienia na `Assigned` | `Shipment.AssignVehicle` | potwierdzone |
| Agent może ustawić status tylko po accepted assignment | kontroler zwraca `Conflict` przed komendą | potwierdzone |
| `Delivered` ustawia `DeliveredAtUtc`; zakończone shipmenty nie mogą być dalej aktualizowane | `Shipment.UpdateStatus` | potwierdzone |
| `ShipmentOpsState` synchronizuje handover: delivered -> completed, agent+vehicle -> ready, inaczej pending, ale nie nadpisuje exception/completed | `ShipmentOpsState.SyncWithShipment` | potwierdzone |
| Outbox jest zapisywany przy create, assign, accept, reject, rate, assign vehicle i status update | `LogisticsService` | potwierdzone |

## Obsługa Błędów

| Typ błędu | Zachowanie | Źródło |
|---|---|---|
| Brak lub zły token | `401` albo `Unauthorized(new { message = "Invalid token." })` | `ShipmentsController.cs:42-45` |
| Brak shipmentu albo brak scope | `404` | `ShipmentsController.cs:35-55` |
| Agent bez accepted assignment przy status update | `409` z komunikatem kontrolera | `ShipmentsController.cs:168-170` |
| Pusty message chatbota | `400` z `Message is required.` | `ShipmentsController.cs:269-272` |
| FluentValidation | obsługa przez middleware API | `LogisticsTracking.API/Program.cs` |
| `InvalidOperationException` domeny | obsługa przez middleware API jako błąd business | `LogisticsTracking.API/Program.cs` |

## Luki API

| Priorytet | Luka | Dowód | Rekomendacja dokumentacyjna |
|---|---|---|---|
| P0 | Brak endpointu `GET shipments by orderId`; `/orders/:id/tracking` pobiera listę i filtruje w Angularze. | `order-tracking.component.ts:374-395` | Wymagać testu wydajności/data exposure albo zaplanować endpoint serwerowy w osobnym zadaniu. |
| P0 | Skrypt SQL Logistics nie odzwierciedla aktualnych endpointów i modelu ops/rating/assignment. | `scripts/migrations/LogisticsTracking.sql`, EF snapshot | Utrzymać EF jako źródło prawdy i opisać rozbieżność w ryzykach. |
| P1 | `AssignAgent` nie potwierdza użytkownika w IdentityAuth. | `AssignAgentRequestValidator` sprawdza tylko GUID | Dodać do backlogu test/kontrakt integracyjny. |
| P1 | `OrderTrackingComponent` może pokazać aktywny status action bez pojazdu. | UI nie sprawdza `vehicleNumber`, backend wymaga pojazdu dla Agenta | Oznaczyć jako rozjazd UI/backend w rolach i testach. |
| P1 | Frontend ops queue maskuje błąd PUT. | `ShipmentOpsQueueService.update()` łapie błąd i zwraca lokalny stan | Test UI powinien odróżniać stan zapisany w API od fallbacku. |
| P1 | Chatbot role matrix różni się między UI i backendem. | UI bez Warehouse, backend z Warehouse | Ujednolicić wymaganie w osobnym zadaniu. |
