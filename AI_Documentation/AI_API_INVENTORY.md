# AI API Inventory

## Gateway

Frontend używa ścieżek przez Ocelot Gateway:

- `/identity/*` -> IdentityAuth `:8001`.
- `/catalog/*` -> CatalogInventory `:8002`.
- `/orders/*` -> Order `:8003`.
- `/logistics/*` -> LogisticsTracking `:8004`.
- `/payments/*` -> PaymentInvoice `:8005`.
- `/notifications/*` -> Notification `:8006`.

Publiczne wyjatki w gatewayu i frontendzie obejmuja logowanie/rejestracje, publiczne listowanie katalogu, wybrane credit-check i ingest notyfikacji. Szczegóły zawsze weryfikuj w `gateway/OcelotGateway/ocelot.json` oraz w atrybutach kontrolerow.

## IdentityAuth

Base downstream: `/api`.

- `POST /api/auth/register` anon, body `RegisterDealerRequest`, response `RegisterDealerResponse`.
- `POST /api/auth/login` anon, body `LoginRequest`, response `AuthResponse`, ustawia cookie `refreshToken`.
- `POST /api/auth/refresh` anon, czyta cookie, response `AuthResponse`.
- `POST /api/auth/forgot-password` anon.
- `POST /api/auth/reset-password` anon.
- `POST /api/auth/change-password` auth.
- `POST /api/auth/logout` auth.
- `GET /api/users/profile` auth.
- `GET /api/admin/dealers` Admin, query `page`, `pageSize`, `search`.
- `GET /api/admin/dealers/{id}` Admin.
- `PUT /api/admin/dealers/{id}/approve` Admin.
- `PUT /api/admin/dealers/{id}/reject` Admin.
- `PUT /api/admin/dealers/{id}/credit-limit` Admin.
- `GET /api/admin/users/agents` Admin/Logistics.
- `POST /api/admin/users/agents` Admin.
- `GET /api/internal/users/{id}/contact` internal API key.

## CatalogInventory

- `GET /api/products` anon, query `page`, `size`, `includeInactive`.
- `GET /api/products/categories` anon.
- `GET /api/products/{id}` anon.
- `GET /api/products/search?q=` anon.
- `POST /api/products` Admin.
- `PUT /api/products/{id}` Admin.
- `PUT /api/products/{id}/deactivate` Admin.
- `POST /api/products/{id}/restock` Admin/Warehouse.
- `GET /api/products/{id}/stock` Admin/Warehouse.
- `GET /api/products/{id}/reviews` anon.
- `POST /api/products/{id}/reviews` Dealer.
- `PUT /api/products/reviews/{reviewId}/approve` Admin.
- `PUT /api/products/reviews/{reviewId}/reject` Admin.
- `POST /api/inventory/soft-lock` Admin/Dealer/OrderService.
- `POST /api/inventory/hard-deduct` Admin.
- `POST /api/inventory/release-soft-lock` Admin/OrderService.
- `POST /api/inventory/subscriptions` Dealer.
- `DELETE /api/inventory/subscriptions` Dealer.
- `POST /api/internal/inventory/soft-lock` internal API key.
- `POST /api/internal/inventory/hard-deduct` internal API key.
- `POST /api/internal/inventory/release-soft-lock` internal API key.
- `POST /api/internal/inventory/restock` internal API key.

## Order

- `POST /api/orders` Dealer, body `CreateOrderRequest`.
- `GET /api/orders/my` Dealer.
- `GET /api/orders/{id}` auth; dealer widzi tylko swoje, role wewnętrzne widza więcej.
- `GET /api/orders/{id}/saga` auth.
- `PUT /api/orders/{id}/status` Admin/Logistics przez logike roli w kontrolerze/serwisie.
- `POST /api/orders/{id}/cancel` Dealer/Admin.
- `POST /api/orders/{id}/returns` Dealer.
- `GET /api/admin/orders` Admin/Warehouse/Logistics.
- `GET /api/admin/orders/analytics` Admin/Warehouse/Logistics.
- `POST /api/admin/orders/bulk-status` Admin/Logistics.
- `PUT /api/admin/orders/{id}/approve-hold` Admin.
- `PUT /api/admin/orders/{id}/reject-hold` Admin.
- `PUT /api/admin/orders/{id}/approve-return` Admin.
- `PUT /api/admin/orders/{id}/reject-return` Admin.

