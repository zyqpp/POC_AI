# AI Data Model

## Zasada czytania modelu

Zrodlem prawdy dla bazy są DbContexty w `services/*/*.Infrastructure/Persistence/*DbContext.cs` oraz migracje EF. Encje domenowe są w `services/*/*.Domain/Entities`.

## IdentityAuth

DbContext: `services/IdentityAuth/IdentityAuth.Infrastructure/Persistence/IdentityAuthDbContext.cs`.

- `Users`: `UserId`, `Email` unique, `PasswordHash`, `FullName`, `PhoneNumber`, `Role`, `Status`, `CreditLimit`, `RejectionReason`, daty.
- `DealerProfiles`: profil dealera powiązany 1:1 z `Users`; unique `GstNumber`.
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

Reguły domenowe produktu są w `Product.cs`: `AvailableStock = TotalStock - ReservedStock`, soft reserve, release reserve, hard deduct i restock.

## Order

DbContext: `services/Order/Order.Infrastructure/Persistence/OrderDbContext.cs`.

- `Orders`: `OrderId`, unique `OrderNumber`, `DealerId`, `Status`, `CreditHoldStatus`, `PaymentMode`, `TotalAmount`, `PlacedAtUtc`, `CancellationReason`.
- `OrderLines`: linie zamówienia, produkt, SKU, ilość, cena.
- `OrderStatusHistory`: historia zmian statusu.
- `ReturnRequests`: request zwrotu 1:1 z orderem.
- `OrderSagaStates`: stan sagi zamówienia, `CurrentState`, `LastMessage`, daty start/update/completion.
- `OutboxMessages`.

Statusy przejść są w `OrderAggregate.cs`; okno returnu wynosi 48 godzin od dostawy.

## LogisticsTracking

DbContext: `services/LogisticsTracking/LogisticsTracking.Infrastructure/Persistence/LogisticsTrackingDbContext.cs`.

- `Shipments`: `ShipmentId`, `OrderId`, `DealerId`, unique `ShipmentNumber`, adres, `AssignedAgentId`, `VehicleNumber`, decyzja assignmentu, rating agenta, `Status`.
- `ShipmentEvents`: historia statusów przesylki.
- `ShipmentOpsStates`: stan operacyjny handover/retry 1:1 z shipmentem.
- `OutboxMessages`.

Reguły domenowe `Shipment.cs`: agent musi być przypisany przed akceptacją, dostawy nie da się aktualizować po stanie terminalnym, rating tylko po `Delivered`, dostawa `Delivered` wymaga pojazdu.

## PaymentInvoice

DbContext: `services/PaymentInvoice/PaymentInvoice.Infrastructure/Persistence/PaymentInvoiceDbContext.cs`.

- `DealerCreditAccounts`: unique `DealerId`, `CreditLimit`, `CurrentOutstanding`, computed `AvailableCredit`.
- `Invoices`: unique `InvoiceNumber`, unique `IdempotencyKey`, `OrderId`, `DealerId`, GST, subtotal/tax/grand total, PDF path.
- `InvoiceLines`: pozycję faktury.
- `InvoiceWorkflowStates`: status, due date, promise-to-pay, follow-up, note, reminders.
- `InvoiceWorkflowActivities`: aktywnośći workflow faktury.
- `PaymentRecords`: tryb płatności, kwotą, referencja.
- `OutboxMessages`.

## Notification

DbContext: `services/Notification/Notification.Infrastructure/Persistence/NotificationDbContext.cs`.

- `Notifications`: `NotificationId`, `RecipientUserId`, `Title`, `Body`, `SourceService`, `EventType`, `Channel`, `Status`, `CreatedAtUtc`, `SentAtUtc`, `FailureReason`, read state.
- `OutboxMessages`.

`NotificationMessage.CreateFromEvent` mapuje część eventów Identity/Payment/Logistics/Order na kanał Email, pozostałe na InApp.
