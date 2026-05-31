# Narzędzia Warsztatu Agentów

Status: `potwierdzone` po pierwszym inkremencie naprawczym.
Zasada: wyniki skryptów są punktem startowym. Każdy ważny fakt wpisany do dokumentacji musi być potwierdzony w kodzie.

## Skrypty Aktywne

| Skrypt | Cel | Domyślny wynik | Ograniczenia | Status |
|---|---|---|---|---|
| `AI_Agent_scripts/Export-Podejscie2AngularRoutes.ps1` | wyciąga route'y Angular, komponenty i role | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/angular-routes.json` | parser statyczny, wymaga potwierdzenia w `app.routes.ts` | aktywny |
| `AI_Agent_scripts/Export-Podejscie2DotnetApi.ps1` | wyciąga kontrolery, base route, metody HTTP i role | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/dotnet-api.json` | role i statusy wymagają potwierdzenia w kontrolerach | aktywny |
| `AI_Agent_scripts/Export-Podejscie2EfModel.ps1` | wyciąga `DbContext`, `DbSet`, `ToTable` i indeksy | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/ef-model.json` | nie zastępuje pełnej analizy encji i migracji | aktywny |
| `AI_Agent_scripts/Export-AosTraceFacts.ps1` | buduje szeroki trace UI -> API -> handler -> EF i raport luk | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/AI_AOS_TRACE_FACTS.json`, `AI_AOS_TRACE_REPORT.md` | heurystyczne dopasowania, relacje kandydackie wymagają review | aktywny |
| `AI_Agent_scripts/Test-Podejscie2DocumentationQuality.ps1` | bramka jakości dokumentacji | raport w konsoli | kontroluje minimum struktury, trace facts, AOS checkout i template'y; nie zastępuje review | aktywny |

## Skrypty Ograniczone

| Skrypt | Cel | Warunek bezpiecznego użycia | Status |
|---|---|---|---|
| `AI_Agent_scripts/New-AosScaffold.ps1` | generuje wieloplikowy szkielet AOS z `AI_Documentation/AOS_Template` | najpierw waliduje istnienie template'ów; używać z `-DryRun` przed realnym scaffoldem | aktywny po dodaniu `AOS_Template` |
| `AI_Agent_scripts/Collect-CodeFacts.ps1` | ogólne fakty o kodzie | traktować jako pomocniczy snapshot, nie jako źródło końcowe | pomocniczy |
| `AI_Agent_scripts/Generate-ProjectTree.ps1` | generuje drzewo projektu | używać do orientacji, nie do faktów biznesowych | pomocniczy |

## Reguła Użycia W AOS

1. Uruchom skrypty faktów.
2. Wybierz ekran albo proces.
3. Potwierdź route, komponent, endpoint, DTO, handler, usługę, encje i tabele w kodzie.
4. Dopiero wtedy wpisz fakt do AOS ze statusem.
5. Luki wpisuj jako `brak w kodzie`, `do potwierdzenia` albo ryzyko.

## Artefakty Faktów

| Artefakt | Cel | Status |
|---|---|---|
| `fakty/angular-routes.json` | route'y Angular | aktywny |
| `fakty/dotnet-api.json` | kontrolery i endpointy .NET | aktywny |
| `fakty/ef-model.json` | DbContext, DbSet, tabele | aktywny |
| `fakty/AI_AOS_TRACE_FACTS.json` | pełny snapshot trace | aktywny |
| `fakty/AI_AOS_TRACE_REPORT.md` | raport czytelny dla agenta | aktywny |
