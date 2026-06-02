# TC-011 Testy Ekranu

Status: `uzupełniony`; przypadki testowe pokrywają pusty koszyk, koszyk z pozycjami i usuwanie pozycji.

| ID testu | Typ | Given (skrótowo) | Priorytet | Status |
|---|---|---|---|---|
| [TC-011-0001](TC-011-0001__pusty-koszyk.md) | smoke | Dealer, CartStore.items puste | P0 | `wniosek z analizy` |
| [TC-011-0002](TC-011-0002__produkty-w-koszyku.md) | happy path | Dealer, CartStore.items >= 1 | P0 | `wniosek z analizy` |
| [TC-011-0003](TC-011-0003__usun-pozycje-localstorage.md) | happy path | Koszyk z 2 pozycjami, usuń jedną | P1 | `wniosek z analizy` |

## Istniejące Testy Automatyczne

`brak w kodzie`

## Luki Testowe

- Brak testu automatycznego UI dla ekranu koszyka.
- Brak testu walidacji ilości: przekroczenie `availableStock` → ERR-011-0002.
- Brak testu walidacji `minOrderQty` → ERR-011-0003.
- Brak testu autoryzacji: tylko rola `Dealer` ma dostęp do `/cart`.
- Brak testu persystencji koszyka po odświeżeniu strony (reload z localStorage).
