# P-007-0012 Result count

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | display |
| Źródło | `resultCountLabel()` |
| Wymagalność | readonly |
| Walidacje | brak; wartość wyliczana z `products().length` i `totalCount()` |
| API/DTO | `PagedResult.totalCount` dla trybu stronicowania produktów |
| Tabela SQL | brak bezpośredniej tabeli dla pola; count pochodzi z query produktów |
| Kolumna SQL | brak pojedynczej kolumny; agregacja liczby rekordów `Products` |
| Dane Do Test | `TD-007-0001` |
| Akcje | load page, search, filtry lokalne |
