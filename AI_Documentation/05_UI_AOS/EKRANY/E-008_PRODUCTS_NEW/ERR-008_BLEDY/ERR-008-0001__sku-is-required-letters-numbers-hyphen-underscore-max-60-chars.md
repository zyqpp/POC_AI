# ERR-008-0001 Walidacja SKU

Status: `potwierdzone`.

## Warunki Wystąpienia

| Warstwa | Warunek | Źródło |
|---|---|---|
| UI | `sku` puste, dłuższe niż 60 znaków albo poza regex `^[A-Za-z0-9-_]+$` | `product-form.component.ts/html` |
| Backend | `Sku` `NotEmpty`, `MaximumLength(60)`, `Matches(...)` | `CreateProductRequestValidator` |
| Backend biznesowy | SKU po normalizacji istnieje już w `Products.Sku` | `CatalogInventoryService.CreateProductAsync` |
| DB | unikalny indeks `IX_Products_Sku` | `CatalogInventoryDbContext` |

## Komunikaty I Efekt

| Typ | Treść / efekt |
|---|---|
| UI | `SKU is required (letters, numbers, hyphen, underscore; max 60 chars)` |
| Backend regex | `SKU must contain only letters, numbers, hyphen, or underscore.` |
| Backend duplikat | `SKU already exists.` |
| Skutek DB | brak insertu `Products`, brak outbox `ProductCreated` |

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0002` | `TD-008-0001` z pustym SKU, znakiem spacji i znakiem specjalnym | przycisk submit zablokowany lub walidacja UI widoczna |
| `TC-008-0004` | `TD-008-0001` z duplikatem `PUMP-X100` | backend odrzuca request, brak nowego rekordu |

## Linki

- [P-008-0001 SKU](../P-008_POLA/P-008-0001__sku.md)
- [A-008-0001 Submit](../A-008_AKCJE/A-008-0001__submit.md)
