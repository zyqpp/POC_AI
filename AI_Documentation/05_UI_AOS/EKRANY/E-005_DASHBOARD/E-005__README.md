# E-005 DashboardComponent

Status: `wniosek z analizy`; źródło startowe: routing i komponent Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-005` |
| Route | `/dashboard` |
| Komponent | `DashboardComponent` |
| Guardy | `brak guardów w route` |
| Role frontendu | `brak ról w route` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` |
| Status faktów | `do uzupełnienia` |

## Dokumenty Atomowe

- [Pola UI](P-005_POLA/P-005__INDEX.md)
- [Akcje UI](A-005_AKCJE/A-005__INDEX.md)
- [Błędy i komunikaty](ERR-005_BLEDY/ERR-005__INDEX.md)
- [Dane testowe](TD-005_DANE_TESTOWE/TD-005__INDEX.md)
- [Testy](TC-005_TESTY/TC-005__INDEX.md)
- [Linki śladu](E-005__LINKI.md)

## Cel Ekranu

Główny ekran po zalogowaniu — agreguje kluczowe informacje dla zalogowanego użytkownika (Dealer / Admin / Warehouse / Logistics / Agent). Ekran jest read-only — dane ładowane asynchronicznie z kilku endpointów w `ngOnInit` z podziałem per rola. Widok dostosowuje się do roli użytkownika (sygnały `isDealer()`, `isAdmin()`, `isWarehouse()`).

Główne funkcje:
- Karty statystyczne (Dealer: kredyt, zamówienia, koszyk, wysyłki; Admin: zamówienia, wysyłki aktywne, produkty, dealerzy; Warehouse: zamówienia, alerty magazynowe)
- Lista ostatnich zamówień (Dealer: własne; Admin/Warehouse/Logistics: wszystkie)
- Lista aktywnych wysyłek (Dealer: własne; Agent: przypisane; Admin/Logistics: wszystkie; Warehouse: brak)
- Ostatnie produkty z katalogu
- Alerty niskiego stanu magazynowego (Admin/Warehouse)
- Analityki zamówień i top dealerzy / top produkty (Admin/Warehouse/Logistics)
- Wykres kołowy statusów zamówień
- Chatbot logistyczny (wyłączony — `canUseDashboardChatbot() === false`)

Powiązany proces: [do uzupełnienia po analizie procesów]

## Kluczowe Pliki Kodu

| Rola | Ścieżka |
|---|---|
| Komponent Angular | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.ts` |
| Template HTML | `supply-chain-frontend/src/app/features/dashboard/dashboard.component.html` |
| Store autentykacji | `supply-chain-frontend/src/app/core/stores/auth.store.ts` |
| Store koszyka | `supply-chain-frontend/src/app/core/stores/cart.store.ts` |
| Serwis zamówień (Dealer) | `supply-chain-frontend/src/app/core/api/order-api.service.ts` (OrderApiService) |
| Serwis zamówień (Admin) | `supply-chain-frontend/src/app/core/api/order-api.service.ts` (AdminOrderApiService) |
| Serwis logistyki | `supply-chain-frontend/src/app/core/api/logistics-api.service.ts` |
| Serwis katalogu | `supply-chain-frontend/src/app/core/api/catalog-api.service.ts` |
| Serwis płatności | `supply-chain-frontend/src/app/core/api/payment-api.service.ts` |
| Serwis admin | `supply-chain-frontend/src/app/core/api/admin-api.service.ts` |
| Serwis alertów magazynowych | `supply-chain-frontend/src/app/core/services/inventory-alert-rules.service.ts` |

## Główne Wywołania API

| Metoda | Endpoint | Cel | Warunek (rola) |
|---|---|---|---|
| `GET` | `/order/api/orders` (getMyOrders) | ostatnie zamówienia dealera | Dealer |
| `GET` | `/order/api/admin/orders` (getAllOrders) | wszystkie zamówienia | Admin / Warehouse / Logistics |
| `GET` | `/order/api/admin/analytics` (getOrderAnalytics) | analityki zamówień | Admin / Warehouse / Logistics |
| `GET` | `/catalog/api/products` | katalog produktów (do 100 pozycji) | wszystkie role |
| `GET` | `/logistics/api/shipments/my` (getMyShipments) | wysyłki dealera | Dealer |
| `GET` | `/logistics/api/shipments/assigned` (getAssignedShipments) | przypisane wysyłki | Agent |
| `GET` | `/logistics/api/shipments` (getAllShipments) | wszystkie wysyłki | Admin / Logistics |
| `GET` | `/payment/api/credit/check/{userId}` (checkCredit) | limit kredytowy dealera | Dealer |
| `GET` | `/admin/api/dealers/{dealerId}` (getDealerById) | dane dealera do mapy nazw | Admin (analytics) |
| `POST` | `/logistics/api/chatbot/ask` (askChatbot) | chatbot logistyczny | wyłączony |

## Stany Ekranu

| Stan | Warunek | Zachowanie UI |
|---|---|---|
| Ładowanie zamówień | `ordersLoading() === true` | spinner / skeleton w sekcji zamówień |
| Ładowanie produktów | `productsLoading() === true` | spinner / skeleton w sekcji produktów |
| Ładowanie wysyłek | `shipmentsLoading() === true` | spinner / skeleton w sekcji wysyłek |
| Ładowanie analityk | `analyticsLoading() === true` | spinner w sekcji analityk (Admin) |
| Dane załadowane | wszystkie sygnały loading === false | pełny widok dashboardu |
| Brak uprawnień (Agent) | rola Agent | zamówienia puste; wysyłki z getAssignedShipments |

## Zasada Uzupełniania

Każde pole `P-005-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
