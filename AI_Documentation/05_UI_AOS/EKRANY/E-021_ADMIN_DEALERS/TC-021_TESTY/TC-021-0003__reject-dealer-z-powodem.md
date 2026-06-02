# TC-021-0003 Reject Dealer z Powodem — RequiredReason (NotEmpty, Max 400 Znaków)

| Atrybut | Wartość |
|---|---|
| ID | `TC-021-0003` |
| Ekran | [E-021](../E-021__README.md) |
| Typ | walidacja |
| Priorytet | P1 |
| Powiązane | P-021-0006 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Admin`.
- Na liście dealerów widoczny jest dealer Y ze statusem `Pending`.
- Backend walidator `RejectDealerRequestValidator`: `Reason.NotEmpty()`, `Reason.MaximumLength(400)`.
- API `PUT /identity/api/admin/dealers/{id}/reject` oczekuje ciała `{reason: string}`.

## When (Akcja)

Scenariusz A — pusty powód odrzucenia:
- Użytkownik klika `"Reject"` przy dealerze Y.
- W polu powodu (reason) pozostawia wartość pustą.
- Klika `"Confirm Reject"`.

Scenariusz B — powód za długi (> 400 znaków):
- Użytkownik klika `"Reject"` przy dealerze Y.
- Wpisuje powód o długości > 400 znaków.
- Klika `"Confirm Reject"`.

Scenariusz C — poprawny powód:
- Użytkownik klika `"Reject"` przy dealerze Y.
- Wpisuje powód: `"Incomplete business documents."`.
- Klika `"Confirm Reject"`.

## Then (Oczekiwany rezultat)

Scenariusz A:
- Walidacja (frontend lub backend) blokuje wysłanie.
- Wyświetla się błąd: powód jest wymagany.
- Status dealera pozostaje `Pending`.

Scenariusz B:
- Backend zwraca błąd `400` (FluentValidation: MaximumLength 400).
- Wyświetla się komunikat błędu o zbyt długim powodzie.
- Status dealera pozostaje `Pending`.

Scenariusz C:
- Frontend wysyła `PUT /identity/api/admin/dealers/{id}/reject` z `{reason: "Incomplete business documents."}`.
- API zwraca `200 OK`.
- Status dealera Y zmienia się na `Rejected` w tabeli.
- Wyświetla się komunikat sukcesu.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| reason | `"Incomplete business documents."` | `` (puste), ciąg > 400 znaków |
| reason.length | `<= 400` | `> 400` |
| dealerId | ID dealera ze statusem `Pending` | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
