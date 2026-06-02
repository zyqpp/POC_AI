# TC-022-0002 Duplikat Emaila → Błąd "Email already exists"

| Atrybut | Wartość |
|---|---|
| ID | `TC-022-0002` |
| Ekran | [E-022](../E-022__README.md) |
| Typ | błąd HTTP |
| Priorytet | P0 |
| Powiązane | A-022-0001, P-022-0002, ERR-022-0001, ERR-022-0003 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Admin`.
- Email `existing.agent@logistics.com` jest już zarejestrowany w systemie (np. inny agent lub dealer).
- API `POST /identity/api/admin/users/agents` zwraca błąd `400` lub `409` z komunikatem o duplikacie emaila.

## When (Akcja)

- Użytkownik wypełnia formularz poprawnymi danymi.
- W polu email wpisuje `existing.agent@logistics.com` — email już zajęty.
- Klika `"Create Agent"`.

## Then (Oczekiwany rezultat)

- Frontend wysyła `POST /identity/api/admin/users/agents`.
- Backend zwraca błąd `400`/`409` z komunikatem o zajętym emailu.
- `AgentCreateComponent.createError` jest ustawiony na komunikat błędu z API (np. `"Email already exists"` lub odpowiedź `err.error?.message`).
- Na ekranie wyświetla się komunikat błędu z `createError`.
- Formularz pozostaje widoczny z wypełnionymi polami.
- Przycisk `"Create Agent"` wraca do stanu aktywnego (`creating = false`).
- Żadne nowe konto **nie** jest tworzone w bazie danych.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| email | `new.agent@logistics.com` | `existing.agent@logistics.com` (zajęty) |
| fullName | `Rajesh Kumar` | `brak` |
| phoneNumber | `9182683257` | `brak` |
| temporaryPassword | `Temp@1234` | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
