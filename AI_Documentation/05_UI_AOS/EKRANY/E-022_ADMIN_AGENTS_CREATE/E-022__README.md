# E-022 AgentCreateComponent

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-022` |
| Route | `/admin/agents/create` |
| Komponent | `AgentCreateComponent` |
| Guardy | `roleGuard` |
| Role frontendu | `Admin` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.html` |
| Status faktów | `wniosek z analizy` |

## Cel Ekranu

Formularz tworzenia nowego agenta dostawczego przez administratora. Agent to użytkownik z rolą 'Agent' który może przyjmować i realizować dostawy. Po stworzeniu agent może się zalogować i widzieć przypisane wysyłki.

Formularz zawiera 4 pola: fullName, email, phoneNumber, temporaryPassword. Frontend normalizuje numer telefonu do formatu Indian mobile (10 cyfr, pierwsza 6-9). Walidacja po stronie backend przez `CreateAgentRequestValidator`.

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.ts` | Komponent formularza tworzenia agenta — walidacja numeru telefonu, obsługa błędów |
| `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.html` | Template formularza |
| `supply-chain-frontend/src/app/core/api/admin-api.service.ts` | `AdminApiService.createAgent({fullName, email, phoneNumber, temporaryPassword})` |
| `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs` | `CreateAgentRequestValidator` — walidacja pól formularza |
| `services/IdentityAuth/IdentityAuth.Application/Features/Auth/Commands/` | `CreateAgentCommandHandler` |

## Główne Wywołania API

| Metoda | Endpoint | Opis |
|---|---|---|
| `POST` | `/identity/api/admin/users/agents` | Tworzenie agenta z `{fullName, email, phoneNumber, temporaryPassword}` |

## Stany Ekranu

| Stan | Warunek | Renderowanie |
|---|---|---|
| Formularz | `creating() === false && createSuccess() === ''` | Pola input + przycisk "Create Agent" |
| Wysyłanie | `creating() === true` | Przycisk disabled, loading indicator |
| Sukces | `createSuccess() !== ''` | Komunikat "Agent created: {email}"; pola wyczyszczone |
| Błąd | `createError() !== ''` | Komunikat błędu (np. "Email already registered", "All fields are required") |

## Dokumenty Atomowe

- [Pola UI](P-022_POLA/P-022__INDEX.md)
- [Akcje UI](A-022_AKCJE/A-022__INDEX.md)
- [Błędy i komunikaty](ERR-022_BLEDY/ERR-022__INDEX.md)
- [Dane testowe](TD-022_DANE_TESTOWE/TD-022__INDEX.md)
- [Testy](TC-022_TESTY/TC-022__INDEX.md)
- [Linki śladu](E-022__LINKI.md)

## Zasada Uzupełniania

Każde pole `P-022-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
