# TC-002-0003 Walidacja GST (Format Indyjski) → Błąd Frontendu

| Atrybut | Wartość |
|---|---|
| ID | `TC-002-0003` |
| Ekran | [E-002](../E-002__README.md) |
| Typ | walidacja |
| Priorytet | P1 |
| Powiązane | A-002-0001, P-002-0006, ERR-002-0007 |
| Status | `potwierdzone` |

## Given (Warunki wstępne)

- Formularz rejestracji jest widoczny.
- Pole `gstNumber` (P-002-0006) posiada walidację regex formatu GST: `[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}` (standard indyjski).
- Komunikat błędu zdefiniowany jako: `"Valid GST required (example: 29ABCDE1234F1Z5)"`.

## When (Akcja)

Scenariusz A — zbyt krótki/błędny format:
- Użytkownik wpisuje `INVALIDGST` w polu GST Number.
- Użytkownik klika Submit lub opuszcza pole.

Scenariusz B — brak cyfr na początku:
- Użytkownik wpisuje `ABCDE1234F1Z5` (brakuje 2-cyfrowego kodu stanu).
- Użytkownik klika Submit.

## Then (Oczekiwany rezultat)

- Frontend waliduje pole `gstNumber` bez wywołania API.
- Wyświetla się komunikat: `"Valid GST required (example: 29ABCDE1234F1Z5)"`.
- Żadne wywołanie `POST /identity/api/auth/register` **nie** jest wysyłane.
- Router **nie** przekierowuje.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| gstNumber | `29ABCDE1234F1Z5` | `INVALIDGST`, `12345`, `ABCDE1234F1Z5`, `` (puste) |
| fullName | `Test Dealer` | `brak` |
| email | `valid@example.com` | `brak` |
| password | `Dealer@1234` | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
