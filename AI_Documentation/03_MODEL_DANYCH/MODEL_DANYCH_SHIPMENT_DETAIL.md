# Model Danych: Shipment Detail I Tracking

Status: `potwierdzone` dla tabel i kolumn LogisticsTracking DB; `wniosek z analizy` dla relacji między mikroserwisami; `potwierdzone jako ryzyko` dla rozbieżności EF vs SQL.
Zakres: `/shipments/:id`, `/orders/:id/tracking`, statusy dostawy, assignment, ops-state, retry, rating, outbox i lokalne delivery attempts.

## Źródła

| Obszar | Źródło |
|---|---|
| EF Core mapping | `services/LogisticsTracking/LogisticsTracking.Infrastructure/Persistence/LogisticsTrackingDbContext.cs:7-81` |
| Snapshot EF | `services/LogisticsTracking/LogisticsTracking.Infrastructure/Persistence/Migrations/LogisticsTrackingDbContextModelSnapshot.cs:63-248` |
| Encja shipment | `services/LogisticsTracking/LogisticsTracking.Domain/Entities/Shipment.cs:11-214` |
| Encja event | `services/LogisticsTracking/LogisticsTracking.Domain/Entities/ShipmentEvent.cs:11-29` |
| Encja ops-state | `services/LogisticsTracking/LogisticsTracking.Domain/Entities/ShipmentOpsState.cs:11-113` |
| Repozytorium | `services/LogisticsTracking/LogisticsTracking.Infrastructure/Repositories/ShipmentRepository.cs:17-127` |
| Serwis aplikacyjny | `services/LogisticsTracking/LogisticsTracking.Application/Services/LogisticsService.cs` |
| Skrypt SQL | `scripts/migrations/LogisticsTracking.sql` |

## Tabele I Kolumny LogisticsTracking DB

