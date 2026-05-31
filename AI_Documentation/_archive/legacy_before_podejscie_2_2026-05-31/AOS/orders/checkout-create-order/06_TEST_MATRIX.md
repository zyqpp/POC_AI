# AOS Checkout Create Order - Test Matrix

## Cel Pliku

Ten plik przeklada AOS checkout/create order na testy manualne, UI automaty, API/backend i regresje.

## Zakres Testow

| Obszar | Czy testowac | Uwagi |
|---|---|---|
| UI manual | Tak | Pierwsza walidacja przepływu COD, PrePaid, stock changed |
| UI automation | Tak | Brakuje testów checkout; potrzebne stabilne selektóry/data-testid |
| API automation | Tak | `POST /orders/api/orders`, internal stock/credit przez fake/integration |
| Backend unit/domain | Tak | `OrderService.CreateOrderAsync`, `OrderAggregate`, `OrderLine` |
| Contract tests | Tak | TS `CreateOrderRequest` vs C# `CreateOrderRequest` |
| Regression | Tak | Wysokie ryzyko, bo proces dotyka Order, Catalog, Payment |

## Istniejace Pokrycie W Repo

| Obszar | Wynik analizy | Dowod |
|---|---|---|
| Front checkout | Brak testu `CheckoutComponent` | `rg "CheckoutComponent|createOrder" -g "*.spec.ts"` bez wynikow dla checkout |
| Front smoke | Jest tylko smoke test | `supply-chain-frontend/src/app/smoke.spec.ts` |
| Order return approval | Są testy zwrotów, nie create order | `tests/Order.Domain.Tests/OrderServiceReturnApprovalTests.cs` |
| Backend create order | Brak dedykowanego testu wykrytego w repo | search po `CreateOrderRequest` w testach |

## Dane Testowe

| ID danych | Rola | Stan poczatkowy | Jak przygotować | Jak posprzatac |
|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-DATASET-001` | Dealer | Aktywny dealer z tokenem, product aktywny, stock >= quantity, credit available >= total | Seed Identity user + Product + DealerCreditAccount | Usun zamówienie/test DB reset |
| `AOS-ORD-CHECKOUT-DATASET-002` | Dealer | Product aktywny, ale availableStock mniejszy niż quantity | Seed Product z niskim stockiem albo zmien stock po dodaniu do koszyka | Reset Product |
| `AOS-ORD-CHECKOUT-DATASET-003` | Dealer | Credit account z insufficient credit | `DealerCreditAccounts.CurrentOutstanding` tak, aby available < total | Reset account |
| `AOS-ORD-CHECKOUT-DATASET-004` | Dealer | Payment gateway disabled/unavailable | Test config/mock | Reset config/mock |

## Scenariusze Manualne

| ID testu | Priorytet | Rola | Warunek poczatkowy | Kroki | Oczekiwany wynik | Powiązane ID |
|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-TC-001` | P1 | Dealer | Koszyk z 1 aktywnym produktem, sufficient credit | Wejdz `/checkout`, zostaw COD, kliknij `Place Order` | Toast success, koszyk pusty, redirect `/orders/{id}`, order `Processing` | `UC-001`, `API-001`, `DATA-001..009` |
| `AOS-ORD-CHECKOUT-TC-002` | P1 | Dealer | Koszyk pusty | Wejdz `/checkout` | Redirect do `/cart`, brak POST order | `RULE-002` |
| `AOS-ORD-CHECKOUT-TC-003` | P1 | Dealer | Produkt w koszyku, potem cena/stock/MOQ zmienione | Kliknij `Place Order` | Koszyk aktualizuje się, order nie jest wysłany, error stock changed | `RULE-003`, `VFE-003` |
| `AOS-ORD-CHECKOUT-TC-004` | P1 | Dealer | Insufficient credit | COD lub PrePaid, kliknij Place Order | Order zapisany jako `OnHold`, outbox `AdminApprovalRequired` | `RULE-006`, `DATA-009` |
| `AOS-ORD-CHECKOUT-TC-005` | P2 | Dealer | PrePaid, Razorpay happy path | Wybierz PrePaid, przejdź bramke, kliknij/zaakceptuj płatność | verify true, potem order create, redirect do order detail | `API-004`, `API-005` |
| `AOS-ORD-CHECKOUT-TC-006` | P2 | Dealer | PrePaid, payment failed | Wybierz PrePaid, zasymuluj failed payment | Order nie jest wysłany, error payment failed | `ERR-006` |
| `AOS-ORD-CHECKOUT-TC-007` | P2 | Dealer | Wolne API | Kliknij Place Order wielokrotnie | Button disabled; backend nie powinien tworzyć duplikatów, ale luka idempotencji do potwierdzenia | `RISK-001` |

## Automaty UI

