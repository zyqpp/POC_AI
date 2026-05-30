# AOS Checkout Create Order - Screen Overview

## Metryka Dokumentu

| Pole | Wartość |
|---|---|
| AOS ID | `AOS-ORD-CHECKOUT` |
| Moduł / menu | `Cart / Checkout / Orders` |
| Ekran / funkcja | `Checkout - utworzenie zamówienia z koszyka` |
| URL frontendu | `/checkout` |
| Komponent frontend | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.ts` |
| Template frontend | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` |
| Główne API | `POST /orders/api/orders` |
| Główne tabele SQL | `Orders`, `OrderLines`, `OrderStatusHistory`, `OrderSagaStates`, `OutboxMessages`; zależne: `Products`, `StockTransactions`, `DealerCreditAccounts`, `PaymentRecords` |
| Role | `Dealer` |
| Status dokumentu | `draft` |
| Ostatnia weryfikacja z kodem | `2026-05-30`, commit bazowy `9f1301d` |
| Autor / reviewer | `AI agent / do review przez analityka, testera i developera` |

## Cel Biznesowy

Ekran pozwala dealerowi potwierdzić koszyk i utworzyć zamówienie. System przed wysłaniem zamówienia odświeża dane produktów i stock z katalogu, pozwala wybrać metodę płatności, a po stronie backendu rezerwuje stock, sprawdza kredyt dealera i zapisuje zamówienie.

## Zakres

### W zakresie

- wyświetlenie pozycji koszyka i sumy;
- wybór metody płatności `COD` albo `PrePaid`;
- frontendowa walidacja aktualności produktów, cen i stocku;
- opcjonalny frontendowy przepływ Razorpay dla `PrePaid`;
- utworzenie zamówienia przez `POST /orders/api/orders`;
- zapis zamówienia, linii, historii statusu, sagi i outboxa;
- powiązanie danych UI z tabelami i kolumnami SQL.

### Poza zakresem

- dodawanie produktów do koszyka;
- szczegóły ekranu koszyka `/cart`;
- dalsze procesy statusów zamówienia po utworzeniu;
- fakturowanie;
- dostawy i shipmenty;
- pełna implementacja bramki Razorpay.

## Użytkownicy I Role

| Rola | Dostęp do ekranu | Dozwolone operacje | Ograniczenia danych |
|---|---|---|---|
| Dealer | Tak | Przejść do checkoutu, zmienić metodę płatności, złożyć zamówienie | Koszyk lokalny użytkownika; zamówienie tworzone z `DealerId` z tokenu JWT |
| Admin | Nie | Brak | Route guard blokuje `/checkout` |
| Warehouse | Nie | Brak | Route guard blokuje `/checkout` |
| Logistics | Nie | Brak | Route guard blokuje `/checkout` |
| Agent | Nie | Brak | Route guard blokuje `/checkout` |

Źródło: `supply-chain-frontend/src/app/app.routes.ts`, `services/Order/Order.API/Controllers/OrdersController.cs`.

## Wejścia I Wyjścia Ekranu

| Typ | Opis | Źródło / cel |
|---|---|---|
| Parametry route | Brak | `/checkout` |
| Dane wejściowe | Pozycje koszyka z `CartStore` i `localStorage` key `sc_cart` | `cart.store.ts` |
| Draft ekranu | Wybrany `paymentMode` w `localStorage` key `sc_checkout_draft` | `checkout.component.ts` |
| Dane z API przed złożeniem | Aktualne dane produktu: aktywność, stock, cena, MOQ, nazwa, SKU | `GET /catalog/api/products/{id}` |
| Wynik operacji | Utworzone zamówienie i przekierowanie na `/orders/{orderId}` | `POST /orders/api/orders`, tabela SQL `Orders` |

## Główne Scenariusze Użycia

| ID | Scenariusz | Rola | Wynik biznesowy |
|---|---|---|---|
| `AOS-ORD-CHECKOUT-UC-001` | Dealer składa zamówienie COD | Dealer | Zamówienie zapisane, stock soft-locked, kredyt zatwierdzony albo zamówienie trafia na hold |
| `AOS-ORD-CHECKOUT-UC-002` | Dealer składa zamówienie PrePaid po weryfikacji bramki płatniczej | Dealer | Płatność zweryfikowana we frontendowym flow, następnie zamówienie zapisane jak wyżej |
| `AOS-ORD-CHECKOUT-UC-003` | Stock/cena zmieniły się od czasu dodania do koszyka | Dealer | Koszyk zostaje zaktualizowany, a zamówienie nie jest wysłane do backendu |
| `AOS-ORD-CHECKOUT-UC-004` | Credit-check backendowy nie przechodzi | Dealer | Zamówienie zostaje zapisane jako `OnHold`, generowany jest outbox `AdminApprovalRequired` |

## Powiązane Dokumenty

- UI: `01_UI_FIELDS_AND_LAYOUT.md`.
- Akcje i procesy: `02_ACTIONS_AND_PROCESS_TRACE.md`.
- API: `03_API_AND_CONTRACTS.md`.
- Dane: `04_DATA_LINEAGE.md`.
- Reguły i błędy: `05_RULES_VALIDATIONS_ERRORS.md`.
- Testy: `06_TEST_MATRIX.md`.
- Nawigacja po kodzie: `07_DEV_AI_NAVIGATION.md`.
- Wymagania i pokrycie: `08_REQUIREMENTS_TRACEABILITY.md`.
- Historia zmian i review: `09_CHANGELOG_REVIEW_GATE.md`.

## Otwarte Pytania I Luki

| ID | Pytanie / luka | Wpływ | Decyzja / status |
|---|---|---|---|
| `AOS-ORD-CHECKOUT-GAP-001` | `idempotencyKey` jest wysyłany przez frontend, ale nie widać jego użycia w `OrderService.CreateOrderAsync`. | Ryzyko duplikatu zamówienia po ponownym kliknięciu/retry. | Do decyzji technicznej. |
| `AOS-ORD-CHECKOUT-GAP-002` | Backend zapisuje `ProductName`, `Sku`, `UnitPrice` z requestu, nie pobiera ich ponownie z Catalog. | Ryzyko manipulacji ceną/nazwą/SKU przez klienta. | Do decyzji architektonicznej. |
| `AOS-ORD-CHECKOUT-GAP-003` | Notatka pozycji koszyka `note` jest widoczna w UI koszyka/checkoutu, ale nie jest wysyłana w `CreateOrderLineRequest`. | Utrata informacji wpisanej przez użytkownika. | Do decyzji biznesowej. |
| `AOS-ORD-CHECKOUT-GAP-004` | Frontendowy credit-check dla `PrePaid` nie blokuje przycisku, backend i tak wykonuje osobny credit-check. | Możliwa niespójność nazwy `Credit (PrePaid)` i faktycznej logiki. | Do wyjaśnienia z biznesem. |
