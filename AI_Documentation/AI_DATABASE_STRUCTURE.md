# Aktywna Struktura Bazy Danych

Status: `potwierdzone` jako aktywny indeks dokumentacji bazy.
Zakres pierwszego pełnego pionu: checkout i utworzenie zamówienia.
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
