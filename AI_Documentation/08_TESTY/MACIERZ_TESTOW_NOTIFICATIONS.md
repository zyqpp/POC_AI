# MACIERZ_TESTOW_NOTIFICATIONS

Status: `potwierdzone` jako wymagania testowe dla `E-020_NOTIFICATIONS`.

## Testy Istniejące

| Test | Plik | Pokrycie | Luka |
|---|---|---|---|
| `CreateFromEvent_IdentityPasswordReset_UsesEmailChannel` | `tests/Notification.Domain.Tests/UnitTest1.cs` | domena: routing kanału Email dla `PasswordResetRequested` | brak testu outbox ingest, brak API |
| `CreateFromEvent_UnknownEvent_FallsBackToInApp` | `tests/Notification.Domain.Tests/UnitTest1.cs` | domena: fallback kanału InApp dla nieznanych zdarzeń | brak pokrycia innych event types |
| `CreateFromEvent_LogisticsAssignmentDecision_UsesEmailChannel` | `tests/Notification.Domain.Tests/UnitTest1.cs` (teoria) | domena: `ShipmentAssignmentAccepted` i `ShipmentAssignmentRejected` — kanał Email | brak testu wysyłki przez SMTP, brak outbox |
| `MarkFailed_SetsFailedStatusAndTrimmedReason` | `tests/Notification.Domain.Tests/UnitTest1.cs` | domena: `MarkFailed`, trimowanie powodu błędu | brak testu retry logiki |
| `MarkSent_ClearsFailureReasonAndSetsSentTimestamp` | `tests/Notification.Domain.Tests/UnitTest1.cs` | domena: `MarkSent`, czyszczenie `FailureReason`, timestamp | brak testu API `PUT /{id}/sent` |

## Scenariusze do Przetestowania

| ID | Scenariusz | Typ testu | Dane | Obecny status | Kryterium zamknięcia |
|---|---|---|---|---|---|
| `TC-NOTIF-0001` | Zalogowany użytkownik pobiera swoje powiadomienia (`GET /my`). | API integration | JWT Dealer/Admin/Logistics | `brak w kodzie` | `200`, lista zawiera tylko powiadomienia dla `RecipientUserId` z JWT. |
| `TC-NOTIF-0002` | Użytkownik A nie widzi powiadomień użytkownika B. | API integration | JWT A, `GET /notifications/{B_notif_id}` | `brak w kodzie` | `404` (backend chroni przez `RecipientUserId != userId`). |
| `TC-NOTIF-0003` | Admin widzi powiadomienia dowolnego użytkownika (`GET /{id}`). | API integration | JWT Admin, dowolne `notificationId` | `brak w kodzie` | `200`, brak sprawdzenia `RecipientUserId` dla Admina. |
| `TC-NOTIF-0004` | Użytkownik oznacza powiadomienie jako przeczytane (`PUT /{id}/read`). | API integration | JWT zalogowanego, własne powiadomienie | `brak w kodzie` | `200`, `ReadAt` ustawiony, status `Read`. |
| `TC-NOTIF-0005` | Użytkownik oznacza powiadomienie jako nieprzeczytane (`PUT /{id}/unread`). | API integration | JWT zalogowanego, przeczytane powiadomienie | `brak w kodzie` | `200`, `ReadAt` wyczyszczony. |
| `TC-NOTIF-0006` | Użytkownik nie może oznaczyć powiadomienia innego użytkownika. | API integration | JWT A, powiadomienie należące do B | `brak w kodzie` | `404`. |
| `TC-NOTIF-0007` | `POST /ingest` z poprawnym `X-Internal-Api-Key` tworzy powiadomienie z outboxu. | API integration | klucz z konfiguracji, `IngestIntegrationEventRequest` | `brak w kodzie` | `200`, powiadomienie zapisane w DB, kanał wyznaczony przez `CreateFromEvent`. |
| `TC-NOTIF-0008` | `POST /ingest` bez nagłówka `X-Internal-Api-Key` zwraca `401`. | API auth | brak nagłówka | `brak w kodzie` | `401`. |
| `TC-NOTIF-0009` | `POST /ingest` z błędnym kluczem zwraca `401`. | API auth | zły klucz | `brak w kodzie` | `401`. |
| `TC-NOTIF-0010` | Admin tworzy ręczne powiadomienie dla konkretnego użytkownika. | API integration | JWT Admin, `{recipientUserId, title, body, channel}` | `brak w kodzie` | `201`, powiadomienie w DB z poprawnym `RecipientUserId`. |
| `TC-NOTIF-0011` | Nie-Admin nie może tworzyć ręcznych powiadomień (`POST /manual`). | API auth | JWT Dealer | `brak w kodzie` | `403`. |
| `TC-NOTIF-0012` | Admin oznacza powiadomienie jako wysłane (`PUT /{id}/sent`). | API integration | JWT Admin, istniejące powiadomienie | `brak w kodzie` | `200`, `Status = Sent`, `SentAtUtc` ustawiony. |
| `TC-NOTIF-0013` | Admin oznacza powiadomienie jako nieudane (`PUT /{id}/failed`). | API integration | JWT Admin, istniejące powiadomienie | `brak w kodzie` | `200`, `Status = Failed`, `FailureReason` zapisany. |
| `TC-NOTIF-0014` | Zdarzenie `PasswordResetRequested` z Identity tworzy powiadomienie Email. | API integration (ingest) | event type `passwordresetrequested`, source `identity` | `brak w kodzie` | Powiadomienie w DB z `Channel = Email`. |
| `TC-NOTIF-0015` | Nieznane zdarzenie z dowolnego serwisu tworzy powiadomienie InApp. | API integration (ingest) | event type `unknownevent`, source `catalog` | `brak w kodzie` | Powiadomienie w DB z `Channel = InApp`. |
| `TC-NOTIF-0016` | Admin widzi listę wszystkich powiadomień przez `GET /` (nie `GET /my`). | API integration | JWT Admin | `brak w kodzie` | `200`, lista wszystkich powiadomień w systemie bez filtra `RecipientUserId`. |

## Luki Testowe

| Luka | Opis | Priorytet |
|---|---|---|
| Izolacja użytkowników | Brak testu weryfikującego że użytkownik A nie może czytać/oznaczać powiadomień użytkownika B. Runtime check jest w kontrolerze — bez testu API może zostać przypadkowo usunięty. | KRYTYCZNY |
| Outbox ingest security | Brak testu sprawdzającego bezpieczeństwo `POST /ingest` — endpointu wewnętrznego z `[AllowAnonymous]`. | KRYTYCZNY |
| Mark-read / mark-unread przez właściciela | Brak testu API dla `PUT /{id}/read` i `PUT /{id}/unread`. Logika runtime check dla właściciela jest w kontrolerze bez pokrycia testowego. | WYSOKI |
| Routing kanałów dla wszystkich event types | Testy domenowe pokrywają 4 event types. Brak systematycznego testu dla każdego obsługiwanego zdarzenia z innych serwisów (Order, Logistics, Payment). | SREDNI |
| Admin `GET /` vs zwykły `GET /my` | Brak testu weryfikującego że `GET /` jest dostępny TYLKO dla Admina, a `GET /my` dla wszystkich ról. | WYSOKI |
| Powiadomienia broadcast (`RecipientUserId = null`) | Brak testu sprawdzającego zachowanie dla powiadomień bez konkretnego odbiorcy. | SREDNI |
