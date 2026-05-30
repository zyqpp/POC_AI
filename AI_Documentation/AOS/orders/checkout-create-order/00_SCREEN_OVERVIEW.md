# AOS Checkout Create Order - Screen Overview

## Metryka Dokumentu

| Pole | Wartosc |
|---|---|
| AOS ID | `AOS-ORD-CHECKOUT` |
| Modul / menu | `Cart / Checkout / Orders` |
| Ekran / funkcja | `Checkout - utworzenie zamowienia z koszyka` |
| URL frontendu | `/checkout` |
| Komponent frontend | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.ts` |
| Template frontend | `supply-chain-frontend/src/app/features/cart/checkout/checkout.component.html` |
| Glowne API | `POST /orders/api/orders` |
| Glowne tabele SQL | `Orders`, `OrderLines`, `OrderStatusHistory`, `OrderSagaStates`, `OutboxMessages`; zalezne: `Products`, `StockTransactions`, `DealerCreditAccounts`, `PaymentRecords` |
| Role | `Dealer` |
| Status dokumentu | `draft` |
| Ostatnia weryfikacja z kodem | `2026-05-30`, commit bazowy `9f1301d` |
| Autor / reviewer | `AI agent / do review przez analityka, testera i developera` |

## Cel Biznesowy

Ekran pozwala dealerowi potwierdzic koszyk i utworzyc zamowienie. System przed wyslaniem zamowienia odswieza dane produktow i stock z katalogu, pozwala wybrac metode platnosci, a po stronie backendu rezerwuje stock, sprawdza kredyt dealera i zapisuje zamowienie.

## Zakres

### W zakresie

- wyswietlenie pozycji koszyka i sumy;
- wybor metody platnosci `COD` albo `PrePaid`;
- frontendowa walidacja aktualnosci produktow, cen i stocku;
- opcjonalny frontendowy przeplyw Razorpay dla `PrePaid`;
- utworzenie zamowienia przez `POST /orders/api/orders`;
- zapis zamowienia, linii, historii statusu, sagi i outboxa;
- powiazanie danych UI z tabelami i kolumnami SQL.

### Poza zakresem

- dodawanie produktow do koszyka;
- szczegoly ekranu koszyka `/cart`;
- dalsze procesy statusow zamowienia po utworzeniu;
- fakturowanie;
- dostawy i shipmenty;
- pelna implementacja bramki Razorpay.

## Uzytkownicy I Role

| Rola | Dostep do ekranu | Dozwolone operacje | Ograniczenia danych |
|---|---|---|---|
| Dealer | Tak | Przejsc do checkoutu, zmienic metode platnosci, zlozyc zamowienie | Koszyk lokalny uzytkownika; zamowienie tworzone z `DealerId` z tokenu JWT |
| Admin | Nie | Brak | Route guard blokuje `/checkout` |
| Warehouse | Nie | Brak | Route guard blokuje `/checkout` |
| Logistics | Nie | Brak | Route guard blokuje `/checkout` |
| Agent | Nie | Brak | Route guard blokuje `/checkout` |

Zrodlo: `supply-chain-frontend/src/app/app.routes.ts`, `services/Order/Order.API/Controllers/OrdersController.cs`.

## Wejscia I Wyjscia Ekranu

| Typ | Opis | Zrodlo / cel |
|---|---|---|
| Parametry route | Brak | `/checkout` |
| Dane wejsciowe | Pozycje koszyka z `CartStore` i `localStorage` key `sc_cart` | `cart.store.ts` |
| Draft ekranu | Wybrany `paymentMode` w `localStorage` key `sc_checkout_draft` | `checkout.component.ts` |
| Dane z API przed zlozeniem | Aktualne dane produktu: aktywnosc, stock, cena, MOQ, nazwa, SKU | `GET /catalog/api/products/{id}` |
| Wynik operacji | Utworzone zamowienie i przekierowanie na `/orders/{orderId}` | `POST /orders/api/orders`, tabela SQL `Orders` |

## Glowne Scenariusze Uzycia

| ID | Scenariusz | Rola | Wynik biznesowy |
|---|---|---|---|
| `AOS-ORD-CHECKOUT-UC-001` | Dealer sklada zamowienie COD | Dealer | Zamowienie zapisane, stock soft-locked, kredyt zatwierdzony albo zamowienie trafia na hold |
| `AOS-ORD-CHECKOUT-UC-002` | Dealer sklada zamowienie PrePaid po weryfikacji bramki platniczej | Dealer | Platnosc zweryfikowana we frontendowym flow, nastepnie zamowienie zapisane jak wyzej |
| `AOS-ORD-CHECKOUT-UC-003` | Stock/cena zmienily sie od czasu dodania do koszyka | Dealer | Koszyk zostaje zaktualizowany, a zamowienie nie jest wyslane do backendu |
| `AOS-ORD-CHECKOUT-UC-004` | Credit-check backendowy nie przechodzi | Dealer | Zamowienie zostaje zapisane jako `OnHold`, generowany jest outbox `AdminApprovalRequired` |

## Powiazane Dokumenty

- UI: `01_UI_FIELDS_AND_LAYOUT.md`.
- Akcje i procesy: `02_ACTIONS_AND_PROCESS_TRACE.md`.
- API: `03_API_AND_CONTRACTS.md`.
- Dane: `04_DATA_LINEAGE.md`.
- Reguly i bledy: `05_RULES_VALIDATIONS_ERRORS.md`.
- Testy: `06_TEST_MATRIX.md`.
- Nawigacja po kodzie: `07_DEV_AI_NAVIGATION.md`.
- Wymagania i pokrycie: `08_REQUIREMENTS_TRACEABILITY.md`.
- Historia zmian i review: `09_CHANGELOG_REVIEW_GATE.md`.

## Otwarte Pytania I Luki

| ID | Pytanie / luka | Wplyw | Decyzja / status |
|---|---|---|---|
| `AOS-ORD-CHECKOUT-GAP-001` | `idempotencyKey` jest wysylany przez frontend, ale nie widac jego uzycia w `OrderService.CreateOrderAsync`. | Ryzyko duplikatu zamowienia po ponownym kliknieciu/retry. | Do decyzji technicznej. |
| `AOS-ORD-CHECKOUT-GAP-002` | Backend zapisuje `ProductName`, `Sku`, `UnitPrice` z requestu, nie pobiera ich ponownie z Catalog. | Ryzyko manipulacji cena/nazwa/SKU przez klienta. | Do decyzji architektonicznej. |
| `AOS-ORD-CHECKOUT-GAP-003` | Notatka pozycji koszyka `note` jest widoczna w UI koszyka/checkoutu, ale nie jest wysylana w `CreateOrderLineRequest`. | Utrata informacji wpisanej przez uzytkownika. | Do decyzji biznesowej. |
| `AOS-ORD-CHECKOUT-GAP-004` | Frontendowy credit-check dla `PrePaid` nie blokuje przycisku, backend i tak wykonuje osobny credit-check. | Mozliwa niespojnosc nazwy `Credit (PrePaid)` i faktycznej logiki. | Do wyjasnienia z biznesem. |
