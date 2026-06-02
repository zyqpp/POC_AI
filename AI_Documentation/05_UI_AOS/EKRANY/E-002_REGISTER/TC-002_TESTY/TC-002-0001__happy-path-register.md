# TC-002-0001 Happy Path — Wszystkie Pola Poprawne → "Registration submitted"

| Atrybut | Wartość |
|---|---|
| ID | `TC-002-0001` |
| Ekran | [E-002](../E-002__README.md) |
| Typ | happy path |
| Priorytet | P0 |
| Powiązane | A-002-0001 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Email `testdealer@example.com` nie istnieje jeszcze w systemie.
- API `POST /identity/api/auth/register` jest dostępne i zwraca `200` lub `201`.
- GST number ma poprawny format indyjski (np. `29ABCDE1234F1Z5`).
- Numer telefonu ma format `^[6-9][0-9]{9}$` (np. `9182683257`).

## When (Akcja)

- Użytkownik wypełnia wszystkie pola formularza rejestracji poprawnymi wartościami:
  - Full Name: `Test Dealer`
  - Email: `testdealer@example.com`
  - Password: `Dealer@1234`
  - Phone Number: `9182683257`
  - Business Name: `Test Business Pvt Ltd`
  - GST Number: `29ABCDE1234F1Z5`
  - Trade License No: `TL123456`
  - PIN Code: `560001`
  - Address: `123 Main Street`
  - City: `Bangalore`
  - State: `Karnataka`
- Użytkownik klika Submit.

## Then (Oczekiwany rezultat)

- Frontend wysyła `POST /identity/api/auth/register` z danymi formularza.
- API zwraca `200`/`201` z potwierdzeniem.
- Na ekranie pojawia się komunikat sukcesu (np. `"Registration submitted"` lub podobny).
- Konto dealera jest tworzone ze statusem `Pending` w bazie danych.
- Formularz jest czyszczony lub użytkownik jest przekierowany na stronę logowania.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| fullName | `Test Dealer` | `` (puste) |
| email | `testdealer@example.com` | `notanemail` |
| password | `Dealer@1234` | `weak` |
| phoneNumber | `9182683257` | `12345` |
| businessName | `Test Business Pvt Ltd` | `` (puste) |
| gstNumber | `29ABCDE1234F1Z5` | `INVALID_GST` |
| pinCode | `560001` | `12` |
| address | `123 Main Street` | `` (puste) |

## Powiązany test automatyczny

`brak w kodzie`
