# TD-009-0013 Stany Stock I Statusy

Status: `potwierdzone`.

| Typ | Dane | Oczekiwany rezultat |
|---|---|---|
| available normal | `TotalStock=30`, `ReservedStock=5`, `MinOrderQty=5` | `Available=25`, brak badge stock warning |
| low stock | `TotalStock=8`, `ReservedStock=0`, `MinOrderQty=1` | badge `Low Stock` |
| out of stock | `TotalStock=5`, `ReservedStock=5` | badge `Out of Stock`, zakup disabled |
| below min | `AvailableStock=3`, `MinOrderQty=5` | `maxPurchasable=0`, zakup disabled |
| inactive | `IsActive=false` | badge `Inactive`, zakup disabled |
