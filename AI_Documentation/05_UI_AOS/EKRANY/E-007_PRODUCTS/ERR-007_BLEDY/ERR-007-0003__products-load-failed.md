# ERR-007-0003 Products load failed

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | `getProducts` albo `searchProducts` zwraca błąd |
| Komunikat UI | brak dedykowanego komunikatu; `loading` jest wyłączane |
| Warstwa | frontend/API |
| Status HTTP | dowolny błąd Catalog API |
| Wpływ na dane | lista pozostaje pusta albo z poprzednim stanem; brak zapisu DB |
| Dane Do Test | `TD-007-0001` |
| Test | `TC-007-0001`, `TC-007-0002` |
