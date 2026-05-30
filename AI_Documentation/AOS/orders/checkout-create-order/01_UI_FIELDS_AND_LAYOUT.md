# AOS Checkout Create Order - UI Fields And Layout

## Cel Pliku

Ten plik opisuje ekran `/checkout`: widoczne sekcje, pola, przyciski, stany i powiązania z danymi.

## Struktura Ekranu

| Sekcja | Opis | Widocznosc | Źródło w kodzie |
|---|---|---|---|
| Header | Tytul `Checkout` i link `Back to Cart` | Dealer po przejśćiu na `/checkout` | `checkout.component.html` |
| Order Items | Lista pozycji koszyka: nazwa, SKU, ilość, opcjonalna notatka, wartość linii | Gdy `cartStore.items()` nie jest puste | `checkout.component.html`, `CartStore` |
| Payment Method | Radio: `Cash on Delivery` albo `Credit (PrePaid)` | Zawsze na ekranie checkout | `checkout.component.html`, `CheckoutComponent.paymentMode` |
| Credit Info | Wynik credit-check dla `PrePaid`: approved/fail + available credit | Tylko gdy `paymentMode === PrePaid` i `creditCheck()` istnieje | `checkout.component.html`, `PaymentApiService.checkCredit` |
| Place Order | Podsumowanie liczby sztuk, total, błąd i przycisk `Place Order` | Zawsze na ekranie checkout | `checkout.component.html` |

## Pola Widoczne Na Ekranie

| ID pola | Etykieta UI | Typ UI | Widoczne dla rol | Read-only? | Źródło danych | Format | Pusty stan | Źródło w kodzie |
|---|---|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-FLD-001` | Product name | Text | Dealer | Tak | `CartItem.productName` | Tekst | Brak pozycji przekierowuje do `/cart` | `checkout.component.html`, `cart.store.ts` |
| `AOS-ORD-CHECKOUT-FLD-002` | SKU x quantity | Text | Dealer | Tak | `CartItem.sku`, `CartItem.quantity` | `SKU x qty` | Brak | `checkout.component.html` |
| `AOS-ORD-CHECKOUT-FLD-003` | Note | Text | Dealer | Tak | `CartItem.note` | Tekst | Ukryte gdy puste | `checkout.component.html` |
| `AOS-ORD-CHECKOUT-FLD-004` | Line total | Text/currency | Dealer | Tak | `CartItem.lineTotal` | `currency:'INR'` | Brak | `checkout.component.html`, `CartStore` |
| `AOS-ORD-CHECKOUT-FLD-005` | Total | Text/currency | Dealer | Tak | `cartStore.total()` | `currency:'INR'` | Brak | `checkout.component.html`, `CartStore` |
| `AOS-ORD-CHECKOUT-FLD-006` | Items | Text/number | Dealer | Tak | `cartStore.itemCount()` | Liczba sztuk | Brak | `checkout.component.html`, `CartStore` |
| `AOS-ORD-CHECKOUT-FLD-007` | Error messąge | Alert | Dealer | Tak | `errorMsg()` | Tekst | Ukryte gdy puste | `checkout.component.html`, `checkout.component.ts` |
| `AOS-ORD-CHECKOUT-FLD-008` | Credit approved/fail | Alert | Dealer | Tak | `creditCheck()` | Tekst + kwoty INR | Ukryte dla COD albo braku wyniku | `checkout.component.html` |

## Pola Formularza

| ID pola | Nazwa formularza | Etykieta | Typ | Wymagane | Domyslna wartość | Walidacja front | Walidacja backend | Zapis do |
|---|---|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-FORM-001` | `paymentMode` | Cash on Delivery | radio | Tak | `PaymentMode.COD` | enum w komponencie | `CreateOrderRequestValidator.PaymentMode.IsInEnum()` | `Orders.PaymentMode` |
| `AOS-ORD-CHECKOUT-FORM-002` | `paymentMode` | Credit (PrePaid) | radio | Tak | Nie | enum w komponencie | `CreateOrderRequestValidator.PaymentMode.IsInEnum()` | `Orders.PaymentMode` |

## Kolumny / Lista Pozycji

