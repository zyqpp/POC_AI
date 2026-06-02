# TC-001-0004 Walidacja Frontendu — Pusty Email lub Nieprawidłowy Format

| Atrybut | Wartość |
|---|---|
| ID | `TC-001-0004` |
| Ekran | [E-001](../E-001__README.md) |
| Typ | walidacja |
| Priorytet | P1 |
| Powiązane | A-001-0001, P-001-0001, P-001-0002, ERR-001-0002, ERR-001-0003 |
| Status | `potwierdzone` |

## Given (Warunki wstępne)

- Formularz logowania jest widoczny.
- Walidatory Reactive Forms: pole `email` ma `Validators.required` + `Validators.email`; pole `password` ma `Validators.required`.
- Wywołanie API **nie** nastąpi gdy formularz jest `invalid`.

## When (Akcja)

Scenariusz A — pusty email:
- Użytkownik pozostawia pole email puste.
- Użytkownik wpisuje hasło i klika Submit.

Scenariusz B — nieprawidłowy format email:
- Użytkownik wpisuje `notanemail` w polu email.
- Użytkownik wpisuje hasło i klika Submit.

Scenariusz C — puste hasło:
- Użytkownik wpisuje poprawny email.
- Pozostawia pole password puste i klika Submit.

## Then (Oczekiwany rezultat)

- `LoginComponent.submit()` wykrywa `form.invalid` → wywołuje `form.markAllAsTouched()`.
- Żadne wywołanie HTTP do `POST /identity/api/auth/login` **nie** jest wysyłane.
- Pole email — scenariusz A: wyświetla komunikat `"Please enter a valid email"` lub `"Email is required"`.
- Pole email — scenariusz B: wyświetla komunikat `"Please enter a valid email"`.
- Pole password — scenariusz C: wyświetla komunikat `"Password is required"`.
- Router **nie** przekierowuje.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| email | `admin@test.com` | `` (puste), `notanemail`, `@brak.pl` |
| password | `Admin@1234` | `` (puste) |

## Powiązany test automatyczny

`brak w kodzie`
