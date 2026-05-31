# Źródła Prawdy

## Źródła dozwolone

| Obszar | Źródło | Status |
|---|---|---|
| Frontend | `supply-chain-frontend/src/app/**` | potwierdzone |
| Gateway | `gateway/OcelotGateway/**` | potwierdzone |
| Backend | `services/**` | potwierdzone |
| Building blocks | `src/BuildingBlocks/**`, `src/SharedKernel/**` | potwierdzone |
| Testy | `tests/**`, `supply-chain-frontend/src/**/*.spec.ts` | potwierdzone |
| Uruchomienie | `docker-compose*.yml`, `start-backend.ps1`, `package.json`, `*.csproj`, `SupplyChainPlatform.slnx` | potwierdzone |
| Migracje i SQL | `services/**/Migrations/**`, `scripts/migrations/**` | potwierdzone jako artefakty wdrożeniowe |
| Skrypty agentowe | `AI_Agent_scripts/**` | narzędzia pomocnicze, nie źródło opisu biznesowego |

## Źródła zakazane

`AI_Documentation/_archive/**` nie jest źródłem prawdy. Aktywne dokumenty nie mogą opierać wniosków na archiwum ani linkować do niego jako potwierdzenia faktu.

## Zasada rozbieżności

Jeżeli kod, konfiguracja i skrypty SQL pokazują różne fakty, dokumentacja ma wskazać rozbieżność oraz preferować aktualny kod EF i kontrolery jako źródło bieżącego zachowania aplikacji.

