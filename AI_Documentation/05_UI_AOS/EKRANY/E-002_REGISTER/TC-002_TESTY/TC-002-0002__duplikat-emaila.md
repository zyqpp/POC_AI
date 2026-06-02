# TC-002-0002 Duplikat Emaila → Błąd z Backendu

| Atrybut | Wartość |
|---|---|
| ID | `TC-002-0002` |
| Ekran | [E-002](../E-002__README.md) |
| Typ | błąd HTTP |
| Priorytet | P0 |
| Powiązane | A-002-0001, ERR-002-0001, ERR-002-0011 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Email `existing@example.com` jest już zarejestrowany w systemie (konto aktywne lub Pending).
- API `POST /identity/api/auth/register` zwraca błąd `400` lub `409` z komunikatem o duplikacie.

## When (Akcja)

- Użytkownik wypełnia formularz poprawnymi danymi (GST, telefon, hasło w poprawnym formacie).
- W polu email wpisuje `existing@example.com` — email już zajęty.
- Użytkownik klika Submit.

## Then (Oczekiwany rezultat)

- Frontend wysyła `POST /identity/api/auth/register`.
- Backend zwraca błąd `400`/`409` z komunikatem o zajętym emailu.
- Na ekranie wyświetla się komunikat błędu z `errorMsg` zawierający informację o duplikacie (np. `"Email already in use"` lub odpowiedź z API).
- Żadne nowe konto **nie** jest tworzone w bazie danych.
- Formularz pozostaje widoczny z wypełnionymi polami.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| email | `newemail@example.com` | `existing@example.com` (zajęty) |
| fullName | `Test Dealer` | `brak` |
| password | `Dealer@1234` | `brak` |
| gstNumber | `29ABCDE1234F1Z5` | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
