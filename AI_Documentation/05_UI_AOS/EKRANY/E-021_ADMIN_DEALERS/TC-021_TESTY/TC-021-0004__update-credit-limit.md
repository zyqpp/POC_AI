# TC-021-0004 Update Credit Limit → >= 0 (Walidator UpdateCreditLimitRequestValidator)

| Atrybut | Wartość |
|---|---|
| ID | `TC-021-0004` |
| Ekran | [E-021](../E-021__README.md) |
| Typ | walidacja |
| Priorytet | P1 |
| Powiązane | P-021-0007 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Admin`.
- Na liście dealerów widoczny jest dealer Z ze statusem `Active` i aktualnym limitem kredytowym np. `50000`.
- Backend walidator `UpdateCreditLimitRequestValidator`: `CreditLimit >= 0` (GreaterThanOrEqualTo(0)).
- API `PUT /identity/api/admin/dealers/{id}/credit-limit` oczekuje ciała `{creditLimit: number}`.

## When (Akcja)

Scenariusz A — wartość ujemna:
- Użytkownik klika "Edit Credit Limit" przy dealerze Z.
- Wpisuje wartość `-100` w pole limitu kredytowego.
- Klika `"Save"` / `"Update"`.

Scenariusz B — zero (dopuszczalne):
- Użytkownik wpisuje `0`.
- Klika `"Save"`.

Scenariusz C — wartość poprawna dodatnia:
- Użytkownik wpisuje `75000`.
- Klika `"Save"`.

## Then (Oczekiwany rezultat)

Scenariusz A:
- Backend zwraca błąd `400` (FluentValidation: `GreaterThanOrEqualTo(0)`).
- Wyświetla się komunikat błędu informujący o nieprawidłowej wartości.
- Limit kredytowy dealera **nie** jest zmieniany.

Scenariusz B:
- Frontend wysyła `PUT /identity/api/admin/dealers/{id}/credit-limit` z `{creditLimit: 0}`.
- API zwraca `200 OK`.
- Pole `d-creditlimit` (P-021-0007) w tabeli aktualizuje się do `0`.

Scenariusz C:
- Frontend wysyła `PUT /identity/api/admin/dealers/{id}/credit-limit` z `{creditLimit: 75000}`.
- API zwraca `200 OK`.
- Pole `d-creditlimit` w tabeli aktualizuje się do `75000`.
- Wyświetla się komunikat sukcesu.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| creditLimit | `75000`, `0` | `-100`, `-1` |
| dealerId | ID dealera ze statusem `Active` | `brak` |
| creditLimit.type | `number` | `string` ("abc") |

## Powiązany test automatyczny

`brak w kodzie`
