# Ryzyka I Rekomendacje

Status: rejestr aktywny po audycie dokumentacji i pierwszym inkremencie `/checkout`.

| Priorytet | Ryzyko | Dowód | Skutek | Rekomendacja | Status | Warunek zamknięcia |
|---|---|---|---|---|---|---|
| P0 | Brak pełnych AOS dla większości route'ów | `05_UI_AOS` ma wzorzec `/checkout`, pozostałe route'y nadal mają głównie mapę | dokumentacja nie jest jeszcze kompletna funkcjonalnie | tworzyć kolejne AOS-y według wzorca `/checkout` | otwarte | AOS-y istnieją dla wszystkich route'ów albo mają jawny backlog |
| P0 | Brak pełnego modelu danych dla całego systemu | szczegółowo opisany jest pierwszy pion checkout | AOS-y innych ekranów mogą nie mieć tabel/kolumn | rozszerzać `03_MODEL_DANYCH` per proces | otwarte | każdy kluczowy proces ma lineage tabel i kolumn |
| P0 | `PaymentRecord.OrderId = Guid.Empty` przy gateway verify | `PaymentInvoiceService.VerifyGatewayPaymentAsync` zapisuje payment record przed utworzeniem orderu | płatność może być trudna do powiązania z zamówieniem | potwierdzić model korelacji payment-order i opisać decyzję | otwarte | decyzja biznesowo-techniczna albo zmiana kodu w osobnym zadaniu |
| P0 | `AddOutstandingAsync` jest po zapisie orderu | `OrderService.CreateOrderAsync` zapisuje order przed integracją outstanding | możliwa niespójność między Order i PaymentInvoice | dodać kompensację/test/monitoring albo zaakceptować jako świadomy tradeoff | otwarte | opisany mechanizm kompensacji lub test integracyjny |
| P0 | Brak pełnego testu E2E checkout | testy domenowe istnieją, ale brak ścieżki UI/API/integracje/DB | regresja checkout może przejść niewykryta | dodać testy według `08_TESTY/MACIERZ_TESTOW_CHECKOUT.md` | otwarte | istnieje test happy path i błędów checkout |
| P1 | `idempotencyKey` z UI nie ma potwierdzonego użycia w `OrderService` | UI wysyła `idempotencyKey`, service nie używa go w prześledzonym kodzie | retry może utworzyć duplikat orderu | potwierdzić wymaganie i udokumentować albo naprawić w osobnym zadaniu | otwarte | decyzja lub implementacja idempotencji |
| P1 | UI pokazuje credit check tylko dla `PrePaid`, backend sprawdza credit także dla `COD` | `CheckoutComponent.onPaymentChange`, `OrderService.CreateOrderAsync` | użytkownik może dostać hold dla COD bez wcześniejszego komunikatu UI | potwierdzić UX i opisać regułę w wymaganiach | otwarte | zaakceptowana decyzja UX/backend |
| P1 | Trace facts są heurystyczne | `Export-AosTraceFacts.ps1` używa analizy statycznej | możliwe fałszywe dopasowania UI/API/DB | każdy fakt potwierdzać w kodzie przed wpisem do AOS | kontrolowane | quality gate i AOS pokazują status faktów |
| P1 | Archiwum może zostać przypadkowo użyte jako źródło | stara dokumentacja istnieje w `_archive` | zanieczyszczenie podejścia od zera | walidator blokuje linki do archiwum jako źródła | kontrolowane | brak aktywnych linków źródłowych do `_archive` |
| P2 | Push na GitHub wymaga zgody w kolejnych sesjach | wcześniejszy push wymagał eskalacji sandboxa, ale gałąź `podejście_2` jest już na `origin` | przyszłe publikacje mogą wymagać ponownej zgody | traktować jako ograniczenie operacyjne, nie blokadę projektu | zamknięte dla poprzedniego pushu | gałąź istnieje na GitHub; kolejne push wymagają normalnej zgody |

