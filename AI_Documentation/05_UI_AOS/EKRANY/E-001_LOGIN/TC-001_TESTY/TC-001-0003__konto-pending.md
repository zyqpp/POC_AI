# TC-001-0003 Konto Pending → Komunikat "Account pending approval"

| Atrybut | Wartość |
|---|---|
| ID | `TC-001-0003` |
| Ekran | [E-001](../E-001__README.md) |
| Typ | błąd HTTP |
| Priorytet | P1 |
| Powiązane | A-001-0001, ERR-001-0001 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Istnieje konto dealera z `status = Pending` (zarejestrowane, ale niezatwierdzone przez admina).
- API `POST /identity/api/auth/login` zwraca błąd `403` lub `400` z komunikatem dotyczącym stanu konta.

## When (Akcja)

- Użytkownik wpisuje email konta z Pending (np. `dealer.pending@test.com`).
- Użytkownik wpisuje poprawne hasło.
- Użytkownik klika przycisk Submit.

## Then (Oczekiwany rezultat)

- Frontend wysyła `POST /identity/api/auth/login`.
- API zwraca błąd z komunikatem informującym o stanie konta (np. `"Account pending approval"`).
- Na ekranie wyświetla się komunikat błędu z `errorMsg` informujący o stanie zawieszenia konta.
- `AuthStore` pozostaje pusty — żaden token nie jest zapisywany.
- Router **nie** przekierowuje na `/dashboard`.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| email | `dealer.pending@test.com` | `brak` |
| password | `Dealer@1234` | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
