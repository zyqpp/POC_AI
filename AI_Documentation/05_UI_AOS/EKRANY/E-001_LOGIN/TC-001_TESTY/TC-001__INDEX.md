# TC-001 Testy Ekranu

Status: `uzupełniony`; przypadki testowe pokrywają happy path, błędy HTTP, walidację i wymuszony reset hasła.

| ID testu | Typ | Given (skrótowo) | Priorytet | Status |
|---|---|---|---|---|
| [TC-001-0001](TC-001-0001__happy-path-login.md) | happy path | Aktywne konto, poprawne dane | P0 | `potwierdzone` |
| [TC-001-0002](TC-001-0002__bledne-haslo.md) | błąd HTTP | Aktywne konto, błędne hasło | P0 | `wniosek z analizy` |
| [TC-001-0003](TC-001-0003__konto-pending.md) | błąd HTTP | Konto z status=Pending | P1 | `wniosek z analizy` |
| [TC-001-0004](TC-001-0004__walidacja-frontendu.md) | walidacja | Pusty email lub zły format | P1 | `potwierdzone` |
| [TC-001-0005](TC-001-0005__must-change-password.md) | happy path | mustChangePassword=true w odpowiedzi API | P1 | `potwierdzone` |

## Istniejące Testy Automatyczne

`brak w kodzie`

## Luki Testowe

- Brak testu automatycznego UI dla ekranu logowania.
- Brak testu dla konta z `status = Rejected`.
- Brak testu dla wygaśniętego tokenu (zachowanie po odświeżeniu strony).
