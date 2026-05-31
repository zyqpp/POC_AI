# Model Danych Checkout

Status: `potwierdzone` dla ścieżki checkout na podstawie kodu.
Zakres: `/checkout`, `POST /api/orders`, credit check, soft-lock stocku, gateway payment i outbox.

## Źródła

| Obszar | Źródło |
|---|---|
| UI checkout | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.ts`, `checkout.component.html` |
| Koszyk | `supply-chain-frontend/src/app/core/stores/cart.store.ts`, `shared.models.ts` |
| Order API | `services/Order/Order.API/Controllers/OrdersController.cs` |
| Order DTO i walidacje | `services/Order/Order.Application/DTOs/OrderDtos.cs`, `OrderValidators.cs` |
| Order DB | `services/Order/Order.Infrastructure/Persistence/OrderDbContext.cs` |
| Inventory DB | `services/CatalogInventory/CatalogInventory.Infrastructure/Persistence/CatalogInventoryDbContext.cs` |
| Payment DB | `services/PaymentInvoice/PaymentInvoice.Infrastructure/Persistence/PaymentInvoiceDbContext.cs` |

## Lineage Danych

| UI/API | DTO / model | Encja | Tabela SQL | Kolumna SQL | R/W | Status |
|---|---|---|---|---|---|---|
| `cartStore.items().productId` | `CreateOrderLineRequest.ProductId` | `OrderLine` | `OrderLines` | `ProductId` | zapis order line | potwierdzone |
| `cartStore.items().productName` | `CreateOrderLineRequest.ProductName` | `OrderLine` | `OrderLines` | `ProductName` | zapis order line | potwierdzone |
| `cartStore.items().sku` | `CreateOrderLineRequest.Sku` | `OrderLine` | `OrderLines` | `Sku` | zapis order line | potwierdzone |
| `cartStore.items().quantity` | `CreateOrderLineRequest.Quantity` | `OrderLine` | `OrderLines` | `Quantity` | zapis order line | potwierdzone |
| `cartStore.items().unitPrice` | `CreateOrderLineRequest.UnitPrice` | `OrderLine` | `OrderLines` | `UnitPrice` | zapis order line | potwierdzone |
| `paymentMode` | `CreateOrderRequest.PaymentMode` | `OrderAggregate` | `Orders` | `PaymentMode` | zapis order | potwierdzone |
| token użytkownika | `CreateOrderCommand.DealerId` | `OrderAggregate` | `Orders` | `DealerId` | zapis order | potwierdzone |
| `cartStore.total()` | `OrderAggregate.TotalAmount` | `OrderAggregate` | `Orders` | `TotalAmount` | zapis order | potwierdzone |
| wygenerowany numer | `GenerateOrderNumber()` | `OrderAggregate` | `Orders` | `OrderNumber` | zapis order | potwierdzone |
| wynik credit check | `CreditCheckResult.Approved` | `OrderAggregate` | `Orders` | `Status`, `CreditHoldStatus` | zapis statusu | potwierdzone |
| soft-lock inventory | `SoftLockStockRequest` | `Product` | `Products` | `ReservedStock` | zapis przez inventory | potwierdzone |
| soft-lock inventory | `SoftLockStockRequest` | `StockTransaction` | `StockTransactions` | `TransactionType`, `Quantity`, `ReferenceId`, `ProductId` | zapis transakcji | potwierdzone |
| credit check | `CheckCreditQuery` | `DealerCreditAccount` | `DealerCreditAccounts` | `CreditLimit`, `CurrentOutstanding` | odczyt | potwierdzone |
| approved credit | `AddOutstandingAsync` | `DealerCreditAccount` | `DealerCreditAccounts` | `CurrentOutstanding` | zapis po `SaveChanges` orderu | potwierdzone |
| gateway verify | `VerifyGatewayPaymentRequest` | `PaymentRecord` | `PaymentRecords` | `OrderId`, `DealerId`, `PaymentMode`, `Amount`, `ReferenceNo` | zapis, ale `OrderId = Guid.Empty` | potwierdzone jako ryzyko |
| `lineTotal` w UI | `CartItem.lineTotal`, `OrderLineDto.LineTotal` | `OrderLine` | brak kolumny | brak kolumny | wyliczane | potwierdzone |
| `availableStock` w UI | `ProductDto.AvailableStock` | `Product` | brak kolumny | brak kolumny | wyliczane z `TotalStock - ReservedStock` | potwierdzone |
| `availableCredit` w UI | `CreditCheckResponse.AvailableCredit` | `DealerCreditAccount` | brak kolumny | brak kolumny | wyliczane | potwierdzone |

## Tabele Order DB

| Tabela | Kolumny krytyczne | Ograniczenia EF | Użycie w checkout |
|---|---|---|---|
| `Orders` | `OrderId`, `OrderNumber`, `DealerId`, `Status`, `CreditHoldStatus`, `PaymentMode`, `TotalAmount`, `PlacedAtUtc`, `CancellationReason` | `OrderNumber` max 32 i unique; indeksy `(DealerId, PlacedAtUtc)`, `(Status, PlacedAtUtc)`; enumy jako string | zapis po `CreateOrderAsync` |
| `OrderLines` | `OrderLineId`, `OrderId`, `ProductId`, `ProductName`, `Sku`, `Quantity`, `UnitPrice` | `ProductName` max 220, `Sku` max 60, `UnitPrice` precision 18,2, `LineTotal` ignorowane | zapis linii z koszyka |
| `OrderStatusHistory` | `HistoryId`, `OrderId`, `FromStatus`, `ToStatus`, `ChangedByUserId`, `ChangedByRole`, `ChangedAtUtc` | enumy jako string max 40, `ChangedByRole` max 40 | zapis przejść statusów domenowych |
| `OrderSagaStates` | `OrderId`, `OrderNumber`, `DealerId`, `CurrentState`, `StartedAtUtc`, `UpdatedAtUtc`, `CompletedAtUtc`, `LastMessage` | `OrderId` jako klucz, `OrderNumber` max 32, `CurrentState` string max 64, `LastMessage` max 500 | zapis stanu sagi po utworzeniu orderu |
| `OutboxMessages` | `MessageId`, `EventType`, `Payload`, `Status`, `Error` | `EventType` max 200, `Payload` wymagany, `Status` string max 32, `Error` max 2000 | zapis `OrderPlaced` albo `AdminApprovalRequired` |

## Tabele Inventory DB

| Tabela | Kolumny krytyczne | Ograniczenia EF | Użycie w checkout |
|---|---|---|---|
| `Products` | `ProductId`, `Sku`, `Name`, `UnitPrice`, `MinOrderQty`, `TotalStock`, `ReservedStock`, `IsActive` | `Sku` max 60 i unique, `Name` max 200, `UnitPrice` precision 18,2, `AvailableStock` ignorowane | odczyt w UI i soft-lock w backendzie |
| `StockTransactions` | `TxId`, `ProductId`, `TransactionType`, `Quantity`, `ReferenceId`, `CreatedAtUtc` | `TransactionType` string max 40, `ReferenceId` max 120, FK do `Products` | zapis soft-lock i późniejszych zmian stocku |
| `OutboxMessages` | `MessageId`, `EventType`, `Payload`, `Status`, `Error` | jak w outbox | zapis eventów inventory |

## Tabele Payment DB

| Tabela | Kolumny krytyczne | Ograniczenia EF | Użycie w checkout |
|---|---|---|---|
| `DealerCreditAccounts` | `AccountId`, `DealerId`, `CreditLimit`, `CurrentOutstanding` | unique `DealerId`, decimal precision 18,2, `AvailableCredit` ignorowane | credit check i outstanding |
| `PaymentRecords` | `PaymentRecordId`, `OrderId`, `DealerId`, `PaymentMode`, `Amount`, `ReferenceNo`, `CreatedAtUtc` | `PaymentMode` string max 20, `Amount` precision 18,2, `ReferenceNo` max 100 | zapis przy weryfikacji gateway |
| `OutboxMessages` | `MessageId`, `EventType`, `Payload`, `Status`, `Error` | jak w outbox | zapis `PaymentCaptured` albo `PaymentFailed` |

## Relacje Checkout

| Relacja | Typ | Status |
|---|---|---|
| `OrderLines.OrderId -> Orders.OrderId` | fizyczna FK, cascade | potwierdzone |
| `OrderStatusHistory.OrderId -> Orders.OrderId` | fizyczna FK, cascade | potwierdzone |
| `OrderSagaStates.OrderId -> Orders.OrderId` | logiczna w tej samej bazie, klucz `OrderId` | potwierdzone |
| `OrderLines.ProductId -> CatalogInventory.Products.ProductId` | logiczna między bazami | wniosek z analizy |
| `Orders.DealerId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy |
| `DealerCreditAccounts.DealerId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy |
| `PaymentRecords.OrderId -> Orders.OrderId` | logiczna między bazami; obecnie gateway zapisuje `Guid.Empty` | potwierdzone jako ryzyko |
