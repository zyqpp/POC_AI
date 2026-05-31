# ERR-010-0001 SKU Validation Message

Status: `potwierdzone`, ale w E-010 typowo nieosiągalne.

| Atrybut | Wartość |
|---|---|
| Pole | [P-010-0001](../P-010_POLA/P-010-0001__sku.md) |
| Komunikat UI | `SKU is required (letters, numbers, hyphen, underscore; max 60 chars)` |
| Warunek | kontrolka `sku` invalid i touched; w edit kontrolka jest wyłączana po load |
| Warstwa | frontend |
| API/DB | brak wpływu w E-010, bo `Sku` nie jest w `UpdateProductRequest` |
| Dane testowe | [TD-010-0001](../TD-010_DANE_TESTOWE/TD-010-0001__sku.md) |

Kryterium testu: po załadowaniu edit SKU jest widoczne, ale nieedytowalne i nie trafia do requestu update.
