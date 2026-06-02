# E-020 NotificationListComponent

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i NotificationApiService.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-020` |
| Route | `/notifications` |
| Komponent | `NotificationListComponent` |
| Guardy | `brak guardów w route` |
| Role frontendu | `brak ról w route` (Admin widzi wszystkie powiadomienia; inni użytkownicy tylko swoje) |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` |
| Serwis Angular | `NotificationApiService` w `supply-chain-frontend/src/app/core/api/notification-api.service.ts` |
| Status faktów | `wniosek z analizy` |

## Cel Ekranu

Lista powiadomień systemowych dla zalogowanego użytkownika. Powiadomienia są generowane przez backend (outbox) przy zdarzeniach: nowe zamówienie, zmiana statusu, shipment update. Użytkownik może oznaczyć jako przeczytane.

Admin widzi wszystkie powiadomienia w systemie (`GET /notifications/api/notifications`). Zwykły użytkownik widzi tylko swoje (`GET /notifications/api/notifications/my`). Ekran odświeża dane automatycznie co 60 sekund. Obsługuje filtry: kanał, typ zdarzenia, priorytet, stan przeczytania, wyszukiwanie tekstowe. Preferencje kanałów i wyciszonych źródeł są zapisywane lokalnie przez `NotificationPreferencesService` (localStorage). Admin ma dodatkowy przycisk tworzenia manualnego powiadomienia.

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.ts` | Komponent Angular — ładowanie, filtry, toggleRead, markAllRead, preferencje, createNotification |
| `supply-chain-frontend/src/app/features/notifications/notification-list/notification-list.component.html` | Szablon UI |
| `supply-chain-frontend/src/app/core/api/notification-api.service.ts` | `NotificationApiService` — GET my/all, PUT read/unread/sent/failed, POST manual |
| `supply-chain-frontend/src/app/core/services/notification-preferences.service.ts` | Preferencje kanałów — localStorage, brak backendu |
| `supply-chain-frontend/src/app/core/models/notification.models.ts` | `NotificationDto`, `CreateManualNotificationRequest` |
| `services/Notification/Notification.API/` | Backend — kontroler obsługujący wszystkie endpointy `/notifications/api/notifications` |

## Główne Wywołania API

| Metoda | URL | Opis | Role |
|---|---|---|---|
| `GET` | `/notifications/api/notifications` | Wszystkie powiadomienia (admin) | Admin |
| `GET` | `/notifications/api/notifications/my` | Powiadomienia zalogowanego użytkownika | Wszyscy poza Admin |
| `PUT` | `/notifications/api/notifications/{id}/read` | Oznacz jako przeczytane | Wszyscy |
| `PUT` | `/notifications/api/notifications/{id}/unread` | Cofnij oznaczenie przeczytania | Wszyscy |
| `PUT` | `/notifications/api/notifications/{id}/sent` | Oznacz jako wysłane (admin) | Admin |
| `PUT` | `/notifications/api/notifications/{id}/failed` | Oznacz jako nieudane (admin) | Admin |
| `POST` | `/notifications/api/notifications/manual` | Utwórz powiadomienie ręcznie (admin) | Admin |

## Stany Ekranu

| Stan | Opis |
|---|---|
| Ładowanie | `loading = true` — spinner podczas pierwszego/kolejnego `load()` |
| Lista powiadomień | `filtered` signal z powiadomieniami po zastosowaniu wszystkich filtrów |
| Brak powiadomień | Pusty wynik `filtered` — ekran pustego stanu (empty state) |
| Błąd ładowania | Toast "Failed to load notifications"; `loading = false` |
| Dialog preferencji | `showPreferencesDialog = true` — modal ustawień kanałów i wyciszonych źródeł |
| Dialog tworzenia (admin) | `showCreateDialog = true` — formularz manualnego powiadomienia |

## Dokumenty Atomowe

- [Pola UI](P-020_POLA/P-020__INDEX.md)
- [Akcje UI](A-020_AKCJE/A-020__INDEX.md)
- [Błędy i komunikaty](ERR-020_BLEDY/ERR-020__INDEX.md)
- [Dane testowe](TD-020_DANE_TESTOWE/TD-020__INDEX.md)
- [Testy](TC-020_TESTY/TC-020__INDEX.md)
- [Linki śladu](E-020__LINKI.md)

## Walidatory Backendu

Pliki: `services/Notification/Notification.Application/Validation/NotificationValidators.cs`

| Walidator | Reguły | Powiązana akcja |
|---|---|---|
| `CreateManualNotificationRequestValidator` | title max 180, body max 4000 | `A-020-0014__createnotification` |
| `IngestIntegrationEventRequestValidator` | sourceService max 100, eventType max 100, payload required | integracja wewnętrzna (nie UI) |
| `MarkNotificationFailedRequestValidator` | failureReason max 1000 | `A-020-0009__markfailed` |

## Zasada Uzupełniania

Każde pole `P-020-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