| ID testu | Selektor / cel UI | Akcja | Mock/API live | Asercje | Ryzyka stabilnosci |
|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-E2E-001` | `/checkout`, Place Order button | COD happy path | Mock Catalog/Order API | POST body, toast, redirect | Brak `data-testid` |
| `AOS-ORD-CHECKOUT-E2E-002` | route `/checkout` | Login jako Admin/Warehouse | Auth mock/live | Dostęp zabroniony | Guard behavior do ustalenia |
| `AOS-ORD-CHECKOUT-E2E-003` | PrePaid radio | Payment gateway error | Mock script/API | Error messąge, no POST order | Zewnetrzny script Razorpay |
| `AOS-ORD-CHECKOUT-E2E-004` | Cart changed | Mock `GET product` ze zmienioną ceną | Mock Catalog | Koszyk zmieniony, no POST order | Potrzebny dostęp do localStorage/test store |

## Testy API

| ID testu | Endpoint | Request | Auth | Oczekiwany status | Asercje body | Asercje danych |
|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-API-TC-001` | `POST /orders/api/orders` | valid COD lines | Dealer | 201 | `orderNumber`, `status=Processing` przy approved credit | `Orders`, `OrderLines`, `OrderStatusHistory`, `OrderSagaStates`, `OutboxMessages`, `Products.ReservedStock`, `PaymentRecords` |
| `AOS-ORD-CHECKOUT-API-TC-002` | `POST /orders/api/orders` | invalid line quantity/unitPrice/sku | Dealer | 400/validation | validation errors | brak zapisu |
| `AOS-ORD-CHECKOUT-API-TC-003` | `GET /payments/api/payment/dealers/{dealerId}/credit-check` | `amount` | Dealer owner | 200 | approved/availableCredit | account created if missing |
| `AOS-ORD-CHECKOUT-API-TC-004` | `POST /orders/api/orders` | valid body | no auth/Admin | 401/403 | auth error | brak zapisu |
| `AOS-ORD-CHECKOUT-API-TC-005` | `POST /orders/api/orders` | product stock insufficient at soft-lock | Dealer | error/500 currently likely | messąge about reserve stock | no `Orders`; prior soft-locks released best effort |
| `AOS-ORD-CHECKOUT-API-TC-006` | `POST /orders/api/orders` | payment service unavailable | Dealer | 201 | `status=OnHold`, saga awaiting manual | `AdminApprovalRequired` outbox |
| `AOS-ORD-CHECKOUT-API-TC-007` | `POST /api/internal/inventory/soft-lock` | valid body without internal key | none | 401 | invalid internal API key | no stock change |

## Testy Backend / Domenowe

| ID testu | Klasą/metoda | Warunek | Asercja | Typ testu |
|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-DOM-TC-001` | `OrderLine.Create` | quantity < minOrderQty | throws `Line quantity is below...` | unit |
| `AOS-ORD-CHECKOUT-DOM-TC-002` | `OrderAggregate.AddLine` | wiele linii | `TotalAmount` = suma line totals | unit |
| `AOS-ORD-CHECKOUT-DOM-TC-003` | `OrderService.CreateOrderAsync` | credit approved | status Processing, outbox OrderPlaced, AddOutstanding called | unit/service |
| `AOS-ORD-CHECKOUT-DOM-TC-004` | `OrderService.CreateOrderAsync` | credit rejected | status OnHold, outbox AdminApprovalRequired, AddOutstanding not called | unit/service |
| `AOS-ORD-CHECKOUT-DOM-TC-005` | `OrderService.CreateOrderAsync` | second soft-lock fails | release best effort called for previous locks, no zapis orderu | unit/service |
| `AOS-ORD-CHECKOUT-DOM-TC-006` | `CatalogInventoryService.SoftLockStockAsync` | available stock insufficient | false, no ReservedStock increment | unit/service |

## Testy Regresji Po Zmianie

| Zmiana | Minimalna regresja | Dlaczego |
|---|---|---|
| DTO `CreateOrderRequest` | API-TC-001/002 + E2E-001 | Front i backend musza mieć zgodny kontrakt |
| Cart quantity normalization | TC-003 + DOM-TC-001 | Ryzyko zamówień ponizej MOQ albo ponad stock |
| Credit-check | TC-004 + DOM-TC-003/004 | Decyduje o statusię i outboxie |
| Inventory soft-lock | API-TC-005 + DOM-TC-005/006 | Decyduje o rezerwacji stocku |
| Payment PrePaid flow | TC-005/006 | Może blokowac lub przepuszczac order create |
| EF mapping Orders/OrderLines | API-TC-001 + migracje | Ryzyko utraty danych w SQL |

## Macierz Pokrycia

| Wymaganie / akcja / reguła | Test manualny | Test UI auto | Test API | Test backend |
|---|---|---|---|---|
| `REQ-001`, `ACT-003` | `TC-001` | `E2E-001` | `API-TC-001` | `DOM-TC-003` |
| `RULE-002` | `TC-002` | suggested | `API-TC-002` | n/a |
| `RULE-003` | `TC-003` | `E2E-004` | `API-TC-005` | `DOM-TC-006` |
| `RULE-006` | `TC-004` | suggested | `API-TC-006` | `DOM-TC-004` |
| `PrePaid` | `TC-005/006` | `E2E-003` | API mocks | suggested |

## Luki Testowe

| Luka | Ryzyko | Rekomendowany test |
|---|---|---|
| Brak testów checkout component | Regresja UI bez wykrycia | Vitest component tests albo Playwright |
| Brak testu create order service | Zmiana statusu/stock/credit może się popsuc | Unit tests z fake repository/gateways |
| Brak contract test TS/C# DTO | Rozjazd modelu front/back | Generator kontraktow lub snapshot JSON schema |
| Brak testu idempotencji | Duplikaty zamówień | Test dwukrotnego POST z tym sąmym key po wdrozeniu idempotencji |