## LogisticsTracking

- `POST /api/logistics/shipments` Admin/Logistics.
- `GET /api/logistics/shipments/{shipmentId}` Admin/Logistics/Agent/Dealer, scoped dla Agent/Dealer.
- `GET /api/logistics/shipments/my` Dealer.
- `GET /api/logistics/shipments` Admin/Logistics.
- `GET /api/logistics/shipments/assigned` Agent.
- `PUT /api/logistics/shipments/{shipmentId}/assign-agent` Admin/Logistics.
- `PUT /api/logistics/shipments/{shipmentId}/assignment/accept` Agent.
- `PUT /api/logistics/shipments/{shipmentId}/assignment/reject` Agent.
- `PUT /api/logistics/shipments/{shipmentId}/agent-rating` Dealer.
- `PUT /api/logistics/shipments/{shipmentId}/assign-vehicle` Admin/Logistics.
- `PUT /api/logistics/shipments/{shipmentId}/status` Admin/Logistics/Agent.
- `GET /api/logistics/shipments/{shipmentId}/ops-state` Admin/Logistics/Agent/Dealer.
- `POST /api/logistics/shipments/ops-states/batch` Admin/Logistics/Agent/Dealer.
- `PUT /api/logistics/shipments/{shipmentId}/ops-state` Admin/Logistics.
- `POST /api/logistics/shipments/chatbot/ask` Admin/Logistics/Agent/Dealer/Warehouse.

## PaymentInvoice

- `POST /api/payment/gateway/orders` Dealer.
- `POST /api/payment/gateway/verify` Dealer.
- `POST /api/payment/dealers/{dealerId}/account` Admin.
- `GET /api/payment/dealers/{dealerId}/credit-check` Admin/Dealer, dealer scoped.
- `GET /api/payment/internal/dealers/{dealerId}/credit-check` internal API key.
- `PUT /api/payment/dealers/{dealerId}/credit-limit` Admin.
- `PUT /api/payment/internal/dealers/{dealerId}/credit-limit` internal API key.
- `POST /api/payment/dealers/{dealerId}/settlements` Admin/Dealer, dealer scoped.
- `POST /api/payment/internal/dealers/{dealerId}/settlements` internal API key.
- `POST /api/payment/internal/dealers/{dealerId}/outstanding` internal API key.
- `POST /api/payment/invoices` Admin.
- `GET /api/payment/invoices/{invoiceId}` Admin/Dealer.
- `GET /api/payment/dealers/{dealerId}/invoices` Admin/Dealer, dealer scoped.
- `GET /api/payment/invoices/{invoiceId}/workflow` Admin/Dealer.
- `GET /api/payment/dealers/{dealerId}/invoice-workflows` Admin/Dealer, dealer scoped.
- `PUT /api/payment/invoices/{invoiceId}/workflow` Admin/Dealer.
- `GET /api/payment/invoices/{invoiceId}/workflow-activities` Admin/Dealer.
- `POST /api/payment/invoices/{invoiceId}/workflow-activities` Admin/Dealer.
- `GET /api/payment/invoices/{invoiceId}/download` Admin/Dealer.

## Notification

- `POST /api/notifications/manual` Admin.
- `POST /api/notifications/ingest` internal API key.
- `GET /api/notifications/my` auth.
- `GET /api/notifications` Admin.
- `GET /api/notifications/{notificationId}` auth, scoped dla nie-admina.
- `PUT /api/notifications/{notificationId}/sent` Admin.
- `PUT /api/notifications/{notificationId}/failed` Admin.
- `PUT /api/notifications/{notificationId}/read` auth, scoped dla nie-admina.
- `PUT /api/notifications/{notificationId}/unread` auth, scoped dla nie-admina.
