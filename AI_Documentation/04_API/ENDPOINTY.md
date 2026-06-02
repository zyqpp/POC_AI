# Endpointy API

## IdentityAuth

| Kontroler | Base route | Endpointy | Role | Status |
|---|---|---|---|---|
| `AuthController` | `api/auth` | `POST register`, `POST login`, `POST refresh`, `POST forgot-password`, `POST reset-password`, `POST change-password`, `POST logout` | publiczne dla większości, `change-password` i `logout` wymagają auth | potwierdzone |
| `UsersController` | `api/users` | `GET profile` | authenticated | potwierdzone |
| `AdminDealersController` | `api/admin/dealers` | `GET`, `GET {id}`, `PUT approve`, `PUT reject`, `PUT credit-limit` | Admin | potwierdzone |
| `AdminUsersController` | `api/admin/users` | `GET agents`, `POST agents` | Admin/Logistics dla listy, Admin dla tworzenia | potwierdzone |
| `InternalUsersController` | `api/internal/users` | `GET {id}/contact` | internal API | potwierdzone |

### Szczegółowe endpointy IdentityAuth

| Moduł | Metoda | Path | Rola | Link |
|---|---|---|---|---|
| Identity / Auth | `POST` | `/identity/api/auth/register` | `AllowAnonymous` | [API_IDENTITY](API_IDENTITY.md#post-apiauthregister) |
| Identity / Auth | `POST` | `/identity/api/auth/login` | `AllowAnonymous` | [API_IDENTITY](API_IDENTITY.md#post-apiauthlogin) |
| Identity / Auth | `POST` | `/identity/api/auth/refresh` | `AllowAnonymous` | [API_IDENTITY](API_IDENTITY.md#post-apiauthrefresh) |
| Identity / Auth | `POST` | `/identity/api/auth/forgot-password` | `AllowAnonymous` | [API_IDENTITY](API_IDENTITY.md#post-apiauthforgot-password) |
| Identity / Auth | `POST` | `/identity/api/auth/reset-password` | `AllowAnonymous` | [API_IDENTITY](API_IDENTITY.md#post-apiauthreset-password) |
| Identity / Auth | `POST` | `/identity/api/auth/change-password` | `Authorize` | [API_IDENTITY](API_IDENTITY.md#post-apiauthchange-password) |
| Identity / Auth | `POST` | `/identity/api/auth/logout` | `Authorize` | [API_IDENTITY](API_IDENTITY.md#post-apiauthlogout) |
| Identity / Users | `GET` | `/identity/api/users/profile` | `Authorize` | [API_IDENTITY](API_IDENTITY.md#get-apiusersprofile) |
| Identity / Admin Dealers | `GET` | `/identity/api/admin/dealers` | `Admin` | [API_IDENTITY](API_IDENTITY.md#get-apiadmindealers) |
| Identity / Admin Dealers | `GET` | `/identity/api/admin/dealers/{id}` | `Admin` | [API_IDENTITY](API_IDENTITY.md#get-apiadmindealersid) |
| Identity / Admin Dealers | `PUT` | `/identity/api/admin/dealers/{id}/approve` | `Admin` | [API_IDENTITY](API_IDENTITY.md#put-apiadmindealersidapprove) |
| Identity / Admin Dealers | `PUT` | `/identity/api/admin/dealers/{id}/reject` | `Admin` | [API_IDENTITY](API_IDENTITY.md#put-apiadmindealersidreject) |
| Identity / Admin Dealers | `PUT` | `/identity/api/admin/dealers/{id}/credit-limit` | `Admin` | [API_IDENTITY](API_IDENTITY.md#put-apiadmindealersidcredit-limit) |
| Identity / Admin Users | `GET` | `/identity/api/admin/users/agents` | `Admin,Logistics` | [API_IDENTITY](API_IDENTITY.md#get-apiadminusersagents) |
| Identity / Admin Users | `POST` | `/identity/api/admin/users/agents` | `Admin` | [API_IDENTITY](API_IDENTITY.md#post-apiadminusersagents) |

## CatalogInventory

| Kontroler | Base route | Endpointy | Role | Status |
|---|---|---|---|---|
| `ProductsController` | `api/products` | CRUD produktu, kategorie, search, stock, reviews, moderacja reviews | publiczne dla list/detali, Admin/Warehouse/Dealer zależnie od akcji | potwierdzone |
| `InventoryController` | `api/inventory` | `soft-lock`, `hard-deduct`, `release-soft-lock`, `subscriptions` | Admin, Dealer, Warehouse, OrderService | potwierdzone |
| `InternalInventoryController` | `api/internal/inventory` | `soft-lock`, `hard-deduct`, `release-soft-lock`, `restock` | internal API key | potwierdzone |

## Order

| Kontroler | Base route | Endpointy | Role | Status |
|---|---|---|---|---|
| `OrdersController` | `api/orders` | `POST`, `GET my`, `GET {id}`, `GET {id}/saga`, `PUT {id}/status`, `POST cancel`, `POST returns` | Dealer, authenticated, Dealer/Admin zależnie od akcji | potwierdzone |
| `AdminOrdersController` | `api/admin/orders` | `GET`, `GET analytics`, `POST bulk-status`, hold approval/reject, return approval/reject | Admin, Warehouse, Logistics; część tylko Admin | potwierdzone |

## LogisticsTracking

| Kontroler | Base route | Endpointy | Role | Status |
|---|---|---|---|---|
| `ShipmentsController` | `api/logistics/shipments` | tworzenie, listy, szczegóły, assignment, rating, vehicle, status, ops-state, chatbot | Admin, Logistics, Agent, Dealer, Warehouse zależnie od akcji | potwierdzone |

### Szczegółowe endpointy LogisticsTracking

| Moduł | Metoda | Path | Rola | Link |
|---|---|---|---|---|
| Logistics / Shipments | `POST` | `/logistics/api/logistics/shipments` | `Admin,Logistics` | [API_LOGISTICS](API_LOGISTICS.md#post-apilogisticsshipments) |
| Logistics / Shipments | `GET` | `/logistics/api/logistics/shipments` | `Admin,Logistics` | [API_LOGISTICS](API_LOGISTICS.md#get-apilogisticsshipments) |
| Logistics / Shipments | `GET` | `/logistics/api/logistics/shipments/{shipmentId}` | `Admin,Logistics,Agent,Dealer` | [API_LOGISTICS](API_LOGISTICS.md#get-apilogisticsshipmentsshipmentid) |
| Logistics / Shipments | `GET` | `/logistics/api/logistics/shipments/my` | `Dealer` | [API_LOGISTICS](API_LOGISTICS.md#get-apilogisticsshipmentsmy) |
| Logistics / Shipments | `GET` | `/logistics/api/logistics/shipments/assigned` | `Agent` | [API_LOGISTICS](API_LOGISTICS.md#get-apilogisticsshipmentsassigned) |
| Logistics / Assignment | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/assign-agent` | `Admin,Logistics` | [API_LOGISTICS](API_LOGISTICS.md#put-apilogisticsshipmentsshipmentidassign-agent) |
| Logistics / Assignment | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/assignment/accept` | `Agent` | [API_LOGISTICS](API_LOGISTICS.md#put-apilogisticsshipmentsshipmentidassignmentaccept) |
| Logistics / Assignment | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/assignment/reject` | `Agent` | [API_LOGISTICS](API_LOGISTICS.md#put-apilogisticsshipmentsshipmentidassignmentreject) |
| Logistics / Assignment | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/assign-vehicle` | `Admin,Logistics` | [API_LOGISTICS](API_LOGISTICS.md#put-apilogisticsshipmentsshipmentidassign-vehicle) |
| Logistics / Status | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/status` | `Admin,Logistics,Agent` | [API_LOGISTICS](API_LOGISTICS.md#put-apilogisticsshipmentsshipmentidstatus) |
| Logistics / Rating | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/agent-rating` | `Dealer` | [API_LOGISTICS](API_LOGISTICS.md#put-apilogisticsshipmentsshipmentidagent-rating) |
| Logistics / Ops State | `GET` | `/logistics/api/logistics/shipments/{shipmentId}/ops-state` | `Admin,Logistics,Agent,Dealer` | [API_LOGISTICS](API_LOGISTICS.md#get-apilogisticsshipmentsshipmentidops-state) |
| Logistics / Ops State | `POST` | `/logistics/api/logistics/shipments/ops-states/batch` | `Admin,Logistics,Agent,Dealer` | [API_LOGISTICS](API_LOGISTICS.md#post-apilogisticsshipmentsops-statesbatch) |
| Logistics / Ops State | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/ops-state` | `Admin,Logistics` | [API_LOGISTICS](API_LOGISTICS.md#put-apilogisticsshipmentsshipmentidops-state) |
| Logistics / Chatbot | `POST` | `/logistics/api/logistics/shipments/chatbot/ask` | `Admin,Logistics,Agent,Dealer,Warehouse` | [API_LOGISTICS](API_LOGISTICS.md#post-apilogisticsshipmentschatbotask) |

## PaymentInvoice

| Kontroler | Base route | Endpointy | Role | Status |
|---|---|---|---|---|
| `PaymentController` | `api/payment` | gateway payment, dealer account, credit check, credit limit, settlements, outstanding, invoices, workflow, activities, PDF | Admin, Dealer, internal zależnie od akcji | potwierdzone |

### Szczegółowe endpointy PaymentInvoice

| Moduł | Metoda | Path | Rola | Link |
|---|---|---|---|---|
| Payment / Invoices | `POST` | `/payments/api/payment/invoices` | `Admin` | [API_INVOICES](API_INVOICES.md#post-apipaymentinvoices) |
| Payment / Invoices | `GET` | `/payments/api/payment/invoices/{invoiceId}` | `Admin,Dealer` | [API_INVOICES](API_INVOICES.md#get-apipaymentinvoicesinvoiceid) |
| Payment / Invoices | `GET` | `/payments/api/payment/dealers/{dealerId}/invoices` | `Admin,Dealer` | [API_INVOICES](API_INVOICES.md#get-apipaymentdealersdealeridInvoices) |
| Payment / Invoices | `GET` | `/payments/api/payment/invoices/{invoiceId}/download` | `Admin,Dealer` | [API_INVOICES](API_INVOICES.md#get-apipaymentinvoicesinvoiceiddownload) |
| Payment / Workflow | `GET` | `/payments/api/payment/invoices/{invoiceId}/workflow` | `Admin,Dealer` | [API_INVOICES](API_INVOICES.md#get-apipaymentinvoicesinvoiceidworkflow) |
| Payment / Workflow | `PUT` | `/payments/api/payment/invoices/{invoiceId}/workflow` | `Admin,Dealer` | [API_INVOICES](API_INVOICES.md#put-apipaymentinvoicesinvoiceidworkflow) |
| Payment / Workflow | `GET` | `/payments/api/payment/dealers/{dealerId}/invoice-workflows` | `Admin,Dealer` | [API_INVOICES](API_INVOICES.md#get-apipaymentdealersdealeridinvoice-workflows) |
| Payment / Activities | `GET` | `/payments/api/payment/invoices/{invoiceId}/workflow-activities` | `Admin,Dealer` | [API_INVOICES](API_INVOICES.md#get-apipaymentinvoicesinvoiceidworkflow-activities) |
| Payment / Activities | `POST` | `/payments/api/payment/invoices/{invoiceId}/workflow-activities` | `Admin,Dealer` | [API_INVOICES](API_INVOICES.md#post-apipaymentinvoicesinvoiceidworkflow-activities) |
| Payment / Gateway | `POST` | `/payments/api/payment/gateway/orders` | `Dealer` | [API_INVOICES](API_INVOICES.md#post-apipaymentgatewayorders) |
| Payment / Gateway | `POST` | `/payments/api/payment/gateway/verify` | `Dealer` | [API_INVOICES](API_INVOICES.md#post-apipaymentgatewayverify) |
| Payment / Credit | `POST` | `/payments/api/payment/dealers/{dealerId}/account` | `Admin` | [API_INVOICES](API_INVOICES.md#post-apipaymentdealersdealeridaccount) |
| Payment / Credit | `GET` | `/payments/api/payment/dealers/{dealerId}/credit-check` | `Admin,Dealer` | [API_INVOICES](API_INVOICES.md#get-apipaymentdealersdealeridcredit-check) |
| Payment / Credit | `PUT` | `/payments/api/payment/dealers/{dealerId}/credit-limit` | `Admin` | [API_INVOICES](API_INVOICES.md#put-apipaymentdealersdealeridcredit-limit) |
| Payment / Credit | `POST` | `/payments/api/payment/dealers/{dealerId}/settlements` | `Admin,Dealer` | [API_INVOICES](API_INVOICES.md#post-apipaymentdealersdealeridSettlements) |
| Payment / Internal | `GET` | `/payments/api/payment/internal/dealers/{dealerId}/credit-check` | `X-Internal-Api-Key` | [API_INVOICES](API_INVOICES.md#6-endpointy-wewnętrzne-internal) |
| Payment / Internal | `PUT` | `/payments/api/payment/internal/dealers/{dealerId}/credit-limit` | `X-Internal-Api-Key` | [API_INVOICES](API_INVOICES.md#6-endpointy-wewnętrzne-internal) |
| Payment / Internal | `POST` | `/payments/api/payment/internal/dealers/{dealerId}/settlements` | `X-Internal-Api-Key` | [API_INVOICES](API_INVOICES.md#6-endpointy-wewnętrzne-internal) |
| Payment / Internal | `POST` | `/payments/api/payment/internal/dealers/{dealerId}/outstanding` | `X-Internal-Api-Key` | [API_INVOICES](API_INVOICES.md#6-endpointy-wewnętrzne-internal) |

## Notification

| Kontroler | Base route | Endpointy | Role | Status |
|---|---|---|---|---|
| `NotificationsController` | `api/notifications` | manual, ingest, my, all, details, sent, failed, read, unread | Admin dla operacji administracyjnych, authenticated dla użytkownika | potwierdzone |

### Szczegółowe endpointy Notification

| Moduł | Metoda | Path | Rola | Link |
|---|---|---|---|---|
| Notification | `POST` | `/notification/api/notifications/manual` | `Admin` | [API_NOTIFICATIONS](API_NOTIFICATIONS.md#post-apinotificationsmanual) |
| Notification | `POST` | `/notification/api/notifications/ingest` | `X-Internal-Api-Key` | [API_NOTIFICATIONS](API_NOTIFICATIONS.md#post-apinotificationsingest) |
| Notification | `GET` | `/notification/api/notifications/my` | `Authorize` | [API_NOTIFICATIONS](API_NOTIFICATIONS.md#get-apinotificationsmy) |
| Notification | `GET` | `/notification/api/notifications` | `Admin` | [API_NOTIFICATIONS](API_NOTIFICATIONS.md#get-apinotifications) |
| Notification | `GET` | `/notification/api/notifications/{notificationId}` | `Authorize` (scope) | [API_NOTIFICATIONS](API_NOTIFICATIONS.md#get-apinotificationsnotificationid) |
| Notification | `PUT` | `/notification/api/notifications/{notificationId}/read` | `Authorize` (właściciel lub Admin) | [API_NOTIFICATIONS](API_NOTIFICATIONS.md#put-apinotificationsnotificationidread) |
| Notification | `PUT` | `/notification/api/notifications/{notificationId}/unread` | `Authorize` (właściciel lub Admin) | [API_NOTIFICATIONS](API_NOTIFICATIONS.md#put-apinotificationsnotificationidunread) |
| Notification | `PUT` | `/notification/api/notifications/{notificationId}/sent` | `Admin` | [API_NOTIFICATIONS](API_NOTIFICATIONS.md#put-apinotificationsnotificationidsent) |
| Notification | `PUT` | `/notification/api/notifications/{notificationId}/failed` | `Admin` | [API_NOTIFICATIONS](API_NOTIFICATIONS.md#put-apinotificationsnotificationidfailed) |

