# TC-001-0002 Błędne Hasło → Komunikat "Invalid credentials", Brak Tokenu

| Atrybut | Wartość |
|---|---|
| ID | `TC-001-0002` |
| Ekran | [E-001](../E-001__README.md) |
| Typ | błąd HTTP |
| Priorytet | P0 |
| Powiązane | A-001-0001, ERR-001-0001 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Użytkownik posiada aktywne konto.
- API `POST /identity/api/auth/login` zwraca `401 Unauthorized` lub `400 Bad Request` z komunikatem błędu w ciele odpowiedzi.

## When (Akcja)

- Użytkownik wpisuje poprawny email (np. `admin@test.com`) w pole email.
- Użytkownik wpisuje **błędne** hasło (np. `WrongPass!1`) w pole password.
- Użytkownik klika przycisk Submit.

## Then (Oczekiwany rezultat)

- Frontend wysyła `POST /identity/api/auth/login` z błędnymi danymi.
- API zwraca błąd `401` lub `400`.
- Na ekranie pojawia się komunikat błędu: `"Invalid email or password."` (lub wiadomość z `err.error?.message`).
- `AuthStore` pozostaje pusty — `accessToken` nie jest zapisany.
- Router **nie** przekierowuje na `/dashboard`.
- Formularz pozostaje widoczny i dostępny do ponownego wypełnienia.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| email | `admin@test.com` | `admin@test.com` |
| password | `Admin@1234` | `WrongPass!1` |

## Powiązany test automatyczny

`brak w kodzie`
