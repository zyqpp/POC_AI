# Integracje

## Gateway

Ocelot mapuje prefiksy frontendu na downstream API:

| Prefix gateway | Downstream | Status |
|---|---|---|
| `/identity/**` | `localhost:8001` | potwierdzone |
| `/catalog/**` | `localhost:8002` | potwierdzone |
| `/orders/**` | `localhost:8003` | potwierdzone |
| `/logistics/**` | `localhost:8004` | potwierdzone |
| `/payments/**` | `localhost:8005` | potwierdzone |
| `/notifications/**` | `localhost:8006` | potwierdzone |

Źródło: `gateway/OcelotGateway/ocelot.json`.

## Integracje międzyserwisowe

| Integracja | Kierunek | Źródła | Status |
|---|---|---|---|
| Credit limit sync | IdentityAuth -> PaymentInvoice | `IdentityAuth.Infrastructure/DependencyInjection.cs`, `PaymentCreditLimitGateway` | potwierdzone |
| Notification gateway | IdentityAuth -> Notification | `IdentityAuth.Infrastructure/DependencyInjection.cs`, `NotificationGateway` | potwierdzone |
| Contact lookup | Notification -> IdentityAuth | `Notification.Infrastructure/Integrations/IdentityUserContactClient.cs` | potwierdzone |
| Stock reservation/deduct/release | Order -> CatalogInventory | `Order.Application.Services.OrderService`, inventory endpoints | potwierdzone |
| Credit check/outstanding | Order -> PaymentInvoice | `Order.Application.Services.OrderService`, payment endpoints | potwierdzone |
| Outbox events | każdy serwis domenowy | `OutboxMessages`, background dispatchers | potwierdzone |

## Zewnętrzne usługi techniczne

SQL Server, Redis, RabbitMQ, Hangfire, SMTP i Razorpay są widoczne w konfiguracji oraz zależnościach projektów. Dane sekretne i klucze w `appsettings.json` należy traktować jako konfigurację lokalnego POC, nie jako wzorzec produkcyjny.

