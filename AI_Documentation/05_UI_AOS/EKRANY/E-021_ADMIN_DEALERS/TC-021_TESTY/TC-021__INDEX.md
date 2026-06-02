# TC-021 Testy Ekranu

Status: `uzupełniony`; przypadki testowe pokrywają smoke, approve, reject z walidacją oraz update credit limit.

| ID testu | Typ | Given (skrótowo) | Priorytet | Status |
|---|---|---|---|---|
| [TC-021-0001](TC-021-0001__smoke-lista-dealerow.md) | smoke | Admin, baza z dealerami Pending i Active | P0 | `wniosek z analizy` |
| [TC-021-0002](TC-021-0002__approve-dealer.md) | happy path | Admin, dealer ze statusem Pending | P0 | `wniosek z analizy` |
| [TC-021-0003](TC-021-0003__reject-dealer-z-powodem.md) | walidacja | Admin, pusty/zbyt długi powód odrzucenia | P1 | `wniosek z analizy` |
| [TC-021-0004](TC-021-0004__update-credit-limit.md) | walidacja | Admin, ujemny lub poprawny limit kredytowy | P1 | `wniosek z analizy` |

## Istniejące Testy Automatyczne

`brak w kodzie`

## Luki Testowe

- Brak testu automatycznego UI dla ekranu listy dealerów.
- Brak testu autoryzacji: tylko rola `Admin` ma dostęp do `/admin/dealers`.
- Brak testu wyszukiwania z debounce 300ms (pole P-021-0001).
- Brak testu paginacji (page, pageSize).
- Brak testu nawigacji do szczegółu dealera (`/admin/dealers/:id`).
