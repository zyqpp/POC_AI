# P-009 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-009-0001` | qty | [ngModel] | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | [P-009-0001__qty.md](P-009-0001__qty.md) |
| `P-009-0002` | reviewRating | [(ngModel)] | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | [P-009-0002__reviewrating.md](P-009-0002__reviewrating.md) |
| `P-009-0003` | reviewTitle | [(ngModel)] | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | [P-009-0003__reviewtitle.md](P-009-0003__reviewtitle.md) |
| `P-009-0004` | reviewComment | [(ngModel)] | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | [P-009-0004__reviewcomment.md](P-009-0004__reviewcomment.md) |
| `P-009-0005` | restockQty | [(ngModel)] | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | [P-009-0005__restockqty.md](P-009-0005__restockqty.md) |
| `P-009-0006` | restockRef | [(ngModel)] | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | [P-009-0006__restockref.md](P-009-0006__restockref.md) |
| `P-009-0007` | r.title | interpolation | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | [P-009-0007__r-title.md](P-009-0007__r-title.md) |
| `P-009-0008` | r.createdAtUtc | interpolation | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | [P-009-0008__r-createdatutc.md](P-009-0008__r-createdatutc.md) |
| `P-009-0009` | r.comment | interpolation | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | [P-009-0009__r-comment.md](P-009-0009__r-comment.md) |
| `P-009-0010` | r.moderationNote | interpolation | `supply-chain-frontend/src/app/features/catalog/product-detail/product-detail.component.html` | [P-009-0010__r-moderationnote.md](P-009-0010__r-moderationnote.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
