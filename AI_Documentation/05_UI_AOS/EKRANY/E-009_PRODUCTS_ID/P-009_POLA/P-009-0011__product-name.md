# P-009-0011 Product Name

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | H1 `product.name` |
| Wymagalność | wymagane w `ProductDto`; ekran pusty, gdy produkt nie istnieje |
| Walidacje | create/update max 200, required |
| API/DTO | `ProductDto.Name` z `GET /catalog/api/products/{id}` |
| Tabela SQL | `Products` |
| Kolumna SQL | `Products.Name` R, max 200, `NOT NULL` |
| Dane Do Test | `TD-009-0011`: produkt aktywny, inactive, not found |
| Testy | `TC-009-0001`, `TC-009-0002` |
