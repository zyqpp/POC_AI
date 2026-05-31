# P-008-0008 Image URL

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | input url |
| Wymagalność | optional |
| Walidacje | Angular: max 500 i regex pusty/http/https; backend: max 500 i absolutny URL http/https |
| API/DTO | `CreateProductRequest.imageUrl` |
| Tabela SQL | `Products` |
| Kolumna SQL | `ImageUrl`, max 500, `NULL`, zapis `W` |
| Dane Do Test | `TD-008-0008`: pusty, `https://...`, `ftp://...`, >500 znaków |
| Błędy | [ERR-008-0010](../ERR-008_BLEDY/ERR-008-0010__image-url-must-be-valid-and-max-500-chars.md) |
