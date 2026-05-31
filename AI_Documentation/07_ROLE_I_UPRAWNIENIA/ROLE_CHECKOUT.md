# Role I Uprawnienia: Checkout

Status: `potwierdzone` dla ścieżki `/checkout`.

## Macierz Akcji

| Akcja | UI guard / rola | Endpoint | Backend auth | Dodatkowy check | Zgodność | Status |
|---|---|---|---|---|---|---|
| Wejście na `/checkout` | `roleGuard`, `Dealer` | brak | brak | koszyk niepusty w komponencie | zgodne | potwierdzone |
| Odczyt produktu do walidacji koszyka | `Dealer` przez ekran | `GET /catalog/api/products/{id}` | publiczne `[AllowAnonymous]` | brak | backend szerszy niż UI | potwierdzone |
| Credit check UI | `Dealer` przez ekran | `GET /payments/api/payment/dealers/{dealerId}/credit-check` | `Admin,Dealer` | `EnsureDealerScope` | zgodne dla dealera | potwierdzone |
| Utworzenie gateway order | `Dealer` | `POST /payments/api/payment/gateway/orders` | `Dealer` | user id z tokenu | zgodne | potwierdzone |
| Weryfikacja gateway payment | `Dealer` | `POST /payments/api/payment/gateway/verify` | `Dealer` | user id z tokenu | zgodne | potwierdzone |
| Utworzenie orderu | `Dealer` | `POST /orders/api/orders` | `Dealer` | user id z tokenu musi być `Guid` | zgodne | potwierdzone |
| Soft-lock inventory z OrderService | rola użytkownika nie dotyczy | `POST /api/internal/inventory/soft-lock` | `X-Internal-Api-Key` | ręczny check headera | osobny auth techniczny | potwierdzone |
| Credit check z OrderService | rola użytkownika nie dotyczy | `GET /api/payment/internal/dealers/{id}/credit-check` | `X-Internal-Api-Key` | ręczny check headera | osobny auth techniczny | potwierdzone |
| Outstanding z OrderService | rola użytkownika nie dotyczy | `POST /api/payment/internal/dealers/{id}/outstanding` | `X-Internal-Api-Key` | ręczny check headera | osobny auth techniczny | potwierdzone |

## Rozdzielenie Ról

| Typ | Wartości / mechanizm | Użycie w checkout |
|---|---|---|
| Role użytkowników | `Dealer`, dodatkowo `Admin` dla publicznego credit check poza checkout | route `/checkout`, `POST /api/orders`, payment gateway |
| Role techniczne | `OrderService` pojawia się w publicznym inventory API, ale nie jest rolą UI | nie używać jako roli użytkownika w AOS checkout |
| Auth techniczny | `X-Internal-Api-Key` z konfiguracji `InternalApi:Key` | internal inventory i internal payment |

## Ryzyka Uprawnień

| Ryzyko | Dowód | Status |
|---|---|---|
| Backend credit check działa też dla `Admin`, ale UI checkout tylko dla `Dealer` | `PaymentController.CheckCredit` ma `Admin,Dealer` | potwierdzone, akceptowalne poza checkout |
| Publiczne endpointy product detail są szersze niż ekran checkout | `ProductsController.GetById` jest publiczny | potwierdzone, wymaga świadomego opisu w API |
| Rola `OrderService` może być mylona z rolą użytkownika | `InventoryController` ma `OrderService`; frontend enum jej nie ma | potwierdzone jako ryzyko dokumentacyjne |
