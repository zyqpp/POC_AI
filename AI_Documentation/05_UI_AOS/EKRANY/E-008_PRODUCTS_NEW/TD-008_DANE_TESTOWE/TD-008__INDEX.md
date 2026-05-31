# TD-008 Dane Testowe

Status: `potwierdzone` jako projekt danych do testów automatycznych; same testy UI/API mają status `brak w kodzie`.

| ID danych | Pole | Zakres | Dokument |
|---|---|---|---|
| `TD-008-0001` | [P-008-0001](../P-008_POLA/P-008-0001__sku.md) | poprawne, format, duplikat | [TD-008-0001__sku.md](TD-008-0001__sku.md) |
| `TD-008-0002` | [P-008-0002](../P-008_POLA/P-008-0002__name.md) | wymagane, limit 200 | [TD-008-0002__name.md](TD-008-0002__name.md) |
| `TD-008-0003` | [P-008-0003](../P-008_POLA/P-008-0003__unitprice.md) | cena dodatnia | [TD-008-0003__unitprice.md](TD-008-0003__unitprice.md) |
| `TD-008-0004` | [P-008-0004](../P-008_POLA/P-008-0004__minorderqty.md) | liczba całkowita dodatnia | [TD-008-0004__minorderqty.md](TD-008-0004__minorderqty.md) |
| `TD-008-0005` | [P-008-0005](../P-008_POLA/P-008-0005__openingstock.md) | zero i wartości dodatnie | [TD-008-0005__openingstock.md](TD-008-0005__openingstock.md) |
| `TD-008-0006` | [P-008-0006](../P-008_POLA/P-008-0006__categoryid.md) | istniejąca, pusta i nieistniejąca kategoria | [TD-008-0006__categoryid.md](TD-008-0006__categoryid.md) |
| `TD-008-0007` | [P-008-0007](../P-008_POLA/P-008-0007__description.md) | wymagane, limit 2000 | [TD-008-0007__description.md](TD-008-0007__description.md) |
| `TD-008-0008` | [P-008-0008](../P-008_POLA/P-008-0008__imageurl.md) | pusty, HTTPS, błędny schemat | [TD-008-0008__imageurl.md](TD-008-0008__imageurl.md) |
| `TD-008-0009` | [P-008-0009](../P-008_POLA/P-008-0009__isactive.md) | default aktywności produktu | [TD-008-0009__isactive.md](TD-008-0009__isactive.md) |
| `TD-008-0010` | [P-008-0010](../P-008_POLA/P-008-0010__group-parent-name.md) | grupa kategorii | [TD-008-0010__group-parent-name.md](TD-008-0010__group-parent-name.md) |
| `TD-008-0011` | [P-008-0011](../P-008_POLA/P-008-0011__child-name.md) | kategoria dziecko | [TD-008-0011__child-name.md](TD-008-0011__child-name.md) |

## Zestaw Happy Path

| Pole | Wartość |
|---|---|
| `sku` | `PUMP-X100` |
| `name` | `Industrial Pump X100` |
| `description` | `Industrial pump for automated warehouse flow.` |
| `categoryId` | istniejący `Categories.CategoryId` z kategorii `Industrial Equipment` |
| `unitPrice` | `1299.99` |
| `minOrderQty` | `1` |
| `openingStock` | `25` |
| `imageUrl` | `https://cdn.example.test/products/pump-x100.png` |
