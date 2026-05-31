# Plan Naprawczy Po Audycie Dokumentacji

Data: 2026-05-31
Źródło: `AI_Documentation/99_AUDYT_DOKUMENTACJI/AUDYT_DOKUMENTACJI_2026-05-31.md`
Zakres: tylko dokumentacja i narzędzia dokumentacyjne.

## Zasada Wykonania

Nie poprawiać wszystkiego naraz. Najpierw powstaje jeden pełny pionowy wzorzec jakości: dane + AOS `/checkout` + proces checkout + API + role + testy. Dopiero po tym wzorzec jest kopiowany na kolejne ekrany i procesy.

## Etap 1 - Zamknięcie P0 Fundamentów

| Kolejność | Obszar | Zadanie | Wynik |
|---:|---|---|---|
| 1 | `03_MODEL_DANYCH` | Rozbudować model danych do poziomu tabel, kolumn, typów, nullability, kluczy, indeksów, FK fizycznych/logicznych i R/W. | Aktywny model danych spełnia wymagania AOS. |
| 2 | `00_START` | Dodać mierzalną checklistę AOS i rozwiązać brak aktywnego `AI_DATABASE_STRUCTURE.md`. | Agent ma jednoznaczną bramkę jakości. |
| 3 | `10_WARSZTAT_AGENTOW` | Naprawić albo jawnie zablokować `New-AosScaffold.ps1`; ujednolicić listę skryptów w `NARZEDZIA.md`. | Narzędzia nie wprowadzają agentów w błąd. |
| 4 | `09_RYZYKA_I_REKOMENDACJE` | Zamknąć nieaktualne ryzyko pushu i dodać ryzyka jakościowe z audytu. | Rejestr ryzyk jest aktualny. |

## Etap 2 - Wzorcowy Pion AOS `/checkout`

| Obszar | Zadanie | Wynik |
|---|---|---|
| `05_UI_AOS` | Utworzyć AOS `/checkout` z route, komponentem, template, polami, przyciskami, walidacjami i serwisami API. | Pierwszy właściwy AOS. |
| `06_PROCESY` | Rozpisać checkout end-to-end: UI, check credit, create order, inventory, payment, outbox, błędy i rollbacki. | Pełny proces biznesowy. |
| `04_API` | Udokumentować endpointy checkout per metoda/ścieżka/rola/DTO/status/walidacja. | API jest testowalnym kontraktem. |
| `03_MODEL_DANYCH` | Dodać lineage danych checkout: pole UI/API -> DTO -> encja -> tabela -> kolumna -> R/W. | Dane procesu są śledzalne. |
| `07_ROLE_I_UPRAWNIENIA` | Udokumentować role i data scope checkout. | Uprawnienia są spójne z kodem. |
| `08_TESTY` | Dodać testy istniejące i brakujące dla checkout. | Luka testowa jest mierzalna. |

## Etap 3 - Rozszerzenie Na Kluczowe Ekrany

Po zatwierdzeniu wzorca `/checkout` wykonać AOS-y w tej kolejności:

1. `/orders/:id`
2. `/shipments/:id`
3. `/invoices/:id`
4. `/admin/dealers/:id`
5. `/products/:id`

Każdy AOS musi mieć ten sam format: UI, akcje, API, DTO, logika, walidacje, DB, relacje, testy, ryzyka, źródła kodowe.

## Etap 4 - Pełne Inventory API I Ról

| Obszar | Zadanie | Wynik |
|---|---|---|
| `04_API` | Rozbić wszystkie kontrolery na endpointy. | Pełna tabela endpointów. |
| `04_API` | Dodać DTO request/response, statusy HTTP, walidatory, handler/usługę. | Kontrakty API są kompletne. |
| `04_API` | Osobno opisać internal API przez `X-Internal-Api-Key`. | Role użytkowników nie mieszają się z auth technicznym. |
| `07_ROLE_I_UPRAWNIENIA` | Zbudować macierz route/przycisk/guard/endpoint/Authorize/data scope. | Uprawnienia są audytowalne. |

## Etap 5 - System, Architektura, Testy

| Obszar | Zadanie | Wynik |
|---|---|---|
| `01_SYSTEM` | Rozszerzyć moduły o runtime, zależności, bazy, Swagger/health, start order i troubleshooting. | Dokumentacja operacyjna jest użyteczna. |
| `02_ARCHITEKTURA` | Dodać decyzje architektoniczne, integracje, retry/timeout, security, gateway route inventory. | Architektura jest utrzymywalna. |
| `08_TESTY` | Zbudować macierz testów i luk. | Testy są powiązane z ryzykami. |
| `10_WARSZTAT_AGENTOW` | Rozbudować quality gate o kompletność AOS, kolumn SQL, trace facts, template'y i statusy ryzyk. | Walidator łapie P0. |

## Kryteria Zamknięcia Całego Planu

- Brak otwartych P0 z audytu.
- Co najmniej jeden AOS wzorcowy `/checkout` ma pełny ślad end-to-end.
- Każdy kluczowy folder `00-10` ma aktualny status i kryteria jakości.
- Quality gate nie przechodzi, jeśli brakuje AOS template, trace report, kolumn SQL lub statusów ryzyk.
- Rejestr ryzyk zawiera wszystkie P0/P1 z audytu z datą, statusem i warunkiem zamknięcia.
