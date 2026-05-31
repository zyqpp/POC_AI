# Relacje Danych

## Relacje wewnątrz baz

| Obszar | Relacje fizyczne potwierdzone w EF | Status |
|---|---|---|
| IdentityAuth | `DealerProfiles.UserId`, `RefreshTokens.UserId`, `OtpRecords.UserId` do `Users` | potwierdzone |
| CatalogInventory | `Products.CategoryId` do `Categories`, `Categories.ParentCategoryId`, stock do `Products` | potwierdzone |
| Order | `OrderLines.OrderId`, `OrderStatusHistory.OrderId`, `ReturnRequests.OrderId` do `Orders` | potwierdzone |
| LogisticsTracking | `ShipmentEvents.ShipmentId`, `ShipmentOpsStates.ShipmentId` do `Shipments` | potwierdzone |
| PaymentInvoice | `InvoiceLines.InvoiceId`, `InvoiceWorkflowStates.InvoiceId`, `InvoiceWorkflowActivities.InvoiceId` do `Invoices` | potwierdzone |
| Notification | brak relacji fizycznych do Identity; `RecipientUserId` jest identyfikatorem logicznym | potwierdzone |

## Relacje między bazami

Relacje między mikroserwisami są logiczne przez identyfikatory `Guid`; nie ma fizycznych FK między bazami.

| Identyfikator | Źródło logiczne | Użycie | Status |
|---|---|---|---|
| `UserId` | IdentityAuth `Users` | dealer, agent, admin, odbiorca powiadomień | potwierdzone |
| `DealerId` | IdentityAuth `Users.UserId` dla roli `Dealer` | zamówienia, przesyłki, faktury, konta kredytowe | wniosek z analizy |
| `ProductId` | CatalogInventory `Products` | linie zamówień, faktur, stock transactions | potwierdzone |
| `OrderId` | Order `Orders` | faktury, płatności, przesyłki, saga | potwierdzone |
| `ShipmentId` | LogisticsTracking `Shipments` | eventy i ops-state | potwierdzone |
| `InvoiceId` | PaymentInvoice `Invoices` | linie, workflow i aktywności workflow | potwierdzone |

