# A-007-0004 Przejście do szczegółu produktu

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Trigger | klik karty produktu |
| Handler | `routerLink=['/products', p.productId]` |
| Route docelowy | `/products/:id` |
| API | brak w samej akcji; docelowy ekran `E-009` ładuje `GET /catalog/api/products/{id}` |
| Dane | używa `ProductListItemDto.productId`; brak zapisu DB |
| Testy | `TC-007-0001` |