| Tabela | Kolumna | Typ SQL / ograniczenie | Null | R/W w pionie | Źródło |
|---|---|---|---|---|---|
| `Shipments` | `ShipmentId` | `uniqueidentifier`, PK | nie | odczyt i identyfikacja akcji | `Shipment.cs:11`, snapshot `:65` |
| `Shipments` | `OrderId` | `uniqueidentifier` | nie | odczyt; powiązanie logiczne z Order DB | `Shipment.cs:12`, snapshot `:116` |
| `Shipments` | `DealerId` | `uniqueidentifier`, index z `CreatedAtUtc` | nie | odczyt, data scope Dealera | `Shipment.cs:13`, `LogisticsTrackingDbContext.cs:22` |
| `Shipments` | `ShipmentNumber` | `nvarchar(32)`, unique index | nie | odczyt UI | `LogisticsTrackingDbContext.cs:20-21`, snapshot `:124-148` |
| `Shipments` | `DeliveryAddress` | `nvarchar(500)` | nie | odczyt UI | `LogisticsTrackingDbContext.cs:25`, snapshot `:98-101` |
| `Shipments` | `City` | `nvarchar(100)` | nie | odczyt UI | `LogisticsTrackingDbContext.cs:26`, snapshot `:84-87` |
| `Shipments` | `State` | `nvarchar(100)` | nie | odczyt UI | `LogisticsTrackingDbContext.cs:27`, snapshot `:129-132` |
| `Shipments` | `PostalCode` | `nvarchar(12)` | nie | odczyt UI | `LogisticsTrackingDbContext.cs:28`, snapshot `:119-122` |
| `Shipments` | `AssignedAgentId` | `uniqueidentifier` | tak | odczyt i zapis assign/reject | `Shipment.cs:19`, snapshot `:69-70` |
| `Shipments` | `VehicleNumber` | `nvarchar(32)` | tak | odczyt i zapis assign vehicle | `LogisticsTrackingDbContext.cs:29`, snapshot `:139-141` |
| `Shipments` | `AssignmentDecisionStatus` | `nvarchar(20)`, enum jako string | nie | odczyt i zapis accept/reject/assign | `LogisticsTrackingDbContext.cs:30`, snapshot `:79-82` |
| `Shipments` | `AssignmentDecisionReason` | `nvarchar(500)` | tak | zapis reject, odczyt UI | `LogisticsTrackingDbContext.cs:31`, snapshot `:75-77` |
| `Shipments` | `AssignmentDecisionAtUtc` | `datetime2` | tak | zapis accept/reject | `Shipment.cs:23`, snapshot `:72-73` |
| `Shipments` | `DeliveryAgentRating` | `int` | tak | zapis rating | `Shipment.cs:24`, snapshot `:109-110` |
| `Shipments` | `DeliveryAgentRatingComment` | `nvarchar(500)` | tak | zapis rating comment | `LogisticsTrackingDbContext.cs:34`, snapshot `:112-114` |
| `Shipments` | `DeliveryAgentRatedAtUtc` | `datetime2` | tak | zapis rating timestamp | `Shipment.cs:26`, snapshot `:103-104` |
| `Shipments` | `DeliveryAgentRatedByUserId` | `uniqueidentifier` | tak | zapis dealer rating actor | `Shipment.cs:27`, snapshot `:106-107` |
| `Shipments` | `Status` | `nvarchar(32)`, enum jako string | nie | odczyt i zapis statusów | `LogisticsTrackingDbContext.cs:37`, snapshot `:134-137` |
| `Shipments` | `CreatedAtUtc` | `datetime2`, index | nie | odczyt, sort, ETA | `Shipment.cs:29`, `LogisticsTrackingDbContext.cs:24` |
| `Shipments` | `DeliveredAtUtc` | `datetime2` | tak | zapis przy `Delivered` | `Shipment.cs:30`, snapshot `:95-96` |
| `ShipmentEvents` | `ShipmentEventId` | `uniqueidentifier`, PK | nie | odczyt timeline | `ShipmentEvent.cs:11`, snapshot `:159-161` |
| `ShipmentEvents` | `ShipmentId` | `uniqueidentifier`, FK cascade | nie | relacja do shipmentu | `LogisticsTrackingDbContext.cs:38-41`, snapshot `:171-172` |
| `ShipmentEvents` | `Status` | `nvarchar(32)` | nie | odczyt timeline | `LogisticsTrackingDbContext.cs:48`, snapshot `:174-177` |
| `ShipmentEvents` | `Note` | `nvarchar(500)` | nie | odczyt timeline; zapis przy akcjach | `LogisticsTrackingDbContext.cs:49`, snapshot `:166-169` |
| `ShipmentEvents` | `UpdatedByUserId` | `uniqueidentifier` | nie | audyt aktora | `ShipmentEvent.cs:15`, snapshot `:184-185` |
| `ShipmentEvents` | `UpdatedByRole` | `nvarchar(40)` | nie | audyt roli | `LogisticsTrackingDbContext.cs:50`, snapshot `:179-182` |
| `ShipmentEvents` | `CreatedAtUtc` | `datetime2` | nie | timestamp timeline | `ShipmentEvent.cs:17`, snapshot `:163-164` |
| `ShipmentOpsStates` | `ShipmentId` | `uniqueidentifier`, PK i FK do `Shipments` | nie | odczyt i zapis ops-state | `LogisticsTrackingDbContext.cs:55-66`, snapshot `:196-197` |
| `ShipmentOpsStates` | `HandoverState` | `nvarchar(20)` | nie | odczyt i zapis handover | `LogisticsTrackingDbContext.cs:57`, snapshot `:203-206` |
| `ShipmentOpsStates` | `HandoverExceptionReason` | `nvarchar(300)` | tak | zapis exception reason | `LogisticsTrackingDbContext.cs:58`, snapshot `:199-201` |
| `ShipmentOpsStates` | `RetryRequired` | `bit` | nie | zapis retry flag | `LogisticsTrackingDbContext.cs:59`, snapshot `:221-222` |
| `ShipmentOpsStates` | `RetryCount` | `int` | nie | zapis retry count, clamp 0-99 | `ShipmentOpsState.cs:15`, snapshot `:214-215` |
| `ShipmentOpsStates` | `RetryReason` | `nvarchar(300)` | tak | zapis retry reason | `LogisticsTrackingDbContext.cs:61`, snapshot `:217-219` |
| `ShipmentOpsStates` | `NextRetryAtUtc` | `datetime2` | tak | zapis planowanego retry | `ShipmentOpsState.cs:17`, snapshot `:211-212` |
| `ShipmentOpsStates` | `LastRetryScheduledAtUtc` | `datetime2` | tak | zapis czasu planowania retry | `ShipmentOpsState.cs:18`, snapshot `:208-209` |
| `ShipmentOpsStates` | `UpdatedAtUtc` | `datetime2` | nie | timestamp ops-state | `LogisticsTrackingDbContext.cs:62`, snapshot `:224-225` |
| `OutboxMessages` | `MessageId`, `EventType`, `Payload`, `Status`, `CreatedAtUtc`, `PublishedAtUtc`, `RetryCount`, `Error` | outbox | mieszane | zapis eventów logistycznych | `ShipmentRepository.cs:110-122`, `OutboxMessage.cs` |

