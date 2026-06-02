# Narzędzia Warsztatu Agentów

Status: `potwierdzone` po pierwszym inkremencie naprawczym.
Zasada: wyniki skryptów są punktem startowym. Każdy ważny fakt wpisany do dokumentacji musi być potwierdzony w kodzie.

## Skrypty Aktywne

| Skrypt | Cel | Domyślny wynik | Ograniczenia | Status |
|---|---|---|---|---|
| `AI_Agent_scripts/Export-Podejscie2AngularRoutes.ps1` | wyciąga route'y Angular, komponenty i role | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/angular-routes.json` | parser statyczny, wymaga potwierdzenia w `app.routes.ts` | aktywny |
| `AI_Agent_scripts/New-FrontendScreenScaffold.ps1` | generuje atomową strukturę ekranów `E/P/A/ERR/TD/TC` z routingu i template Angular | `AI_Documentation/05_UI_AOS/EKRANY/**` | parser heurystyczny; pola, akcje i błędy są kandydatami do ręcznego potwierdzenia | aktywny |
| `AI_Agent_scripts/Export-Podejscie2DotnetApi.ps1` | wyciąga kontrolery, base route, metody HTTP i role | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/dotnet-api.json` | role i statusy wymagają potwierdzenia w kontrolerach | aktywny |
| `AI_Agent_scripts/Export-Podejscie2EfModel.ps1` | wyciąga `DbContext`, `DbSet`, `ToTable` i indeksy | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/ef-model.json` | nie zastępuje pełnej analizy encji i migracji | aktywny |
| `AI_Agent_scripts/Export-AosTraceFacts.ps1` | buduje szeroki trace UI -> API -> handler -> EF i raport luk | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/AI_AOS_TRACE_FACTS.json`, `AI_AOS_TRACE_REPORT.md` | heurystyczne dopasowania, relacje kandydackie wymagają review | aktywny |
| `AI_Agent_scripts/Test-Podejscie2DocumentationQuality.ps1` | bramka jakości dokumentacji | raport w konsoli | rozdziela błędy blokujące od ostrzeżeń nawigacyjnych i merytorycznych; waliduje tylko aktywne artefakty | aktywny |
| `AI_Agent_scripts/Invoke-DocumentationAudit.ps1` | heurystyczny audyt pokrycia dokumentacji: ekrany, procesy, handlery MediatR i walidatory | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/documentation-audit.json`, `fakty/DOCUMENTATION_AUDIT_REPORT.md` | parser statyczny + wyszukiwanie tekstowe; wyniki heurystyczne, wymagają oceny AI | aktywny |
| `AI_Agent_scripts/Invoke-UpdateDocumentationLinks.ps1` | mechaniczne odnajdywanie i aktualizacja linków między dokumentami AOS (LINKI.md) | aktualizacja `05_UI_AOS/EKRANY/E-NNN/E-NNN__LINKI.md` | dopasowanie po ID i nazwie pliku; semantyczne powiązania wymagają skilla `cross-reference-linker` | aktywny |
| `AI_Agent_scripts/Update-DocsTreePages.ps1` | regeneruje helpery `NAV_FOLDER_TREE.md` i `NAV_FILES_BY_FOLDER.md` | `AI_Documentation/NAV_FOLDER_TREE.md`, `AI_Documentation/NAV_FILES_BY_FOLDER.md` | pomija archiwum, `AOS_Template` i katalogi template'ów; nie zastępuje ręcznej oceny punktów wejścia | aktywny |

## Skrypty Ograniczone

| Skrypt | Cel | Warunek bezpiecznego użycia | Status |
|---|---|---|---|
| `AI_Agent_scripts/New-AosScaffold.ps1` | generuje wieloplikowy szkielet AOS z `AI_Documentation/AOS_Template` | najpierw waliduje istnienie template'ów; używać z `-DryRun` przed realnym scaffoldem | aktywny po dodaniu `AOS_Template` |
| `AI_Agent_scripts/Collect-CodeFacts.ps1` | ogólne fakty o kodzie | traktować jako pomocniczy snapshot, nie jako źródło końcowe | pomocniczy |
| `AI_Agent_scripts/Generate-ProjectTree.ps1` | generuje drzewo projektu | używać do orientacji, nie do faktów biznesowych | pomocniczy |

