# P-009-0015 Available Stock

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | liczba `Available`, badge `Out of Stock`/`Low Stock`, limit koszyka |
| Wymagalność | wymagane w `ProductDto` jako wartość wyliczona |
| Walidacje | `canPurchase`, `maxPurchasable`, `addToCart` porównują z `availableStock` |
| API/DTO | `ProductDto.AvailableStock` |
| Tabela SQL | `Products` |
| Kolumna SQL | brak osobnej kolumny; wyliczone z `Products.TotalStock - Products.ReservedStock` |
| Dane Do Test | `TD-009-0013`: `0`, `5`, `25`, poniżej `MinOrderQty` |
| Testy | `TC-009-0001`, `TC-009-0003`, `TC-009-0004` |
