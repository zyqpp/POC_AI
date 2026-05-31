# AOS Checkout Create Order - Requirements Traceability

## Cel Pliku

Ten plik laczy opis checkoutu z wymaganiami, kryteriami akceptacji i testami.

## Zakres Biznesowy

| Obszar | Opis |
|---|---|
| Proces biznesowy | Zlozenie zamówienia przez dealera |
| Krok procesu | Potwierdzenie koszyka i utworzenie orderu |
| Decyzje użytkownika | Wybiera metodę płatności i potwierdza zamówienie |
| Wynik biznesowy | Zamówienie jest zapisane, stock zarezerwowany, status wynika z credit-checka |
| Systemy / moduly zależne | Angular frontend, Ocelot, Order service, Catalog service, Payment service, SQL DB, Redis/cache, Razorpay |

## Wymagania Funkcjonalne

| ID wymagania | Opis | Priorytet | Rola | Powiązany scenariusz | Status |
|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-REQ-001` | Dealer może złożyć zamówienie z niepustego koszyka. | MUST | Dealer | `UC-001` | potwierdzone w kodzie |
| `AOS-ORD-CHECKOUT-REQ-002` | System odświeża dane produktu i stock przed wysłaniem orderu. | MUST | Dealer | `UC-003` | potwierdzone w kodzie |
| `AOS-ORD-CHECKOUT-REQ-003` | System rezerwuje stock podczas tworzenia zamówienia. | MUST | Dealer/System | `UC-001` | potwierdzone w kodzie |
| `AOS-ORD-CHECKOUT-REQ-004` | Credit-check decyduje czy order idzie do `Processing`, czy `OnHold`. | MUST | Dealer/Admin | `UC-004` | potwierdzone w kodzie |
| `AOS-ORD-CHECKOUT-REQ-005` | Po sukcesie koszyk i draft checkoutu są czyszczone, a user trafia na szczegóły zamówienia. | SHOULD | Dealer | `UC-001` | potwierdzone w kodzie |
| `AOS-ORD-CHECKOUT-REQ-006` | PrePaid wymaga pozytywnej weryfikacji payment gateway przed utworzeniem orderu. | SHOULD | Dealer | `UC-002` | potwierdzone w frontend/payment code |
| `AOS-ORD-CHECKOUT-REQ-007` | Ponowne wysłanie tego samego orderu nie powinno tworzyć duplikatu. | MUST | Dealer/System | edge/retry | luka w kodzie |

## Wymagania Niefunkcjonalne Dla Ekranu

| ID | Obszar | Wymaganie | Jak mierzyc | Źródło / test |
|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-NFR-001` | Security | Tylko Dealer może utworzyć order z checkoutu. | test auth/role | `AUTH-001`, `API-TC-004` |
| `AOS-ORD-CHECKOUT-NFR-002` | Consistency | Stock musi być rezerwowany przed zapisem/akceptacją orderu. | test soft-lock + zapis orderu | `API-TC-005`, `DOM-TC-005` |
| `AOS-ORD-CHECKOUT-NFR-003` | Audit | Order create powinien być odtwarzalny z tabel i eventów. | `Orders`, `OrderLines`, `OrderStatusHistory`, `OutboxMessages`, `StockTransactions`, `OrderSagaStates` | `04_DATA_LINEAGE.md` |
| `AOS-ORD-CHECKOUT-NFR-004` | Reliability | Retry/double-click nie powinien dublowac orderu. | test idempotencji | luka `GAP-001` |

## Kryteria Akceptacji

