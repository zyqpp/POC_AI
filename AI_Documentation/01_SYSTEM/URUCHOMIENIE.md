# Uruchomienie I Zależności

## Technologie

| Obszar | Technologia | Źródło | Status |
|---|---|---|---|
| Backend | .NET `net10.0` | `*.csproj` | potwierdzone |
| Frontend | Angular `^21.2.0` | `supply-chain-frontend/package.json` | potwierdzone |
| Gateway | Ocelot `24.1.0` | `gateway/OcelotGateway/OcelotGateway.csproj` | potwierdzone |
| ORM | Entity Framework Core `10.0.5` | projekty `Infrastructure` | potwierdzone |
| Messaging | RabbitMQ.Client `7.2.1` | projekty `Infrastructure` | potwierdzone |
| Cache | Redis przez `StackExchange.Redis` | projekty `Infrastructure` | potwierdzone |
| Jobs | Hangfire `1.8.23` | projekty `API` i `Infrastructure` | potwierdzone |
| Testy .NET | xUnit | `tests/**/*.csproj` | potwierdzone |
| Testy frontend | Vitest | `supply-chain-frontend/package.json` | potwierdzone |

## Komendy znalezione w repo

| Cel | Komenda | Źródło | Status |
|---|---|---|---|
| Start frontendu | `npm start` w `supply-chain-frontend` | `supply-chain-frontend/package.json` | potwierdzone |
| Build frontendu | `npm run build` w `supply-chain-frontend` | `supply-chain-frontend/package.json` | potwierdzone |
| Test frontendu | `npm test` w `supply-chain-frontend` | `supply-chain-frontend/package.json` | potwierdzone |
| Start backendu | `start-backend.ps1` | plik w katalogu głównym | potwierdzone |
| Migracje EF | `scripts/apply-migrations.ps1` | `scripts/**` | potwierdzone |
| Testy .NET JUnit | `scripts/run-dotnet-junit-tests.ps1` | `scripts/**` | potwierdzone |

## Backend w Dockerze

Wariant kontenerowy uruchamia gateway, sześć API, SQL Server, Redis, RabbitMQ i Mailpit bez lokalnego SDK `.NET 10`.

| Element | Adres hosta | Uwagi |
|---|---|---|
| Gateway Ocelot | `http://localhost:5000` | jedyny publiczny punkt wejścia backendu |
| SQL Server dev | `localhost:14333` | baza lokalna w kontenerze, hasło z `.env.example` |
| Redis | `localhost:6380` | port techniczny |
| RabbitMQ Management | `http://localhost:15672` | domyślnie `guest` / `guest` |
| Mailpit UI | `http://localhost:8025` | poczta developerska |

Mikroserwisy API nie są wystawiane na hosta. Gateway komunikuje się z nimi po nazwach usług Dockera i porcie `8080`.

### Komendy

| Cel | Komenda |
|---|---|
| Walidacja Compose | `docker compose --env-file .env.example config` |
| Build obrazów | `docker compose --env-file .env.example build` |
| Start infrastruktury | `docker compose --env-file .env.example up -d sqlserver redis rabbitmq mailpit` |
| Migracje EF | `docker compose --env-file .env.example run --rm migration-runner` albo `.\scripts\docker-migrate.ps1` |
| Start backendu | `docker compose --env-file .env.example up -d` albo `.\scripts\docker-up.ps1` |
| Start backendu z buildem | `.\scripts\docker-up.ps1 -Build` |
| Logi | `.\scripts\docker-logs.ps1 -Follow` albo `.\scripts\docker-logs.ps1 -Service ocelot-gateway -Follow` |
| Stop | `.\scripts\docker-down.ps1` |

### Wynik weryfikacji 2026-06-02

| Test | Wynik |
|---|---|
| `docker compose --env-file .env.example config` | przeszedł |
| `docker compose --env-file .env.example build` | przeszedł; obrazy gatewaya, 6 API i migratora zbudowane na `.NET 10` w kontenerze |
| `docker compose --env-file .env.example run --rm migration-runner` | przeszedł; migracje wykonane dla 6 DbContextów |
| Frontend `http://127.0.0.1:4200` | `HTTP 200` |
| Gateway root `http://localhost:5000` | `HTTP 404`, oczekiwane, bo brak trasy root w Ocelot |
| Trasy gateway do downstreamów | `HTTP 503`; wymaga diagnostyki logów `ocelot-gateway` i API po stronie Compose |

Status: konteneryzacja i migrator są przygotowane, ale pełna akceptacja backendu przez gateway wymaga domknięcia błędu `503`.
