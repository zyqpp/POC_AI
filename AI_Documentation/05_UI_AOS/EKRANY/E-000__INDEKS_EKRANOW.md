# E-000 Indeks Ekranów

Status: `szkielet`; indeks generowany z `supply-chain-frontend/src/app/app.routes.ts`.

| ID | Route | Komponent | Role | Dokument |
|---|---|---|---|---|
| `E-001` | `/login` | `LoginComponent` | brak ról w route | [E-001_LOGIN/E-001__README.md](E-001_LOGIN/E-001__README.md) |
| `E-002` | `/register` | `RegisterComponent` | brak ról w route | [E-002_REGISTER/E-002__README.md](E-002_REGISTER/E-002__README.md) |
| `E-003` | `/forgot-password` | `ForgotPasswordComponent` | brak ról w route | [E-003_FORGOT_PASSWORD/E-003__README.md](E-003_FORGOT_PASSWORD/E-003__README.md) |
| `E-004` | `/unauthorized` | `UnauthorizedComponent` | brak ról w route | [E-004_UNAUTHORIZED/E-004__README.md](E-004_UNAUTHORIZED/E-004__README.md) |
| `E-005` | `/dashboard` | `DashboardComponent` | brak ról w route | [E-005_DASHBOARD/E-005__README.md](E-005_DASHBOARD/E-005__README.md) |
| `E-006` | `/profile` | `ProfileComponent` | brak ról w route | [E-006_PROFILE/E-006__README.md](E-006_PROFILE/E-006__README.md) |
| `E-007` | `/products` | `ProductListComponent` | brak ról w route | [E-007_PRODUCTS/E-007__README.md](E-007_PRODUCTS/E-007__README.md) |
| `E-008` | `/products/new` | `ProductFormComponent` | Admin | [E-008_PRODUCTS_NEW/E-008__README.md](E-008_PRODUCTS_NEW/E-008__README.md) |
| `E-009` | `/products/:id` | `ProductDetailComponent` | brak ról w route | [E-009_PRODUCTS_ID/E-009__README.md](E-009_PRODUCTS_ID/E-009__README.md) |
| `E-010` | `/products/:id/edit` | `ProductFormComponent` | Admin | [E-010_PRODUCTS_ID_EDIT/E-010__README.md](E-010_PRODUCTS_ID_EDIT/E-010__README.md) |
| `E-011` | `/cart` | `CartComponent` | Dealer | [E-011_CART/E-011__README.md](E-011_CART/E-011__README.md) |
| `E-012` | `/checkout` | `CheckoutComponent` | Dealer | [E-012_CHECKOUT/E-012__README.md](E-012_CHECKOUT/E-012__README.md) |
| `E-013` | `/orders` | `OrderListComponent` | Admin, Dealer, Warehouse, Logistics | [E-013_ORDERS/E-013__README.md](E-013_ORDERS/E-013__README.md) |
| `E-014` | `/orders/:id/tracking` | `OrderTrackingComponent` | Admin, Dealer, Logistics, Agent | [E-014_ORDERS_ID_TRACKING/E-014__README.md](E-014_ORDERS_ID_TRACKING/E-014__README.md) |
| `E-015` | `/orders/:id` | `OrderDetailComponent` | Admin, Dealer, Warehouse, Logistics | [E-015_ORDERS_ID/E-015__README.md](E-015_ORDERS_ID/E-015__README.md) |
| `E-016` | `/shipments` | `ShipmentListComponent` | Admin, Logistics, Agent, Dealer | [E-016_SHIPMENTS/E-016__README.md](E-016_SHIPMENTS/E-016__README.md) |
| `E-017` | `/shipments/:id` | `ShipmentDetailComponent` | Admin, Logistics, Agent, Dealer | [E-017_SHIPMENTS_ID/E-017__README.md](E-017_SHIPMENTS_ID/E-017__README.md) |
| `E-018` | `/invoices` | `InvoiceListComponent` | Admin, Dealer | [E-018_INVOICES/E-018__README.md](E-018_INVOICES/E-018__README.md) |
| `E-019` | `/invoices/:id` | `InvoiceDetailComponent` | Admin, Dealer | [E-019_INVOICES_ID/E-019__README.md](E-019_INVOICES_ID/E-019__README.md) |
| `E-020` | `/notifications` | `NotificationListComponent` | brak ról w route | [E-020_NOTIFICATIONS/E-020__README.md](E-020_NOTIFICATIONS/E-020__README.md) |
| `E-021` | `/admin/dealers` | `DealerListComponent` | Admin | [E-021_ADMIN_DEALERS/E-021__README.md](E-021_ADMIN_DEALERS/E-021__README.md) |
| `E-022` | `/admin/agents/create` | `AgentCreateComponent` | Admin | [E-022_ADMIN_AGENTS_CREATE/E-022__README.md](E-022_ADMIN_AGENTS_CREATE/E-022__README.md) |
| `E-023` | `/admin/dealers/:id` | `DealerDetailComponent` | Admin | [E-023_ADMIN_DEALERS_ID/E-023__README.md](E-023_ADMIN_DEALERS_ID/E-023__README.md) |

## Zasada Numeracji

Numeracja `E-001...` wynika z kolejności route'ów Angular po odfiltrowaniu route pustego, `AppShellComponent` i wildcard `**`.
