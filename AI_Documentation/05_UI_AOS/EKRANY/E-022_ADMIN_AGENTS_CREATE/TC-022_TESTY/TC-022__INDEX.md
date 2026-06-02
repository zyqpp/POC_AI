# TC-022 Testy Ekranu

Status: `uzupełniony`; przypadki testowe pokrywają happy path, duplikat emaila i walidację formatu telefonu.

| ID testu | Typ | Given (skrótowo) | Priorytet | Status |
|---|---|---|---|---|
| [TC-022-0001](TC-022-0001__happy-path-create-agent.md) | happy path | Admin, unikalny email, poprawne dane agenta | P0 | `wniosek z analizy` |
| [TC-022-0002](TC-022-0002__duplikat-emaila-agenta.md) | błąd HTTP | Admin, email już istniejący w systemie | P0 | `wniosek z analizy` |
| [TC-022-0003](TC-022-0003__phone-format-validation.md) | walidacja | Admin, błędny format telefonu (regex ^[6-9][0-9]{9}$) | P1 | `potwierdzone` |

## Istniejące Testy Automatyczne

`brak w kodzie`

## Luki Testowe

- Brak testu automatycznego UI dla ekranu tworzenia agenta.
- Brak testu walidacji `temporaryPassword` (min 8 zn. + uppercase + cyfra).
- Brak testu autoryzacji: tylko rola `Admin` ma dostęp do `/admin/agents/create`.
- Brak testu E2E: agent loguje się po stworzeniu i widzi wymuszony reset hasła (`mustChangePassword=true`).
