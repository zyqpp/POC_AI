# Audyt Dokumentacji Podejście 2

Data audytu: 2026-05-31
Gałąź: `podejście_2`
Commit bazowy audytu: `e77a226`
Zakres: aktywna dokumentacja w `AI_Documentation/00_START` - `AI_Documentation/10_WARSZTAT_AGENTOW`
Wykluczenie: `AI_Documentation/_archive/**` nie było używane jako źródło faktów.

## Executive Summary

Dokumentacja po podejściu 2 jest dobrym startem technicznym, ale nie spełnia jeszcze wymagań jakościowych postawionych dla pełnej dokumentacji projektowej AOS. Obecnie większość folderów ma charakter indeksu, mapy albo szkicu. Największe braki dotyczą śladu end-to-end, mapowania tabel i kolumn SQL, szczegółowego opisu API per endpoint oraz właściwych AOS dla ekranów.

Najważniejsze wnioski:

- Istniejący walidator `AI_Agent_scripts/Test-Podejscie2DocumentationQuality.ps1` przechodzi, ale kontroluje głównie strukturę, mojibake i podstawowe zasady. Nie sprawdza kompletności AOS, kolumn SQL, per-endpoint ról, świeżości faktów ani pokrycia testami.
- `05_UI_AOS` nie zawiera właściwych AOS. Sam dokument `README.md` deklaruje, że AOS-y powstaną dopiero docelowo.
- `03_MODEL_DANYCH` nie schodzi do poziomu wymaganych kolumn SQL, typów, nullability, indeksów, odczytów/zapisów i mapowania ekran/API -> encja -> tabela -> kolumna.
- `04_API` opisuje kontrolery zbiorczo. Dla części kontrolerów role są zbyt ogólne, przez co dokument może wprowadzać w błąd.
- `06_PROCESY` opisuje procesy jako listę, nie jako ślad end-to-end z błędami, rollbackami, outboxem, integracjami i testami.
- `07_ROLE_I_UPRAWNIENIA` nie pokazuje różnic między rolami UI, rolami backendu, rolami technicznymi i autoryzacją przez `X-Internal-Api-Key`.
- `09_RYZYKA_I_REKOMENDACJE` zawiera nieaktualne ryzyko dotyczące pushu na GitHub po tym, jak gałąź `podejście_2` została już wypchnięta.
- `10_WARSZTAT_AGENTOW` ma niespójność narzędziową: `AGENTS.md` wskazuje skrypty `New-AosScaffold.ps1` i `Export-AosTraceFacts.ps1`, ale aktywne dokumenty warsztatu skupiają się na skryptach `Podejscie2`, a `New-AosScaffold.ps1` oczekuje nieistniejącego aktywnego katalogu `AI_Documentation/AOS_Template`.

## Metodyka

Audyt został wykonany w trybie dokumentacyjnym, bez zmian w kodzie aplikacji. Wykorzystano:

- trzech agentów eksploracyjnych dla zakresów `00-03`, `04-07`, `08-10`,
- lokalny skill `AI_Documentation/10_WARSZTAT_AGENTOW/skills/documentation-quality-gate/SKILL.md`,
- statyczne wyszukiwanie `rg` po dokumentacji, kodzie, testach i skryptach,
- uruchomienie walidatora dokumentacji.

Skala priorytetów:

| Priorytet | Znaczenie |
|---|---|
| P0 | Blokuje uznanie dokumentacji za zgodną z wymaganiami AOS/projektowymi. |
| P1 | Istotna luka jakościowa, ale nie blokuje całego warsztatu. |
| P2 | Usprawnienie, porządek albo dług dokumentacyjny. |

## Weryfikacja Techniczna

| Kontrola | Wynik | Wniosek |
|---|---:|---|
| `git branch --show-current` | `podejście_2` | Audyt dotyczy właściwej gałęzi. |
| `git rev-parse --short HEAD` | `e77a226` | To commit bazowy audytu. |
| `git remote -v` | `https://github.com/zyqpp/POC_AI.git` | Repo ma podpięty remote GitHub. |
| `AI_Agent_scripts/Test-Podejscie2DocumentationQuality.ps1` | `Documentation quality check passed.` | Walidator przechodzi, ale zakres kontroli jest za płytki. |
| Aktywne foldery dokumentacji | `00_START` - `10_WARSZTAT_AGENTOW` | Struktura główna istnieje. |

Liczebność aktywnej dokumentacji w czasie audytu:

