# ERR-013 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-013-0001` | invalidPrecheckItems( | angular-if-error-view | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.html` | [ERR-013-0001__invalidprecheckitems.md](ERR-013-0001__invalidprecheckitems.md) |
| `ERR-013-0002` | `Selected ${uniqueIds.length} order(s | toast.warning | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.ts` | [ERR-013-0002__selected-uniqueids-length-order-s.md](ERR-013-0002__selected-uniqueids-length-order-s.md) |
| `ERR-013-0003` | Failed to select matching orders | toast.error | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.ts` | [ERR-013-0003__failed-to-select-matching-orders.md](ERR-013-0003__failed-to-select-matching-orders.md) |
| `ERR-013-0004` | `${result.invalidCount} order(s | toast.warning | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.ts` | [ERR-013-0004__result-invalidcount-order-s.md](ERR-013-0004__result-invalidcount-order-s.md) |
| `ERR-013-0005` | Failed to validate selected orders | toast.error | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.ts` | [ERR-013-0005__failed-to-validate-selected-orders.md](ERR-013-0005__failed-to-validate-selected-orders.md) |
| `ERR-013-0006` | Run Validate Selection before applying bulk status | toast.warning | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.ts` | [ERR-013-0006__run-validate-selection-before-applying-bulk-status.md](ERR-013-0006__run-validate-selection-before-applying-bulk-status.md) |
| `ERR-013-0007` | `${failedCount} order(s | toast.warning | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.ts` | [ERR-013-0007__failedcount-order-s.md](ERR-013-0007__failedcount-order-s.md) |
| `ERR-013-0008` | Bulk update failed | toast.error | `supply-chain-frontend/src/app/features/orders/order-list/order-list.component.ts` | [ERR-013-0008__bulk-update-failed.md](ERR-013-0008__bulk-update-failed.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
