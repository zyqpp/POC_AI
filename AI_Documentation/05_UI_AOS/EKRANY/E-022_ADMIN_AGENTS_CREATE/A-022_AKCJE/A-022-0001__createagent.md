# A-022-0001 createAgent

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-022-0001` |
| Ekran | [E-022](../E-022__README.md) |
| Nazwa wykryta | `createAgent` |
| Typ detekcji | `click` |
| Źródło | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Tworzenie nowego agenta dostawczego. Frontend waliduje wszystkie pola i normalizuje numer telefonu przed wywołaniem API. Po sukcesie formularz jest czyszczony i wyświetlany komunikat sukcesu. Błędy walidacji z backend (FluentValidation) są wyświetlane inline.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | Przycisk "Create Agent" (`creating()` — disabled podczas wysyłania) | `wniosek z analizy` |
| Metoda komponentu | `AgentCreateComponent.createAgent()` | `wniosek z analizy` |
| Serwis frontend | `AdminApiService.createAgent({fullName, email, phoneNumber, temporaryPassword})` | `wniosek z analizy` |
| Endpoint API | `POST /identity/api/admin/users/agents` | `wniosek z analizy` |
| Komenda/zapytanie | `CreateAgentCommand` → `CreateAgentCommandHandler` | `wniosek z analizy` |
| Walidacje (frontend) | Wszystkie pola wymagane; telefon normalizowany przez `normalizeIndianMobile()` (format `[6-9][0-9]{9}`) | `potwierdzone` |
| Walidacje (backend) | `CreateAgentRequestValidator`: Email.EmailAddress, TemporaryPassword min 8 zn. + uppercase + cyfra, FullName max 120, PhoneNumber regex `^[6-9][0-9]{9}$` | `potwierdzone` |
| Skutek w bazie | Zapis `Users` z rolą `Agent` (szacowane) | `wniosek z analizy` |

## Diagram Przepływu

```mermaid
sequenceDiagram
    actor A as Admin
    participant C as AgentCreateComponent
    participant API as AdminApiService
    participant BE as CreateAgentCommandHandler
    A->>C: Wypełnia formularz, klik "Create Agent"
    C->>C: Walidacja lokalna + normalizeIndianMobile()
    alt Walidacja frontendowa nieudana
        C->>C: createError = "All fields are required." / "Phone number invalid"
    else Walidacja OK
        C->>C: creating = true
        C->>API: POST /identity/api/admin/users/agents
        API->>BE: CreateAgentCommand
        BE-->>API: CreateAgentResponse {email}
        API-->>C: result
        C->>C: creating = false; createSuccess = "Agent created: {email}"
        C->>C: Wyczyść pola formularza
    end
```

## Przykład HTTP

```http
POST /identity/api/admin/users/agents
Content-Type: application/json
Authorization: Bearer {token}

{
  "fullName": "Rajesh Kumar",
  "email": "rajesh.kumar@logistics.com",
  "phoneNumber": "9182683257",
  "temporaryPassword": "Temp@1234"
}

Response: 200 OK
{
  "userId": "...",
  "email": "rajesh.kumar@logistics.com",
  "role": "Agent"
}
```

## Testy

- [Macierz testów ekranu](../TC-022_TESTY/TC-022__INDEX.md)
- Dane wejściowe: `{fullName, email, phoneNumber, temporaryPassword}`.
- Oczekiwany rezultat (sukces): `createSuccess = "Agent created: {email}"`; pola wyczyszczone.
- Oczekiwany rezultat (błąd email zajęty): `createError` zawiera komunikat z API.
- Oczekiwany rezultat (błąd telefon): `createError = "Phone number must be a valid Indian mobile number."`

## Linki

- [Indeks akcji](A-022__INDEX.md)
- [Pola ekranu](../P-022_POLA/P-022__INDEX.md)
- [Ślad ekranu](../E-022__LINKI.md)
