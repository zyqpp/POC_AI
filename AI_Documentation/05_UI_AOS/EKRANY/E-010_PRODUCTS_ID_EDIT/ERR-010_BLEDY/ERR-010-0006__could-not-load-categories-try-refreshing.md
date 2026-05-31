# ERR-010-0006 Could Not Load Categories

Status: `potwierdzone`.

| Atrybut | Wartość |
|---|---|
| Akcja | [A-010-0003](../A-010_AKCJE/A-010-0003__load-product-and-categories.md) |
| Pole | [P-010-0006](../P-010_POLA/P-010-0006__categoryid.md) |
| Komunikat UI | `Could not load categories. Try refreshing.` |
| Warunek | `CatalogApiService.getCategories()` zwraca błąd |
| UI state | `categoryLoadFailed=true`, select disabled gdy brak kategorii |
| DB | brak zapisu, odczyt `Categories` nieudany |
| Dane testowe | [TD-010-0006](../TD-010_DANE_TESTOWE/TD-010-0006__categoryid.md) |
