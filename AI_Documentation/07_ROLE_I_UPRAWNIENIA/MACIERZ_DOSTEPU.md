# Macierz Dostępu

## Role

Źródła: `supply-chain-frontend/src/app/core/models/enums.ts`, atrybuty `[Authorize]` w kontrolerach. Status: `potwierdzone`.

- `Admin`
- `Dealer`
- `Warehouse`
- `Logistics`
- `Agent`

## Dostęp frontendowy

| Obszar UI | Role | Status |
|---|---|---|
| Auth publiczny | brak wymogu logowania | potwierdzone |
| Dashboard, profile, notifications | authenticated | potwierdzone |
| Products list/detail | authenticated | potwierdzone |
| Product create/edit | Admin | potwierdzone |
| Cart/checkout | Dealer | potwierdzone |
| Orders | Admin, Dealer, Warehouse, Logistics | potwierdzone |
| Order tracking | Admin, Dealer, Logistics, Agent | potwierdzone |
| Shipments | Admin, Logistics, Agent, Dealer | potwierdzone |
| Invoices | Admin, Dealer | potwierdzone |
| Admin dealers/agents | Admin | potwierdzone |

## Uwagi backendowe

Backend ma dodatkowe role lub ścieżki techniczne widoczne w kontrolerach, np. `OrderService` przy operacjach inventory oraz endpointy `api/internal/**` chronione mechanizmem internal API. To wymaga osobnej walidacji w AOS dla procesów międzyserwisowych.

