# API Checkout

Status: `potwierdzone` dla endpointów używanych przez `/checkout`.
Zakres: endpointy UI checkout oraz endpointy internal wywoływane przez `OrderService`.

## Endpointy Frontendowe

| Akcja | Metoda i ścieżka gateway | Kontroler backend | Role / auth | DTO | Statusy / błędy | Status faktu |
|---|---|---|---|---|---|---|
| Walidacja produktu i stocku przed złożeniem zamówienia | `GET /catalog/api/products/{id}` | `ProductsController.GetById` | `[AllowAnonymous]` w Catalog API; frontend wywołuje z kontekstu dealera | `ProductDto` | `200`, `404` | potwierdzone |
| Credit check UI dla `PrePaid` | `GET /payments/api/payment/dealers/{dealerId}/credit-check?amount=` | `PaymentController.CheckCredit` | `Admin,Dealer`; dodatkowo `EnsureDealerScope` | `CreditCheckResponse` | `200`, `401`, `403` | potwierdzone |
| Utworzenie zamówienia | `POST /orders/api/orders` | `OrdersController.Create` | `Dealer`; `userId` z tokenu musi być parsowalnym `Guid` | `CreateOrderRequest` -> `OrderDto` | `201`, `401`, walidacja `400`, konflikty biznesowe przez middleware | potwierdzone |
| Utworzenie gateway order | `POST /payments/api/payment/gateway/orders` | `PaymentController.CreateGatewayOrder` | `Dealer` | `CreateGatewayOrderRequest` -> `GatewayOrderDto` | `200`, `401`, błędy gateway przez middleware | potwierdzone |
| Weryfikacja gateway payment | `POST /payments/api/payment/gateway/verify` | `PaymentController.VerifyGatewayPayment` | `Dealer` | `VerifyGatewayPaymentRequest` -> `GatewayPaymentVerificationDto` | `200`, `401`, błędy walidacji/gateway | potwierdzone |

## Endpointy Internal Wywoływane Przez Order

| Wywołujący | Endpoint downstream | Ochrona | DTO / payload | Skutek | Status |
|---|---|---|---|---|---|
| `CatalogInventoryGateway.SoftLockStockAsync` | `POST /api/internal/inventory/soft-lock` | `[AllowAnonymous]` + `X-Internal-Api-Key` | `SoftLockStockRequest` | rezerwacja stocku i `StockTransaction` | potwierdzone |
| `CatalogInventoryGateway.ReleaseSoftLockAsync` | `POST /api/internal/inventory/release-soft-lock` | `[AllowAnonymous]` + `X-Internal-Api-Key` | `ReleaseSoftLockRequest` | zwolnienie soft-locku przy błędzie/cancel | potwierdzone |
| `CatalogInventoryGateway.HardDeductStockAsync` | `POST /api/internal/inventory/hard-deduct` | `[AllowAnonymous]` + `X-Internal-Api-Key` | `HardDeductStockRequest` | finalne zdjęcie stocku przy późniejszym statusie | potwierdzone |
| `PaymentCreditCheckGateway.CheckCreditAsync` | `GET /api/payment/internal/dealers/{dealerId}/credit-check?amount=` | `[AllowAnonymous]` + `X-Internal-Api-Key` | query `amount` | credit decision dla orderu | potwierdzone |
| `PaymentCreditCheckGateway.AddOutstandingAsync` | `POST /api/payment/internal/dealers/{dealerId}/outstanding` | `[AllowAnonymous]` + `X-Internal-Api-Key` | `orderId`, `amount`, `paymentMode`, `referenceNo` | zwiększenie outstanding po zapisaniu orderu | potwierdzone |

## Kontrakt `POST /orders/api/orders`

| Pole | Źródło UI | Walidacja backend | Zapis danych | Status |
|---|---|---|---|---|
| `paymentMode` | radio `COD`/`PrePaid` | `IsInEnum()` | `Orders.PaymentMode` | potwierdzone |
| `idempotencyKey` | generowany w `CheckoutComponent.submitOrder()` | brak widocznej walidacji w `CreateOrderRequestValidator` | w prześledzonym `OrderService` brak użycia | luka do potwierdzenia |
| `lines[].productId` | `CartItem.productId` | `NotEmpty()` | `OrderLines.ProductId` | potwierdzone |
| `lines[].productName` | `CartItem.productName` | `NotEmpty().MaximumLength(220)` | `OrderLines.ProductName` | potwierdzone |
| `lines[].sku` | `CartItem.sku` | `NotEmpty().MaximumLength(60)` | `OrderLines.Sku` | potwierdzone |
| `lines[].quantity` | `CartItem.quantity` | `GreaterThan(0)` | `OrderLines.Quantity`, `StockTransactions.Quantity` | potwierdzone |
| `lines[].unitPrice` | `CartItem.unitPrice` | `GreaterThan(0)` | `OrderLines.UnitPrice` | potwierdzone |
| `lines[].minOrderQty` | `CartItem.minOrderQty` | `GreaterThan(0)` | brak osobnej kolumny w `OrderLines` | potwierdzone |

## Role I Rozjazdy

| Obszar | Fakt | Status |
|---|---|---|
| UI `/checkout` | route chroniony przez `roleGuard`, tylko `Dealer` | potwierdzone |
| `POST /api/orders` | backend wymaga `Dealer` | potwierdzone |
| Credit check UI | UI pokazuje credit check tylko dla `PrePaid` | potwierdzone |
| Credit check backend | `OrderService.CreateOrderAsync` wykonuje credit check dla każdego `PaymentMode`, także `COD` | potwierdzone jako rozjazd do decyzji |
| Internal API | `X-Internal-Api-Key` nie jest rolą użytkownika i musi być dokumentowane osobno | potwierdzone |
