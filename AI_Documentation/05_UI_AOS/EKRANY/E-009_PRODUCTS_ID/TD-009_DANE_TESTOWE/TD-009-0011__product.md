# TD-009-0011 Produkt Bazowy

Status: `potwierdzone`.

| Typ | Dane | Oczekiwany rezultat |
|---|---|---|
| aktywny | `ProductId=11111111-1111-4111-8111-111111111111`, `Sku=PUMP-X100`, `Name=Industrial Pump X100`, `UnitPrice=1299.99`, `MinOrderQty=5`, `TotalStock=30`, `ReservedStock=5`, `IsActive=true` | ekran pokazuje dane produktu, `AvailableStock=25`, Dealer może dodać do koszyka |
| inactive | ten sam produkt z `IsActive=false` | badge `Inactive`, `Add to Cart` disabled |
| not found | `ProductId=99999999-9999-4999-8999-999999999999` | [ERR-009-0007](../ERR-009_BLEDY/ERR-009-0007__product-not-found.md) |
| image null | `ImageUrl=null` | fallback obrazu po stronie frontendu |
