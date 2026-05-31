# ERR-008 Błędy I Komunikaty

Status: `potwierdzone` dla komunikatów UI i walidacji backendu; brak automatycznych testów UI/API oznaczony w [TC-008](../TC-008_TESTY/TC-008__INDEX.md).

| ID błędu | Komunikat / problem | Pole lub akcja | Warstwa | Dokument |
|---|---|---|---|---|
| `ERR-008-0001` | `SKU is required (letters, numbers, hyphen, underscore; max 60 chars)` | [P-008-0001](../P-008_POLA/P-008-0001__sku.md) | UI i backend | [ERR-008-0001__sku-is-required-letters-numbers-hyphen-underscore-max-60-chars.md](ERR-008-0001__sku-is-required-letters-numbers-hyphen-underscore-max-60-chars.md) |
| `ERR-008-0002` | `Name is required (max 200 chars)` | [P-008-0002](../P-008_POLA/P-008-0002__name.md) | UI i backend | [ERR-008-0002__name-is-required-max-200-chars.md](ERR-008-0002__name-is-required-max-200-chars.md) |
| `ERR-008-0003` | `Positive price required` | [P-008-0003](../P-008_POLA/P-008-0003__unitprice.md) | UI i backend | [ERR-008-0003__positive-price-required.md](ERR-008-0003__positive-price-required.md) |
| `ERR-008-0004` | `Positive integer required` | [P-008-0004](../P-008_POLA/P-008-0004__minorderqty.md) | UI i backend | [ERR-008-0004__positive-integer-required.md](ERR-008-0004__positive-integer-required.md) |
| `ERR-008-0005` | `Non-negative integer required` | [P-008-0005](../P-008_POLA/P-008-0005__openingstock.md) | UI i backend | [ERR-008-0005__non-negative-integer-required.md](ERR-008-0005__non-negative-integer-required.md) |
| `ERR-008-0006` | `Could not load categories. Try refreshing.` | [A-008-0003](../A-008_AKCJE/A-008-0003__load-categories.md) | UI/API | [ERR-008-0006__could-not-load-categories-try-refreshing.md](ERR-008-0006__could-not-load-categories-try-refreshing.md) |
| `ERR-008-0007` | `No categories available.` | [P-008-0006](../P-008_POLA/P-008-0006__categoryid.md) | UI/API | [ERR-008-0007__no-categories-available.md](ERR-008-0007__no-categories-available.md) |
| `ERR-008-0008` | `Category is required` | [P-008-0006](../P-008_POLA/P-008-0006__categoryid.md) | UI i backend | [ERR-008-0008__category-is-required.md](ERR-008-0008__category-is-required.md) |
| `ERR-008-0009` | `Description is required (max 2000 chars)` | [P-008-0007](../P-008_POLA/P-008-0007__description.md) | UI i backend | [ERR-008-0009__description-is-required-max-2000-chars.md](ERR-008-0009__description-is-required-max-2000-chars.md) |
| `ERR-008-0010` | `Image URL must be valid and max 500 chars` | [P-008-0008](../P-008_POLA/P-008-0008__imageurl.md) | UI i backend | [ERR-008-0010__image-url-must-be-valid-and-max-500-chars.md](ERR-008-0010__image-url-must-be-valid-and-max-500-chars.md) |
| `ERR-008-0011` | konflikt SKU: `SKU already exists.` | [P-008-0001](../P-008_POLA/P-008-0001__sku.md) | backend | brak osobnego pliku, ujęte w `ERR-008-0001` i `TC-008-0004` |
| `ERR-008-0012` | nieistniejąca kategoria: `Category does not exist.` | [P-008-0006](../P-008_POLA/P-008-0006__categoryid.md) | backend | ujęte w `ERR-008-0008` i `TC-008-0004` |

## Luka Obsługi Błędów

`ProductFormComponent.submit()` przy błędzie API tylko ustawia `loading=false`; w kodzie frontendu nie ma mapowania odpowiedzi backendu na toast lub komunikat przy formularzu. Status: `brak w kodzie`.
