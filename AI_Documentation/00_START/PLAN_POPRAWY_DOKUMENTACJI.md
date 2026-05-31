# Plan Poprawy Dokumentacji

Data: 2026-05-31
Gałąź: `podejście_2`
Status: aktywny plan realizacji po audycie jakości.

## Cel

Doprowadzić aktywną dokumentację do standardu AOS: każdy kluczowy ekran i proces ma ślad od route'u i pola UI do endpointu, DTO, logiki aplikacyjnej, walidacji, encji, tabeli SQL, kolumny, relacji, testów, luk i ryzyk.

## Zasady Pracy

| Zasada | Decyzja | Status |
|---|---|---|
| Źródło faktów | Kod, konfiguracja, migracje, testy i aktywne skrypty. `AI_Documentation/_archive/**` nie jest źródłem faktów. | obowiązuje |
| Zakres zmian | Tylko `AI_Documentation/**`, `AI_Agent_scripts/**` i ewentualnie `AGENTS.md`. | obowiązuje |
| Jednostka pracy | Jeden pion AOS na raz: UI -> API -> proces -> DB -> testy -> ryzyka. | obowiązuje |
| Status faktów | Każda teza ma status: `potwierdzone`, `wniosek z analizy`, `do potwierdzenia`, `brak w kodzie`. | obowiązuje |
| Bramka jakości | Po każdym inkremencie uruchomić `AI_Agent_scripts/Test-Podejscie2DocumentationQuality.ps1` i szybkie skany `rg`. | obowiązuje |

## Role Agentów

| Ciało agenta | Odpowiedzialność | Aktualne użycie |
|---|---|---|
| Orkiestrator dokumentacji | Priorytetyzuje zakres, scala wyniki agentów, pilnuje standardu AOS i commita. | aktywne w tej sesji |
| Eksplorator UI/API | Zbiera route'y Angular, komponenty, akcje UI, serwisy API, kontrolery, role i DTO. | uruchomiony dla `/orders/:id` |
| Eksplorator modelu danych i testów | Zbiera DbContext, encje, tabele, kolumny, relacje i testy. | uruchomiony dla `/orders/:id` |
| Eksplorator jakości/warsztatu | Sprawdza luki w dokumentacji, skillach, skryptach i quality gate. | uruchomiony dla planu naprawczego |

## Skille I Narzędzia

| Skill/narzędzie | Użycie w planie | Kryterium jakości |
|---|---|---|
| `aos-documentation-from-code` | Każdy AOS zaczyna się od route'u i kończy śladem DB/testy/ryzyka. | AOS ma pełny ślad z kodu. |
| `api-inventory-from-dotnet` | Każdy endpoint ma metodę, ścieżkę, role, DTO, handler/usługę i walidator. | Role nie są opisywane zbiorczo. |
| `ef-data-model-documenter` | Każdy proces wskazuje tabelę, kolumnę, typ/ograniczenie i R/W. | Brak pola bez decyzji DB. |
| `angular-screen-mapper` | Każdy route ma komponent, guard, role, pola i akcje. | UI jest zgodne albo jawnie niezgodne z API. |
| `documentation-quality-gate` | Walidacja przed commitem. | Gate nie przechodzi przy braku artefaktów AOS. |

## Etapy Realizacji

| Etap | Zakres | Status | Kryterium zakończenia |
|---|---|---|---|
| 1 | Fundament: checklista AOS, aktywne `AI_DATABASE_STRUCTURE.md`, szablony i walidator. | zakończone jako pierwszy inkrement | Walidator przechodzi, a dokumenty aktywne nie wskazują archiwum jako źródła. |
| 2 | Wzorcowy pion `/checkout`: AOS, proces, API, dane, role, testy. | zakończone jako pierwszy pion jakościowy | Checkout ma ślad UI/API/logika/DB/testy/ryzyka. |
| 3 | Pion `/orders/:id`: szczegół zamówienia, lifecycle statusów, anulowanie, zwrot, hold, notatki ops, role i luki. | w realizacji | Powstaje komplet dokumentów AOS/API/proces/role/testy/model danych dla route'u. |
| 4 | Pion `/shipments/:id` i tracking z `/orders/:id/tracking`. | do wykonania | Dostawa ma ślad LogisticsTracking, Agent, Warehouse/Logistics i DB. |
| 5 | Pion `/invoices/:id` oraz płatności/invoice workflow. | do wykonania | Faktura ma ślad PaymentInvoice, statusy, płatności i DB. |
| 6 | Pion `/admin/dealers/:id`: dealer approval, credit limit i role admina. | do wykonania | Admin dealer ma ślad IdentityAuth/PaymentInvoice i ryzyka integracyjne. |
| 7 | Rozszerzenie quality gate i trace facts do wykrywania kompletności AOS per route. | ciągłe | Gate wykrywa brak wymaganych dokumentów i sekcji. |

