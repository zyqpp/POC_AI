# Role I Uprawnienia: `/orders/:id`

Status: `potwierdzone`; dokument ujawnia rozjazdy UI/backend jako ryzyka, nie poprawia kodu.

## Macierz Akcji

| Akcja | Route role | Warunek UI | Backend auth | Warunek runtime / data scope | Status zgodności |
|---|---|---|---|---|---|
| Wejście na ekran | `Admin`, `Dealer`, `Warehouse`, `Logistics` | route guard | `GET /api/orders/{id}`: `[Authorize]` | `Dealer` tylko własny; `Admin/Warehouse/Logistics` wszystkie | zgodne |
| Track Delivery | ekran dostępny bez `Agent`, ale `canTrackDelivery()` dopuszcza `Agent` | `Admin`, `Dealer`, `Logistics`, `Agent` | route `/orders/:id/tracking`: `Admin`, `Dealer`, `Logistics`, `Agent` | brak zapisu | częściowo martwy warunek dla `Agent` na ekranie detail |
| Update Status | `Admin`, `Warehouse`, `Logistics` | `canManageOrderLifecycle`: `Admin`, `Logistics`, `Warehouse`; target per rola | `PUT /api/orders/{id}/status`: `[Authorize]`, potem `CanManageOrderStatus` tylko `Admin`, `Logistics` | serwis zna `Warehouse` tylko dla `ReadyForDispatch` | konflikt P0 |
| Cancel Order | `Admin`, `Dealer` widzą przycisk według statusu | Dealer: `Placed/OnHold`; Admin: nie `Cancelled/Closed` | `[Authorize(Roles = "Dealer,Admin")]` | brak owner check dla Dealer w `CancelOrderAsync` | konflikt P0 |
| Request Return | `Dealer` | `Delivered`, brak returnu, okno 48h | `[Authorize(Roles = "Dealer")]` | `order.DealerId == dealerId`, status delivered, okno 48h | zgodne |
| Reorder Items | `Dealer` | Dealer i order ma linie | Catalog API per product; zapis tylko koszyk lokalny | brak zapisu Order DB | zgodne |
| Operations Notes | `Admin`, `Warehouse`, `Logistics` | `canManageOpsNotes` | brak backendu | localStorage tylko w przeglądarce | zgodne technicznie, ryzyko audytu |
| Approve Hold | `Admin` | status `OnHold` | `[Authorize(Roles = "Admin")]` | order musi istnieć i mieć `OnHold` | zgodne |
| Reject Hold | `Admin` | status `OnHold` | `[Authorize(Roles = "Admin")]` | order musi istnieć i mieć `OnHold` | zgodne; ryzyko actor `System` |
| Approve Return | `Admin` | `ReturnRequested`, return istnieje, nie approved/rejected | `[Authorize(Roles = "Admin")]` | return istnieje, restock i credit settlement muszą przejść | zgodne |
| Reject Return | `Admin` | `ReturnRequested`, return istnieje, nie approved/rejected | `[Authorize(Roles = "Admin")]` | return istnieje, reason walidowany | zgodne |

## Role Użytkowników

| Rola | Dostęp do ekranu | Może odczytać | Może zapisać | Ograniczenia / luki |
|---|---|---|---|---|
| `Dealer` | tak | własne zamówienie przez `GetOrderAsync` | cancel, request return, reorder lokalny | cancel API nie sprawdza właściciela orderu |
| `Admin` | tak | wszystkie zamówienia | status, cancel, hold, return review | brak krytycznej luki w samym auth |
| `Warehouse` | tak | wszystkie zamówienia | UI pokazuje update status do `ReadyForDispatch`, ops notes local | kontroler statusu blokuje `Warehouse`; brak backendu ops notes |
| `Logistics` | tak | wszystkie zamówienia | statusy logistyczne, ops notes local | zgodne dla statusów przez kontroler i serwis |
| `Agent` | nie dla `/orders/:id` | nie dotyczy | nie dotyczy | `canTrackDelivery()` uwzględnia `Agent`, ale Agent nie powinien znaleźć się na tym ekranie |

## Role Techniczne

| Mechanizm | Gdzie użyty | Status |
|---|---|---|
| Bearer JWT | gateway `/orders/{everything}` i Order API `[Authorize]` | potwierdzone |
| `ClaimTypes.Role` | controller odczytuje rolę dla data scope i statusów | potwierdzone |
| `sub` / `NameIdentifier` | controller odczytuje user id | potwierdzone |
| `X-Internal-Api-Key` | nie dla endpointów tego ekranu; używany dalej przez integracje inventory/payment | potwierdzone jako kontekst |

## Data Scope

| Endpoint | Data scope | Status |
|---|---|---|
| `GET /orders/api/orders/{id}` | Dealer tylko własny; Admin/Warehouse/Logistics wszystkie | potwierdzone |
| `PUT /orders/api/orders/{id}/status` | brak owner scope, bo role operacyjne | potwierdzone |
| `POST /orders/api/orders/{id}/cancel` | brak owner scope dla Dealer | luka P0 |
| `POST /orders/api/orders/{id}/returns` | Dealer tylko własny order | potwierdzone |
| `PUT /orders/api/admin/orders/{id}/approve-hold` | Admin wszystkie | potwierdzone |
| `PUT /orders/api/admin/orders/{id}/reject-hold` | Admin wszystkie | potwierdzone |
| `PUT /orders/api/admin/orders/{id}/approve-return` | Admin wszystkie | potwierdzone |
| `PUT /orders/api/admin/orders/{id}/reject-return` | Admin wszystkie | potwierdzone |

## Ryzyka Uprawnień

| Priorytet | Ryzyko | Dowód | Kryterium zamknięcia |
|---|---|---|---|
| P0 | Dealer może anulować cudze zamówienie przez API. | `OrdersController.cs:108-119`, `OrderService.cs:368-394` | Test negatywny i owner check albo jawna decyzja biznesowa. |
| P0 | `Warehouse` ma niespójne uprawnienie do statusu. | `order-detail.component.ts:60-90`, `OrdersController.cs:142-146`, `OrderService.cs:608-626` | Spójna reguła UI/controller/service i test. |
| P1 | `Agent` w `canTrackDelivery()` jest martwym przypadkiem na detail. | `order-detail.component.ts:93-95`, `app.routes.ts:95-98` | Usunąć warunek albo zmienić routing według decyzji biznesowej. |
| P1 | Ops notes bez backendowego auth i audytu. | `order-ops-notes.service.ts:12-18`, `order-ops-notes.service.ts:77-84` | Decyzja: local-only lub pełny backend audytowy. |
