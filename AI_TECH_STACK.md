# AI Tech Stack

Ten dokument opisuje stos technologiczny ustalony z kodu po usunieciu starej dokumentacji.

## Platforma

- Backend: .NET `net10.0`, C#, ASP.NET Core Web API.
- SDK wymagany przez `global.json`: `.NET SDK 10.0.104`.
- Lokalnie w tej maszynie dostepne sa SDK `7.0.400` i `9.0.102`, dlatego backend nie zbuduje sie bez instalacji SDK 10 albo zmiany `global.json` i target frameworkow.
- Frontend: Angular `21.2.x`, TypeScript `~5.9.2`, RxJS `~7.8.0`, SSR przez `@angular/ssr` i Express.
- Node: projekt frontendowy deklaruje `npm@11.5.0`; lokalnie `npm.cmd --version` zwraca `11.6.2`.

## Backend

- Architektura backendu: mikroserwisy pod `services/*`, wspolne biblioteki `src/BuildingBlocks` i `src/SharedKernel`.
- API gateway: Ocelot `24.1.0` w `gateway/OcelotGateway`.
- Mediator/CQRS: MediatR w warstwach `Application/Features`.
- Walidacja: FluentValidation.
- Persistence: Entity Framework Core `10.0.5`, SQL Server, migracje EF w `Infrastructure/Persistence/Migrations`.
- Background jobs: Hangfire `1.8.23` z SQL Server storage.
- Messaging: RabbitMQ.Client `7.2.1`; outbox per mikroserwis.
- Cache / stan pomocniczy: Redis przez StackExchange.Redis i Microsoft.Extensions.Caching.StackExchangeRedis.
- Logging: Serilog.AspNetCore + Serilog.Sinks.File.
- Auth: JWT Bearer, role `Admin`, `Dealer`, `Warehouse`, `Logistics`, `Agent`; IdentityAuth dodatkowo sprawdza revocation store w Redis.
- Dokumentacja runtime API w dev: Swagger / Swashbuckle.

## Frontend

- Angular standalone routes w `supply-chain-frontend/src/app/app.routes.ts`.
- Klienci API sa w `supply-chain-frontend/src/app/core/api`.
- Modele frontendowe sa w `supply-chain-frontend/src/app/core/models`.
- Globalne interceptory:
  - `auth.interceptor.ts`: dodaje Bearer token poza wybranymi publicznymi URL.
  - `correlation-id.interceptor.ts`: dodaje `X-Correlation-Id` i `Oc-Client` dla gatewaya.
  - `error.interceptor.ts`, `loading.interceptor.ts`, `utc-date-normalization.interceptor.ts`.
- Dev proxy: `supply-chain-frontend/proxy.conf.json` kieruje prefiksy `/identity`, `/catalog`, `/orders`, `/logistics`, `/payments`, `/notifications` do gatewaya `http://localhost:5000`.

## Integracje

- Gateway: `http://localhost:5000`.
- Mikroserwisy:
  - IdentityAuth: `http://localhost:8001`.
  - CatalogInventory: `http://localhost:8002`.
  - Order: `http://localhost:8003`.
  - LogisticsTracking: `http://localhost:8004`.
  - PaymentInvoice: `http://localhost:8005`.
  - Notification: `http://localhost:8006`.
- Docker Compose uruchamia tylko infrastrukturę pomocniczą: RabbitMQ, Redis, Mailpit.
- SQL Server nie jest w `docker-compose.yml`; connection stringi sa w `appsettings.json` poszczegolnych serwisow.
- Payment: Razorpay client w `PaymentInvoice.Infrastructure/PaymentGateway`.
- E-mail: MailKit/SmtpClient w `Notification.Infrastructure/Email`; appsettings wskazuja SMTP, a compose zapewnia Mailpit.
- LLM: `LogisticsTracking.Infrastructure/Llm/OpenAiLogisticsChatLlmClient.cs` z fallbackiem na odpowiedz wewnetrzna.

## Komendy

- Backend: `dotnet test SupplyChainPlatform.slnx` po zainstalowaniu SDK 10.0.104.
- Infrastruktura: `docker compose up -d`.
- Backend lokalnie: `.\start-backend.ps1`.
- Frontend: w `supply-chain-frontend` uruchomic `npm.cmd ci`, potem `npm.cmd run build` albo `npm.cmd test`.
