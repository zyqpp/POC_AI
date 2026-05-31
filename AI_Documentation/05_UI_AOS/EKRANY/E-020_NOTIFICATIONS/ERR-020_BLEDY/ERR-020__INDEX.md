# ERR-020 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-020-0001` | Failed to load notifications | toast.error | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.ts` | [ERR-020-0001__failed-to-load-notifications.md](ERR-020-0001__failed-to-load-notifications.md) |
| `ERR-020-0002` | markRead ? 'Failed to mark notification as read' : 'Failed to mark notification as unread | toast.error | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.ts` | [ERR-020-0002__markread-failed-to-mark-notification-as-read-failed-to-mark-notification-as-unread.md](ERR-020-0002__markread-failed-to-mark-notification-as-read-failed-to-mark-notification-as-unread.md) |
| `ERR-020-0003` | Some notifications could not be marked as read | toast.warning | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.ts` | [ERR-020-0003__some-notifications-could-not-be-marked-as-read.md](ERR-020-0003__some-notifications-could-not-be-marked-as-read.md) |
| `ERR-020-0004` | Failed to mark notification as sent | toast.error | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.ts` | [ERR-020-0004__failed-to-mark-notification-as-sent.md](ERR-020-0004__failed-to-mark-notification-as-sent.md) |
| `ERR-020-0005` | Failed to mark notification as failed | toast.error | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.ts` | [ERR-020-0005__failed-to-mark-notification-as-failed.md](ERR-020-0005__failed-to-mark-notification-as-failed.md) |
| `ERR-020-0006` | Failed to create notification | toast.error | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.ts` | [ERR-020-0006__failed-to-create-notification.md](ERR-020-0006__failed-to-create-notification.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
