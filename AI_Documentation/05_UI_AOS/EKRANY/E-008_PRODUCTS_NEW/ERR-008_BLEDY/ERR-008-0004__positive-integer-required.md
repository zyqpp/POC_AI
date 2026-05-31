# ERR-008-0004 Walidacja Minimalnej Ilości Zamówienia

Status: `potwierdzone`.

| Warstwa | Warunek | Źródło |
|---|---|---|
| UI | `minOrderQty` mniejsze niż `1` albo brak wymaganej wartości | `product-form.component.ts/html` |
| Backend | `MinOrderQty` większe od `0` | `CreateProductRequestValidator` |
| DB | `Products.MinOrderQty`, `NOT NULL` | `CatalogInventoryDbContext` |

Komunikat UI: `Positive integer required`.

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0002` | `TD-008-0004`: `0`, `-1`, `1`, `24` | wartości mniejsze niż 1 blokują zapis |

## Linki

- [P-008-0004 Min Order Qty](../P-008_POLA/P-008-0004__minorderqty.md)
- [A-008-0001 Submit](../A-008_AKCJE/A-008-0001__submit.md)
