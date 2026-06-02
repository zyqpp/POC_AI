# TC-011-0001 Pusty Koszyk → Komunikat "Your cart is empty"

| Atrybut | Wartość |
|---|---|
| ID | `TC-011-0001` |
| Ekran | [E-011](../E-011__README.md) |
| Typ | smoke |
| Priorytet | P0 |
| Powiązane | A-011-0007 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Dealer`.
- `CartStore.items()` zwraca pustą tablicę (`length === 0`).
- `localStorage` klucz `sc_cart` jest pusty lub nie istnieje.

## When (Akcja)

- Użytkownik wchodzi na trasę `/cart`.

## Then (Oczekiwany rezultat)

- Na ekranie widoczny jest komunikat informujący o pustym koszyku (np. `"Your cart is empty"`).
- Tabela pozycji koszyka **nie** jest wyświetlana.
- Suma zamówienia (`cartStore.total()`) **nie** jest wyświetlana lub wynosi `0`.
- Przycisk `"Proceed to Checkout"` **nie** jest widoczny lub jest wyłączony.
- Widoczny jest link lub przycisk przekierowujący na listę produktów (A-011-0007: `/products`).

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| CartStore.items | `[]` (puste) | `[{productId: "1", ...}]` (niepuste) |
| localStorage sc_cart | `[]` lub brak klucza | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
