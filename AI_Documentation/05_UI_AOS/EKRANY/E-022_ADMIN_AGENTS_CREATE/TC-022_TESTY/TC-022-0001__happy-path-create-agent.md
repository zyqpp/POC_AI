# TC-022-0001 Happy Path — Utwórz Agenta → Agent Może się Zalogować

| Atrybut | Wartość |
|---|---|
| ID | `TC-022-0001` |
| Ekran | [E-022](../E-022__README.md) |
| Typ | happy path |
| Priorytet | P0 |
| Powiązane | A-022-0001, P-022-0001, P-022-0002, P-022-0003, P-022-0004 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Admin`.
- Email `rajesh.kumar@logistics.com` nie istnieje w systemie.
- API `POST /identity/api/admin/users/agents` jest dostępne.
- Backend walidator `CreateAgentRequestValidator` przechodzi dla podanych danych.

## When (Akcja)

- Użytkownik wypełnia formularz:
  - Full Name: `Rajesh Kumar`
  - Email: `rajesh.kumar@logistics.com`
  - Phone Number: `9182683257`
  - Temporary Password: `Temp@1234`
- Użytkownik klika `"Create Agent"`.

## Then (Oczekiwany rezultat)

- Frontend normalizuje numer telefonu przez `normalizeIndianMobile()` → `9182683257`.
- Frontend wysyła `POST /identity/api/admin/users/agents` z danymi agenta.
- API zwraca `200 OK` z `{userId, email, role: "Agent"}`.
- Na ekranie pojawia się komunikat sukcesu: `"Agent created: rajesh.kumar@logistics.com"`.
- Pola formularza są czyszczone.
- Przycisk `"Create Agent"` wraca do stanu aktywnego (`creating = false`).
- Konto agenta jest zapisane w bazie z rolą `Agent` i `mustChangePassword = true`.
- Agent może zalogować się na `/login` używając tymczasowego hasła.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| fullName | `Rajesh Kumar` | `` (puste) |
| email | `rajesh.kumar@logistics.com` | `notanemail` |
| phoneNumber | `9182683257` | `12345` |
| temporaryPassword | `Temp@1234` | `weak` |

## Powiązany test automatyczny

`brak w kodzie`
