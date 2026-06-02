# P-022-0004 temporaryPassword

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-022-0004` |
| Ekran | [E-022](../E-022__README.md) |
| Nazwa wykryta | `temporaryPassword` |
| Typ detekcji | `[(ngModel)]` |
| Źródło | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Tymczasowe hasło startowe dla nowego agenta. Agent powinien zmienić hasło po pierwszym logowaniu (wymóg biznesowy — `do uzupełnienia`, brak mechanizmu wymuszenia w kodzie). Hasło nie jest wyświetlane po zapisaniu (input type=password).

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — `!temporaryPassword` → błąd "All fields are required." | `potwierdzone` |
| Typ UI | `input[type=password]` z `[(ngModel)]="temporaryPassword"` | `wniosek z analizy` |
| Reguły walidacji (backend) | `NotEmpty().MinimumLength(8).Matches("[A-Z]").Matches("[0-9]")` — `CreateAgentRequestValidator` | `potwierdzone` |
| Komunikaty błędów | [ERR-022](../ERR-022_BLEDY/ERR-022__INDEX.md) | "Password must contain at least one uppercase letter." / "Password must contain at least one number." |

## Walidator Backend (CreateAgentRequestValidator)

Plik: `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs`
```csharp
RuleFor(x => x.TemporaryPassword)
    .NotEmpty()
    .MinimumLength(8)
    .Matches("[A-Z]").WithMessage("Password must contain at least one uppercase letter.")
    .Matches("[0-9]").WithMessage("Password must contain at least one number.");
```

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `AgentCreateComponent.temporaryPassword: string` | `wniosek z analizy` |
| Serwis API | `AdminApiService.createAgent({temporaryPassword})` | `wniosek z analizy` |
| Endpoint | `POST /identity/api/admin/users/agents` | `wniosek z analizy` |
| DTO/kontrakt | `CreateAgentRequest.temporaryPassword` | `wniosek z analizy` |
| Encja/model | `User.PasswordHash` (hasłowane BCrypt przed zapisem) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `Users` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `PasswordHash` (szacowane — nie przechowywany plaintext) | `wniosek z analizy` |
| Odczyt/zapis | zapis (POST — hash, nie plaintext) | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-022_DANE_TESTOWE/TD-022-0004__temporarypassword.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-022__INDEX.md)
- [Akcje ekranu](../A-022_AKCJE/A-022__INDEX.md)
- [Ślad ekranu](../E-022__LINKI.md)
