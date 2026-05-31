# P-020 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-020-0001` | channelFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0001__channelfilter.md](P-020-0001__channelfilter.md) |
| `P-020-0002` | readFilter | [(ngModel)] | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0002__readfilter.md](P-020-0002__readfilter.md) |
| `P-020-0003` | searchQuery | [(ngModel)] | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0003__searchquery.md](P-020-0003__searchquery.md) |
| `P-020-0004` | isChannelEnabledInDraft(NotificationChannel.InApp) | [checked] | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0004__ischannelenabledindraft-notificationchannel-inapp.md](P-020-0004__ischannelenabledindraft-notificationchannel-inapp.md) |
| `P-020-0005` | isChannelEnabledInDraft(NotificationChannel.Email) | [checked] | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0005__ischannelenabledindraft-notificationchannel-email.md](P-020-0005__ischannelenabledindraft-notificationchannel-email.md) |
| `P-020-0006` | isChannelEnabledInDraft(NotificationChannel.Sms) | [checked] | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0006__ischannelenabledindraft-notificationchannel-sms.md](P-020-0006__ischannelenabledindraft-notificationchannel-sms.md) |
| `P-020-0007` | isChannelEnabledInDraft(NotificationChannel.Push) | [checked] | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0007__ischannelenabledindraft-notificationchannel-push.md](P-020-0007__ischannelenabledindraft-notificationchannel-push.md) |
| `P-020-0008` | !isSourceMutedInDraft(source) | [checked] | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0008__issourcemutedindraft-source.md](P-020-0008__issourcemutedindraft-source.md) |
| `P-020-0009` | recipientUserId | formControlName | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0009__recipientuserid.md](P-020-0009__recipientuserid.md) |
| `P-020-0010` | title | formControlName | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0010__title.md](P-020-0010__title.md) |
| `P-020-0011` | body | formControlName | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0011__body.md](P-020-0011__body.md) |
| `P-020-0012` | channel | formControlName | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0012__channel.md](P-020-0012__channel.md) |
| `P-020-0013` | row.label | interpolation | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0013__row-label.md](P-020-0013__row-label.md) |
| `P-020-0014` | row.value | interpolation | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0014__row-value.md](P-020-0014__row-value.md) |
| `P-020-0015` | n.body | interpolation | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0015__n-body.md](P-020-0015__n-body.md) |
| `P-020-0016` | n.failureReason | interpolation | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0016__n-failurereason.md](P-020-0016__n-failurereason.md) |
| `P-020-0017` | n.sourceService | interpolation | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0017__n-sourceservice.md](P-020-0017__n-sourceservice.md) |
| `P-020-0018` | source | interpolation | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | [P-020-0018__source.md](P-020-0018__source.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
