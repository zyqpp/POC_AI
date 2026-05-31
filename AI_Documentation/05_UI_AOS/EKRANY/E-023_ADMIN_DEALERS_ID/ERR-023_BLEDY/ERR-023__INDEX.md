# ERR-023 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-023-0001` | Rejection Reason: dealer()!.rejectionReason | error-css-class | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.html` | [ERR-023-0001__rejection-reason-dealer-rejectionreason.md](ERR-023-0001__rejection-reason-dealer-rejectionreason.md) |
| `ERR-023-0002` | this.getErrorMessage(err, 'Failed to create credit account | toast.error | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.ts` | [ERR-023-0002__this-geterrormessage-err-failed-to-create-credit-account.md](ERR-023-0002__this-geterrormessage-err-failed-to-create-credit-account.md) |
| `ERR-023-0003` | this.getErrorMessage(err, 'Failed to update credit limit | toast.error | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.ts` | [ERR-023-0003__this-geterrormessage-err-failed-to-update-credit-limit.md](ERR-023-0003__this-geterrormessage-err-failed-to-update-credit-limit.md) |
| `ERR-023-0004` | this.getErrorMessage(err, 'Failed to settle outstanding amount | toast.error | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.ts` | [ERR-023-0004__this-geterrormessage-err-failed-to-settle-outstanding-amount.md](ERR-023-0004__this-geterrormessage-err-failed-to-settle-outstanding-amount.md) |
| `ERR-023-0005` | err: unknown, fallback: string | ErrorMessage | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.ts` | [ERR-023-0005__err-unknown-fallback-string.md](ERR-023-0005__err-unknown-fallback-string.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