| ID kryterium | Given | When | Then | Pokryte przez |
|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-AC-001` | Dealer ma koszyk z aktywnym produktem i wystarczajacy stock/credit | Kliknie `Place Order` z COD | Order powstaje, status `Processing`, stock reserved, cart cleared, redirect order detail | `ACT-003`, `API-001`, `DATA-001..011`, `TC-001` |
| `AOS-ORD-CHECKOUT-AC-002` | Produkt w koszyku zmienil cene/stock/MOQ | Dealer klika `Place Order` | Koszyk jest aktualizowany i order nie jest wysłany | `RULE-003`, `TC-003` |
| `AOS-ORD-CHECKOUT-AC-003` | Credit-check backendowy nie przechodzi | Dealer składa order | Order powstaje jako `OnHold`, outbox `AdminApprovalRequired`, saga awaiting manual | `RULE-006`, `TC-004`, `API-TC-006` |
| `AOS-ORD-CHECKOUT-AC-004` | User nie jest Dealerem | Probuje wejsc na `/checkout` albo POST order | Dostęp zabroniony | `AUTH-001`, `E2E-002`, `API-TC-004` |
| `AOS-ORD-CHECKOUT-AC-005` | PrePaid payment verify zwraca false | Dealer probuje złożyć order | Order nie jest wysłany | `ERR-006`, `TC-006` |

## Macierz Sladowania

| Wymaganie | UI | Akcja/proces | API | Dane | Reguły/walidacje | Testy |
|---|---|---|---|---|---|---|
| `REQ-001` | `FLD-001..007` | `ACT-003` | `API-001` | `DATA-001..009` | `RULE-001..002` | `TC-001`, `API-TC-001` |
| `REQ-002` | `FLD-001..005` | `ACT-003` | `API-002` | `DATA-001..004`, `DATA-010` | `VFE-003..004` | `TC-003`, `E2E-004` |
| `REQ-003` | n/a | backend soft-lock | `API-006` | `DATA-011`, `StockTransactions` | `RULE-007` | `API-TC-005`, `DOM-TC-006` |
| `REQ-004` | `FLD-008` | backend credit-check | `API-003`, `API-007`, `API-008` | `DATA-008..009` | `RULE-005..006` | `TC-004`, `API-TC-006` |
| `REQ-005` | success toast/redirect | `submitOrder().next` | `API-001` | localStorage cleared | n/a | `TC-001`, `E2E-001` |
| `REQ-006` | PrePaid radio | Razorpay flow | `API-004`, `API-005` | `PaymentRecords`, Payment outbox | `VFE-005` | `TC-005..006` |
| `REQ-007` | Place Order button | retry/double click | `API-001` | expected idempotency data missing | `RISK-001` | `TC-007` |

## Decyzje Analityczne

| ID decyzji | Decyzja | Uzasądnienie | Wpływ na system | Data / autor |
|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-DEC-001` | AOS opisuje Checkout/Create Order jako pionowy proces, nie caly modul Orders. | Pozwala przejść od ekranu do tabel SQL bez nadmiernego zakresu. | Dokument ma zależności do Catalog i Payment. | 2026-05-30 / AI |
| `AOS-ORD-CHECKOUT-DEC-002` | Luki cen/idempotencji/note oznaczone jako ryzyka, nie poprawki. | Użytkownik prosil teraz o opis procesu, nie zmiany kodu. | Wymaga decyzji przed implementacja. | 2026-05-30 / AI |

## Reguły Interpretacji Dla Testerow

| Sytuacja | Jak interpretowac zgodność | Co jest błędem |
|---|---|---|
| Credit insufficient | Order może powstac, ale powinien być `OnHold` i mieć outbox manual approval. | Brak orderu bez jasnego błędu albo order `Processing`. |
| Stock changed przed POST | Front powinien przerwać proces i zaktualizować koszyk. | POST order wysłany mimo zmienionego stocku/ceny. |
| Soft-lock failed na backendzie | Order create powinien zakończyć się błędem i nie zapisać orderu. | Order zapisany bez stock reserve. |
| PrePaid verify failed | Order nie powinien być wysłany do Order API. | `POST /orders/api/orders` mimo verify false. |

## Luki W Wymaganiach

| ID luki | Opis | Ryzyko | Właściciel decyzji | Status |
|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-GAP-REQ-001` | Czy cena ma być autorytatywna z Catalog backend, czy z koszyka klienta? | Wysokie | PO/Architekt | open |
| `AOS-ORD-CHECKOUT-GAP-REQ-002` | Czy note z koszyka ma być częścią zamówienia? | Średnie | Analityk | open |
| `AOS-ORD-CHECKOUT-GAP-REQ-003` | Jak ma dzialac idempotencja create order? | Wysokie | Architekt/dev | open |
| `AOS-ORD-CHECKOUT-GAP-REQ-004` | Czy `PrePaid` oznacza credit-limit, gateway payment, czy oba naraz? | Średnie/wysokie | PO/analityk | open |
