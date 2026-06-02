# TC-011-0003 Usuń Pozycję → localStorage sc_cart Zaktualizowany

| Atrybut | Wartość |
|---|---|
| ID | `TC-011-0003` |
| Ekran | [E-011](../E-011__README.md) |
| Typ | happy path |
| Priorytet | P1 |
| Powiązane | A-011-0006, A-011-0001 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Dealer`.
- `CartStore.items()` zawiera co najmniej 2 pozycje (produkt A i produkt B).
- `localStorage["sc_cart"]` zawiera serializowany JSON z 2 pozycjami.

## When (Akcja)

- Użytkownik klika przycisk usunięcia (ikonka kosza / "Remove") przy pozycji produktu A (A-011-0006: `cartStore.removeItem`).

## Then (Oczekiwany rezultat)

- `CartStore.removeItem(productId)` jest wywołany.
- `CartStore.items()` nie zawiera już produktu A; zawiera tylko produkt B.
- `localStorage["sc_cart"]` jest zaktualizowany — JSON zawiera tylko produkt B.
- Suma zamówienia (`cartStore.total()`) aktualizuje się (bez produktu A).
- Brak wywołania żadnego endpointu HTTP — usunięcie jest lokalne.
- Jeśli była to ostatnia pozycja — wyświetla się komunikat pustego koszyka (stan TC-011-0001).

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| CartStore.items.length przed | `2` | `brak` |
| CartStore.items.length po usunięciu | `1` | `brak` |
| localStorage sc_cart po usunięciu | JSON z 1 pozycją | JSON z 2 pozycjami (niezaktualizowany) |

## Powiązany test automatyczny

`brak w kodzie`