## Reguła Użycia W AOS

1. Uruchom skrypty faktów.
2. Jeżeli pracujesz nad frontendem, uruchom `New-FrontendScreenScaffold.ps1` i pracuj na katalogu `05_UI_AOS/EKRANY/E-...`.
3. Wybierz ekran albo proces.
4. Potwierdź route, komponent, endpoint, DTO, handler, usługę, encje i tabele w kodzie.
5. Dopiero wtedy wpisz fakt do AOS ze statusem.
6. Luki wpisuj jako `do uzupełnienia`, `brak w kodzie`, `do potwierdzenia`, `wniosek z analizy` albo ryzyko.

## Komenda Walidacji

Na Windows uruchamiaj bramkę jakości tak, aby ominąć lokalną politykę podpisu skryptów tylko dla tego procesu:

```powershell
powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\Test-Podejscie2DocumentationQuality.ps1
```

## Komenda Generowania Ekranów

Najpierw odśwież routing, potem wygeneruj brakujące katalogi ekranów:

```powershell
powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\Export-Podejscie2AngularRoutes.ps1
powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\New-FrontendScreenScaffold.ps1
```

## Artefakty Faktów

| Artefakt | Cel | Status |
|---|---|---|
| `fakty/angular-routes.json` | route'y Angular | aktywny |
| `05_UI_AOS/EKRANY/E-000__INDEKS_EKRANOW.md` | indeks atomowych ekranów | aktywny |
| `fakty/dotnet-api.json` | kontrolery i endpointy .NET | aktywny |
| `fakty/ef-model.json` | DbContext, DbSet, tabele | aktywny |
| `fakty/AI_AOS_TRACE_FACTS.json` | pełny snapshot trace | aktywny |
| `fakty/AI_AOS_TRACE_REPORT.md` | raport czytelny dla agenta | aktywny |
| `fakty/documentation-audit.json` | dane pokrycia audytu (ekrany, procesy, algorytmy) | aktywny |
| `fakty/DOCUMENTATION_AUDIT_REPORT.md` | heurystyczny raport audytu dokumentacji | aktywny |

## Ograniczenia `Export-AosTraceFacts.ps1`

`Export-AosTraceFacts.ps1` jest narzędziem heurystycznym, a nie źródłem prawdy. Jego wynik należy traktować jako listę tropów do weryfikacji, nie jako finalny audyt.

Najważniejsze ograniczenia:

- Dopasowania są oparte na nazwach, wzorcach i konwencjach, więc mogą pominąć przepływy ukryte za aliasami, wrapperami, factory methods, reflection albo dynamicznym routingiem.
- Relacje między UI, API, handlerami i EF są częściowo kandydackie; wymagają potwierdzenia w źródłach, a nie tylko w raporcie.
- Narzędzie nie rozstrzyga jakości semantycznej. Może wskazać powiązanie, ale nie potwierdzi, że mapowanie jest kompletne, poprawne biznesowo i pokryte testami.
- Zmiana nazwy komponentu, DTO, endpointu albo handlera może obniżyć trafność bez wygenerowania twardego błędu.
- Nie zastępuje ręcznego sprawdzenia `app.routes.ts`, kontrolerów, serwisów, encji, `DbContext`, migracji i dokumentacji atomowej ekranów.

W praktyce:

1. Uruchom `Export-AosTraceFacts.ps1`.
2. Potwierdź fakty w kodzie i w dokumentach źródłowych.
3. Traktuj raport luk jako backlog do review, a nie jako zamknięty dowód kompletności.

## Ostatnie Użycie

| Data | Obszar | Narzędzia | Wynik |
|---|---|---|---|
| 2026-05-31 | `/shipments/:id` i `/orders/:id/tracking` | `New-AosScaffold.ps1 -DryRun`, `Export-Podejscie2AngularRoutes.ps1`, `Export-Podejscie2DotnetApi.ps1`, `Export-Podejscie2EfModel.ps1`, `Export-AosTraceFacts.ps1`, `Test-Podejscie2DocumentationQuality.ps1` | powstał pełny pion AOS/API/model/proces/role/testy dla shipment detail; quality gate przeszedł |
