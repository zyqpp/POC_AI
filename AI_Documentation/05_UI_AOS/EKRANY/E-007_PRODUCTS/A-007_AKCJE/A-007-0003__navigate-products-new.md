# A-007-0003 Przejście do tworzenia produktu

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Trigger | link `Add Product` |
| Widoczność | tylko `Admin` przez `@if (isAdmin())` |
| Handler | Angular Router |
| Route docelowy | `/products/new` |
| API | brak w tej akcji; docelowy ekran `E-008` używa `POST /catalog/api/products` |
| Dane | brak odczytu/zapisu DB |
| Testy | `TC-007-0006` |
