# TC-007 Testy

Status: `uzupełniony`; kluczowe przypadki testowe są zdefiniowane w plikach TC-007-NNNN.

| ID testu | Typ | Given (skrótowo) | Priorytet | Status |
|---|---|---|---|---|
| [TC-007-0001](TC-007-0001__smoke-lista-produktow.md) | smoke | Zalogowany Dealer, baza z aktywnymi produktami | P0 | `brak w kodzie` |
| [TC-007-0002](TC-007-0002__wyszukiwanie-debounce.md) | happy path | Lista załadowana, wpisanie frazy search (debounce 300ms) | P1 | `brak w kodzie` |
| [TC-007-0003](TC-007-0003__quick-add-do-koszyka.md) | happy path | Dealer, aktywny produkt ze stockiem | P1 | `potwierdzone` |
| [TC-007-0004](TC-007-0004__pusta-lista-empty-state.md) | błąd HTTP | API zwraca pustą listę lub filtry dają 0 wyników | P2 | `wniosek z analizy` |

## Istniejące Testy Automatyczne

`brak w kodzie`

## Luki Testowe

- Brak testu automatycznego UI dla ekranu produktów.
- Brak testu autoryzacji: Admin widzi przycisk "Add Product", Dealer nie.
- Brak testu paginacji (zmiana strony przez A-007-0006).
- Brak testu quick add dla produktu niedostępnego (stock=0) → ERR-007-0001.