## Odczyt Shipment Detail

| Dane UI | Źródło DTO | Encja / tabela | Kolumna | Status |
|---|---|---|---|---|
| Numer przesyłki | `ShipmentDto.ShipmentNumber` | `Shipments` | `ShipmentNumber` | potwierdzone |
| Status | `ShipmentDto.Status` | `Shipments` | `Status` | potwierdzone |
| Order link | `ShipmentDto.OrderId` | `Shipments` | `OrderId` | potwierdzone; relacja logiczna |
| Dealer scope | `ShipmentDto.DealerId` | `Shipments` | `DealerId` | potwierdzone |
| Adres | `DeliveryAddress`, `City`, `State`, `PostalCode` | `Shipments` | adresowe | potwierdzone |
| Agent | `AssignedAgentId` | `Shipments` | `AssignedAgentId` | potwierdzone |
| Assignment | `AssignmentDecisionStatus`, `AssignmentDecisionReason`, `AssignmentDecisionAtUtc` | `Shipments` | assignment columns | potwierdzone |
| Pojazd | `VehicleNumber` | `Shipments` | `VehicleNumber` | potwierdzone |
| Rating | rating fields | `Shipments` | `DeliveryAgentRating*` | potwierdzone |
| Timeline | `ShipmentDto.Events[]` | `ShipmentEvents` | event columns | potwierdzone |
| Ops card | `ShipmentOpsStateDto` | `ShipmentOpsStates` | ops columns | potwierdzone |
| ETA/SLA | `ShipmentEtaService.getEtaInfo` | brak tabeli | brak; wyliczane z `CreatedAtUtc` i statusu | potwierdzone |
| Delivery attempts | `ShipmentDeliveryAttempt[]` | brak tabeli | localStorage | potwierdzone jako local-only |

## Zapisy Per Akcja

| Akcja | Tabele zapisywane | Kolumny | Integracje / efekty uboczne | Status |
|---|---|---|---|---|
| `CreateShipment` | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | `Shipments.*`, event `Created`, default ops-state, `ShipmentCreated` | RabbitMQ przez outbox dispatcher | potwierdzone |
| `Assign Agent` | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | `AssignedAgentId`, `AssignmentDecisionStatus=Pending`, event, `ShipmentAssigned` | brak weryfikacji IdentityAuth po stronie backendu | potwierdzone |
| `Accept Assignment` | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | `AssignmentDecisionStatus=Accepted`, `AssignmentDecisionAtUtc`, event, `ShipmentAssignmentAccepted` | Notification może konsumować event | potwierdzone |
| `Reject Assignment` | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | `AssignedAgentId=null`, `AssignmentDecisionStatus=Rejected`, reason/date, event, `ShipmentAssignmentRejected` | Notification może konsumować event | potwierdzone |
| `Assign Vehicle` | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | `VehicleNumber`, ewentualnie `Status=Assigned`, event, `ShipmentVehicleAssigned` | RabbitMQ przez outbox | potwierdzone |
| `Update Status` | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | `Status`, `DeliveredAtUtc` dla delivered, event, `ShipmentStatusUpdated` | RabbitMQ przez outbox | potwierdzone |
| `Rate Delivery Agent` | `Shipments`, `ShipmentEvents`, `OutboxMessages` | rating fields, rating event, `ShipmentAgentRated` | event ma `RecipientUserId=AssignedAgentId` | potwierdzone |
| `Upsert Ops State` | `ShipmentOpsStates` | handover/retry columns, `UpdatedAtUtc` | brak outbox w tej akcji | potwierdzone |
| `Raise Handover Exception` | `ShipmentOpsStates`; Notification DB po manual notification | `HandoverState=Exception`, `HandoverExceptionReason` | `POST /notifications/api/notifications/manual` z UI | potwierdzone |
| `Schedule Retry` | `ShipmentOpsStates`; Notification DB po manual notification | `RetryRequired`, `RetryCount`, `RetryReason`, retry dates | `POST /notifications/api/notifications/manual` z UI | potwierdzone |
| `Log Attempt` | brak tabeli SQL | localStorage `scp.shipment-delivery-attempts.v1` | opcjonalnie `ScheduleRetry` przez ops-state | potwierdzone jako local-only |

