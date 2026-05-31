# Mapa Ekranów

Źródło: `supply-chain-frontend/src/app/app.routes.ts`. Status: `potwierdzone`.

| Route | Komponent | Role frontendu | Główne API |
|---|---|---|---|
| `/login` | `LoginComponent` | publiczny | `AuthApiService.login` |
| `/register` | `RegisterComponent` | publiczny | `AuthApiService.register` |
| `/forgot-password` | `ForgotPasswordComponent` | publiczny | `AuthApiService.forgotPassword`, `resetPassword` |
| `/unauthorized` | `UnauthorizedComponent` | publiczny | brak |
| `/dashboard` | `DashboardComponent` | authenticated | zależne od roli: orders, payment, logistics |
| `/profile` | `ProfileComponent` | authenticated | `AuthApiService.profile` |
| `/products` | `ProductListComponent` | authenticated | `CatalogApiService.getProducts`, `searchProducts` |
| `/products/new` | `ProductFormComponent` | Admin | `CatalogApiService.createProduct` |
| `/products/:id` | `ProductDetailComponent` | authenticated | `CatalogApiService.getProduct`, reviews, stock |
| `/products/:id/edit` | `ProductFormComponent` | Admin | `CatalogApiService.updateProduct` |
| `/cart` | `CartComponent` | Dealer | koszyk frontendu, produkty z Catalog |
| `/checkout` | `CheckoutComponent` | Dealer | `PaymentApiService.checkCredit`, `OrderApiService.createOrder` |
| `/orders` | `OrderListComponent` | Admin, Dealer, Warehouse, Logistics | `OrderApiService`, `AdminOrderApiService` |
| `/orders/:id` | `OrderDetailComponent` | Admin, Dealer, Warehouse, Logistics | order status, cancel, return |
| `/orders/:id/tracking` | `OrderTrackingComponent` | Admin, Dealer, Logistics, Agent | logistics tracking |
| `/shipments` | `ShipmentListComponent` | Admin, Logistics, Agent, Dealer | `LogisticsApiService` |
| `/shipments/:id` | `ShipmentDetailComponent` | Admin, Logistics, Agent, Dealer | assignment, vehicle, status, ops-state, rating |
| `/invoices` | `InvoiceListComponent` | Admin, Dealer | `PaymentApiService.getDealerInvoices` |
| `/invoices/:id` | `InvoiceDetailComponent` | Admin, Dealer | invoice detail, workflow, activities, PDF |
| `/notifications` | `NotificationListComponent` | authenticated | `NotificationApiService` |
| `/admin/dealers` | `DealerListComponent` | Admin | `AdminApiService.getDealers` |
| `/admin/dealers/:id` | `DealerDetailComponent` | Admin | dealer details, approval, credit limit |
| `/admin/agents/create` | `AgentCreateComponent` | Admin | `AdminApiService.createAgent` |

## Priorytet AOS

Pierwsze AOS powinny objąć procesy o największym przekroju między modułami: `/checkout`, `/orders/:id`, `/shipments/:id`, `/invoices/:id`, `/admin/dealers/:id`.

