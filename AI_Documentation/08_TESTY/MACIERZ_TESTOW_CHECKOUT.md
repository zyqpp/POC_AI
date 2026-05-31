# Macierz Testów Checkout

Status: `wniosek z analizy` dla luk, `potwierdzone` dla wskazanych istniejących testów.

## Istniejące Pokrycie

| Obszar | Test / plik | Co pokrywa | Status |
|---|---|---|---|
| Order domain | `tests/Order.Domain.Tests/UnitTest1.cs` | agregat orderu, przejścia statusów, credit rejected | potwierdzone |
| Return approval | `tests/Order.Domain.Tests/OrderServiceReturnApprovalTests.cs` | część integracji `OrderService` z inventory/payment dla zwrotów | potwierdzone |
| Catalog domain | `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | produkt, stock, hard deduct | potwierdzone |
| Payment domain | `tests/PaymentInvoice.Domain.Tests/UnitTest1.cs` | `DealerCreditAccount`, outstanding i available credit | potwierdzone |
| Frontend smoke | `supply-chain-frontend/src/app/smoke.spec.ts` | konfiguracja test runnera | potwierdzone |
| Order SLA frontend | `supply-chain-frontend/src/app/core/services/order-sla.service.spec.ts` | logika SLA zamówień | potwierdzone |

## Braki Testowe Dla Checkout

| Scenariusz | Typ testu | Oczekiwane pokrycie | Priorytet | Status |
|---|---|---|---|---|
| COD happy path: `CheckoutComponent -> POST /orders -> soft-lock -> credit approved -> order saved -> saga completed` | integracyjny API / application | `OrderService.CreateOrderAsync` z fake inventory/payment/saga/outbox | P0 | brak w kodzie |
| Credit rejected: order on hold, outbox `AdminApprovalRequired`, saga `AwaitingManualApproval` | integracyjny application | potwierdzenie statusu i outboxa | P0 | brak w kodzie |
| Soft-lock częściowo nieudany i best-effort release | integracyjny application | wywołania release dla już zablokowanych produktów | P0 | brak w kodzie |
| PrePaid gateway verify tworzy `PaymentRecord` i potem order | integracyjny cross-service albo kontraktowy | korelacja payment-order i wykrycie `Guid.Empty` | P0 | brak w kodzie |
| `AddOutstandingAsync` fail po `SaveChangesAsync` orderu | integracyjny application | decyzja o kompensacji albo jawny błąd procesu | P0 | brak w kodzie |
| `CheckoutComponent` usuwa niedostępny produkt i blokuje submit | unit/component frontend | walidacja `validateCartAgainstCurrentStock()` | P1 | brak w kodzie |
| `CheckoutComponent` pokazuje credit check tylko dla `PrePaid` | unit/component frontend | różnica COD/PrePaid | P1 | brak w kodzie |
| API role: `POST /api/orders` tylko Dealer | API auth | `401/403` dla braku tokenu i złej roli | P1 | brak w kodzie |

## Kryterium Domknięcia

Checkout można uznać za testowo zabezpieczony, gdy istnieją co najmniej:

1. Test application dla `CreateOrderAsync` credit approved.
2. Test application dla credit rejected.
3. Test application dla soft-lock failure i kompensacji.
4. Test komponentu Angular dla COD/PrePaid i walidacji stocku.
5. Test autoryzacji `POST /api/orders`.
