# ERR-007-0004 Categories load failed

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | `getCategories()` zwraca błąd |
| Komunikat UI | brak dedykowanego komunikatu na liście; kategorie ustawiane są na pustą tablicę |
| Warstwa | frontend/API |
| Status HTTP | dowolny błąd Catalog API |
| Wpływ na dane | filtry kategorii nie mają opcji; brak zapisu DB |
| Dane Do Test | `TD-007-0002` |
| Test | `TC-007-0001`, `TC-007-0003` |
