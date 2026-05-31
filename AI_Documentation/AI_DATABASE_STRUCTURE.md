# Aktywna Struktura Bazy Danych

Status: `potwierdzone` jako aktywny indeks dokumentacji bazy.
Zakres pełnych pionów: checkout, utworzenie zamówienia, szczegół zamówienia `/orders/:id`, shipment detail `/shipments/:id` i tracking `/orders/:id/tracking`.
Źródła główne: `services/**/Infrastructure/Persistence/*DbContext.cs`, encje domenowe, migracje EF, `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/AI_AOS_TRACE_REPORT.md`.

## Zasada Użycia

Ten plik jest aktywnym punktem wejścia wymaganym przez `AGENTS.md`. Szczegółowe opisy modelu są utrzymywane w `03_MODEL_DANYCH/**`; dla procesu checkout obowiązuje dokument `03_MODEL_DANYCH/MODEL_DANYCH_CHECKOUT.md`.

## Bazy I Konteksty

| Baza logiczna | DbContext | Główne tabele | Status |
|---|---|---|---|
| `OrderMigrationsDB` | `OrderDbContext` | `Orders`, `OrderLines`, `OrderStatusHistory`, `ReturnRequests`, `OrderSagaStates`, `OutboxMessages` | potwierdzone |
| `CatalogInventoryMigrationsDB` | `CatalogInventoryDbContext` | `Products`, `Categories`, `StockTransactions`, `StockSubscriptions`, `OutboxMessages` | potwierdzone |
| `PaymentInvoiceMigrationsDB` | `PaymentInvoiceDbContext` | `DealerCreditAccounts`, `Invoices`, `InvoiceLines`, `InvoiceWorkflowStates`, `InvoiceWorkflowActivities`, `PaymentRecords`, `OutboxMessages` | potwierdzone |
| `IdentityAuthMigrationsDB` | `IdentityAuthDbContext` | `Users`, `DealerProfiles`, `RefreshTokens`, `OtpRecords`, `OutboxMessages` | potwierdzone |
| `LogisticsTrackingMigrationsDB` | `LogisticsTrackingDbContext` | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | potwierdzone |
| `NotificationMigrationsDB` | `NotificationDbContext` | `Notifications`, `OutboxMessages` | potwierdzone |

## Model Danych Checkout

| Obszar | Tabela | Kolumny krytyczne | R/W w checkout | Status |
|---|---|---|---|---|
| Zamówienie | `Orders` | `OrderId`, `OrderNumber`, `DealerId`, `Status`, `CreditHoldStatus`, `PaymentMode`, `TotalAmount`, `PlacedAtUtc`, `CancellationReason` | zapis przy `POST /api/orders`, odczyt po przejściu do szczegółów zamówienia | potwierdzone |
| Linie zamówienia | `OrderLines` | `OrderLineId`, `OrderId`, `ProductId`, `ProductName`, `Sku`, `Quantity`, `UnitPrice` | zapis z koszyka; `LineTotal` jest wyliczane i ignorowane przez EF | potwierdzone |
| Historia statusu | `OrderStatusHistory` | `HistoryId`, `OrderId`, `FromStatus`, `ToStatus`, `ChangedByUserId`, `ChangedByRole`, `ChangedAtUtc` | zapis przy zmianach statusu domenowego | potwierdzone |
| Saga zamówienia | `OrderSagaStates` | `OrderId`, `OrderNumber`, `DealerId`, `CurrentState`, `StartedAtUtc`, `UpdatedAtUtc`, `CompletedAtUtc`, `LastMessage` | zapis po utworzeniu zamówienia i wyniku credit check | potwierdzone |
| Outbox order | `OutboxMessages` w Order DB | `MessageId`, `EventType`, `Payload`, `Status`, `Error` | zapis `AdminApprovalRequired` albo `OrderPlaced` | potwierdzone |
| Produkt i stock | `Products` | `ProductId`, `Sku`, `Name`, `UnitPrice`, `MinOrderQty`, `TotalStock`, `ReservedStock`, `IsActive` | odczyt w walidacji UI; zmiana `ReservedStock` przez soft-lock | potwierdzone |
| Transakcje stocku | `StockTransactions` | `TxId`, `ProductId`, `TransactionType`, `Quantity`, `ReferenceId`, `CreatedAtUtc` | zapis `SoftLock`, później `HardDeduct` lub `ReleaseReserve` | potwierdzone |
| Konto kredytowe | `DealerCreditAccounts` | `AccountId`, `DealerId`, `CreditLimit`, `CurrentOutstanding` | odczyt credit check, zapis outstanding po zatwierdzeniu kredytu | potwierdzone |
| Płatność gateway | `PaymentRecords` | `PaymentRecordId`, `OrderId`, `DealerId`, `PaymentMode`, `Amount`, `ReferenceNo`, `CreatedAtUtc` | zapis po pozytywnej weryfikacji Razorpay; `OrderId = Guid.Empty` w obecnym kodzie | potwierdzone |

