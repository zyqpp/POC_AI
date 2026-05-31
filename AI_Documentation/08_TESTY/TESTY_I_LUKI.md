# Testy I Luki

## Testy znalezione

| Obszar | Źródło | Zakres | Status |
|---|---|---|---|
| CatalogInventory Domain | `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | testy domenowe produktów/stocku | potwierdzone |
| IdentityAuth Domain | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | testy użytkownika/profilu/limitu | potwierdzone |
| LogisticsTracking Domain | `tests/LogisticsTracking.Domain.Tests/UnitTest1.cs` | testy domeny przesyłek | potwierdzone |
| Notification Domain | `tests/Notification.Domain.Tests/UnitTest1.cs` | testy powiadomień | potwierdzone |
| Order Domain/Application | `tests/Order.Domain.Tests/**` | domena zamówień i approval zwrotów | potwierdzone |
| PaymentInvoice Domain | `tests/PaymentInvoice.Domain.Tests/UnitTest1.cs` | konto kredytowe, faktury, workflow | potwierdzone |
| Frontend smoke | `supply-chain-frontend/src/app/smoke.spec.ts` | konfiguracja test runnera | potwierdzone |
| Frontend SLA | `supply-chain-frontend/src/app/core/services/order-sla.service.spec.ts` | stan SLA zamówień | potwierdzone |

## Luki testowe

| Luka | Ryzyko | Status |
|---|---|---|
| Brak pełnych testów API kontrolerów | endpoint może działać inaczej niż DTO/front | wniosek z analizy |
| Brak testów E2E dla checkoutu | najważniejszy proces multi-service może się rozjechać | wniosek z analizy |
| Brak testów routingu/guardów Angular dla wszystkich ról | błąd dostępu może być wykryty dopiero manualnie | wniosek z analizy |
| Brak testów integracji outbox/RabbitMQ | zdarzenia mogą nie docierać mimo poprawnej domeny | wniosek z analizy |
| Brak testów zgodności EF vs SQL scripts | ryzyko dryfu migracji i dokumentacji | wniosek z analizy |

