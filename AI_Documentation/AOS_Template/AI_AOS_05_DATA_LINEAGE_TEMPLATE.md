# AOS Data Lineage Template

## Model Danych

| UI/API | DTO/model | Encja | DbContext | Tabela | Kolumna | R/W | Relacja | Status |
|---|---|---|---|---|---|---|---|---|
| `<pole>` | `<DTO>` | `<encja>` | `<DbContext>` | `<tabela>` | `<kolumna>` | `<R/W>` | `<FK/logiczna>` | do potwierdzenia |

## Dane Niepersistowane

| Pole | Powód braku kolumny | Status |
|---|---|---|
| `<pole>` | `<wyliczane/localStorage/runtime>` | do potwierdzenia |
