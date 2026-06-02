# TC-022-0003 Phone Format Validation → Regex ^[6-9][0-9]{9}$

| Atrybut | Wartość |
|---|---|
| ID | `TC-022-0003` |
| Ekran | [E-022](../E-022__README.md) |
| Typ | walidacja |
| Priorytet | P1 |
| Powiązane | A-022-0001, P-022-0003, ERR-022-0002 |
| Status | `potwierdzone` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Admin`.
- Formularz tworzenia agenta jest widoczny.
- Frontend waliduje telefon przez `normalizeIndianMobile()`.
- Backend walidator: `PhoneNumber.NotEmpty().Matches("^[6-9][0-9]{9}$")` (`CreateAgentRequestValidator`).
- Komunikat błędu: `"Phone number must be a valid Indian mobile number (example: 9182683257)."`.

## When (Akcja)

Scenariusz A — numer za krótki:
- Użytkownik wpisuje `12345` w polu Phone Number.
- Klika `"Create Agent"`.

Scenariusz B — numer zaczyna się od niedozwolonej cyfry (1-5):
- Użytkownik wpisuje `5182683257` (pierwsza cyfra to 5, dozwolone 6-9).
- Klika `"Create Agent"`.

Scenariusz C — numer z prefiksem kraju (akceptowany przez normalize):
- Użytkownik wpisuje `919182683257` (z prefiksem 91).
- Frontend normalizuje do `9182683257`.
- Klika `"Create Agent"`.

Scenariusz D — numer z zerem na początku (akceptowany):
- Użytkownik wpisuje `09182683257`.
- Frontend normalizuje do `9182683257`.
- Klika `"Create Agent"` (zakładając poprawne pozostałe pola).

## Then (Oczekiwany rezultat)

Scenariusz A:
- Frontend lub backend zgłasza błąd: `"Phone number must be a valid Indian mobile number (example: 9182683257)."`.
- Żadne wywołanie API (lub API zwraca 400) **nie** tworzy konta.

Scenariusz B:
- Backend zwraca `400` (regex `^[6-9][0-9]{9}$` nie pasuje do `5182683257`).
- Wyświetla się komunikat błędu.

Scenariusz C:
- `normalizeIndianMobile("919182683257")` → `"9182683257"`.
- API otrzymuje poprawny numer; jeśli reszta danych poprawna → sukces jak TC-022-0001.

Scenariusz D:
- `normalizeIndianMobile("09182683257")` → `"9182683257"`.
- API otrzymuje poprawny numer; jeśli reszta danych poprawna → sukces.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| phoneNumber (raw) | `9182683257`, `09182683257`, `919182683257` | `12345`, `5182683257`, `abc`, `` (puste) |
| phoneNumber (po normalizacji) | `9182683257` | `5182683257`, `1234` |
| regex | `^[6-9][0-9]{9}$` spełniony | nie spełniony |

## Powiązany test automatyczny

`brak w kodzie`
