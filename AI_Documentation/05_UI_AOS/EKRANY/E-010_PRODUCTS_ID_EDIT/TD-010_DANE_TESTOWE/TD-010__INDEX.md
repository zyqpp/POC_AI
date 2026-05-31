# TD-010 Dane Testowe

Status: `potwierdzone` jako wymagania danych dla testów E-010.

| ID | Pole | Dane pozytywne | Dane negatywne / brzegowe | Dokument |
|---|---|---|---|---|
| `TD-010-0001` | [P-010-0001](../P-010_POLA/P-010-0001__sku.md) | `SKU-EDIT-010` | próba zmiany SKU w edit | [TD-010-0001](TD-010-0001__sku.md) |
| `TD-010-0002` | [P-010-0002](../P-010_POLA/P-010-0002__name.md) | `Industrial Pump X2` | pusty, 201 znaków | [TD-010-0002](TD-010-0002__name.md) |
| `TD-010-0003` | [P-010-0003](../P-010_POLA/P-010-0003__unitprice.md) | `1250.50` | `0`, `-1`, puste | [TD-010-0003](TD-010-0003__unitprice.md) |
| `TD-010-0004` | [P-010-0004](../P-010_POLA/P-010-0004__minorderqty.md) | `1`, `5` | `0`, `-1`, puste | [TD-010-0004](TD-010-0004__minorderqty.md) |
| `TD-010-0005` | [P-010-0005](../P-010_POLA/P-010-0005__openingstock.md) | stock początkowy `40` przed edycją | formularz edit nie może zmienić stocku | [TD-010-0005](TD-010-0005__openingstock.md) |
| `TD-010-0006` | [P-010-0006](../P-010_POLA/P-010-0006__categoryid.md) | istniejący `CategoryId` | pusty, nieistniejący GUID, błędny format | [TD-010-0006](TD-010-0006__categoryid.md) |
| `TD-010-0007` | [P-010-0007](../P-010_POLA/P-010-0007__description.md) | opis produktu | pusty, 2001 znaków | [TD-010-0007](TD-010-0007__description.md) |
| `TD-010-0008` | [P-010-0008](../P-010_POLA/P-010-0008__imageurl.md) | pusty, `https://cdn.example.test/pump.png` | `ftp://...`, 501 znaków | [TD-010-0008](TD-010-0008__imageurl.md) |
| `TD-010-0009` | [P-010-0009](../P-010_POLA/P-010-0009__isactive.md) | `true`, `false` | brak dedykowanej wartości błędnej w UI | [TD-010-0009](TD-010-0009__isactive.md) |
| `TD-010-0010` | [P-010-0010](../P-010_POLA/P-010-0010__group-parent-name.md) | parent `Industrial` | pusta lista kategorii | [TD-010-0010](TD-010-0010__group-parent-name.md) |
| `TD-010-0011` | [P-010-0011](../P-010_POLA/P-010-0011__child-name.md) | child `Pumps` | brak dzieci dla parenta | [TD-010-0011](TD-010-0011__child-name.md) |

## Precondition

Testy E-010 wymagają istniejącego produktu w `Products`, co najmniej jednej kategorii w `Categories` oraz użytkownika `Admin` z ważnym tokenem.
