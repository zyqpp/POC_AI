# AI Project Tree

Wygenerowano: 2026-05-30 17:10:44 UTC

Tryb: bez zaleznosci i artefaktow build/cache; uzyj -IncludeDependencies, gdy potrzebny jest pelny vendor tree.

~~~text
B2B-supply-chain/
|-- .github/
|   +-- workflows/
|       +-- demo-ci.yml
|-- .vscode/
|   |-- extensions.json
|   |-- settings.json
|   +-- tasks.json
|-- AI_Agent_scripts/
|   |-- Collect-CodeFacts.ps1
|   +-- Generate-ProjectTree.ps1
|-- AI_Documentation/
|   |-- AI_API_INVENTORY.md
|   |-- AI_ARCHITECTURE_HLD.md
|   |-- AI_CODE_FACTS.json
|   |-- AI_CODE_NAVIGATION_GUIDE.md
|   |-- AI_DATA_MODEL.md
|   |-- AI_DOCUMENTATION_INDEX.md
|   |-- AI_DOCUMENTATION_RECOMMENDATIONS.md
|   |-- AI_DTO_MODELS.md
|   |-- AI_PROJECT_TREE.md
|   +-- AI_TECH_STACK.md
|-- gateway/
|   +-- OcelotGateway/
|       |-- Properties/
|       |   +-- launchSettings.json
|       |-- appsettings.Development.json
|       |-- appsettings.json
|       |-- ocelot.json
|       |-- OcelotGateway.csproj
|       +-- Program.cs
|-- scripts/
|   |-- migrations/
|   |   |-- CatalogInventory.sql
|   |   |-- IdentityAuth.sql
|   |   |-- IndexingPatch.sql
|   |   |-- LogisticsTracking.sql
|   |   |-- Notification.sql
|   |   |-- Order.sql
|   |   +-- PaymentInvoice.sql
|   |-- apply-indexing-patch.ps1
|   |-- apply-migrations.ps1
|   |-- check-core-notification-email.ps1
|   |-- check-return-order-flow.ps1
|   |-- demo-load-balancer.ps1
|   |-- generate-migration-sql.ps1
|   |-- run-dotnet-junit-tests.ps1
|   |-- run-email-trigger-deep-check.ps1
|   |-- run-frontend-page-role-matrix.ps1
|   +-- run-role-endpoint-matrix.ps1
|-- services/
|   |-- CatalogInventory/
|   |   |-- CatalogInventory.API/
|   |   |   |-- Controllers/
|   |   |   |   |-- InternalInventoryController.cs
|   |   |   |   |-- InventoryController.cs
|   |   |   |   +-- ProductsController.cs
|   |   |   |-- Properties/
|   |   |   |   +-- launchSettings.json
|   |   |   |-- appsettings.Development.json
|   |   |   |-- appsettings.json
|   |   |   |-- CatalogInventory.API.csproj
|   |   |   +-- Program.cs
|   |   |-- CatalogInventory.Application/
|   |   |   |-- Abstractions/
|   |   |   |   +-- CatalogContracts.cs
|   |   |   |-- DTOs/
|   |   |   |   +-- CatalogDtos.cs
|   |   |   |-- Features/
|   |   |   |   +-- Catalog/
|   |   |   |       |-- Commands/
|   |   |   |       |   +-- CatalogCommands.cs
|   |   |   |       +-- Queries/
|   |   |   |           +-- CatalogQueries.cs
|   |   |   |-- Services/
|   |   |   |   +-- CatalogInventoryService.cs
|   |   |   |-- Validation/
|   |   |   |   +-- CatalogValidators.cs
|   |   |   |-- CatalogInventory.Application.csproj
|   |   |   +-- DependencyInjection.cs
|   |   |-- CatalogInventory.Domain/
|   |   |   |-- Entities/
|   |   |   |   |-- Category.cs
|   |   |   |   |-- Product.cs
|   |   |   |   |-- StockSubscription.cs
|   |   |   |   +-- StockTransaction.cs
|   |   |   |-- Enums/
|   |   |   |   +-- StockTransactionType.cs
|   |   |   +-- CatalogInventory.Domain.csproj
|   |   +-- CatalogInventory.Infrastructure/
|   |       |-- Background/
|   |       |   +-- CatalogOutboxDispatcher.cs
|   |       |-- Cache/
|   |       |   +-- RedisInventoryCacheStore.cs
|   |       |-- Persistence/
|   |       |   |-- Migrations/
|   |       |   |   |-- 20260328174540_InitialCreate.cs
|   |       |   |   |-- 20260328174540_InitialCreate.Designer.cs
|   |       |   |   +-- CatalogInventoryDbContextModelSnapshot.cs
|   |       |   +-- CatalogInventoryDbContext.cs
|   |       |-- Repositories/
|   |       |   +-- CatalogInventoryRepository.cs
|   |       |-- CatalogInventory.Infrastructure.csproj
|   |       +-- DependencyInjection.cs
|   |-- IdentityAuth/
|   |   |-- IdentityAuth.API/
|   |   |   |-- Controllers/
|   |   |   |   |-- AdminDealersController.cs
|   |   |   |   |-- AdminUsersController.cs
|   |   |   |   |-- AuthController.cs
|   |   |   |   |-- InternalUsersController.cs
|   |   |   |   +-- UsersController.cs
|   |   |   |-- Jobs/
|   |   |   |   +-- HangfireHeartbeatJob.cs
|   |   |   |-- Properties/
|   |   |   |   +-- launchSettings.json
|   |   |   |-- appsettings.Development.json
|   |   |   |-- appsettings.json
|   |   |   |-- IdentityAuth.API.csproj
|   |   |   +-- Program.cs
|   |   |-- IdentityAuth.Application/
|   |   |   |-- Abstractions/
|   |   |   |   +-- IdentityContracts.cs
|   |   |   |-- DTOs/
|   |   |   |   +-- AuthDtos.cs
|   |   |   |-- Exceptions/
|   |   |   |   +-- DomainValidationException.cs
|   |   |   |-- Features/
|   |   |   |   +-- Auth/
|   |   |   |       |-- Commands/
|   |   |   |       |   +-- IdentityAuthCommands.cs
|   |   |   |       +-- Queries/
|   |   |   |           +-- IdentityAuthQueries.cs
|   |   |   |-- Services/
|   |   |   |   +-- IdentityAuthService.cs
|   |   |   |-- Validation/
|   |   |   |   +-- AuthValidators.cs
|   |   |   |-- DependencyInjection.cs
|   |   |   +-- IdentityAuth.Application.csproj
|   |   |-- IdentityAuth.Domain/
|   |   |   |-- Entities/
|   |   |   |   |-- OtpRecord.cs
|   |   |   |   |-- RefreshToken.cs
|   |   |   |   +-- User.cs
|   |   |   |-- Enums/
|   |   |   |   |-- UserRole.cs
|   |   |   |   +-- UserStatus.cs
|   |   |   |-- ValueObjects/
|   |   |   |   +-- DealerProfile.cs
|   |   |   +-- IdentityAuth.Domain.csproj
|   |   +-- IdentityAuth.Infrastructure/
|   |       |-- Background/
|   |       |   +-- IdentityOutboxDispatcher.cs
|   |       |-- Integrations/
|   |       |   |-- NotificationGateway.cs
|   |       |   +-- PaymentCreditLimitGateway.cs
|   |       |-- Persistence/
|   |       |   |-- Migrations/
|   |       |   |   |-- 20260328174525_InitialCreate.cs
|   |       |   |   |-- 20260328174525_InitialCreate.Designer.cs
|   |       |   |   |-- 20260411042402_SyncModel_20260411.cs
|   |       |   |   |-- 20260411042402_SyncModel_20260411.Designer.cs
|   |       |   |   +-- IdentityAuthDbContextModelSnapshot.cs
|   |       |   +-- IdentityAuthDbContext.cs
|   |       |-- Repositories/
|   |       |   +-- IdentityUserRepository.cs
|   |       |-- Security/
|   |       |   |-- JwtTokenService.cs
|   |       |   |-- PasswordAndOtpServices.cs
|   |       |   +-- RedisTokenRevocationStore.cs
|   |       |-- DependencyInjection.cs
|   |       +-- IdentityAuth.Infrastructure.csproj
|   |-- LogisticsTracking/
|   |   |-- LogisticsTracking.API/
|   |   |   |-- Controllers/
|   |   |   |   +-- ShipmentsController.cs
|   |   |   |-- Properties/
|   |   |   |   +-- launchSettings.json
|   |   |   |-- appsettings.Development.json
|   |   |   |-- appsettings.json
|   |   |   |-- LogisticsTracking.API.csproj
|   |   |   +-- Program.cs
|   |   |-- LogisticsTracking.Application/
|   |   |   |-- Abstractions/
|   |   |   |   +-- LogisticsContracts.cs
|   |   |   |-- DTOs/
|   |   |   |   +-- LogisticsDtos.cs
|   |   |   |-- Features/
|   |   |   |   +-- Shipments/
|   |   |   |       |-- Commands/
|   |   |   |       |   +-- ShipmentCommands.cs
|   |   |   |       +-- Queries/
|   |   |   |           +-- ShipmentQueries.cs
|   |   |   |-- Services/
|   |   |   |   +-- LogisticsService.cs
|   |   |   |-- Validation/
|   |   |   |   +-- LogisticsValidators.cs
|   |   |   |-- DependencyInjection.cs
|   |   |   +-- LogisticsTracking.Application.csproj
|   |   |-- LogisticsTracking.Domain/
|   |   |   |-- Entities/
|   |   |   |   |-- Shipment.cs
|   |   |   |   |-- ShipmentEvent.cs
|   |   |   |   +-- ShipmentOpsState.cs
|   |   |   |-- Enums/
|   |   |   |   |-- AssignmentDecisionStatus.cs
|   |   |   |   |-- HandoverState.cs
|   |   |   |   +-- ShipmentStatus.cs
|   |   |   +-- LogisticsTracking.Domain.csproj
|   |   +-- LogisticsTracking.Infrastructure/
|   |       |-- Background/
|   |       |   +-- LogisticsOutboxDispatcher.cs
|   |       |-- Llm/
|   |       |   |-- LogisticsLlmOptions.cs
|   |       |   +-- OpenAiLogisticsChatLlmClient.cs
|   |       |-- Persistence/
|   |       |   |-- Migrations/
|   |       |   |   |-- 20260328174620_InitialCreate.cs
|   |       |   |   |-- 20260328174620_InitialCreate.Designer.cs
|   |       |   |   |-- 20260331050843_AddShipmentVehicleNumber.cs
|   |       |   |   |-- 20260331050843_AddShipmentVehicleNumber.Designer.cs
|   |       |   |   |-- 20260401150542_AddShipmentOpsState.cs
|   |       |   |   |-- 20260401150542_AddShipmentOpsState.Designer.cs
|   |       |   |   |-- 20260411042424_SyncModel_20260411.cs
|   |       |   |   |-- 20260411042424_SyncModel_20260411.Designer.cs
|   |       |   |   |-- 20260411063723_SyncPendingModelChanges.cs
|   |       |   |   |-- 20260411063723_SyncPendingModelChanges.Designer.cs
|   |       |   |   |-- 20260411100921_AddShipmentAgentRating.cs
|   |       |   |   |-- 20260411100921_AddShipmentAgentRating.Designer.cs
|   |       |   |   |-- 20260411123000_AddShipmentAssignmentDecision.cs
|   |       |   |   +-- LogisticsTrackingDbContextModelSnapshot.cs
|   |       |   +-- LogisticsTrackingDbContext.cs
|   |       |-- Repositories/
|   |       |   +-- ShipmentRepository.cs
|   |       |-- DependencyInjection.cs
|   |       +-- LogisticsTracking.Infrastructure.csproj
|   |-- Notification/
|   |   |-- Notification.API/
|   |   |   |-- Controllers/
|   |   |   |   +-- NotificationsController.cs
|   |   |   |-- Properties/
|   |   |   |   +-- launchSettings.json
|   |   |   |-- appsettings.Development.json
|   |   |   |-- appsettings.json
|   |   |   |-- Notification.API.csproj
|   |   |   +-- Program.cs
|   |   |-- Notification.Application/
|   |   |   |-- Abstractions/
|   |   |   |   +-- NotificationContracts.cs
|   |   |   |-- DTOs/
|   |   |   |   +-- NotificationDtos.cs
|   |   |   |-- Features/
|   |   |   |   +-- Notifications/
|   |   |   |       |-- Commands/
|   |   |   |       |   +-- NotificationCommands.cs
|   |   |   |       +-- Queries/
|   |   |   |           +-- NotificationQueries.cs
|   |   |   |-- Services/
|   |   |   |   +-- NotificationService.cs
|   |   |   |-- Validation/
|   |   |   |   +-- NotificationValidators.cs
|   |   |   |-- DependencyInjection.cs
|   |   |   +-- Notification.Application.csproj
|   |   |-- Notification.Domain/
|   |   |   |-- Entities/
|   |   |   |   +-- NotificationMessage.cs
|   |   |   |-- Enums/
|   |   |   |   |-- NotificationChannel.cs
|   |   |   |   +-- NotificationStatus.cs
|   |   |   +-- Notification.Domain.csproj
|   |   +-- Notification.Infrastructure/
|   |       |-- Background/
|   |       |   |-- NotificationEmailDispatcher.cs
|   |       |   +-- NotificationEventConsumer.cs
|   |       |-- Email/
|   |       |   |-- EmailSettings.cs
|   |       |   +-- SmtpEmailSender.cs
|   |       |-- Integrations/
|   |       |   +-- IdentityUserContactClient.cs
|   |       |-- Persistence/
|   |       |   |-- Migrations/
|   |       |   |   |-- 20260328174653_InitialCreate.cs
|   |       |   |   |-- 20260328174653_InitialCreate.Designer.cs
|   |       |   |   |-- 20260411042444_SyncModel_20260411.cs
|   |       |   |   |-- 20260411042444_SyncModel_20260411.Designer.cs
|   |       |   |   +-- NotificationDbContextModelSnapshot.cs
|   |       |   +-- NotificationDbContext.cs
|   |       |-- Repositories/
|   |       |   +-- NotificationRepository.cs
|   |       |-- DependencyInjection.cs
|   |       +-- Notification.Infrastructure.csproj
|   |-- Order/
|   |   |-- Order.API/
|   |   |   |-- Controllers/
|   |   |   |   |-- AdminOrdersController.cs
|   |   |   |   +-- OrdersController.cs
|   |   |   |-- Properties/
|   |   |   |   +-- launchSettings.json
|   |   |   |-- appsettings.Development.json
|   |   |   |-- appsettings.json
|   |   |   |-- Order.API.csproj
|   |   |   +-- Program.cs
|   |   |-- Order.Application/
|   |   |   |-- Abstractions/
|   |   |   |   +-- OrderContracts.cs
|   |   |   |-- DTOs/
|   |   |   |   +-- OrderDtos.cs
|   |   |   |-- Features/
|   |   |   |   +-- Orders/
|   |   |   |       |-- Commands/
|   |   |   |       |   +-- OrderCommands.cs
|   |   |   |       +-- Queries/
|   |   |   |           +-- OrderQueries.cs
|   |   |   |-- Services/
|   |   |   |   +-- OrderService.cs
|   |   |   |-- Validation/
|   |   |   |   +-- OrderValidators.cs
|   |   |   |-- DependencyInjection.cs
|   |   |   +-- Order.Application.csproj
|   |   |-- Order.Domain/
|   |   |   |-- Entities/
|   |   |   |   |-- OrderAggregate.cs
|   |   |   |   |-- OrderLine.cs
|   |   |   |   |-- OrderStatusHistory.cs
|   |   |   |   +-- ReturnRequest.cs
|   |   |   |-- Enums/
|   |   |   |   |-- CreditHoldStatus.cs
|   |   |   |   |-- OrderStatus.cs
|   |   |   |   +-- PaymentMode.cs
|   |   |   +-- Order.Domain.csproj
|   |   +-- Order.Infrastructure/
|   |       |-- Background/
|   |       |   +-- OrderOutboxDispatcher.cs
|   |       |-- Integrations/
|   |       |   |-- CatalogInventoryGateway.cs
|   |       |   +-- PaymentCreditCheckGateway.cs
|   |       |-- Persistence/
|   |       |   |-- Migrations/
|   |       |   |   |-- 20260328174554_InitialCreate.cs
|   |       |   |   |-- 20260328174554_InitialCreate.Designer.cs
|   |       |   |   |-- 20260403105135_AddOrderSagaState.cs
|   |       |   |   |-- 20260403105135_AddOrderSagaState.Designer.cs
|   |       |   |   |-- 20260411042414_SyncModel_20260411.cs
|   |       |   |   |-- 20260411042414_SyncModel_20260411.Designer.cs
|   |       |   |   +-- OrderDbContextModelSnapshot.cs
|   |       |   |-- OrderDbContext.cs
|   |       |   +-- OrderSagaStateEntity.cs
|   |       |-- Repositories/
|   |       |   +-- OrderRepository.cs
|   |       |-- Saga/
|   |       |   +-- OrderSagaCoordinator.cs
|   |       |-- DependencyInjection.cs
|   |       +-- Order.Infrastructure.csproj
|   +-- PaymentInvoice/
|       |-- PaymentInvoice.API/
|       |   |-- Controllers/
|       |   |   +-- PaymentController.cs
|       |   |-- Properties/
|       |   |   +-- launchSettings.json
|       |   |-- appsettings.Development.json
|       |   |-- appsettings.json
|       |   |-- PaymentInvoice.API.csproj
|       |   +-- Program.cs
|       |-- PaymentInvoice.Application/
|       |   |-- Abstractions/
|       |   |   +-- PaymentContracts.cs
|       |   |-- DTOs/
|       |   |   +-- PaymentDtos.cs
|       |   |-- Features/
|       |   |   +-- Payments/
|       |   |       |-- Commands/
|       |   |       |   +-- PaymentCommands.cs
|       |   |       +-- Queries/
|       |   |           +-- PaymentQueries.cs
|       |   |-- Options/
|       |   |   +-- DemoDataOptions.cs
|       |   |-- Services/
|       |   |   +-- PaymentInvoiceService.cs
|       |   |-- Validation/
|       |   |   +-- PaymentValidators.cs
|       |   |-- DependencyInjection.cs
|       |   +-- PaymentInvoice.Application.csproj
|       |-- PaymentInvoice.Domain/
|       |   |-- Entities/
|       |   |   |-- DealerCreditAccount.cs
|       |   |   |-- Invoice.cs
|       |   |   |-- InvoiceLine.cs
|       |   |   |-- InvoiceWorkflowActivity.cs
|       |   |   |-- InvoiceWorkflowState.cs
|       |   |   +-- PaymentRecord.cs
|       |   |-- Enums/
|       |   |   |-- GstType.cs
|       |   |   |-- InvoiceWorkflowActivityType.cs
|       |   |   |-- InvoiceWorkflowStatus.cs
|       |   |   +-- PaymentMode.cs
|       |   +-- PaymentInvoice.Domain.csproj
|       +-- PaymentInvoice.Infrastructure/
|           |-- Background/
|           |   +-- PaymentOutboxDispatcher.cs
|           |-- Documents/
|           |   +-- QuestPdfInvoiceGenerator.cs
|           |-- PaymentGateway/
|           |   |-- PaymentGatewaySettings.cs
|           |   +-- RazorpayPaymentGateway.cs
|           |-- Persistence/
|           |   |-- Migrations/
|           |   |   |-- 20260328174637_InitialCreate.cs
|           |   |   |-- 20260328174637_InitialCreate.Designer.cs
|           |   |   |-- 20260401150530_AddInvoiceWorkflowStateAndActivity.cs
|           |   |   |-- 20260401150530_AddInvoiceWorkflowStateAndActivity.Designer.cs
|           |   |   |-- 20260411042434_SyncModel_20260411.cs
|           |   |   |-- 20260411042434_SyncModel_20260411.Designer.cs
|           |   |   +-- PaymentInvoiceDbContextModelSnapshot.cs
|           |   +-- PaymentInvoiceDbContext.cs
|           |-- Repositories/
|           |   +-- PaymentRepository.cs
|           |-- DependencyInjection.cs
|           +-- PaymentInvoice.Infrastructure.csproj
|-- src/
|   |-- BuildingBlocks/
|   |   |-- Application/
|   |   |   |-- Behaviors/
|   |   |   |   |-- IdempotencyBehavior.cs
|   |   |   |   |-- LoggingBehavior.cs
|   |   |   |   |-- TransactionBehavior.cs
|   |   |   |   +-- ValidationBehavior.cs
|   |   |   +-- Contracts/
|   |   |       |-- ICacheService.cs
|   |   |       |-- IIdempotencyStore.cs
|   |   |       |-- IIdempotentRequest.cs
|   |   |       +-- IOutboxRepository.cs
|   |   |-- Extensions/
|   |   |   |-- RedisCacheService.cs
|   |   |   |-- RedisIdempotencyStore.cs
|   |   |   +-- ServiceCollectionExtensions.cs
|   |   |-- Persistence/
|   |   |   |-- IApplicationDbContext.cs
|   |   |   |-- OutboxMessage.cs
|   |   |   +-- OutboxStatus.cs
|   |   +-- BuildingBlocks.csproj
|   +-- SharedKernel/
|       |-- Abstractions/
|       |   |-- Entity.cs
|       |   +-- ValueObject.cs
|       |-- Messaging/
|       |   +-- IntegrationEvent.cs
|       +-- SharedKernel.csproj
|-- supply-chain-frontend/
|   |-- .vscode/
|   |   |-- extensions.json
|   |   |-- launch.json
|   |   |-- mcp.json
|   |   +-- tasks.json
|   |-- public/
|   |   |-- assets/
|   |   |   |-- login/
|   |   |   |   |-- supply-chain-ai-loop.svg
|   |   |   |   +-- supply-chain-real.mp4
|   |   |   +-- product-images/
|   |   |       |-- cbl-001-ai.jpg
|   |   |       |-- glv-003-ai.jpg
|   |   |       +-- mtr-002-ai.jpg
|   |   +-- favicon.ico
|   |-- scripts/
|   |   +-- download-ai-product-images.mjs
|   |-- src/
|   |   |-- app/
|   |   |   |-- core/
|   |   |   |   |-- api/
|   |   |   |   |   |-- admin-api.service.ts
|   |   |   |   |   |-- auth-api.service.ts
|   |   |   |   |   |-- catalog-api.service.ts
|   |   |   |   |   |-- logistics-api.service.ts
|   |   |   |   |   |-- notification-api.service.ts
|   |   |   |   |   |-- order-api.service.ts
|   |   |   |   |   +-- payment-api.service.ts
|   |   |   |   |-- guards/
|   |   |   |   |   |-- auth.guard.ts
|   |   |   |   |   +-- role.guard.ts
|   |   |   |   |-- interceptors/
|   |   |   |   |   |-- auth.interceptor.ts
|   |   |   |   |   |-- correlation-id.interceptor.ts
|   |   |   |   |   |-- error.interceptor.ts
|   |   |   |   |   |-- loading.interceptor.ts
|   |   |   |   |   +-- utc-date-normalization.interceptor.ts
|   |   |   |   |-- mocks/
|   |   |   |   |   |-- payment-invoice.mocks.ts
|   |   |   |   |   +-- vehicle.mocks.ts
|   |   |   |   |-- models/
|   |   |   |   |   |-- auth.models.ts
|   |   |   |   |   |-- catalog.models.ts
|   |   |   |   |   |-- enums.ts
|   |   |   |   |   |-- index.ts
|   |   |   |   |   |-- logistics.models.ts
|   |   |   |   |   |-- notification.models.ts
|   |   |   |   |   |-- order.models.ts
|   |   |   |   |   |-- payment.models.ts
|   |   |   |   |   +-- shared.models.ts
|   |   |   |   |-- services/
|   |   |   |   |   |-- inventory-alert-rules.service.ts
|   |   |   |   |   |-- invoice-workflow.service.ts
|   |   |   |   |   |-- invoice-workflow-activity.service.ts
|   |   |   |   |   |-- notification-preferences.service.ts
|   |   |   |   |   |-- order-ops-notes.service.ts
|   |   |   |   |   |-- order-sla.service.spec.ts
|   |   |   |   |   |-- order-sla.service.ts
|   |   |   |   |   |-- product-image.service.ts
|   |   |   |   |   |-- shipment-delivery-attempts.service.ts
|   |   |   |   |   |-- shipment-eta.service.ts
|   |   |   |   |   |-- shipment-ops-queue.service.ts
|   |   |   |   |   +-- toast.service.ts
|   |   |   |   +-- stores/
|   |   |   |       |-- auth.store.ts
|   |   |   |       |-- cart.store.ts
|   |   |   |       +-- loading.store.ts
|   |   |   |-- features/
|   |   |   |   |-- admin/
|   |   |   |   |   |-- agent-create/
|   |   |   |   |   |   |-- agent-create.component.html
|   |   |   |   |   |   +-- agent-create.component.ts
|   |   |   |   |   |-- dealer-detail/
|   |   |   |   |   |   |-- dealer-detail.component.html
|   |   |   |   |   |   |-- dealer-detail.component.scss
|   |   |   |   |   |   +-- dealer-detail.component.ts
|   |   |   |   |   +-- dealer-list/
|   |   |   |   |       |-- dealer-list.component.html
|   |   |   |   |       +-- dealer-list.component.ts
|   |   |   |   |-- auth/
|   |   |   |   |   |-- forgot-password/
|   |   |   |   |   |   |-- forgot-password.component.html
|   |   |   |   |   |   |-- forgot-password.component.scss
|   |   |   |   |   |   +-- forgot-password.component.ts
|   |   |   |   |   |-- login/
|   |   |   |   |   |   |-- login.component.html
|   |   |   |   |   |   |-- login.component.scss
|   |   |   |   |   |   +-- login.component.ts
|   |   |   |   |   |-- register/
|   |   |   |   |   |   |-- register.component.html
|   |   |   |   |   |   |-- register.component.scss
|   |   |   |   |   |   +-- register.component.ts
|   |   |   |   |   +-- unauthorized/
|   |   |   |   |       |-- unauthorized.component.html
|   |   |   |   |       |-- unauthorized.component.scss
|   |   |   |   |       +-- unauthorized.component.ts
|   |   |   |   |-- cart/
|   |   |   |   |   |-- checkout/
|   |   |   |   |   |   |-- checkout.component.html
|   |   |   |   |   |   |-- checkout.component.scss
|   |   |   |   |   |   +-- checkout.component.ts
|   |   |   |   |   |-- cart.component.html
|   |   |   |   |   |-- cart.component.scss
|   |   |   |   |   +-- cart.component.ts
|   |   |   |   |-- catalog/
|   |   |   |   |   |-- product-detail/
|   |   |   |   |   |   |-- product-detail.component.html
|   |   |   |   |   |   |-- product-detail.component.scss
|   |   |   |   |   |   +-- product-detail.component.ts
|   |   |   |   |   |-- product-form/
|   |   |   |   |   |   |-- product-form.component.html
|   |   |   |   |   |   |-- product-form.component.scss
|   |   |   |   |   |   +-- product-form.component.ts
|   |   |   |   |   +-- product-list/
|   |   |   |   |       |-- product-list.component.html
|   |   |   |   |       |-- product-list.component.scss
|   |   |   |   |       +-- product-list.component.ts
|   |   |   |   |-- dashboard/
|   |   |   |   |   |-- dashboard.component.html
|   |   |   |   |   |-- dashboard.component.scss
|   |   |   |   |   +-- dashboard.component.ts
|   |   |   |   |-- logistics/
|   |   |   |   |   |-- shipment-detail/
|   |   |   |   |   |   |-- shipment-detail.component.html
|   |   |   |   |   |   |-- shipment-detail.component.scss
|   |   |   |   |   |   +-- shipment-detail.component.ts
|   |   |   |   |   +-- shipment-list/
|   |   |   |   |       |-- shipment-list.component.html
|   |   |   |   |       +-- shipment-list.component.ts
|   |   |   |   |-- notifications/
|   |   |   |   |   +-- notification-list/
|   |   |   |   |       |-- notification-list.component.html
|   |   |   |   |       |-- notification-list.component.scss
|   |   |   |   |       +-- notification-list.component.ts
|   |   |   |   |-- orders/
|   |   |   |   |   |-- order-detail/
|   |   |   |   |   |   |-- order-detail.component.html
|   |   |   |   |   |   |-- order-detail.component.scss
|   |   |   |   |   |   +-- order-detail.component.ts
|   |   |   |   |   |-- order-list/
|   |   |   |   |   |   |-- order-list.component.html
|   |   |   |   |   |   +-- order-list.component.ts
|   |   |   |   |   +-- order-tracking/
|   |   |   |   |       |-- order-tracking.component.html
|   |   |   |   |       |-- order-tracking.component.scss
|   |   |   |   |       +-- order-tracking.component.ts
|   |   |   |   |-- payments/
|   |   |   |   |   |-- invoice-detail/
|   |   |   |   |   |   |-- invoice-detail.component.html
|   |   |   |   |   |   |-- invoice-detail.component.scss
|   |   |   |   |   |   +-- invoice-detail.component.ts
|   |   |   |   |   +-- invoice-list/
|   |   |   |   |       |-- invoice-list.component.html
|   |   |   |   |       +-- invoice-list.component.ts
|   |   |   |   +-- profile/
|   |   |   |       |-- profile.component.html
|   |   |   |       |-- profile.component.scss
|   |   |   |       +-- profile.component.ts
|   |   |   |-- shared/
|   |   |   |   +-- components/
|   |   |   |       |-- app-shell/
|   |   |   |       |   |-- app-shell.component.html
|   |   |   |       |   |-- app-shell.component.scss
|   |   |   |       |   +-- app-shell.component.ts
|   |   |   |       |-- confirm-dialog/
|   |   |   |       |   |-- confirm-dialog.component.html
|   |   |   |       |   +-- confirm-dialog.component.ts
|   |   |   |       |-- page-banner/
|   |   |   |       |   |-- page-banner.component.html
|   |   |   |       |   |-- page-banner.component.scss
|   |   |   |       |   +-- page-banner.component.ts
|   |   |   |       |-- pagination/
|   |   |   |       |   |-- pagination.component.html
|   |   |   |       |   +-- pagination.component.ts
|   |   |   |       +-- toast-container/
|   |   |   |           |-- toast-container.component.html
|   |   |   |           |-- toast-container.component.scss
|   |   |   |           +-- toast-container.component.ts
|   |   |   |-- app.config.server.ts
|   |   |   |-- app.config.ts
|   |   |   |-- app.html
|   |   |   |-- app.routes.server.ts
|   |   |   |-- app.routes.ts
|   |   |   |-- app.scss
|   |   |   |-- app.ts
|   |   |   +-- smoke.spec.ts
|   |   |-- assets/
|   |   |   +-- images/
|   |   |       +-- banners/
|   |   |           |-- orders-processing.png
|   |   |           |-- shipment-tracking.png
|   |   |           +-- warehouse-catalog.png
|   |   |-- environments/
|   |   |   |-- environment.prod.ts
|   |   |   +-- environment.ts
|   |   |-- index.html
|   |   |-- main.server.ts
|   |   |-- main.ts
|   |   |-- server.ts
|   |   +-- styles.scss
|   |-- .editorconfig
|   |-- .gitignore
|   |-- .prettierrc
|   |-- angular.json
|   |-- package.json
|   |-- package-lock.json
|   |-- proxy.conf.json
|   |-- tsconfig.app.json
|   |-- tsconfig.json
|   |-- tsconfig.spec.json
|   +-- ui-demo.html
|-- tests/
|   |-- CatalogInventory.Domain.Tests/
|   |   |-- CatalogInventory.Domain.Tests.csproj
|   |   +-- UnitTest1.cs
|   |-- IdentityAuth.Domain.Tests/
|   |   |-- IdentityAuth.Domain.Tests.csproj
|   |   +-- UnitTest1.cs
|   |-- LogisticsTracking.Domain.Tests/
|   |   |-- LogisticsTracking.Domain.Tests.csproj
|   |   +-- UnitTest1.cs
|   |-- Notification.Domain.Tests/
|   |   |-- Notification.Domain.Tests.csproj
|   |   +-- UnitTest1.cs
|   |-- Order.Domain.Tests/
|   |   |-- Order.Domain.Tests.csproj
|   |   |-- OrderServiceReturnApprovalTests.cs
|   |   +-- UnitTest1.cs
|   +-- PaymentInvoice.Domain.Tests/
|       |-- PaymentInvoice.Domain.Tests.csproj
|       +-- UnitTest1.cs
|-- .editorconfig
|-- .env.example
|-- .gitignore
|-- docker-compose.override.yml
|-- docker-compose.yml
|-- global.json
|-- package.json
|-- package-lock.json
|-- start-backend.ps1
+-- SupplyChainPlatform.slnx
~~~

