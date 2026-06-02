# A-020-0007 toggleRead

Status: `szkielet`; wymagane ręczne uzupełnienie po analizie UI, API i procesu.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-020-0007` |
| Ekran | [E-020](../E-020__README.md) |
| Nazwa wykryta | `toggleRead` |
| Typ detekcji | `click` |
| Źródło | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Przełącza stan przeczytania pojedynczego powiadomienia. Gdy `markRead=true` → wysyła `PUT .../read`; gdy `markRead=false` → wysyła `PUT .../unread`. Po sukcesie aktualizuje lokalny `readMap` signal i ponownie aplikuje filtry (`applyFilter()`). Po błędzie pokazuje toast z odpowiednim komunikatem.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | Przycisk/checkbox przy każdym wierszu powiadomienia | `wniosek z analizy` |
| Metoda komponentu | `toggleRead(notificationId, markRead)` w `notification-list.component.ts` | `wniosek z analizy` |
| Serwis frontend | `NotificationApiService.markRead(id)` lub `NotificationApiService.markUnread(id)` | `wniosek z analizy` |
| Endpoint API (read) | `PUT /notifications/api/notifications/{id}/read` | `wniosek z analizy` |
| Endpoint API (unread) | `PUT /notifications/api/notifications/{id}/unread` | `wniosek z analizy` |
| Komenda/zapytanie | Backend handler w `Notification.Application` | `wniosek z analizy` |
| Walidacje | Brak — request bez body; błąd HTTP powoduje toast | `wniosek z analizy` |
| Skutek w bazie | UPDATE `Notifications.IsRead = true/false` dla danego `notificationId` | `wniosek z analizy` |

## Testy

- [Macierz testów ekranu](../TC-020_TESTY/TC-020__INDEX.md)
- Dane wejściowe: do uzupełnienia.
- Oczekiwany rezultat: do uzupełnienia.

## Linki

- [Indeks akcji](A-020__INDEX.md)
- [Pola ekranu](../P-020_POLA/P-020__INDEX.md)
- [Ślad ekranu](../E-020__LINKI.md)
