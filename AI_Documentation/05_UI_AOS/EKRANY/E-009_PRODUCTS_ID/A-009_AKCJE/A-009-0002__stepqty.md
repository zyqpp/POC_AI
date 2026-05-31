# A-009-0002 Step Quantity

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| UI | przyciski `-` i `+` w kontroli ilości Dealera |
| Frontend | `stepQty(direction)` używa kroku `max(1, product.minOrderQty)` i `normalizeQty` |
| API | brak |
| DB | brak zapisu; odczyt limitów z `Products.MinOrderQty`, `Products.TotalStock`, `Products.ReservedStock` |
| Testy | `TC-009-0003` |

Akcja modyfikuje tylko lokalne `qty`; zapis koszyka następuje dopiero w [A-009-0005](A-009-0005__addtocart.md).