## Relacje

| Relacja | Typ | Status | Źródło |
|---|---|---|---|
| `ShipmentEvents.ShipmentId -> Shipments.ShipmentId` | fizyczna FK 1:N cascade | potwierdzone | `LogisticsTrackingDbContext.cs:38-41` |
| `ShipmentOpsStates.ShipmentId -> Shipments.ShipmentId` | fizyczna FK 1:1 cascade | potwierdzone | `LogisticsTrackingDbContext.cs:63-66` |
| `Shipments.OrderId -> Order.Orders.OrderId` | logiczna między bazami | wniosek z analizy | brak FK między mikroserwisami |
| `Shipments.DealerId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy | brak FK między mikroserwisami |
| `Shipments.AssignedAgentId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy | brak FK i brak backendowej walidacji aktywnego Agenta |
| `ShipmentEvents.UpdatedByUserId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy | brak FK |
| `Shipments.DeliveryAgentRatedByUserId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy | brak FK |
| Outbox Logistics -> Notification | event przez RabbitMQ `supplychain.events` i routing key `logistics.{eventType}` | potwierdzone | `LogisticsOutboxDispatcher.cs:18-65` |

## Statusy I Enumy

| Enum | Wartości | Tabela / kolumna | Status |
|---|---|---|---|
| `ShipmentStatus` | `Created`, `Assigned`, `PickedUp`, `InTransit`, `OutForDelivery`, `Delivered`, `DeliveryFailed`, `Returned` | `Shipments.Status`, `ShipmentEvents.Status` | potwierdzone |
| `AssignmentDecisionStatus` | `Pending`, `Accepted`, `Rejected` | `Shipments.AssignmentDecisionStatus` | potwierdzone |
| `HandoverState` | `Pending`, `Ready`, `Exception`, `Completed` | `ShipmentOpsStates.HandoverState` | potwierdzone |

## Rozbieżności EF Vs SQL

| Priorytet | Rozbieżność | Dowód | Skutek | Status |
|---|---|---|---|---|
| P0 | `scripts/migrations/LogisticsTracking.sql` zawiera tylko initial create i kończy na migracji `20260328174620_InitialCreate`. | `scripts/migrations/LogisticsTracking.sql:14-92` | wdrożenie ze skryptu SQL nie utworzy `VehicleNumber`, assignment decision, rating ani `ShipmentOpsStates` | potwierdzone |
| P0 | EF migracje `20260411063723_SyncPendingModelChanges` i `20260411123000_AddShipmentAssignmentDecision` dodają te same kolumny `AssignmentDecisionAtUtc`, `AssignmentDecisionReason`, `AssignmentDecisionStatus`. | pliki migracji EF | możliwy błąd migracji lub konflikt defaultów | potwierdzone |
| P1 | `DeliveryAttempts` są opisane w UI, ale nie mają tabeli, API ani migracji. | `ShipmentDeliveryAttemptsService` | brak audytu i spójności między użytkownikami | potwierdzone jako decyzja local-only albo luka produktowa |

## Luki Danych

| Priorytet | Luka | Dowód | Rekomendacja |
|---|---|---|---|
| P0 | Brak autorytatywnego modelu danych dla prób doręczenia. | brak tabeli; localStorage service | Decyzja produktowa: local-only albo tabela/API `ShipmentDeliveryAttempts`. |
| P0 | Aktywny skrypt SQL Logistics nie odpowiada EF runtime. | EF snapshot vs `LogisticsTracking.sql` | Ustalić źródło prawdy migracji i zaktualizować artefakty wdrożeniowe w osobnym zadaniu. |
| P1 | Brak fizycznych FK do Order i Identity. | `LogisticsTrackingDbContext` ma FK tylko do własnych tabel | W dokumentacji i testach traktować te relacje jako logiczne, wymagające walidacji aplikacyjnej. |
| P1 | Brak indeksu po `OrderId` w aktualnym mapowaniu EF. | `LogisticsTrackingDbContext` indeksuje `ShipmentNumber`, `DealerId+CreatedAtUtc`, `AssignedAgentId+CreatedAtUtc`, `CreatedAtUtc` | `/orders/:id/tracking` filtruje po `OrderId` w kliencie; endpoint serwerowy po `OrderId` wymagałby indeksu. |