| ID kolumny | Nagłówek | Pole DTO/model | Sortowanie | Filtrowanie | Format | Akcje w wierszu | Źródło danych |
|---|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-COL-001` | Product | `CartItem.productName` | Nie | Nie | Tekst | Brak | `localStorage sc_cart` przez `CartStore` |
| `AOS-ORD-CHECKOUT-COL-002` | SKU/Qty | `CartItem.sku`, `CartItem.quantity` | Nie | Nie | Tekst | Brak | `CartStore` |
| `AOS-ORD-CHECKOUT-COL-003` | Note | `CartItem.note` | Nie | Nie | Tekst | Brak | `CartStore`; nie jest wysyłane do backendu |
| `AOS-ORD-CHECKOUT-COL-004` | Line total | `CartItem.lineTotal` | Nie | Nie | INR | Brak | `CartStore` |

## Filtry I Wyszukiwanie

Brak filtrow i wyszukiwania na ekranie checkout.

## Przyciski I Operacje UI

| ID akcji | Etykieta / ikona | Lokalizacja | Rola | Warunek aktywnośći | Co uruchamia | Dokument procesu |
|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-ACT-001` | `Back to Cart` | Header | Dealer | Zawsze | Router link `/cart` | Ten plik |
| `AOS-ORD-CHECKOUT-ACT-002` | Payment radio change | Payment Method | Dealer | Zawsze | `onPaymentChange()`; zapis draftu; dla `PrePaid` credit-check | `02_ACTIONS_AND_PROCESS_TRACE.md` |
| `AOS-ORD-CHECKOUT-ACT-003` | `Place Order` | Place Order card | Dealer | `loading() == false`; kod dodatkowo przerywa gdy koszyk pusty | `placeOrder()` | `02_ACTIONS_AND_PROCESS_TRACE.md` |

## Stany Ekranu

| Stan | Kiedy wystepuje | Zachowanie UI | Komunikat | Źródło |
|---|---|---|---|---|
| Empty cart | `cartStore.items().length === 0` w `ngOnInit` | Przekierowanie do `/cart` | Brak komunikatu | `checkout.component.ts` |
| Loading | Po kliknięciu `Place Order`, w trakcie walidacji stocku, bramki płatniczej albo POST order | Disąbled button + spinner | Brak stalego tekstu poza buttonem | `loading` signal |
| Stock changed | Product nieaktywny/brak stocku/cena lub MOQ zmienione | Koszyk jest usuwany/aktualizowany, order nie jest wysłany | `Cart updated due to stock changes. Review and place order again.` + toast warning | `validateCartAgainstCurrentStock()` |
| Stock validation API error | Blad przy `GET /catalog/api/products/{id}` lub forkJoin error | Order nie jest wysłany | `Unable to validate stock right now. Please try again.` | `placeOrder()` |
| Order API error | Blad z `POST /orders/api/orders` | Alert error | `err.error?.messąge || Failed to place order. Please try again.` | `submitOrder()` |
| Payment gateway load/init error | Razorpay script/order creation error | Alert error | `Failed to load payment gateway script.` / `Failed to initialize payment gateway.` | `startGatewayPaymentFlow()` |
| Payment verification fail | Gateway verify zwraca `verified=false` albo API error | Alert error | `Payment verification failed.` / `Unable to verify payment. Please contact support.` | `verifyGatewayPayment()` |

## Dostępnosc I UX

| Obszar | Wymaganie | Status | Uwagi |
|---|---|---|---|
| Keyboard | Radio i button powinny być obsługiwalne klawiaturą | Do potwierdzenia UI testem | Brak testów E2E |
| Labeling | Radio ma label w HTML | OK | Brak osobnych `aria-*` |
| Error display | Bledy globalne w `alert-error` | OK dla błędów globalnych | Brak błędów per pole, bo formularz ma tylko radio |
| Responsive | Uklad zalezy od CSS | Do potwierdzenia screenshotem | Nie analizowano CSS w tym AOS |

## Zrzuty / Referencje Wizualne

Brak zrzutu. Rekomendacja: po uruchomieniu UI wykonać screenshot dla COD, PrePaid approved, PrePaid insufficient credit, stock changed i API error.
