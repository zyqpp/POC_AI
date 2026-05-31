# Narzędzia

## Skrypty podejścia 2

| Skrypt | Cel | Wynik domyślny | Status |
|---|---|---|---|
| `AI_Agent_scripts/Export-Podejscie2AngularRoutes.ps1` | wyciąga route'y Angular, komponenty i role | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/angular-routes.json` | dodany |
| `AI_Agent_scripts/Export-Podejscie2DotnetApi.ps1` | wyciąga kontrolery, base route, metody HTTP i role | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/dotnet-api.json` | dodany |
| `AI_Agent_scripts/Export-Podejscie2EfModel.ps1` | wyciąga DbContext, DbSet i mapowania `ToTable` | `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/ef-model.json` | dodany |
| `AI_Agent_scripts/Test-Podejscie2DocumentationQuality.ps1` | sprawdza mojibake i zakazane linki do archiwum | raport w konsoli | dodany |

## Reguła użycia

Wyniki skryptów są punktem startowym. Każdy ważny fakt w dokumentacji musi być potwierdzony w kodzie, a nie tylko przepisany z wygenerowanego JSON.

