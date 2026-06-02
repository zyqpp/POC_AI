# TC-011-0002 Produkty w Koszyku → Tabela + Suma + Przycisk "Proceed to Checkout"

| Atrybut | Wartość |
|---|---|
| ID | `TC-011-0002` |
| Ekran | [E-011](../E-011__README.md) |
| Typ | happy path |
| Priorytet | P0 |
| Powiązane | A-011-0008, P-011-0002, P-011-0003, P-011-0004, P-011-0007 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Dealer`.
- `CartStore.items()` zawiera co najmniej 1 pozycję z poprawnymi danymi produktu.
- `localStorage` klucz `sc_cart` zawiera serializowane pozycje koszyka.
- Produkty w koszyku są aktywne i mają wystarczający stock.

## When (Akcja)

- Użytkownik wchodzi na trasę `/cart`.

## Then (Oczekiwany rezultat)

- Na ekranie widoczna jest tabela z pozycjami koszyka.
- Każda pozycja zawiera: nazwę produktu (P-011-0002), SKU (P-011-0003), cenę jednostkową (P-011-0004), notatkę (P-011-0005), minimalną ilość zamówienia (P-011-0006), sumę linii (P-011-0007).
- Na dole tabeli widoczna jest łączna suma zamówienia (`cartStore.total()`).
- Przycisk `"Proceed to Checkout"` jest widoczny i aktywny (A-011-0008).
- Kliknięcie `"Proceed to Checkout"` przekierowuje na `/checkout`.
- Komunikat pustego koszyka **nie** jest wyświetlany.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| CartStore.items.length | `>= 1` | `0` (pusty koszyk) |
| CartItem.productName | `"Cement OPC 53"` | `brak` |
| CartItem.unitPrice | `450.00` | `brak` |
| CartItem.quantity | `>= minOrderQty` | `< minOrderQty` |
| CartStore.total | `> 0` | `0` |

## Powiązany test automatyczny

`brak w kodzie`
