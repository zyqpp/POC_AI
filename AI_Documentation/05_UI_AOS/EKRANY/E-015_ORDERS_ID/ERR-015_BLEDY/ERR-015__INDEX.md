# ERR-015 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-015-0001` | Cancelled: order()!.cancellationReason | error-css-class | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [ERR-015-0001__cancelled-order-cancellationreason.md](ERR-015-0001__cancelled-order-cancellationreason.md) |
| `ERR-015-0002` | Return window expired on returnWindowExpiryLabel() . | error-css-class | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.html` | [ERR-015-0002__return-window-expired-on-returnwindowexpirylabel.md](ERR-015-0002__return-window-expired-on-returnwindowexpirylabel.md) |
| `ERR-015-0003` | this.getErrorMessage(err, 'Failed to cancel order | toast.error | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0003__this-geterrormessage-err-failed-to-cancel-order.md](ERR-015-0003__this-geterrormessage-err-failed-to-cancel-order.md) |
| `ERR-015-0004` | `Return window expired on ${this.returnWindowExpiryLabel( | toast.error | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0004__return-window-expired-on-this-returnwindowexpirylabel.md](ERR-015-0004__return-window-expired-on-this-returnwindowexpirylabel.md) |
| `ERR-015-0005` | No valid status transition available for this order | toast.error | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0005__no-valid-status-transition-available-for-this-order.md](ERR-015-0005__no-valid-status-transition-available-for-this-order.md) |
| `ERR-015-0006` | this.getErrorMessage(err, 'Failed to update order status | toast.error | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0006__this-geterrormessage-err-failed-to-update-order-status.md](ERR-015-0006__this-geterrormessage-err-failed-to-update-order-status.md) |
| `ERR-015-0007` | `${skipped} item${skipped === 1 ? '' : 's'} skipped due to stock or inactive status` | toast.warning | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0007__skipped-item-skipped-1-s-skipped-due-to-stock-or-inactive-status.md](ERR-015-0007__skipped-item-skipped-1-s-skipped-due-to-stock-or-inactive-status.md) |
| `ERR-015-0008` | Failed to reorder items | toast.error | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0008__failed-to-reorder-items.md](ERR-015-0008__failed-to-reorder-items.md) |
| `ERR-015-0009` | this.getErrorMessage(err, 'Failed to approve hold | toast.error | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0009__this-geterrormessage-err-failed-to-approve-hold.md](ERR-015-0009__this-geterrormessage-err-failed-to-approve-hold.md) |
| `ERR-015-0010` | this.getErrorMessage(err, 'Failed to reject hold | toast.error | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0010__this-geterrormessage-err-failed-to-reject-hold.md](ERR-015-0010__this-geterrormessage-err-failed-to-reject-hold.md) |
| `ERR-015-0011` | this.getErrorMessage(err, 'Failed to approve return | toast.error | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0011__this-geterrormessage-err-failed-to-approve-return.md](ERR-015-0011__this-geterrormessage-err-failed-to-approve-return.md) |
| `ERR-015-0012` | this.getErrorMessage(err, 'Failed to reject return | toast.error | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0012__this-geterrormessage-err-failed-to-reject-return.md](ERR-015-0012__this-geterrormessage-err-failed-to-reject-return.md) |
| `ERR-015-0013` | err: unknown, fallback: string | ErrorMessage | `supply-chain-frontend/src/app/features/orders/order-detail/order-detail.component.ts` | [ERR-015-0013__err-unknown-fallback-string.md](ERR-015-0013__err-unknown-fallback-string.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
