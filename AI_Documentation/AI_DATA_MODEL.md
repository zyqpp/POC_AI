# AI Data Model

## Zasada czytania modelu

Zrodlem prawdy dla bazy sa DbContexty w `services/*/*.Infrastructure/Persistence/*DbContext.cs` oraz migracje EF. Encje domenowe sa w `services/*/*.Domain/Entities`.

## IdentityAuth

DbContext: `services/IdentityAuth/IdentityAuth.Infrastructure/Persistence/IdentityAuthDbContext.cs`.

- `Users`: `UserId`, `Email` unique, `PasswordHash`, `FullName`, `PhoneNumber`, `Role`, `Status`, `CreditLimit`, `RejectionReason`, daty.
- `DealerProfiles`: profil dealera powiazany 1:1 z `Users`; unique `GstNumber`.
- `RefreshTokens`: wiele tokenow na usera; unique `TokenHash`.
- `OtpRecords`: OTP dla resetu hasla.
- `OutboxMessages`: eventy integracyjne.

## CatalogInventory

DbContext: `services/CatalogInventory/CatalogInventory.Infrastructure/Persistence/CatalogInventoryDbContext.cs`.

- `Products`: `ProductId`, unique `Sku`, `Name`, `Description`, `CategoryId`, `UnitPrice`, `MinOrderQty`, `TotalStock`, `ReservedStock`, `IsActive`, `ImageUrl`.
- `Categories`: hierarchia kategorii przez `ParentCategoryId`.
- `StockTransactions`: historia operacji magazynowych z `TransactionType`, `ReferenceId`, `ProductId`.
- `StockSubscriptions`: unique para `DealerId + ProductId`.
- `OutboxMessages`.

Reguly domenowe produktu sa w `Product.cs`: `AvailableStock = TotalStock - ReservedStock`, soft reserve, release reserve, hard deduct i restock.

## Order

DbContext: `services/Order/Order.Infrastructure/Persistence/OrderDbContext.cs`.

- `Orders`: `OrderId`, unique `OrderNumber`, `DealerId`, `Status`, `CreditHoldStatus`, `PaymentMode`, `TotalAmount`, `PlacedAtUtc`, `CancellationReason`.
- `OrderLines`: linie zamowienia, produkt, SKU, ilosc, cena.
- `OrderStatusHistory`: historia zmian statusu.
- `ReturnRequests`: request zwrotu 1:1 z orderem.
- `OrderSagaStates`: stan sagi zamowienia, `CurrentState`, `LastMessage`, daty start/update/completion.
- `OutboxMessages`.

Statusy przejsc sa w `OrderAggregate.cs`; okno returnu wynosi 48 godzin od dostawy.

## LogisticsTracking

DbContext: `services/LogisticsTracking/LogisticsTracking.Infrastructure/Persistence/LogisticsTrackingDbContext.cs`.

- `Shipments`: `ShipmentId`, `OrderId`, `DealerId`, unique `ShipmentNumber`, adres, `AssignedAgentId`, `VehicleNumber`, decyzja assignmentu, rating agenta, `Status`.
- `ShipmentEvents`: historia statusow przesylki.
- `ShipmentOpsStates`: stan operacyjny handover/retry 1:1 z shipmentem.
- `OutboxMessages`.

Reguly domenowe `Shipment.cs`: agent musi byc przypisany przed akceptacja, dostawy nie da sie aktualizowac po stanie terminalnym, rating tylko po `Delivered`, dostawa `Delivered` wymaga pojazdu.

## PaymentInvoice

DbContext: `services/PaymentInvoice/PaymentInvoice.Infrastructure/Persistence/PaymentInvoiceDbContext.cs`.

- `DealerCreditAccounts`: unique `DealerId`, `CreditLimit`, `CurrentOutstanding`, computed `AvailableCredit`.
- `Invoices`: unique `InvoiceNumber`, unique `IdempotencyKey`, `OrderId`, `DealerId`, GST, subtotal/tax/grand total, PDF path.
- `InvoiceLines`: pozycje faktury.
- `InvoiceWorkflowStates`: status, due date, promise-to-pay, follow-up, note, reminders.
- `InvoiceWorkflowActivities`: aktywnosci workflow faktury.
- `PaymentRecords`: tryb platnosci, kwota, referencja.
- `OutboxMessages`.

## Notification

DbContext: `services/Notification/Notification.Infrastructure/Persistence/NotificationDbContext.cs`.

- `Notifications`: `NotificationId`, `RecipientUserId`, `Title`, `Body`, `SourceService`, `EventType`, `Channel`, `Status`, `CreatedAtUtc`, `SentAtUtc`, `FailureReason`, read state.
- `OutboxMessages`.

`NotificationMessage.CreateFromEvent` mapuje czesc eventow Identity/Payment/Logistics/Order na kanal Email, pozostale na InApp.
