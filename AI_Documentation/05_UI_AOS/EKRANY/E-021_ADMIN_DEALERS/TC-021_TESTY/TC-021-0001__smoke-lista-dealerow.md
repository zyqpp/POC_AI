# TC-021-0001 Smoke — Lista Dealerów (w tym Pending) Załadowana

| Atrybut | Wartość |
|---|---|
| ID | `TC-021-0001` |
| Ekran | [E-021](../E-021__README.md) |
| Typ | smoke |
| Priorytet | P0 |
| Powiązane | P-021-0002, P-021-0003, P-021-0006 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Admin`.
- Baza danych zawiera co najmniej jednego dealera ze statusem `Pending` i jednego ze statusem `Active`.
- API `GET /identity/api/admin/dealers?page=1&pageSize=20` jest dostępne i zwraca listę dealerów.

## When (Akcja)

- Użytkownik wchodzi na trasę `/admin/dealers`.
- Poczekuje na zakończenie ładowania (loading indicator znika).

## Then (Oczekiwany rezultat)

- Na ekranie widoczna jest tabela dealerów z co najmniej jednym wierszem.
- Każdy wiersz zawiera: pełne imię (P-021-0002), email (P-021-0003), nazwę firmy (P-021-0004), numer GST (P-021-0005), status (P-021-0006), limit kredytowy (P-021-0007), datę rejestracji (P-021-0008).
- Dealerzy ze statusem `Pending` są widoczni na liście.
- Pole wyszukiwania (P-021-0001) jest widoczne i aktywne.
- Loading indicator **nie** jest widoczny.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| page | `1` | `brak` |
| pageSize | `20` | `brak` |
| searchQuery | `` (puste — pełna lista) | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