| Folder | Pliki `.md` | Linie |
|---|---:|---:|
| `00_START` | 4 | 83 |
| `01_SYSTEM` | 4 | 92 |
| `02_ARCHITEKTURA` | 3 | 77 |
| `03_MODEL_DANYCH` | 3 | 63 |
| `04_API` | 2 | 53 |
| `05_UI_AOS` | 2 | 42 |
| `06_PROCESY` | 2 | 41 |
| `07_ROLE_I_UPRAWNIENIA` | 2 | 37 |
| `08_TESTY` | 2 | 31 |
| `09_RYZYKA_I_REKOMENDACJE` | 2 | 16 |
| `10_WARSZTAT_AGENTOW` | 8 | 180 |

## Tabela P0

| Folder | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| `00_START` | `CEL_I_ZAKRES.md`, `AGENTS.md` | Brak mierzalnej checklisty jakości AOS oraz niespójność z wymaganym `AI_DATABASE_STRUCTURE.md`. | `CEL_I_ZAKRES.md:27` mówi o kompletności śladu, ale nie definiuje kontroli; `AGENTS.md:29` wymaga `AI_Documentation/AI_DATABASE_STRUCTURE.md`, którego aktywnie nie ma. | Kolejni agenci nie mają jednoznacznej bramki jakości i mogą uznać szkic za gotowy opis. | Dodać checklistę jakości z wymaganymi polami AOS, źródłem per fakt, statusem faktu, tabelą/kolumną SQL, testem i ryzykiem. Utworzyć aktywny dokument/alias dla struktury bazy. | Istnieje aktywny dokument struktury bazy albo jawny indeks do `03_MODEL_DANYCH`; każdy AOS ma checklistę i statusy faktów. |
| `03_MODEL_DANYCH` | `BAZY_I_KONTEKSTY.md`, `RELACJE.md` | Brak kolumn SQL, typów, nullability, indeksów, R/W i mapowania ekran/API -> encja -> tabela -> kolumna. | Wymóg jest w `AGENTS.md:22`, `AGENTS.md:24`, `AGENTS.md:30`; obecny folder ma tylko 63 linie i opisuje głównie DbContexty/DbSety. | Bez tego AOS nie spełnia minimalnego śladu danych. Tester i developer nie mogą ustalić, gdzie pole jest odczytywane lub zapisywane. | Rozbudować model danych per baza i tabela: kolumny, typy, klucze, FK fizyczne/logiczne, indeksy, enum conversions, R/W, endpointy i procesy używające danych. | Dla każdego `DbSet` istnieje tabela kolumn i relacji; procesy i AOS wskazują konkretne kolumny oraz odczyt/zapis. |
| `04_API` | `ENDPOINTY.md` | Role i endpointy są opisane zbiorczo, miejscami niedokładnie. | `ENDPOINTY.md:18` przypisuje `InventoryController` zbiorcze role `Admin, Dealer, Warehouse, OrderService`; kod rozdziela role per endpoint w `InventoryController.cs:14-47`. | Dokument może błędnie sugerować uprawnienia do operacji takich jak `hard-deduct`, `release-soft-lock` i `subscriptions`. | Przepisać API na inventory per endpoint: metoda, ścieżka downstream, gateway, kontroler, akcja, role, auth, DTO request/response, statusy HTTP, walidacje, źródło. | Każdy endpoint z kontrolerów ma osobny wiersz z rolami i DTO potwierdzonymi w kodzie. |
| `05_UI_AOS` | `README.md`, `MAPA_EKRANOW.md` | Brak właściwych AOS. Folder zawiera mapę ekranów i deklarację, że pełne AOS-y powstaną docelowo. | `README.md:7` mówi: każdy route otrzyma osobny AOS docelowo; `MAPA_EKRANOW.md:18-20` ma tylko route, komponent, role i API. | Nie ma wymaganego śladu ekran -> pole/przycisk -> akcja -> API -> proces -> baza -> testy. | Utworzyć osobne AOS-y co najmniej dla `/checkout`, `/orders/:id`, `/shipments/:id`, `/invoices/:id`, `/admin/dealers/:id`. | Każdy wskazany route ma osobny AOS z polami UI, akcjami, API, walidacją, tabelami/kolumnami, testami i ryzykami. |
| `06_PROCESY` | `PROCESY_END_TO_END.md` | Procesy są listą i uproszczonym diagramem, nie pełnym śladem end-to-end. | `PROCESY_END_TO_END.md:11` opisuje checkout jednym wierszem; `PROCESY_END_TO_END.md:34` oznacza diagram jako wniosek z analizy. | Nie da się zweryfikować przepływów błędów, rollbacków, outboxa, integracji i pokrycia testami. | Rozpisać checkout jako wzorzec: `CheckoutComponent` -> `PaymentApiService.checkCredit` -> `OrderApiService.createOrder` -> `OrderService` -> inventory/payment -> tabele -> outbox -> testy/luki. | Checkout ma pełny lineage UI/API/serwisy/DB/testy oraz warianty błędów i statusów. |
| `07_ROLE_I_UPRAWNIENIA` | `MACIERZ_DOSTEPU.md` | Macierz ról jest za płaska i nie pokazuje konfliktów UI/backend ani zakresu danych. | `MAPA_EKRANOW.md:20` i `order-detail.component.ts:60-61` dopuszczają `Warehouse` do lifecycle; `OrdersController.cs:142-145` pozwala zarządzać statusem tylko `Admin` i `Logistics`. | Dokumentacja nie wykrywa realnych rozjazdów uprawnień między UI i API. | Zbudować macierz route UI -> komponent -> akcja/przycisk -> guard -> endpoint -> `[Authorize]` -> dodatkowy check -> data scope -> test. | Każda akcja krytyczna ma porównanie UI/backend i status zgodności. |
| `09_RYZYKA_I_REKOMENDACJE` | `RYZYKA.md` | Ryzyko pushu na GitHub jest nieaktualne po wypchnięciu gałęzi. | `git branch --show-current` zwraca `podejście_2`, a remote to `origin`; commit bazowy `e77a226` jest na gałęzi śledzącej `origin/podejście_2`. | Rejestr ryzyk miesza ryzyka aktualne z zamkniętymi, przez co traci wiarygodność. | Zamknąć albo przepisać ryzyko jako przyszłą zależność od eskalacji w kolejnych sesjach. | Ryzyko ma status `zamknięte` albo `nieaktualne`, dowód i datę aktualizacji. |
| `10_WARSZTAT_AGENTOW` | `NARZEDZIA.md`, `AGENTS.md`, `New-AosScaffold.ps1` | Niespójność narzędzi AOS i brak aktywnego template'u. | `AGENTS.md:37-38` wskazuje `New-AosScaffold.ps1` i `Export-AosTraceFacts.ps1`; `New-AosScaffold.ps1:29` oczekuje `AI_Documentation/AOS_Template`; `NARZEDZIA.md` opisuje głównie skrypty `Podejscie2`. | Agent nie ma sprawnego, udokumentowanego sposobu wygenerowania AOS zgodnego z wymaganiami. | Ujednolicić listę narzędzi, dodać brakujące szablony albo oznaczyć stare skrypty jako niedostępne do czasu naprawy. | `NARZEDZIA.md` opisuje wszystkie aktywne skrypty, ich status, wejście/wyjście i znane ograniczenia; scaffold AOS działa albo jest jawnie zablokowany. |

