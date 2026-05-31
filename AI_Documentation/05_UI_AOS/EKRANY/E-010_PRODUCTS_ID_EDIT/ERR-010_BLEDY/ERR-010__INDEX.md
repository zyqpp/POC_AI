# ERR-010 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-010-0001` | SKU is required (letters, numbers, hyphen, underscore; max 60 chars) | error-css-class | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | [ERR-010-0001__sku-is-required-letters-numbers-hyphen-underscore-max-60-chars.md](ERR-010-0001__sku-is-required-letters-numbers-hyphen-underscore-max-60-chars.md) |
| `ERR-010-0002` | Name is required (max 200 chars) | error-css-class | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | [ERR-010-0002__name-is-required-max-200-chars.md](ERR-010-0002__name-is-required-max-200-chars.md) |
| `ERR-010-0003` | Positive price required | error-css-class | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | [ERR-010-0003__positive-price-required.md](ERR-010-0003__positive-price-required.md) |
| `ERR-010-0004` | Positive integer required | error-css-class | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | [ERR-010-0004__positive-integer-required.md](ERR-010-0004__positive-integer-required.md) |
| `ERR-010-0005` | Non-negative integer required | error-css-class | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | [ERR-010-0005__non-negative-integer-required.md](ERR-010-0005__non-negative-integer-required.md) |
| `ERR-010-0006` | Could not load categories. Try refreshing. | error-css-class | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | [ERR-010-0006__could-not-load-categories-try-refreshing.md](ERR-010-0006__could-not-load-categories-try-refreshing.md) |
| `ERR-010-0007` | No categories available. | error-css-class | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | [ERR-010-0007__no-categories-available.md](ERR-010-0007__no-categories-available.md) |
| `ERR-010-0008` | Category is required | error-css-class | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | [ERR-010-0008__category-is-required.md](ERR-010-0008__category-is-required.md) |
| `ERR-010-0009` | Description is required (max 2000 chars) | error-css-class | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | [ERR-010-0009__description-is-required-max-2000-chars.md](ERR-010-0009__description-is-required-max-2000-chars.md) |
| `ERR-010-0010` | Image URL must be valid and max 500 chars | error-css-class | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` | [ERR-010-0010__image-url-must-be-valid-and-max-500-chars.md](ERR-010-0010__image-url-must-be-valid-and-max-500-chars.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
