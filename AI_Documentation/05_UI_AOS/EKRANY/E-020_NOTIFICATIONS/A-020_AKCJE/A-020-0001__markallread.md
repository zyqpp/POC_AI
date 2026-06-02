# A-020-0001 markAllRead

Status: `szkielet`; wymagane ręczne uzupełnienie po analizie UI, API i procesu.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-020-0001` |
| Ekran | [E-020](../E-020__README.md) |
| Nazwa wykryta | `markAllRead` |
| Typ detekcji | `click` |
| Źródło | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Oznacza wszystkie nieprzeczytane powiadomienia z aktualnie przefiltrowanej listy jako przeczytane. Akcja iteruje po `filtered()` i dla każdego nieprzeczytanego wysyła osobne `PUT .../read`. Jeśli któryś request zakończy się błędem, po ukończeniu wszystkich żądań wyświetlany jest toast ostrzegawczy "Some notifications could not be marked as read". Akcja jest niedostępna gdy lista jest pusta lub gdy wszystkie są już przeczytane.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | Przycisk "Mark All Read" w nagłówku listy | `wniosek z analizy` |
| Metoda komponentu | `markAllRead()` w `notification-list.component.ts` | `wniosek z analizy` |
| Serwis frontend | `NotificationApiService.markRead(id)` — per każde powiadomienie | `wniosek z analizy` |
| Endpoint API | `PUT /notifications/api/notifications/{id}/read` | `wniosek z analizy` |
| Komenda/zapytanie | Handler w `Notification.Application` — `MarkNotificationReadCommand` | `wniosek z analizy` |
| Walidacje | Pominięcie gdy lista pusta lub `unreadCount() === 0`; toast ostrzeżenia przy częściowym błędzie | `wniosek z analizy` |
| Skutek w bazie | UPDATE `Notifications.IsRead = true` dla każdego oznaczonego ID | `wniosek z analizy` |

## Testy

- [Macierz testów ekranu](../TC-020_TESTY/TC-020__INDEX.md)
- Dane wejściowe: do uzupełnienia.
- Oczekiwany rezultat: do uzupełnienia.

## Linki

- [Indeks akcji](A-020__INDEX.md)
- [Pola ekranu](../P-020_POLA/P-020__INDEX.md)
- [Ślad ekranu](../E-020__LINKI.md)
