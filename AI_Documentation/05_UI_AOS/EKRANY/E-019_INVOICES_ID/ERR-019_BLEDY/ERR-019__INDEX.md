# ERR-019 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-019-0001` | Failed to update collection workflow | toast.error | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` | [ERR-019-0001__failed-to-update-collection-workflow.md](ERR-019-0001__failed-to-update-collection-workflow.md) |
| `ERR-019-0002` | Failed to set promise-to-pay target | toast.error | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` | [ERR-019-0002__failed-to-set-promise-to-pay-target.md](ERR-019-0002__failed-to-set-promise-to-pay-target.md) |
| `ERR-019-0003` | Reminder state saved, but notification dispatch failed | toast.error | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` | [ERR-019-0003__reminder-state-saved-but-notification-dispatch-failed.md](ERR-019-0003__reminder-state-saved-but-notification-dispatch-failed.md) |
| `ERR-019-0004` | Failed to update reminder workflow state | toast.error | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` | [ERR-019-0004__failed-to-update-reminder-workflow-state.md](ERR-019-0004__failed-to-update-reminder-workflow-state.md) |
| `ERR-019-0005` | Failed to mark invoice as paid | toast.error | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` | [ERR-019-0005__failed-to-mark-invoice-as-paid.md](ERR-019-0005__failed-to-mark-invoice-as-paid.md) |
| `ERR-019-0006` | Invoice escalated for collection follow-up | toast.warning | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` | [ERR-019-0006__invoice-escalated-for-collection-follow-up.md](ERR-019-0006__invoice-escalated-for-collection-follow-up.md) |
| `ERR-019-0007` | Escalation state saved, but notification dispatch failed | toast.error | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` | [ERR-019-0007__escalation-state-saved-but-notification-dispatch-failed.md](ERR-019-0007__escalation-state-saved-but-notification-dispatch-failed.md) |
| `ERR-019-0008` | Failed to escalate invoice workflow | toast.error | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` | [ERR-019-0008__failed-to-escalate-invoice-workflow.md](ERR-019-0008__failed-to-escalate-invoice-workflow.md) |
| `ERR-019-0009` | PDF not available | toast.error | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` | [ERR-019-0009__pdf-not-available.md](ERR-019-0009__pdf-not-available.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
