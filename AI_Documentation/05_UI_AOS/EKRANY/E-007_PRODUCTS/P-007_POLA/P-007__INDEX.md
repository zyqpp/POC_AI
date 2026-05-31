# P-007 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-007-0001` | searchQuery | [(ngModel)] | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | [P-007-0001__searchquery.md](P-007-0001__searchquery.md) |
| `P-007-0002` | parentCategoryFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | [P-007-0002__parentcategoryfilter.md](P-007-0002__parentcategoryfilter.md) |
| `P-007-0003` | childCategoryFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | [P-007-0003__childcategoryfilter.md](P-007-0003__childcategoryfilter.md) |
| `P-007-0004` | stockFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | [P-007-0004__stockfilter.md](P-007-0004__stockfilter.md) |
| `P-007-0005` | sortBy | [(ngModel)] | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | [P-007-0005__sortby.md](P-007-0005__sortby.md) |
| `P-007-0006` | parent.name | interpolation | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | [P-007-0006__parent-name.md](P-007-0006__parent-name.md) |
| `P-007-0007` | child.name | interpolation | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | [P-007-0007__child-name.md](P-007-0007__child-name.md) |
| `P-007-0008` | p.name | interpolation | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | [P-007-0008__p-name.md](P-007-0008__p-name.md) |
| `P-007-0009` | p.sku | interpolation | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | [P-007-0009__p-sku.md](P-007-0009__p-sku.md) |
| `P-007-0010` | p.unitPrice | interpolation | `supply-chain-frontend/src/app/features/catalog/product-list/product-list.component.html` | [P-007-0010__p-unitprice.md](P-007-0010__p-unitprice.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
