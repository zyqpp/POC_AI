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

