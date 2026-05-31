# AI DTO Models

## IdentityAuth

Plik: `services/IdentityAuth/IdentityAuth.Application/DTOs/AuthDtos.cs`.

- Requesty: `RegisterDealerRequest`, `LoginRequest`, `CreateAgentRequest`, `ForgotPasswordRequest`, `ResetPasswordRequest`, `ChangePasswordRequest`, `LogoutRequest`, `RejectDealerRequest`, `UpdateCreditLimitRequest`.
- Response/DTO: `RegisterDealerResponse`, `AuthResponse`, `CreateAgentResponse`, `AgentSummaryDto`, `DealerSummaryDto`, `DealerDetailDto`, `UserProfileDto`, `InternalUserContactDto`, `CreditLimitUpdateResult`, `PagedResult<T>`.
- Istotne pola: `AuthResponse` zwraca `AccessToken`, daty wygasniecia i `MustChangePassword`; kontroler czyści `RefreshToken` w body i zapisuje go w HttpOnly cookie.

## CatalogInventory

Plik: `services/CatalogInventory/CatalogInventory.Application/DTOs/CatalogDtos.cs`.

- Requesty produktówe: `CreateProductRequest`, `UpdateProductRequest`, `RestockProductRequest`.
- Requesty stock: `SoftLockStockRequest`, `HardDeductStockRequest`, `ReleaseSoftLockRequest`, `StockSubscriptionRequest`.
- Reviews: `CreateProductReviewRequest`, `ModerateProductReviewRequest`, `ProductReviewDto`.
- Response/DTO: `ProductDto`, `ProductListItemDto`, `CategoryDto`, `StockLevelDto`, `PagedResult<T>`.

## Order

Plik: `services/Order/Order.Application/DTOs/OrderDtos.cs`.

- Requesty: `CreateOrderRequest`, `CreateOrderLineRequest`, `CancelOrderRequest`, `UpdateOrderStatusRequest`, `BulkUpdateOrderStatusRequest`, `ReturnRequestDto`, `AdminDecisionRequest`.
- Response/DTO: `OrderDto`, `OrderListItemDto`, `OrderLineDto`, `OrderStatusHistoryDto`, `ReturnInfoDto`, `OrderSagaDto`, `BulkUpdateOrderStatusResultDto`, `OrderAnalyticsDto`.
- Enum aplikacyjny: `OrderSagaState`.
- `CreateOrderRequest` przyjmuje `PaymentMode`, opcjonalny `IdempotencyKey` i liste linii.

## LogisticsTracking

Plik: `services/LogisticsTracking/LogisticsTracking.Application/DTOs/LogisticsDtos.cs`.

- Requesty: `CreateShipmentRequest`, `AssignAgentRequest`, `AssignVehicleRequest`, `RejectAssignmentRequest`, `RateDeliveryAgentRequest`, `UpdateShipmentStatusRequest`, `GetShipmentOpsStatesRequest`, `UpsertShipmentOpsStateRequest`, `LogisticsChatbotRequest`.
- Response/DTO: `ShipmentDto`, `ShipmentEventDto`, `ShipmentOpsStateDto`, `LogisticsChatbotResponseDto`, `LogisticsChatbotSourceDto`.

## PaymentInvoice

Plik: `services/PaymentInvoice/PaymentInvoice.Application/DTOs/PaymentDtos.cs`.

- Credit/outstanding: `CreditCheckResponse`, `UpdateCreditLimitRequest`, `SeedDealerAccountRequest`, `SettleOutstandingRequest`, `AddOutstandingRequest`, `DealerCreditAccountDto`.
- Faktury: `GenerateInvoiceRequest`, `InvoiceLineInput`, `InvoiceDto`, `InvoiceLineDto`.
- Gateway płatności: `CreateGatewayOrderRequest`, `GatewayOrderDto`, `VerifyGatewayPaymentRequest`, `GatewayPaymentVerificationDto`.
- Workflow faktury: `UpsertInvoiceWorkflowRequest`, `InvoiceWorkflowStateDto`, `AddInvoiceWorkflowActivityRequest`, `InvoiceWorkflowActivityDto`.

## Notification

Plik: `services/Notification/Notification.Application/DTOs/NotificationDtos.cs`.

- Requesty: `CreateManualNotificationRequest`, `IngestIntegrationEventRequest`, `MarkNotificationFailedRequest`.
- Response/DTO: `NotificationDto`.

## Frontend

Frontend ma własne modele TypeScript w `supply-chain-frontend/src/app/core/models/*`. Są nazwane tak samo jak DTO backendu i powinny być porównywane z plikami `Application/DTOs` przy każdej zmianie kontraktu.
