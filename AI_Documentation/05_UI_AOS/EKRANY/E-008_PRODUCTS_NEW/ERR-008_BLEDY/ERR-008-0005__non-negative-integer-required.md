# ERR-008-0005 Walidacja Stanu Początkowego

Status: `potwierdzone`.

| Warstwa | Warunek | Źródło |
|---|---|---|
| UI | `openingStock` mniejsze niż `0` albo brak wymaganej wartości | `product-form.component.ts/html` |
| Backend | `OpeningStock` większe lub równe `0` | `CreateProductRequestValidator` |
| Domena | `Product.Create` odrzuca ujemny stock wyjątkiem `Opening stock cannot be negative.` | `Product.cs` |
| DB | zapis do `Products.TotalStock`, `ReservedStock` pozostaje domyślne `0` | `Product.Create` |

Komunikat UI: `Non-negative integer required`.

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0002` | `TD-008-0005`: `-1`, `0`, `25` | wartości ujemne blokują zapis; `0` i dodatnie przechodzą |

## Linki

- [P-008-0005 Opening Stock](../P-008_POLA/P-008-0005__openingstock.md)
- [A-008-0001 Submit](../A-008_AKCJE/A-008-0001__submit.md)
