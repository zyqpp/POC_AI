# ERR-010 Błędy I Komunikaty

Status: `potwierdzone` dla komunikatów UI i luk obsługi API.

| ID błędu | Komunikat / stan | Powiązanie | Warstwa | Dokument |
|---|---|---|---|---|
| `ERR-010-0001` | `SKU is required...` | `P-010-0001` | UI, odziedziczone z formularza create | [ERR-010-0001](ERR-010-0001__sku-is-required-letters-numbers-hyphen-underscore-max-60-chars.md) |
| `ERR-010-0002` | `Name is required...` | `P-010-0002` | UI i backend | [ERR-010-0002](ERR-010-0002__name-is-required-max-200-chars.md) |
| `ERR-010-0003` | `Positive price required` | `P-010-0003` | UI i backend | [ERR-010-0003](ERR-010-0003__positive-price-required.md) |
| `ERR-010-0004` | `Positive integer required` | `P-010-0004` | UI i backend | [ERR-010-0004](ERR-010-0004__positive-integer-required.md) |
| `ERR-010-0005` | `Non-negative integer required` | `P-010-0005` | UI, nieosiągalne w edit | [ERR-010-0005](ERR-010-0005__non-negative-integer-required.md) |
| `ERR-010-0006` | `Could not load categories. Try refreshing.` | `P-010-0006` | UI load categories | [ERR-010-0006](ERR-010-0006__could-not-load-categories-try-refreshing.md) |
| `ERR-010-0007` | `No categories available.` | `P-010-0006` | UI empty state | [ERR-010-0007](ERR-010-0007__no-categories-available.md) |
| `ERR-010-0008` | `Category is required` | `P-010-0006` | UI i backend | [ERR-010-0008](ERR-010-0008__category-is-required.md) |
| `ERR-010-0009` | `Description is required...` | `P-010-0007` | UI i backend | [ERR-010-0009](ERR-010-0009__description-is-required-max-2000-chars.md) |
| `ERR-010-0010` | `Image URL must be valid...` | `P-010-0008` | UI i backend | [ERR-010-0010](ERR-010-0010__image-url-must-be-valid-and-max-500-chars.md) |
| `ERR-010-0011` | product not found during load/update | `A-010-0001`, `A-010-0003` | API `404`; brak widocznego UI | [ERR-010-0011](ERR-010-0011__product-not-found.md) |
| `ERR-010-0012` | silent update error | `A-010-0001` | UI error handler | [ERR-010-0012](ERR-010-0012__silent-update-error.md) |