## Tabela P1/P2

| Priorytet | Folder | Problem | Dowód | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|
| P1 | `01_SYSTEM` | Mapa systemu i uruchomienie są za skrótowe. Brakuje pełnej mapy runtime, zależności, start order, Swagger/health, baz per serwis, background jobs i internal API. | Folder ma 92 linie dla całego systemu; `ARCHITEKTURA.md:9` wskazuje Swagger/Hangfire jako element API, ale `01_SYSTEM` nie opisuje pełnego operacyjnego uruchomienia. | Rozszerzyć każdy moduł o kontrolery, base routes, DbContext, bazę, tabele własne, route'y UI, integracje, testy i komendy startowe. | Operator może uruchomić środowisko i zweryfikować każdy serwis bez szukania po kodzie. |
| P1 | `02_ARCHITEKTURA` | Architektura jest opisana etykietami, bez decyzji, wariantów, retry/timeoutów, security details i pełnego Ocelot route inventory. | `gateway/OcelotGateway/ocelot.json` ma wiele `UpstreamPathTemplate`, w tym warianty `*-lb`; dokument aktywny streszcza gateway na wysokim poziomie. | Dodać katalog integracji: caller, endpoint/downstream, DTO, auth, sync/async, retry/timeout, błędy, DB effects, testy. | Każda integracja ma właściciela, kontrakt, sposób autoryzacji i scenariusze błędów. |
| P1 | `04_API` | Brak pełnego spisu 95 endpointów z parametrami, DTO, statusami i walidacjami. | Skrypty faktów wykrywają kontrolery i endpointy, ale `ENDPOINTY.md` ma tylko tabele kontrolerów. | Wygenerować i opisać szczegółowy inventory z `services/**/Controllers/*.cs` oraz `services/**/Application/DTOs/**`. | Każdy endpoint ma request/response DTO, walidator/handler/usługę i status faktu. |
| P1 | `04_API` | Internal API jest opisane zbyt ogólnie. | `PaymentController.cs:68-75` używa `[AllowAnonymous]` i ręcznej kontroli; `PaymentController.cs:267-275` sprawdza `InternalApi:Key` i `X-Internal-Api-Key`. | Dodać osobną sekcję internal API: header, konfiguracja, statusy 401/404, wywołujący serwis, ryzyka bezpieczeństwa. | Internal endpointy są rozdzielone od ról użytkowników i mają opis technicznego auth. |
| P1 | `05_UI_AOS` | Mapa ekranów nie wykrywa rozjazdów UI/backend. | Przykład `/orders/:id`: `Warehouse` w UI, ale backend statusu dopuszcza tylko `Admin/Logistics`. | Dodać w każdym AOS sekcję zgodności UI role vs backend role. | Konflikty uprawnień są jawnie oznaczane jako luka lub ryzyko. |
| P1 | `06_PROCESY` | Dane procesów są na poziomie tabel, nie kolumn. Brakuje R/W, relacji logicznych `Guid`, walidacji i statusów. | Wymóg kolumn jest w `AGENTS.md:30`; obecne procesy nie spełniają tego poziomu. | Dodać tabelę lineage: pole UI/API, DTO, encja, tabela, kolumna, odczyt/zapis, relacja, status potwierdzenia. | Każdy proces ma przynajmniej jedną tabelę lineage dla danych krytycznych. |
| P1 | `07_ROLE_I_UPRAWNIENIA` | Role techniczne są mieszane z rolami użytkowników. | `InventoryController.cs:15` i `InventoryController.cs:31` używają `OrderService`; internal API używa `X-Internal-Api-Key`, a nie roli użytkownika. | Rozdzielić role użytkowników, role techniczne i auth techniczne. | Macierz ma osobne sekcje dla ról ludzi, ról serwisowych i nagłówków technicznych. |
| P2 | `07_ROLE_I_UPRAWNIENIA` | Brak mapy testów autoryzacji. | Dokument nie wskazuje testów dla 401/403, guardów ani endpointów. | Dodać kolumnę `Pokrycie testem` i status `brak testu`. | Każda krytyczna akcja ma link do testu albo jawny brak testu. |
| P1 | `08_TESTY` | `TESTY_I_LUKI.md` jest katalogiem testów, nie macierzą pokrycia. | W repo wykryto 33 deklaracje `.NET` `[Fact]/[Theory]` i 4 testy frontendowe `it(...)`, ale dokument nie mapuje ich na proces/API/ryzyko. | Dodać macierz proces biznesowy -> endpoint/UI -> typ testu -> istniejący test -> brakujący test -> priorytet. | Testy i luki są powiązane z procesami, API, rolami i ryzykami. |
| P1 | `08_TESTY` | Luki testowe nie mają priorytetu, wpływu biznesowego ani kryterium zamknięcia. | `TESTY_I_LUKI.md` ma krótką listę luk, bez statusów P0/P1/P2. | Dodać priorytet, dowód, wpływ, rekomendowany typ testu i warunek zamknięcia. | Każda luka testowa jest gotowa do zaplanowania jako zadanie. |
| P1 | `09_RYZYKA_I_REKOMENDACJE` | Rejestr ryzyk jest za mały i bez pól zarządczych. | Folder ma 16 linii; brak kolumn `Priorytet`, `Właściciel`, `Data aktualizacji`, `Warunek zamknięcia`. | Rozbudować rejestr i dodać ryzyka narzędziowe: brak AOS template, brak trace report, płytki quality gate. | Każde ryzyko ma status, priorytet, dowód i kryterium zamknięcia. |
| P1 | `10_WARSZTAT_AGENTOW/fakty` | Raporty faktów są niewystarczające do samodzielnej pracy agentów. | Obecne skrypty `Podejscie2` wykrywają route'y, kontrolery i DbContexty, ale nie pełny trace z DTO, walidatorami, handlerami, kolumnami SQL, testami i commit SHA. | Generować aktywny `AI_AOS_TRACE_FACTS.json` i `AI_AOS_TRACE_REPORT.md` z datą, commit SHA, wersją skryptu i listą luk. | Fakty są świeże względem HEAD i zawierają minimum UI/API/DB/test mapping. |
| P1 | `10_WARSZTAT_AGENTOW/skills` | Skille są sensownie podzielone, ale zbyt skrótowe. | Pliki `SKILL.md` definiują workflow, ale brakuje przykładów wejścia/wyjścia, komend, ograniczeń parserów i checklist `done`. | Dodać do każdego skilla: kiedy używać, komendy, artefakt, typowe błędy, minimalna checklista, powiązane skrypty. | Agent może wykonać skill bez zgadywania formatu wyniku. |
| P2 | `10_WARSZTAT_AGENTOW` | Quality gate przechodzi mimo poważnych braków merytorycznych. | `Documentation quality check passed.` przy jednoczesnych P0 w AOS, API, DB i procesach. | Rozszerzyć gate o świeżość faktów, obecność template'ów, kompletność AOS, kolumn SQL, statusów i rejestru ryzyk. | Walidator potrafi przerwać commit, jeśli brakuje kluczowych artefaktów AOS. |

