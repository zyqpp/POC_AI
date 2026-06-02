# TC-002 Testy Ekranu

Status: `uzupełniony`; przypadki testowe pokrywają happy path, duplikat emaila, walidację GST i walidację hasła.

| ID testu | Typ | Given (skrótowo) | Priorytet | Status |
|---|---|---|---|---|
| [TC-002-0001](TC-002-0001__happy-path-register.md) | happy path | Wszystkie pola poprawne, unikalny email | P0 | `wniosek z analizy` |
| [TC-002-0002](TC-002-0002__duplikat-emaila.md) | błąd HTTP | Email już istniejący w systemie | P0 | `wniosek z analizy` |
| [TC-002-0003](TC-002-0003__walidacja-gst.md) | walidacja | Błędny format GST (indyjski) | P1 | `potwierdzone` |
| [TC-002-0004](TC-002-0004__haslo-zbyt-slabe.md) | walidacja | Hasło nie spełnia wymagań złożoności | P1 | `potwierdzone` |

## Istniejące Testy Automatyczne

`brak w kodzie`

## Luki Testowe

- Brak testu automatycznego UI dla ekranu rejestracji.
- Brak testu walidacji pola `phoneNumber` (format `^[6-9][0-9]{9}$`).
- Brak testu walidacji `pinCode` (6-cyfrowy).
- Brak testu E2E weryfikującego email powitalny po rejestracji.
