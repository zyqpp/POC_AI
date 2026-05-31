# ERR-008-0003 Walidacja Ceny

Status: `potwierdzone`.

| Warstwa | Warunek | Źródło |
|---|---|---|
| UI | `unitPrice` mniejsze niż `0.01` albo brak wymaganej wartości | `product-form.component.ts/html` |
| Backend | `UnitPrice` większe od `0m` | `CreateProductRequestValidator` |
| DB | `Products.UnitPrice` precision 18,2 | `CatalogInventoryDbContext` |

Komunikat UI: `Positive price required`.

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0002` | `TD-008-0003`: `0`, `-1`, `0.01`, `999999.99` | wartości niedodatnie blokują zapis; dodatnie przechodzą |

## Linki

- [P-008-0003 Unit Price](../P-008_POLA/P-008-0003__unitprice.md)
- [A-008-0001 Submit](../A-008_AKCJE/A-008-0001__submit.md)
