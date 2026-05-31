# Endpointy API

## IdentityAuth

| Kontroler | Base route | Endpointy | Role | Status |
|---|---|---|---|---|
| `AuthController` | `api/auth` | `POST register`, `POST login`, `POST refresh`, `POST forgot-password`, `POST reset-password`, `POST change-password`, `POST logout` | publiczne dla większości, `change-password` i `logout` wymagają auth | potwierdzone |
| `UsersController` | `api/users` | `GET profile` | authenticated | potwierdzone |
| `AdminDealersController` | `api/admin/dealers` | `GET`, `GET {id}`, `PUT approve`, `PUT reject`, `PUT credit-limit` | Admin | potwierdzone |
| `AdminUsersController` | `api/admin/users` | `GET agents`, `POST agents` | Admin/Logistics dla listy, Admin dla tworzenia | potwierdzone |
| `InternalUsersController` | `api/internal/users` | `GET {id}/contact` | internal API | potwierdzone |

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

## PaymentInvoice

| Kontroler | Base route | Endpointy | Role | Status |
|---|---|---|---|---|
| `PaymentController` | `api/payment` | gateway payment, dealer account, credit check, credit limit, settlements, outstanding, invoices, workflow, activities, PDF | Admin, Dealer, internal zależnie od akcji | potwierdzone |

## Notification

| Kontroler | Base route | Endpointy | Role | Status |
|---|---|---|---|---|
| `NotificationsController` | `api/notifications` | manual, ingest, my, all, details, sent, failed, read, unread | Admin dla operacji administracyjnych, authenticated dla użytkownika | potwierdzone |

