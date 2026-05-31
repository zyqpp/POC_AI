# P-021 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-021-0001` | searchQuery | [(ngModel)] | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` | [P-021-0001__searchquery.md](P-021-0001__searchquery.md) |
| `P-021-0002` | d.fullName | interpolation | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` | [P-021-0002__d-fullname.md](P-021-0002__d-fullname.md) |
| `P-021-0003` | d.email | interpolation | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` | [P-021-0003__d-email.md](P-021-0003__d-email.md) |
| `P-021-0004` | d.businessName | interpolation | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` | [P-021-0004__d-businessname.md](P-021-0004__d-businessname.md) |
| `P-021-0005` | d.gstNumber | interpolation | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` | [P-021-0005__d-gstnumber.md](P-021-0005__d-gstnumber.md) |
| `P-021-0006` | d.status | interpolation | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` | [P-021-0006__d-status.md](P-021-0006__d-status.md) |
| `P-021-0007` | d.creditLimit | interpolation | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` | [P-021-0007__d-creditlimit.md](P-021-0007__d-creditlimit.md) |
| `P-021-0008` | d.registeredAtUtc | interpolation | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` | [P-021-0008__d-registeredatutc.md](P-021-0008__d-registeredatutc.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
