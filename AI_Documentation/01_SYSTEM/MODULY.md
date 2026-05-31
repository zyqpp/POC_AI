# Moduły

## Frontend

Angular 21 w `supply-chain-frontend`. Routing jest w `supply-chain-frontend/src/app/app.routes.ts`. Komunikacja z backendem przechodzi przez serwisy API w `supply-chain-frontend/src/app/core/api/**`.

## Gateway

Ocelot Gateway w `gateway/OcelotGateway` wystawia ścieżki `/identity`, `/catalog`, `/orders`, `/logistics`, `/payments` i `/notifications` oraz warianty `*-lb`. Potwierdzone w `gateway/OcelotGateway/ocelot.json`.

## Backend

Backend jest podzielony na sześć mikroserwisów domenowych. Każdy główny serwis ma warstwy `API`, `Application`, `Domain` i `Infrastructure`.

| Serwis | Odpowiedzialność | Źródła |
|---|---|---|
| IdentityAuth | logowanie, rejestracja, profile, dealerzy, agenci, JWT | `services/IdentityAuth/**` |
| CatalogInventory | produkty, kategorie, stock, subskrypcje, recenzje | `services/CatalogInventory/**` |
| Order | zamówienia, statusy, zwroty, analityka, saga | `services/Order/**` |
| LogisticsTracking | przesyłki, assignment, tracking, ops-state, chatbot | `services/LogisticsTracking/**` |
| PaymentInvoice | kredyt, płatności, faktury, workflow faktur | `services/PaymentInvoice/**` |
| Notification | powiadomienia manualne, ingest zdarzeń, email | `services/Notification/**` |