## Audyt Folderów

### `00_START`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P0 | `CEL_I_ZAKRES.md` | Kryterium kompletności jest opisowe, nieoperacyjne. | `CEL_I_ZAKRES.md:27` definiuje ślad, ale nie wskazuje listy pól wymaganych w każdym AOS. | Agent może uznać mapę za kompletną dokumentację. | Dodać checklistę AOS i minimalny schemat dokumentu. | Checklista jest używana przez quality gate. |
| P0 | `ZRODLA_PRAWDY.md`, `AGENTS.md` | Brakuje aktywnego `AI_DATABASE_STRUCTURE.md` wymaganego przez instrukcję projektu. | `AGENTS.md:29` nakazuje sprawdzać ten dokument. | AOS-y nie mają stałego punktu odniesienia dla bazy. | Utworzyć aktywny indeks struktury bazy albo przepiąć instrukcję na `03_MODEL_DANYCH`. | Instrukcja i dokumenty wskazują ten sam aktywny artefakt. |
| P1 | `KOLEJNOSC_PRACY.md` | Kolejność pracy nie definiuje bramek między etapami. | Kroki są listą działań, bez warunków przejścia. | Można przejść do kolejnego obszaru z niepełnymi faktami. | Dodać warunki `done` per etap. | Każdy etap ma kryteria przejścia. |

