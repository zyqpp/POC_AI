# TC-001-0001 Happy Path — Poprawny Login → Redirect /dashboard

| Atrybut | Wartość |
|---|---|
| ID | `TC-001-0001` |
| Ekran | [E-001](../E-001__README.md) |
| Typ | happy path |
| Priorytet | P0 |
| Powiązane | A-001-0001 |
| Status | `potwierdzone` |

## Given (Warunki wstępne)

- Użytkownik posiada aktywne konto z rolą `Admin`, `Dealer`, `Agent` lub `Logistics`.
- Konto ma `status = Active` i `mustChangePassword = false`.
- API `POST /identity/api/auth/login` zwraca `200 AuthTokenDto` z tokenem.
- API `GET /identity/api/users/profile` zwraca `UserProfileDto`.

## When (Akcja)

- Użytkownik wpisuje poprawny email (np. `admin@test.com`) w pole email.
- Użytkownik wpisuje poprawne hasło (np. `Admin@1234`) w pole password.
- Użytkownik klika przycisk Submit (lub naciska Enter).

## Then (Oczekiwany rezultat)

- Frontend wysyła `POST /identity/api/auth/login` z `{email, password}`.
- Frontend pobiera profil: `GET /identity/api/users/profile`.
- `AuthStore` zapisuje `accessToken` i dane profilu w pamięci.
- Router przekierowuje użytkownika na `/dashboard`.
- Na ekranie `/dashboard` widoczna jest nawigacja z rolą użytkownika.
- Pole `errorMsg` jest puste — żaden komunikat błędu nie jest widoczny.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| email | `admin@test.com` | `brak` |
| password | `Admin@1234` | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
