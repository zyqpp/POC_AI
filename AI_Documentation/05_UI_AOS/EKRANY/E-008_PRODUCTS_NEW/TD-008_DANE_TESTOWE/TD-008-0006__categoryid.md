# TD-008-0006 Dane Testowe Dla Kategorii

Status: `potwierdzone`.

| Typ | Wartość | Oczekiwany rezultat |
|---|---|---|
| poprawne | istniejący `Categories.CategoryId` | zapis do `Products.CategoryId` |
| puste | pusty string | [ERR-008-0008](../ERR-008_BLEDY/ERR-008-0008__category-is-required.md) |
| zły format | `not-a-guid` | walidacja Angular blokuje submit |
| nieistniejące | poprawny GUID bez rekordu w `Categories` | backend `Category does not exist.` |
| pusty katalog | `GET /categories` zwraca pustą listę | [ERR-008-0007](../ERR-008_BLEDY/ERR-008-0007__no-categories-available.md) |

Powiązane testy: `TC-008-0001`, `TC-008-0003`, `TC-008-0004`.
