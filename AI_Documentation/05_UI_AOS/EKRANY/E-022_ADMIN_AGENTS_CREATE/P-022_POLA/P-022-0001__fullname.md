# P-022-0001 fullName

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-022-0001` |
| Ekran | [E-022](../E-022__README.md) |
| Nazwa wykryta | `fullName` |
| Typ detekcji | `[(ngModel)]` |
| Źródło | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Imię i nazwisko agenta dostawczego. Wyświetlane po stworzeniu konta jako identyfikator użytkownika w systemie. Pole tekstowe w formularzu tworzenia agenta.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — frontend sprawdza `!fullName.trim()`, backend: `NotEmpty()` | `potwierdzone` |
| Typ UI | `input[type=text]` z `[(ngModel)]="fullName"` | `wniosek z analizy` |
| Reguły walidacji (frontend) | `fullName.trim()` musi być niepuste; błąd "All fields are required." | `potwierdzone` |
| Reguły walidacji (backend) | `NotEmpty().MaximumLength(120)` — `CreateAgentRequestValidator` w `AuthValidators.cs` | `potwierdzone` |
| Komunikaty błędów | [ERR-022](../ERR-022_BLEDY/ERR-022__INDEX.md) | "All fields are required." |

## Walidator Backend (CreateAgentRequestValidator)

Plik: `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs`
```csharp
RuleFor(x => x.FullName).NotEmpty().MaximumLength(120);
```

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `AgentCreateComponent.fullName: string` | `wniosek z analizy` |
| Serwis API | `AdminApiService.createAgent({fullName, ...})` | `wniosek z analizy` |
| Endpoint | `POST /identity/api/admin/users/agents` | `wniosek z analizy` |
| DTO/kontrakt | `CreateAgentRequest` w `supply-chain-frontend/src/app/core/models/auth.models.ts` | `wniosek z analizy` |
| Encja/model | `User.FullName` (szacowane) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `Users` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `FullName` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | zapis (POST) | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-022_DANE_TESTOWE/TD-022-0001__fullname.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-022__INDEX.md)
- [Akcje ekranu](../A-022_AKCJE/A-022__INDEX.md)
- [Ślad ekranu](../E-022__LINKI.md)