## Model Danych Szczegółu Zamówienia

| Obszar | Tabela | Kolumny krytyczne | R/W w `/orders/:id` | Status |
|---|---|---|---|---|
| Nagłówek zamówienia | `Orders` | `OrderId`, `OrderNumber`, `DealerId`, `Status`, `CreditHoldStatus`, `PaymentMode`, `TotalAmount`, `PlacedAtUtc`, `CancellationReason` | odczyt szczegółu; zapis statusu, credit hold i anulowania | potwierdzone |
| Linie zamówienia | `OrderLines` | `OrderLineId`, `OrderId`, `ProductId`, `ProductName`, `Sku`, `Quantity`, `UnitPrice` | odczyt szczegółu i reorder; `LineTotal` wyliczane bez kolumny | potwierdzone |
| Historia statusu | `OrderStatusHistory` | `HistoryId`, `OrderId`, `FromStatus`, `ToStatus`, `ChangedByUserId`, `ChangedByRole`, `ChangedAtUtc` | odczyt i zapis przy transition/cancel/return | potwierdzone |
| Zwrot | `ReturnRequests` | `ReturnRequestId`, `OrderId`, `RequestedByDealerId`, `Reason`, `RequestedAtUtc`, `IsApproved`, `IsRejected`, `ReviewedAtUtc` | odczyt i zapis request/approve/reject return | potwierdzone |
| Saga orderu | `OrderSagaStates` | `OrderId`, `OrderNumber`, `DealerId`, `CurrentState`, `StartedAtUtc`, `UpdatedAtUtc`, `CompletedAtUtc`, `LastMessage` | odczyt w backendowym `OrderDto.Saga`, zapis lifecycle | potwierdzone |
| Outbox order | `OutboxMessages` w Order DB | `MessageId`, `EventType`, `Payload`, `Status`, `Error` | zapis `Order{Status}`, `OrderCancelled`, `ReturnRequested`, `ReturnApproved`, `ReturnRejected` | potwierdzone |
| Notatki operacyjne | brak tabeli | brak kolumn SQL | localStorage `scp.order-ops-notes.v1` | potwierdzone |

## Model Danych Shipment Detail I Tracking

| Obszar | Tabela | Kolumny krytyczne | R/W w `/shipments/:id` i `/orders/:id/tracking` | Status |
|---|---|---|---|---|
| Nagłówek shipmentu | `Shipments` | `ShipmentId`, `OrderId`, `DealerId`, `ShipmentNumber`, `Status`, `CreatedAtUtc`, `DeliveredAtUtc` | odczyt szczegółu i trackingu; zapis statusu i delivery timestamp | potwierdzone |
| Adres dostawy | `Shipments` | `DeliveryAddress`, `City`, `State`, `PostalCode` | odczyt UI | potwierdzone |
| Assignment agenta | `Shipments` | `AssignedAgentId`, `AssignmentDecisionStatus`, `AssignmentDecisionReason`, `AssignmentDecisionAtUtc` | odczyt i zapis assign/accept/reject | potwierdzone |
| Pojazd | `Shipments` | `VehicleNumber` | odczyt i zapis assign vehicle | potwierdzone |
| Ocena agenta | `Shipments` | `DeliveryAgentRating`, `DeliveryAgentRatingComment`, `DeliveryAgentRatedAtUtc`, `DeliveryAgentRatedByUserId` | odczyt i zapis ratingu po delivered | potwierdzone |
| Timeline shipmentu | `ShipmentEvents` | `ShipmentEventId`, `ShipmentId`, `Status`, `Note`, `UpdatedByUserId`, `UpdatedByRole`, `CreatedAtUtc` | odczyt i zapis przy akcjach domenowych | potwierdzone |
| Handover i retry | `ShipmentOpsStates` | `ShipmentId`, `HandoverState`, `HandoverExceptionReason`, `RetryRequired`, `RetryCount`, `RetryReason`, `NextRetryAtUtc`, `LastRetryScheduledAtUtc`, `UpdatedAtUtc` | odczyt i zapis ops-state | potwierdzone |
| Outbox logistics | `OutboxMessages` w Logistics DB | `MessageId`, `EventType`, `Payload`, `Status`, `RetryCount`, `Error` | zapis eventów shipment lifecycle | potwierdzone |
| Próby doręczenia | brak tabeli SQL | brak kolumn SQL | localStorage `scp.shipment-delivery-attempts.v1` | potwierdzone jako local-only |

