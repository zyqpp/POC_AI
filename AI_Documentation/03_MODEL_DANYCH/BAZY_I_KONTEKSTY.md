# Bazy I Konteksty

## Mapa baz

Status: `potwierdzone` na podstawie `appsettings.json` i `*DbContext.cs`.

| Serwis | Connection string | Baza lokalna | DbContext |
|---|---|---|---|
| IdentityAuth | `IdentityDb` | `IdentityAuthMigrationsDB` | `IdentityAuthDbContext` |
| CatalogInventory | `InventoryDb` | `CatalogInventoryMigrationsDB` | `CatalogInventoryDbContext` |
| Order | `OrderDb` | `OrderMigrationsDB` | `OrderDbContext` |
| LogisticsTracking | `LogisticsDb` | `LogisticsTrackingMigrationsDB` | `LogisticsTrackingDbContext` |
| PaymentInvoice | `PaymentDb` | `PaymentInvoiceMigrationsDB` | `PaymentInvoiceDbContext` |
| Notification | `NotificationDb` | `NotificationMigrationsDB` | `NotificationDbContext` |

## Tabele według DbContext

| DbContext | DbSet / tabela | Źródło | Status |
|---|---|---|---|
| `IdentityAuthDbContext` | `Users`, `DealerProfiles`, `RefreshTokens`, `OtpRecords`, `OutboxMessages` | `services/IdentityAuth/IdentityAuth.Infrastructure/Persistence/IdentityAuthDbContext.cs` | potwierdzone |
| `CatalogInventoryDbContext` | `Products`, `Categories`, `StockTransactions`, `StockSubscriptions`, `OutboxMessages` | `services/CatalogInventory/CatalogInventory.Infrastructure/Persistence/CatalogInventoryDbContext.cs` | potwierdzone |
| `OrderDbContext` | `Orders`, `OrderLines`, `OrderStatusHistory`, `ReturnRequests`, `OrderSagaStates`, `OutboxMessages` | `services/Order/Order.Infrastructure/Persistence/OrderDbContext.cs` | potwierdzone |
| `LogisticsTrackingDbContext` | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | `services/LogisticsTracking/LogisticsTracking.Infrastructure/Persistence/LogisticsTrackingDbContext.cs` | potwierdzone |
| `PaymentInvoiceDbContext` | `DealerCreditAccounts`, `Invoices`, `InvoiceLines`, `InvoiceWorkflowStates`, `InvoiceWorkflowActivities`, `PaymentRecords`, `OutboxMessages` | `services/PaymentInvoice/PaymentInvoice.Infrastructure/Persistence/PaymentInvoiceDbContext.cs` | potwierdzone |
| `NotificationDbContext` | `Notifications`, `OutboxMessages` | `services/Notification/Notification.Infrastructure/Persistence/NotificationDbContext.cs` | potwierdzone |

## Schemat SQL

Nie znaleziono w analizowanych `DbContext` jawnego `HasDefaultSchema` ani `ToTable(name, schema)`. Przyjmowany schemat runtime: `dbo`. Status: `wniosek z analizy`.

