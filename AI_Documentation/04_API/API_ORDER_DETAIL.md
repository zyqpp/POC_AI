# API: Szczegół Zamówienia `/orders/:id`

Status: `potwierdzone` na podstawie kontrolerów .NET, serwisów Angular, DTO i walidatorów.
Zakres: endpointy używane bezpośrednio lub pośrednio przez ekran `OrderDetailComponent`.

## Źródła

| Obszar | Źródło |
|---|---|
| Angular API | `supply-chain-frontend/src/app/core/api/order-api.service.ts:13-79` |
| Angular model DTO | `supply-chain-frontend/src/app/core/models/order.models.ts:18-98` |
| Kontroler user order | `services/Order/Order.API/Controllers/OrdersController.cs:12-147` |
| Kontroler admin order | `services/Order/Order.API/Controllers/AdminOrdersController.cs:11-107` |
| DTO backend | `services/Order/Order.Application/DTOs/OrderDtos.cs:18-106` |
| Walidatory | `services/Order/Order.Application/Validation/OrderValidators.cs:25-73` |
| Gateway Ocelot | `gateway/OcelotGateway/ocelot.json:397-515` |
| Obsługa błędów Order API | `services/Order/Order.API/Program.cs:116-210` |

## Gateway

| Warstwa | Reguła | Status |
|---|---|---|
| Frontend base | `OrderApiService.base = /orders/api/orders` | potwierdzone |
| Frontend admin base | `AdminOrderApiService.base = /orders/api/admin/orders` | potwierdzone |
| Ocelot upstream | `/orders/{everything}` dla GET/POST/PUT/PATCH/DELETE | potwierdzone |
| Ocelot downstream | `/{everything}` do `localhost:8003` | potwierdzone |
| Auth gateway | `AuthenticationProviderKey = Bearer` | potwierdzone |
| QoS | timeout `5000`, circuit breaker po 3 wyjątkach | potwierdzone |

## Endpointy

| Akcja UI | Frontend | Endpoint gateway | Endpoint backend | Role / warunki | DTO | Backend | Statusy / błędy | Status |
|---|---|---|---|---|---|---|---|---|
| Wczytaj szczegół | `getOrderById(id)` | `GET /orders/api/orders/{id}` | `GET api/orders/{id:guid}` | `[Authorize]`; data scope w `GetOrderAsync`: `Admin`, `Warehouse`, `Logistics` widzą wszystkie, Dealer tylko własne | response `OrderDto` | `GetOrderQuery -> OrderService.GetOrderAsync` | `200`, `401`, `404` | potwierdzone |
| Zmień status | `updateStatus(id, { newStatus })` | `PUT /orders/api/orders/{id}/status` | `PUT api/orders/{id:guid}/status` | `[Authorize]`; kontroler dopuszcza tylko `Admin`, `Logistics`; serwis zna też `Warehouse` dla `ReadyForDispatch` | request `UpdateOrderStatusRequest`; response message | `UpdateOrderStatusCommand -> OrderService.UpdateOrderStatusAsync` | `200`, `401`, `403`, `404`, `400 validation`, `409 business.conflict`, `503/504 dependency` | potwierdzone; konflikt `Warehouse` |
| Anuluj zamówienie | `cancelOrder(id, { reason })` | `POST /orders/api/orders/{id}/cancel` | `POST api/orders/{id:guid}/cancel` | `[Authorize(Roles = "Dealer,Admin")]`; brak sprawdzenia, że Dealer anuluje własne zamówienie | request `CancelOrderRequest`; response message | `CancelOrderCommand -> OrderService.CancelOrderAsync` | `200`, `401`, `403`, `404`, `400 validation`, `409 business.conflict` | potwierdzone; ryzyko data scope |
| Zgłoś zwrot | `requestReturn(id, { reason })` | `POST /orders/api/orders/{id}/returns` | `POST api/orders/{id:guid}/returns` | `[Authorize(Roles = "Dealer")]`; serwis wymaga `order.DealerId == dealerId` | request `ReturnRequestDto`; response message | `RequestReturnCommand -> OrderService.RequestReturnAsync` | `200`, `401`, `403`, `404`, `400 validation`, `400/409 business rule` | potwierdzone |
| Zatwierdź hold | `approveHold(id)` | `PUT /orders/api/admin/orders/{id}/approve-hold` | `PUT api/admin/orders/{id:guid}/approve-hold` | `[Authorize(Roles = "Admin")]` | pusty body `{}`; response message | `ApproveOnHoldCommand -> OrderService.ApproveOnHoldAsync` | `200`, `401`, `403`, `404` | potwierdzone |
| Odrzuć hold | `rejectHold(id, { reason })` | `PUT /orders/api/admin/orders/{id}/reject-hold` | `PUT api/admin/orders/{id:guid}/reject-hold` | `[Authorize(Roles = "Admin")]` | request `AdminDecisionRequest`; response message | `RejectOnHoldCommand -> OrderService.RejectOnHoldAsync` | `200`, `401`, `403`, `404`, możliwy conflict inventory | potwierdzone |
| Zatwierdź zwrot | `approveReturn(id)` | `PUT /orders/api/admin/orders/{id}/approve-return` | `PUT api/admin/orders/{id:guid}/approve-return` | `[Authorize(Roles = "Admin")]` | pusty body `{}`; response message | `ApproveReturnCommand -> OrderService.ApproveReturnAsync` | `200`, `401`, `403`, `404`, `400/503` przy integracjach | potwierdzone |
| Odrzuć zwrot | `rejectReturn(id, { reason })` | `PUT /orders/api/admin/orders/{id}/reject-return` | `PUT api/admin/orders/{id:guid}/reject-return` | `[Authorize(Roles = "Admin")]` | request `AdminDecisionRequest`; response message | `RejectReturnCommand -> OrderService.RejectReturnAsync` | `200`, `401`, `403`, `404`, `400 validation` | potwierdzone |
| Reorder | `CatalogApiService.getProductById(productId)` per linia | `GET /catalog/api/products/{id}` | poza Order API | Dealer na UI; auth Catalog według kontrolera Catalog | response `ProductDto` | CatalogInventory | błędy ignorowane per linia, produkt pomijany | potwierdzone |
| Notatki ops | `OrderOpsNotesService` | brak API | brak | `Admin`, `Warehouse`, `Logistics` tylko w UI | `OrderOpsNote` TS | localStorage | brak backendowych statusów | potwierdzone |