## Relacje

| Relacja | Typ | Status | Źródło |
|---|---|---|---|
| `OrderLines.OrderId -> Orders.OrderId` | fizyczna FK w Order DB | potwierdzone | `OrderDbContext` |
| `OrderStatusHistory.OrderId -> Orders.OrderId` | fizyczna FK w Order DB | potwierdzone | `OrderDbContext` |
| `OrderSagaStates.OrderId -> Orders.OrderId` | logiczna przez ten sam identyfikator; tabela sagi ma `OrderId` jako klucz | potwierdzone | `OrderDbContext`, `OrderSagaCoordinator` |
| `Orders.DealerId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy | brak fizycznego FK między mikroserwisami |
| `OrderLines.ProductId -> CatalogInventory.Products.ProductId` | logiczna między bazami | wniosek z analizy | brak fizycznego FK między mikroserwisami |
| `DealerCreditAccounts.DealerId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy | brak fizycznego FK między mikroserwisami |
| `PaymentRecords.OrderId -> Orders.OrderId` | logiczna między bazami; dla gateway verify obecnie `Guid.Empty` | potwierdzone jako ryzyko | `PaymentInvoiceService` |
| `ShipmentEvents.ShipmentId -> Shipments.ShipmentId` | fizyczna FK w Logistics DB, cascade | potwierdzone | `LogisticsTrackingDbContext` |
| `ShipmentOpsStates.ShipmentId -> Shipments.ShipmentId` | fizyczna FK 1:1 w Logistics DB, cascade | potwierdzone | `LogisticsTrackingDbContext` |
| `Shipments.OrderId -> Orders.OrderId` | logiczna między bazami | wniosek z analizy | brak fizycznego FK między mikroserwisami |
| `Shipments.DealerId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy | brak fizycznego FK między mikroserwisami |
| `Shipments.AssignedAgentId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy | brak fizycznego FK i brak backendowej weryfikacji aktywnego Agenta |

## Rozbieżności Do Kontroli

| Priorytet | Rozbieżność | Dowód | Status |
|---|---|---|---|
| P1 | Skrypt wdrożeniowy `scripts/migrations/Order.sql` tworzy tabele order, outbox, lines, status history i return, ale nie zawiera `OrderSagaStates`; EF migracja `AddOrderSagaState` tę tabelę tworzy. | `scripts/migrations/Order.sql:17`, `scripts/migrations/Order.sql:54`, `scripts/migrations/Order.sql:90`, `20260403105135_AddOrderSagaState.cs:14` | potwierdzone |
| P1 | Backendowy `OrderDto` zawiera `Saga`, ale TypeScript `OrderDto` jej nie deklaruje. | `OrderDtos.cs:93-106`, `order.models.ts:85-98` | potwierdzone |
| P0 | Skrypt `scripts/migrations/LogisticsTracking.sql` kończy się na initial create i nie zawiera aktualnych kolumn/tabel EF: `VehicleNumber`, assignment decision, rating agenta, `ShipmentOpsStates`. | `scripts/migrations/LogisticsTracking.sql:14-92`, `LogisticsTrackingDbContextModelSnapshot.cs:79`, `LogisticsTrackingDbContextModelSnapshot.cs:194` | potwierdzone |
| P0 | Migracje EF `20260411063723_SyncPendingModelChanges` i `20260411123000_AddShipmentAssignmentDecision` dodają te same kolumny `AssignmentDecision*`. | pliki migracji EF LogisticsTracking | potwierdzone |
