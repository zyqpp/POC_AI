# ERR-007-0001 This product is currently unavailable

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | quick add pobiera produkt, ale `!isActive` albo znormalizowana ilość `<= 0` |
| Komunikat UI | `This product is currently unavailable` |
| Warstwa | frontend `ProductListComponent.quickAdd` |
| Status HTTP | brak; błąd biznesowy po stronie UI |
| Wpływ na dane | brak zapisu w `CartStore`, brak zapisu DB |
| Dane Do Test | `TD-007-0005` |
| Test | `TC-007-0005` |
