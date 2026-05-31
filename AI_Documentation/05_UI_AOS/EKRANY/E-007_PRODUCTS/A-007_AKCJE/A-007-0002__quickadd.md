# A-007-0002 Quick add do koszyka

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Trigger | przycisk `+ Add to Cart` na karcie produktu |
| Widoczność | tylko `Dealer`, produkt aktywny i `availableStock > 0` |
| Handler | `quickAdd(event, product)` |
| API | `GET /catalog/api/products/{id}` przez `getProductById` |
| DTO | `ProductDto` |
| Proces | pobiera pełny produkt, normalizuje ilość do `minOrderQty`, zapisuje do `CartStore` |
| Dane | odczyt `Products`; zapis DB `brak w kodzie` na tym ekranie |
| Błędy | [ERR-007-0001](../ERR-007_BLEDY/ERR-007-0001__this-product-is-currently-unavailable.md), [ERR-007-0002](../ERR-007_BLEDY/ERR-007-0002__failed-to-add-product-to-cart.md) |
| Testy | `TC-007-0004`, `TC-007-0005` |
