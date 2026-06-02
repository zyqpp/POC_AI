# TC-001-0005 mustChangePassword=true → Redirect /forgot-password?enforced=1

| Atrybut | Wartość |
|---|---|
| ID | `TC-001-0005` |
| Ekran | [E-001](../E-001__README.md) |
| Typ | happy path |
| Priorytet | P1 |
| Powiązane | A-001-0001, A-001-0003 |
| Status | `potwierdzone` |

## Given (Warunki wstępne)

- Istnieje konto agenta lub dealera z `mustChangePassword = true` (np. nowo stworzony agent przez admina).
- API `POST /identity/api/auth/login` zwraca `200 AuthTokenDto` z polem `mustChangePassword: true`.

## When (Akcja)

- Użytkownik wpisuje poprawny email konta z wymuszonym resetem hasła.
- Użytkownik wpisuje poprawne tymczasowe hasło.
- Użytkownik klika przycisk Submit.

## Then (Oczekiwany rezultat)

- Frontend wysyła `POST /identity/api/auth/login` i otrzymuje `200` z `mustChangePassword: true`.
- Gałąź `alt mustChangePassword === true` w `LoginComponent.submit()` jest wykonana.
- Router przekierowuje na `/forgot-password?email=<email>&enforced=1`.
- `AuthStore` **nie** jest uzupełniany profilem użytkownika (`getProfile()` nie jest wywoływane).
- Na ekranie logowania **nie** wyświetla się żaden komunikat błędu.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| email | `newagent@test.com` | `brak` |
| password | `Temp@1234` | `brak` |
| mustChangePassword (odpowiedź API) | `true` | `false` |

## Powiązany test automatyczny

`brak w kodzie`
