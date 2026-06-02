# TC-007-0003 Quick Add do Koszyka → CartStore.items++, Brak Zapisu DB

| Atrybut | Wartość |
|---|---|
| ID | `TC-007-0003` |
| Ekran | [E-007](../E-007__README.md) |
| Typ | happy path |
| Priorytet | P1 |
| Powiązane | A-007-0002, ERR-007-0001, ERR-007-0002 |
| Status | `potwierdzone` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Dealer`.
- Lista produktów jest załadowana.
- Produkt X jest aktywny i ma `availableStock > 0`.
- Koszyk jest pusty lub zawiera inne produkty (`CartStore.items`).

## When (Akcja)

- Użytkownik klika przycisk `"+ Add to Cart"` na karcie produktu X.

## Then (Oczekiwany rezultat)

- Frontend wywołuje `GET /catalog/api/products/{id}` przez `getProductById` w celu pobrania pełnych danych produktu.
- Ilość jest normalizowana do `minOrderQty` produktu.
- `CartStore.items` zwiększa się o 1 pozycję (lub aktualizuje ilość jeśli produkt już w koszyku).
- Koszyk jest zapisywany w `localStorage` pod kluczem `sc_cart` (zapis do localStorage, brak zapisu do DB).
- Brak wywołania żadnego endpointu `POST /orders/...` — koszyk jest lokalny.
- Ikonka/licznik koszyka w nawigacji aktualizuje się.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| productId | ID istniejącego aktywnego produktu ze stockiem | ID produktu z `availableStock = 0` |
| availableStock | `> 0` | `= 0` (błąd ERR-007-0001) |
| minOrderQty | `1` lub wyższe | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