## DTO

| DTO | Pola | Walidacja | Status |
|---|---|---|---|
| `OrderDto` | `OrderId`, `OrderNumber`, `DealerId`, `Status`, `CreditHoldStatus`, `PaymentMode`, `TotalAmount`, `PlacedAtUtc`, `CancellationReason`, `Lines`, `StatusHistory`, `ReturnRequest`, `Saga` | response, bez walidatora | potwierdzone |
| `OrderLineDto` | `OrderLineId`, `ProductId`, `ProductName`, `Sku`, `Quantity`, `UnitPrice`, `LineTotal` | response, `LineTotal` wyliczany | potwierdzone |
| `OrderStatusHistoryDto` | `HistoryId`, `FromStatus`, `ToStatus`, `ChangedByUserId`, `ChangedByRole`, `ChangedAtUtc` | response | potwierdzone |
| `ReturnInfoDto` | `ReturnRequestId`, `Reason`, `RequestedAtUtc`, `IsApproved`, `IsRejected`, `ReviewedAtUtc` | response | potwierdzone |
| `UpdateOrderStatusRequest` | `NewStatus` | `IsInEnum()` | potwierdzone |
| `CancelOrderRequest` | `Reason` | `NotEmpty().MaximumLength(400)` | potwierdzone |
| `ReturnRequestDto` | `Reason` | `NotEmpty().MaximumLength(500)` | potwierdzone |
| `AdminDecisionRequest` | `Reason?` | `MaximumLength(400)` gdy podane | potwierdzone |

## Reguły Runtime

| Reguła | Implementacja | Status |
|---|---|---|
| Dealer widzi tylko własny order przy odczycie | `OrderService.GetOrderAsync`: jeśli nie admin-like i `order.DealerId != requesterUserId`, zwraca null | potwierdzone |
| Admin-like dla odczytu | `Admin`, `Warehouse`, `Logistics` | potwierdzone |
| Kontroler statusu blokuje `Warehouse` | `OrdersController.CanManageOrderStatus` zwraca true tylko dla `Admin` i `Logistics` | potwierdzone jako rozjazd |
| Serwis statusu zna `Warehouse` | `OrderService.CanRoleManageOrderStatus` dopuszcza `Warehouse` dla statusu `ReadyForDispatch` | potwierdzone jako rozjazd |
| Return tylko dla właściciela | `RequestReturnAsync`: `order.DealerId != dealerId` daje `false` | potwierdzone |
| Return tylko po dostawie i w oknie 48h | `OrderAggregate.RaiseReturn` | potwierdzone |
| Cancel nie sprawdza właściciela dealera | `CancelOrderAsync` nie porównuje `order.DealerId` z `changedByUserId` | potwierdzone jako ryzyko P0 |
| Validator `UpdateOrderStatusRequestValidator` istnieje, ale nie potwierdzono jawnego użycia w `UpdateOrderStatusAsync` | serwis nie ma wstrzykniętego validatora update status | do potwierdzenia |
| Validator `AdminDecisionRequestValidator` istnieje, ale reject hold nie waliduje go w serwisie | `RejectOnHoldAsync` przyjmuje `string reason` bez validatora | do potwierdzenia |

## Obsługa Błędów

| Typ błędu | Status HTTP / code | Źródło |
|---|---|---|
| FluentValidation | `400 validation.failed` | `Program.cs:122-130` |
| `UnauthorizedAccessException` | `401 auth.unauthorized` | `Program.cs:132-139` |
| `KeyNotFoundException` | `404 resource.not-found` | `Program.cs:141-148` |
| downstream `HttpRequestException` | `503 dependency.unavailable` | `Program.cs:150-158` |
| timeout dependency | `504 dependency.timeout` | `Program.cs:160-168` |
| `InvalidOperationException` z `cannot transition`, `unable to deduct/release`, `insufficient` | `409 business.conflict` | `Program.cs:170-210` |
| pozostały `InvalidOperationException` | `400 business.rule-violation` | `Program.cs:170-210` |

## Luki API

| Priorytet | Luka | Dowód | Rekomendacja dokumentacyjna |
|---|---|---|---|
| P0 | `POST /orders/api/orders/{id}/cancel` dla Dealera nie ma data scope właściciela. | `OrdersController.cs:108-119`, `OrderService.cs:368-394` | Oznaczyć w rolach i testach jako wymagany test bezpieczeństwa. |
| P0 | `Warehouse` widzi `Update Status` w UI, ale kontroler zwróci `403`. | `order-detail.component.ts:60-90`, `OrdersController.cs:142-146` | Każdy AOS ma sekcję zgodności UI/backend. |
| P1 | UI cancel reason dopuszcza 500 znaków, backend max 400. | `order-detail.component.html:155`, `OrderValidators.cs:25-30` | Dodać test kontraktu albo ujednolicić limit w osobnym zadaniu. |
| P1 | Backend `OrderDto` ma `Saga`, TS `OrderDto` jej nie ma. | `OrderDtos.cs:93-106`, `order.models.ts:85-98` | Opisać jako brak wykorzystania danych w UI. |