### `01_SYSTEM`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P1 | `MAPA_SYSTEMU.md`, `MODULY.md` | Moduły nie są opisane jako pełne jednostki runtime. | Folder ma 92 linie dla całej mapy systemu. | Brakuje szybkiej odpowiedzi: co uruchomić, z czym się łączy i gdzie jest baza. | Dla każdego modułu dodać port, base route, kontrolery, DbContext, bazę, integracje, background jobs, testy. | Każdy serwis ma kartę runtime. |
| P1 | `URUCHOMIENIE.md` | Status komend nie rozdziela `znalezione w repo` od `uruchomione`. | Walidacja aplikacji nie była częścią audytu; uruchomiony był tylko walidator dokumentacji. | Czytelnik może mylnie uznać, że pełny system został uruchomiony. | Wprowadzić statusy: `znalezione`, `zweryfikowane`, `nieuruchamiane`, `blokada`. | Każda komenda ma status i datę weryfikacji. |

### `02_ARCHITEKTURA`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P1 | `ARCHITEKTURA.md` | Opis warstw jest poprawny, ale zbyt ogólny. | Dokument wymienia warstwy `API/Application/Domain/Infrastructure`, bez decyzji i konsekwencji. | Brakuje wiedzy projektowej potrzebnej do utrzymania. | Dodać decyzje architektoniczne: MediatR, EF per service, outbox, gateway, internal API, CORS/JWT. | Każda decyzja ma powód, konsekwencję i źródło kodowe. |
| P1 | `INTEGRACJE.md` | Integracje nie mają kontraktów i scenariuszy błędów. | `INTEGRACJE.md:25-26` opisuje stock i credit check jednym wierszem. | Nie wiadomo, co się dzieje przy błędzie inventory/payment. | Dodać kontrakty integracji i błędy: retry, timeout, fallback, DB effects. | Każda integracja ma tabelę kontraktu i obsługi błędów. |
| P1 | `ARCHITEKTURA.md` | Gateway nie ma pełnego inventory tras. | `gateway/OcelotGateway/ocelot.json` ma wiele `UpstreamPathTemplate`, w tym `*-lb`. | Dokumentacja nie pokazuje rzeczywistego routingu wejściowego. | Dodać wygenerowaną tabelę Ocelot upstream -> downstream. | Każdy route Ocelot ma status i źródło. |

