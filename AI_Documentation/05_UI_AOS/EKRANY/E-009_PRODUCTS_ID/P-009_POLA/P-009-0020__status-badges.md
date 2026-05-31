# P-009-0020 Product Status Badges

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | badge `Inactive`, `Out of Stock`, `Low Stock` |
| Wymagalność | opcjonalne, zależne od stanu produktu |
| Walidacje | `!isActive`, `availableStock === 0`, `availableStock > 0 && availableStock < 10` |
| API/DTO | `ProductDto.IsActive`, `ProductDto.AvailableStock` |
| Tabela SQL | `Products` |
| Kolumna SQL | `Products.IsActive`, `Products.TotalStock`, `Products.ReservedStock`; `AvailableStock` wyliczone |
| Dane Do Test | `TD-009-0013`: inactive, out of stock, low stock |
| Testy | `TC-009-0002`, `TC-009-0004` |