## Kolejność Dla Kluczowych AOS

| Priorytet | Route/proces | Uzasadnienie |
|---|---|---|
| P0 | `/orders/:id` | Centralny ekran obsługi zamówienia, statusy, return, hold, role i wykryta niespójność `Warehouse`. |
| P0 | `/shipments/:id` | Krytyczny proces logistyczny, statusy dostawy, Agent i operacje magazyn/logistyka. |
| P0 | `/invoices/:id` | Płatności, faktury, workflow i powiązanie z zamówieniem. |
| P0 | `/admin/dealers/:id` | Akceptacja dealera i limity kredytowe wpływają na checkout i order hold. |
| P1 | `/products/:id`, `/cart`, `/orders`, `/admin/orders` | Ważne widoki wspierające, ale mniej złożone niż piony P0. |

## Kryteria Akceptacji Inkrementu

| Kryterium | Wymaganie |
|---|---|
| AOS | Dokument ma sekcje: overview, role, UI, akcje, API, model danych, proces, testy, ryzyka, źródła. |
| API | Każdy endpoint ma metodę, pełną ścieżkę gateway/backend, role frontend/backend, DTO, walidator i metodę serwisu. |
| DB | Każde pole biznesowe wskazuje tabelę i kolumnę albo jawny status `brak kolumny`. |
| Role | Każda akcja ma porównanie: route guard -> warunek komponentu -> `[Authorize]` -> warunek runtime -> data scope. |
| Testy | Dokument wskazuje testy istniejące i brakujące, powiązane z ryzykami. |
| Jakość | Brak mojibake, brak linków do archiwum jako źródła, walidator przechodzi. |

## Aktualny Następny Krok

Realizowany jest pion `/orders/:id` jako drugi pełny wzorzec po `/checkout`. Najważniejsze ryzyko do opisania: UI pozwala `Warehouse` rozpocząć zmianę statusu do `ReadyForDispatch`, ale `OrdersController.CanManageOrderStatus` dopuszcza tylko `Admin` i `Logistics`; `OrderService.CanRoleManageOrderStatus` zawiera już `Warehouse`. To jest luka zgodności warstw, nie poprawka kodu w tym kroku.

## Aktualizacja Po Pionie Shipment Detail

Status na 2026-05-31: pion `/shipments/:id` oraz kontekst `/orders/:id/tracking` został opracowany jako kolejny obszar po `/orders/:id`.

Dodane artefakty:

- `05_UI_AOS/AOS_SHIPMENT_DETAIL.md`
- `04_API/API_SHIPMENT_DETAIL.md`
- `03_MODEL_DANYCH/MODEL_DANYCH_SHIPMENT_DETAIL.md`
- `06_PROCESY/SHIPMENT_DETAIL_LIFECYCLE.md`
- `07_ROLE_I_UPRAWNIENIA/ROLE_SHIPMENT_DETAIL.md`
- `08_TESTY/MACIERZ_TESTOW_SHIPMENT_DETAIL.md`

Najważniejsze wykryte ryzyka: nieaktualny skrypt `scripts/migrations/LogisticsTracking.sql`, podejrzane podwójne dodanie kolumn `AssignmentDecision*` w migracjach EF, delivery attempts zapisane tylko w `localStorage`, brak backendowego endpointu tracking po `orderId`, maskowanie błędów `ops-state` w `ShipmentOpsQueueService`.
