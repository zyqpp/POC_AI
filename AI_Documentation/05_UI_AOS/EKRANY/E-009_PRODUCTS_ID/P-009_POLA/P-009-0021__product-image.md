# P-009-0021 Product Image

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | `img` z `getProductImageUrl(product)` i obsługą `(error)` |
| Wymagalność | `ImageUrl` opcjonalne; fallback generowany po stronie frontendu |
| Walidacje | create/update dopuszcza pusty albo absolutny URL `http`/`https` max 500 |
| API/DTO | `ProductDto.ImageUrl` |
| Tabela SQL | `Products` |
| Kolumna SQL | `Products.ImageUrl` R, max 500, `NULL` dozwolone |
| Dane Do Test | `TD-009-0011`: URL poprawny, null, błąd ładowania obrazu |
| Testy | `TC-009-0001` |