### `03_MODEL_DANYCH`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P0 | `BAZY_I_KONTEKSTY.md` | Brak tabel kolumn SQL. | `AGENTS.md:30` wymaga konkretnych kolumn SQL; folder ma tylko 63 linie. | AOS nie może wskazać zapisu i odczytu pól. | Dla każdej encji opisać kolumny, typy, nullability, klucze, indeksy i relacje. | Każda tabela ma kompletną specyfikację kolumn. |
| P0 | `RELACJE.md` | Relacje logiczne nie są opisane per tabela i kolumna. | W systemie występują identyfikatory `DealerId`, `OrderId`, `ProductId`, `InvoiceId` przekraczające granice mikroserwisów. | Brak rozróżnienia FK fizycznych od logicznych relacji przez `Guid`. | Rozpisać relacje fizyczne i logiczne per baza. | Każda relacja ma typ, źródło, owner i status. |
| P1 | `BAZY_I_KONTEKSTY.md` | Dane niepersistowane nie są jawnie oznaczone. | Przykład z analizy: recenzje produktów mają DTO i endpointy, ale wymagają potwierdzenia trwałości w DbSet/tabeli. | Dokument może sugerować tabelę tam, gdzie dane są wyliczane lub nietrwałe. | Oznaczać `brak w kodzie`, `wniosek z analizy` albo `do potwierdzenia`. | Każdy obiekt danych ma status persistence. |

### `04_API`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P0 | `ENDPOINTY.md` | Role są zbiorcze zamiast per endpoint. | `InventoryController.cs:14-47` ma różne role dla `soft-lock`, `hard-deduct`, `release-soft-lock`, `subscriptions`. | Ryzyko błędnej analizy bezpieczeństwa. | Rozbić kontrolery na endpointy. | Endpointy mają role z konkretnych atrybutów i checków. |
| P1 | `ENDPOINTY.md` | Brakuje DTO, statusów HTTP, walidacji i handlerów. | Kod kontrolerów zawiera `ProducesResponseType`, DTO i MediatR, ale dokument tego nie rozwija. | Dokument API nie wystarcza do testów ani integracji. | Dodać request/response DTO, walidator, handler/usługę, błędy i status faktu. | Każdy endpoint jest testowalnym kontraktem. |
| P1 | `ENDPOINTY.md` | Internal API nie jest opisane jako osobny mechanizm auth. | `PaymentController.cs:68-75`, `PaymentController.cs:267-275`; analogiczny wzorzec w `InternalUsersController.cs:30-38`. | Role użytkowników mieszają się z technicznym nagłówkiem. | Dodać sekcję `Internal API`. | Internal endpointy mają opis headera, konfiguracji i ryzyk. |

### `05_UI_AOS`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P0 | `README.md` | Folder nie zawiera AOS, tylko zapowiedź AOS. | `README.md:7` mówi o docelowych AOS-ach. | Nie spełnia głównego wymagania użytkownika. | Utworzyć AOS-y priorytetowe. | Minimum pięć kluczowych AOS-ów istnieje i przechodzi checklistę. |
| P0 | `MAPA_EKRANOW.md` | Mapa route'ów nie zawiera pól, przycisków, walidacji, DB ani testów. | `MAPA_EKRANOW.md:18-20` ma tylko route, komponent, role, API. | Nie da się prześledzić funkcji od ekranu do danych. | Dodać pełny AOS dla `/checkout` jako wzorzec. | Checkout ma pełny ślad AOS. |
| P1 | `MAPA_EKRANOW.md` | Brak wykrywania konfliktów UI/backend. | Przykład `Warehouse` dla `/orders/:id` kontra backend statusu tylko `Admin/Logistics`. | Dokumentacja nie pokazuje realnych problemów produktu. | Dodać sekcję zgodności ról UI/backend. | Konflikty trafiają do ryzyk. |

