# AOS Checkout Create Order - API And Contracts

## Cel Pliku

Ten plik opisuje kontrakty API używane przez ekran checkout i proces utworzenia zamówienia.

## Lista Endpointów

| ID API | Cel | Front URL | Gateway route | Downstream endpoint | Metoda | Auth/role | Request DTO | Response DTO |
|---|---|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-API-001` | Utworzenie zamówienia | `/orders/api/orders` | `/orders/{everything}` | `/api/orders` | POST | Bearer, Dealer | `CreateOrderRequest` | `OrderDto` |
| `AOS-ORD-CHECKOUT-API-002` | Odswiezenie produktu/stocku przed wysłaniem | `/catalog/api/products/{id}` | `/catalog/{everything}` | `/api/products/{id}` | GET | Front route protected; controller AllowAnonymous | none | `ProductDto` |
| `AOS-ORD-CHECKOUT-API-003` | Credit-check widoczny na UI dla PrePaid | `/payments/api/payment/dealers/{dealerId}/credit-check?amount=...` | special public route + payment route | `/api/payment/dealers/{dealerId}/credit-check` | GET | Bearer, Admin/Dealer | query `amount` | `CreditCheckResponse` |
| `AOS-ORD-CHECKOUT-API-004` | Utworzenie gateway order Razorpay | `/payments/api/payment/gateway/orders` | `/payments/{everything}` | `/api/payment/gateway/orders` | POST | Bearer, Dealer | `CreateGatewayOrderRequest` | `GatewayOrderDto` |
| `AOS-ORD-CHECKOUT-API-005` | Weryfikacja płatności Razorpay | `/payments/api/payment/gateway/verify` | `/payments/{everything}` | `/api/payment/gateway/verify` | POST | Bearer, Dealer | `VerifyGatewayPaymentRequest` | `GatewayPaymentVerificationDto` |
| `AOS-ORD-CHECKOUT-API-006` | Internal soft-lock stocku | Order service direct HTTP to Catalog | n/a | `/api/internal/inventory/soft-lock` | POST | `X-Internal-Api-Key` | `SoftLockStockRequest` | `{ messąge }` |
| `AOS-ORD-CHECKOUT-API-007` | Internal credit-check backendowy | Order service direct HTTP to Payment | n/a | `/api/payment/internal/dealers/{dealerId}/credit-check` | GET | `X-Internal-Api-Key` | query `amount` | `CreditCheckResult` |
| `AOS-ORD-CHECKOUT-API-008` | Internal add outstanding | Order service direct HTTP to Payment | n/a | `/api/payment/internal/dealers/{dealerId}/outstanding` | POST | `X-Internal-Api-Key` | `AddOutstandingRequest` | `DealerCreditAccountDto` |

## Szczegóły Endpointu

### `AOS-ORD-CHECKOUT-API-001` - `POST /orders/api/orders`

#### Cel

Twórzy zamówienie z koszyka dealera. DealerId nie pochodzi z body, tylko z tokenu JWT.

#### Źródła W Kodzie

| Warstwa | Plik / symbol |
|---|---|
| Angular API service | `supply-chain-frontend/src/app/core/api/order-api.service.ts` / `createOrder()` |
| Model TS | `supply-chain-frontend/src/app/core/models/order.models.ts` |
| Gateway | `gateway/OcelotGateway/ocelot.json` / `order-route-post` |
| Controller | `services/Order/Order.API/Controllers/OrdersController.cs` / `Create()` |
| Command | `services/Order/Order.Application/Features/Orders/Commands/OrderCommands.cs` / `CreateOrderCommand` |
| Service | `services/Order/Order.Application/Services/OrderService.cs` / `CreateOrderAsync()` |
| DTO backend | `services/Order/Order.Application/DTOs/OrderDtos.cs` |
| Validator | `services/Order/Order.Application/Validation/OrderValidators.cs` |

#### Request

| Element | Typ | Wymagane | Źródło | Walidacja |
|---|---|---|---|---|
| Header `Authorization` | Bearer JWT | Tak | Gateway/controller | `[Authorize(Roles="Dealer")]` |
| Body `paymentMode` | enum `PaymentMode` | Tak | TS/C# DTO | `IsInEnum()` |
| Body `idempotencyKey` | string? | Nie | TS/C# DTO | Brak widocznej walidacji/użycia |
| Body `lines` | array | Tak | TS/C# DTO | `NotNull().NotEmpty()` |
| Body line `productId` | guid | Tak | TS/C# DTO | `NotEmpty()` |
| Body line `productName` | string | Tak | TS/C# DTO | `NotEmpty().MaximumLength(220)` |
| Body line `sku` | string | Tak | TS/C# DTO | `NotEmpty().MaximumLength(60)` |
| Body line `quantity` | int | Tak | TS/C# DTO | `GreaterThan(0)` + domain MOQ check |
| Body line `unitPrice` | decimal | Tak | TS/C# DTO | `GreaterThan(0)` |
| Body line `minOrderQty` | int | Tak | TS/C# DTO | `GreaterThan(0)` |

#### Request Body Shape

```json
{
  "paymentMode": 0,
  "idempotencyKey": "order-1710000000000-abcd123",
  "lines": [
    {
      "productId": "00000000-0000-0000-0000-000000000001",
      "productName": "Industrial Motor",
      "sku": "MTR-001",
      "quantity": 2,
      "unitPrice": 1000.00,
      "minOrderQty": 1
    }
  ]
}
```

#### Response

| Status | Kiedy | Body | Retryable | Uwagi |
|---|---|---|---|---|
| 201 | Zamówienie zapisane | `OrderDto` | false | `CreatedAtAction(GetById)` |
| 400 | Walidacja FluentValidation/model binding | framework/validation problem | false | Brak jawnego mapowania w kontrolerze |
| 401 | Brak/niepoprawny token lub brak userId w claimach | `{ messąge: "Invalid token." }` | false | `TryGetUserId()` |
| 403 | Rola inna niż Dealer | standard ASP.NET | false | `[Authorize(Roles="Dealer")]` |
| 500 | Wyjatek np. soft-lock failed, domain validation | zależne od global error handling | zależne | Kontroler nie lapie exception |

#### Response Body Shape

```json
{
  "orderId": "guid",
  "orderNumber": "ORD-2026-ABCDEFGH",
  "dealerId": "guid",
  "status": 2,
  "creditHoldStatus": 2,
  "paymentMode": 0,
  "totalAmount": 2000.00,
  "placedAtUtc": "2026-05-30T00:00:00Z",
  "cancellationReason": null,
  "lines": [],
  "statusHistory": [],
  "returnRequest": null,
  "saga": {}
}
```

## Mapowanie DTO Frontend-Backend

| Pole biznesowe | Model TS | DTO backend | Typ TS | Typ C# | Uwagi zgodnośći |
|---|---|---|---|---|---|
| Metoda płatności | `CreateOrderRequest.paymentMode` | `CreateOrderRequest.PaymentMode` | `PaymentMode` numeric enum | `PaymentMode` enum | OK |
| Idempotency key | `idempotencyKey` | `IdempotencyKey` | `string?` | `string?` | Luka: brak widocznego użycia backend |
| Linie | `lines` | `Lines` | array | `IReadOnlyList<CreateOrderLineRequest>` | OK |
| ProductId | `line.productId` | `ProductId` | string guid | `Guid` | OK przy poprawnym GUID |
| ProductName | `line.productName` | `ProductName` | string | string | Backend ufa requestowi |
| SKU | `line.sku` | `Sku` | string | string | Backend normalizuje SKU do uppercase w domain |
| Quantity | `line.quantity` | `Quantity` | number | int | OK |
| UnitPrice | `line.unitPrice` | `UnitPrice` | number | decimal | Backend ufa requestowi |
| MinOrderQty | `line.minOrderQty` | `MinOrderQty` | number | int | Uzyte tylko do walidacji domain, nie zapisane |

## Kontrakty Bledow

| Kod błędu | HTTP | Kiedy występuje | Źródło | Komunikat UI |
|---|---|---|---|---|
| `INVALID_TOKEN` | 401 | Brak GUID w claim `sub`/`NameIdentifier` | `OrdersController.Create()` | `Invalid token.` |
| `ROLE_FORBIDDEN` | 403 | Rola inna niż Dealer | ASP.NET Authorization | fallback `Failed to place order. Please try again.` jesli body brak |
| `STOCK_VALIDATION_UNAVAILABLE` | n/a frontend | Nie można pobrac stocku przed wysłaniem | `placeOrder()` | `Unable to validate stock right now. Please try again.` |
| `STOCK_CHANGED` | n/a frontend | Produkt/cena/MOQ/stock zmienione | `validateCartAgainstCurrentStock()` | `Cart updated due to stock changes. Review and place order again.` |
| `SOFT_LOCK_FAILED` | zwykle 500 z Order API | Catalog internal soft-lock zwrocil false | `OrderService.CreateOrderAsync()` | backend messąge albo fallback |
| `PAYMENT_GATEWAY_ERROR` | n/a frontend/API | Razorpay script/init/verify failed | `CheckoutComponent` | zależne od miejsca błędu |

## Kompatybilnosc

- Zmiana `CreateOrderRequest` jest breaking change dla frontendu checkout.
- Zmiana enumow `PaymentMode` albo `OrderStatus` wymaga rownoczesnej aktualizacji `enums.ts` i backend domain enums.
- Zmiana mapowania tabel `Orders` / `OrderLines` wymaga aktualizacji `04_DATA_LINEAGE.md` i testów API/backend.
