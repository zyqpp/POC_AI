# TC-002-0004 Hasło Zbyt Słabe → Błąd Walidacji

| Atrybut | Wartość |
|---|---|
| ID | `TC-002-0004` |
| Ekran | [E-002](../E-002__README.md) |
| Typ | walidacja |
| Priorytet | P1 |
| Powiązane | A-002-0001, P-002-0003, ERR-002-0004 |
| Status | `potwierdzone` |

## Given (Warunki wstępne)

- Formularz rejestracji jest widoczny.
- Pole `password` (P-002-0003) posiada walidację: min. 8 znaków, wielka litera, mała litera, cyfra, znak specjalny.
- Komunikat błędu: `"Min 8 chars, uppercase, lowercase, number, special char"`.

## When (Akcja)

Scenariusz A — za krótkie hasło:
- Użytkownik wpisuje `abc123` (7 znaków, brak wielkich i znaku specjalnego).

Scenariusz B — brak znaku specjalnego:
- Użytkownik wpisuje `Abcdef12` (brak znaku specjalnego).

Scenariusz C — brak cyfry:
- Użytkownik wpisuje `Abcdefg!` (brak cyfry).

- We wszystkich scenariuszach użytkownik klika Submit lub opuszcza pole hasła.

## Then (Oczekiwany rezultat)

- Frontend waliduje pole `password` bez wywołania API.
- Wyświetla się komunikat błędu: `"Min 8 chars, uppercase, lowercase, number, special char"`.
- Żadne wywołanie `POST /identity/api/auth/register` **nie** jest wysyłane.
- Router **nie** przekierowuje.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| password | `Dealer@1234` | `abc123` (za krótkie), `Abcdef12` (brak specjalnego), `Abcdefg!` (brak cyfry), `abcdef@1` (brak wielkiej) |
| fullName | `Test Dealer` | `brak` |
| email | `valid@example.com` | `brak` |
| gstNumber | `29ABCDE1234F1Z5` | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