### `06_PROCESY`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P0 | `PROCESY_END_TO_END.md` | Checkout nie jest pełnym procesem E2E. | `PROCESY_END_TO_END.md:11` opisuje checkout jednym wierszem. | Brakuje opisu najważniejszego przepływu sprzedażowego. | Rozpisać checkout szczegółowo jako wzorzec. | Dokument pokazuje happy path, błędy, rollbacki, outbox, DB i testy. |
| P1 | `PROCESY_END_TO_END.md` | Brak lineage danych per kolumna. | Wymaganie wynika z `AGENTS.md:22` i `AGENTS.md:30`. | Proces nie spełnia standardu AOS. | Dodać tabelę lineage danych. | Krytyczne pola mają ślad UI/API/DB. |

### `07_ROLE_I_UPRAWNIENIA`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P0 | `MACIERZ_DOSTEPU.md` | Macierz nie schodzi do poziomu akcji i endpointu. | Konflikt `/orders/:id`: UI dopuszcza `Warehouse`, backend update statusu nie. | Ryzyko błędnych wymagań i testów bezpieczeństwa. | Macierz route -> akcja -> guard -> endpoint -> backend auth -> data scope. | Każda akcja ma status zgodności. |
| P1 | `MACIERZ_DOSTEPU.md` | Role techniczne nie są rozdzielone od użytkowników. | `OrderService` w atrybutach API i `X-Internal-Api-Key` w internal API. | Niejasny model bezpieczeństwa. | Osobne sekcje dla ról użytkownika, ról serwisowych i header auth. | Dokument jasno rozróżnia typy autoryzacji. |
| P2 | `MACIERZ_DOSTEPU.md` | Brak pokrycia testami autoryzacji. | Brak kolumny testu. | Nie wiadomo, które 401/403 są sprawdzone. | Dodać link/status testu per akcja. | Każda krytyczna akcja ma test lub jawny brak testu. |

### `08_TESTY`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P1 | `TESTY_I_LUKI.md` | Dokument nie jest macierzą pokrycia. | W repo wykryto testy domenowe i smoke/SLA, ale dokument nie mapuje ich do procesów. | Nie da się ocenić ryzyka regresji procesu. | Macierz proces/API/UI/rola -> test istniejący -> test brakujący. | Każdy P0 proces ma status testowy. |
| P1 | `TESTY_I_LUKI.md` | Luki testowe są zbyt ogólne. | Lista luk nie ma priorytetów ani kryteriów zamknięcia. | Trudno zaplanować pracę testową. | Nadać P0/P1/P2, dowód, wpływ, rekomendowany typ testu. | Każda luka jest zadaniem do realizacji. |

### `09_RYZYKA_I_REKOMENDACJE`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P0 | `RYZYKA.md` | Ryzyko pushu jest nieaktualne. | Aktualna gałąź `podejście_2`, commit `e77a226`, remote GitHub obecny. | Rejestr traci aktualność. | Zamknąć lub przepisać ryzyko. | Ryzyko ma aktualny status i datę. |
| P1 | `RYZYKA.md` | Rejestr jest za mały i bez pól zarządczych. | Folder ma 16 linii. | Ryzyka nie są zarządzalne. | Dodać priorytet, właściciela, datę, status, warunek zamknięcia. | Każde ryzyko ma komplet pól. |
| P1 | `RYZYKA.md` | Brakuje ryzyk narzędziowych wykrytych w audycie. | Brak AOS template, brak aktywnego trace report, płytki quality gate. | Kolejny agent może powtórzyć błędy jakości. | Dodać ryzyka warsztatu agentów. | Ryzyka P0/P1 z audytu są w rejestrze. |

### `10_WARSZTAT_AGENTOW`

