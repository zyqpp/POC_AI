# ERR-008-0010 Walidacja URL Obrazu

Status: `potwierdzone`.

| Warstwa | Warunek | Źródło |
|---|---|---|
| UI | `imageUrl` niepuste i niepasujące do `http` albo `https`, albo powyżej 500 znaków | `product-form.component.ts/html` |
| Backend | `ImageUrl` max 500 i absolutny URL `http` lub `https` | `CreateProductRequestValidator` |
| DB | `Products.ImageUrl` max 500, `NULL` dozwolone | `CatalogInventoryDbContext` |

Komunikat UI: `Image URL must be valid and max 500 chars`.

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0002` | `TD-008-0008`: puste, `https://cdn.example.test/product.png`, `ftp://bad`, 501 znaków | puste i HTTPS przechodzą, błędny schemat i nadmiar długości blokują zapis |

## Linki

- [P-008-0008 Image URL](../P-008_POLA/P-008-0008__imageurl.md)
- [A-008-0001 Submit](../A-008_AKCJE/A-008-0001__submit.md)