| Priorytet | Plik | Problem | Dowód | Wpływ | Rekomendacja | Kryterium zamknięcia |
|---|---|---|---|---|---|---|
| P0 | `NARZEDZIA.md`, `New-AosScaffold.ps1` | Scaffold AOS jest niespójny z aktywną strukturą dokumentacji. | `New-AosScaffold.ps1:29` szuka `AI_Documentation/AOS_Template`, którego nie ma. | Agent nie może powtarzalnie wygenerować AOS. | Dodać template albo oznaczyć narzędzie jako zablokowane. | Scaffold działa albo ma jawny status `niedostępny`. |
| P1 | `NARZEDZIA.md` | Dokument narzędzi nie opisuje wszystkich aktywnych skryptów i ich statusu. | `AGENTS.md:37-38` wskazuje starsze skrypty, dokument warsztatu wskazuje skrypty `Podejscie2`. | Nie wiadomo, które narzędzie jest obowiązujące. | Ujednolicić katalog narzędzi. | Każdy skrypt ma opis wejścia, wyjścia, statusu i ograniczeń. |
| P1 | `skills/**/SKILL.md` | Skille są za krótkie dla samodzielnej pracy. | Brakuje przykładów artefaktów, komend i checklist `done`. | Agent musi zgadywać wynik. | Rozbudować każdy skill o workflow i wzorzec outputu. | Skill ma przykład wejścia/wyjścia i warunki jakości. |
| P2 | `Test-Podejscie2DocumentationQuality.ps1` | Walidator przechodzi mimo P0. | Wynik `Documentation quality check passed.` | Fałszywe poczucie jakości. | Rozszerzyć walidator o kompletność AOS, świeżość faktów i kryteria ryzyk. | Walidator wykrywa braki P0. |

## Plan Naprawczy

Kolejność naprawy powinna iść od fundamentu danych i wzorca AOS, a nie od kosmetyki dokumentów.

1. Naprawić fundament danych w `03_MODEL_DANYCH`.
   - Dodać tabele i kolumny SQL, typy, nullability, klucze, indeksy, relacje fizyczne/logiczne.
   - Dodać R/W, właścicieli procesów i powiązanie z API/DTO.

2. Zbudować wzorcowy AOS `/checkout` w `05_UI_AOS`.
   - Ująć route, komponent, template, pola, przyciski, walidacje, serwisy API, endpointy, DTO, logikę, tabele/kolumny, testy, luki.
   - Ten dokument ma stać się szablonem dla kolejnych AOS.

3. Rozpisać checkout jako pełny proces w `06_PROCESY`.
   - Happy path, błędy, rollbacki, outbox, inventory, payment, statusy i testy.

4. Przepisać `04_API` na inventory per endpoint.
   - Metoda, ścieżka, gateway, kontroler, akcja, role, auth, request/response DTO, statusy, walidacje, handler/usługa, źródło.

5. Przepisać `07_ROLE_I_UPRAWNIENIA` na macierz akcji.
   - Route UI, komponent, przycisk/akcja, guard, endpoint, backend `[Authorize]`, check w kodzie, data scope, test.

6. Naprawić P0 warsztatu w `10_WARSZTAT_AGENTOW`.
   - Ujednolicić `AGENTS.md`, `NARZEDZIA.md`, `New-AosScaffold.ps1`, `Export-AosTraceFacts.ps1` i skrypty `Podejscie2`.
   - Dodać albo zablokować `AOS_Template`.

7. Zaktualizować `09_RYZYKA_I_REKOMENDACJE`.
   - Zamknąć ryzyko pushu.
   - Dodać ryzyka jakościowe wykryte w audycie.

8. Rozszerzyć P1 w `01_SYSTEM`, `02_ARCHITEKTURA`, `08_TESTY`.
   - Operacyjna mapa systemu.
   - Integracje i gateway route inventory.
   - Macierz pokrycia testami.

## Kryteria Akceptacji Po Naprawie

Dokumentację można uznać za zgodną z wymaganiami dopiero wtedy, gdy:

- Każdy fakt techniczny ma źródło w kodzie albo status `potwierdzone`, `do potwierdzenia`, `brak w kodzie`, `wniosek z analizy`.
- Każdy kluczowy ekran ma AOS z pełnym śladem: ekran -> pole/przycisk -> akcja -> frontend -> API -> proces -> walidacje -> encja/model -> baza -> schemat -> tabela -> kolumna -> odczyt/zapis -> relacje -> testy -> kod.
- `03_MODEL_DANYCH` opisuje kolumny SQL, relacje, typy i R/W dla danych używanych przez AOS.
- `04_API` opisuje endpointy per akcja, a nie tylko per kontroler.
- `07_ROLE_I_UPRAWNIENIA` rozdziela role użytkowników, role techniczne i nagłówki internal API.
- `08_TESTY` mapuje testy i braki testów na procesy, endpointy, role i ryzyka.
- `09_RYZYKA_I_REKOMENDACJE` ma aktualne statusy i warunki zamknięcia.
- `10_WARSZTAT_AGENTOW` pozwala kolejnemu agentowi powtórzyć analizę bez zgadywania narzędzi.
- Walidator dokumentacji wykrywa braki P0, a nie tylko strukturę katalogów i mojibake.
