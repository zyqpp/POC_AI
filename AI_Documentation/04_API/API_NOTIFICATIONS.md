# API_NOTIFICATIONS

Status: `potwierdzone` na podstawie `NotificationsController.cs` i `NotificationDtos.cs`.

Serwis: `Notification.API` — gateway prefix `/notification`

| ID | Metoda | Ścieżka | Kontroler | Rola | Request DTO | Response DTO | Statusy |
|---|---|---|---|---|---|---|---|
| `API-NOT-001` | `POST` | `/notification/api/notifications/manual` | `NotificationsController.CreateManual` | `Admin` | `CreateManualNotificationRequest` | `NotificationDto` | `201` |
| `API-NOT-002` | `POST` | `/notification/api/notifications/ingest` | `NotificationsController.Ingest` | `[AllowAnonymous]` + `X-Internal-Api-Key` | `IngestIntegrationEventRequest` | `NotificationDto` | `200`, `401` |
| `API-NOT-010` | `GET` | `/notification/api/notifications/my` | `NotificationsController.GetMy` | `[Authorize]` (każda rola) | brak | `IReadOnlyList<NotificationDto>` | `200`, `401` |
| `API-NOT-011` | `GET` | `/notification/api/notifications` | `NotificationsController.GetAll` | `Admin` | brak | `IReadOnlyList<NotificationDto>` | `200`, `401`, `403` |
| `API-NOT-012` | `GET` | `/notification/api/notifications/{notificationId}` | `NotificationsController.GetById` | `[Authorize]` (Admin widzi wszystko, inne role — tylko swoje) | route `notificationId:guid` | `NotificationDto` | `200`, `401`, `404` |
| `API-NOT-020` | `PUT` | `/notification/api/notifications/{notificationId}/read` | `NotificationsController.MarkRead` | `[Authorize]` (właściciel lub Admin) | route `notificationId:guid` | `{ message }` | `200`, `401`, `404` |
| `API-NOT-021` | `PUT` | `/notification/api/notifications/{notificationId}/unread` | `NotificationsController.MarkUnread` | `[Authorize]` (właściciel lub Admin) | route `notificationId:guid` | `{ message }` | `200`, `401`, `404` |
| `API-NOT-030` | `PUT` | `/notification/api/notifications/{notificationId}/sent` | `NotificationsController.MarkSent` | `Admin` | route `notificationId:guid` | `{ message }` | `200`, `401`, `403`, `404` |
| `API-NOT-031` | `PUT` | `/notification/api/notifications/{notificationId}/failed` | `NotificationsController.MarkFailed` | `Admin` | route + `MarkNotificationFailedRequest` | `{ message }` | `200`, `401`, `403`, `404` |

---

## 1. Tworzenie Powiadomień

### POST /api/notifications/manual

**Opis:** Tworzy ręczne powiadomienie dla konkretnego użytkownika lub rozgłoszeniowe (broadcast gdy `recipientUserId` jest null). Używane przez Admina do komunikacji operacyjnej.

**Rola:** `[Authorize(Roles="Admin")]`

**Przykład żądania:**
```json
{
  "recipientUserId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "title": "Twoje zamówienie zostało zatwierdzone",
  "body": "Zamówienie ORD-2026-0042 zostało zatwierdzone i przekazane do realizacji.",
  "channel": "InApp"
}
```

**Przykład odpowiedzi (201):**
```json
{
  "notificationId": "aab85f64-5717-4562-b3fc-2c963f66afa6",
  "recipientUserId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "title": "Twoje zamówienie zostało zatwierdzone",
  "body": "Zamówienie ORD-2026-0042 zostało zatwierdzone i przekazane do realizacji.",
  "sourceService": "Manual",
  "eventType": "ManualNotification",
  "channel": "InApp",
  "status": "Pending",
  "createdAtUtc": "2026-06-02T10:00:00Z",
  "sentAtUtc": null,
  "failureReason": null,
  "isRead": false,
  "readAtUtc": null
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak `title`, `body` lub `channel` |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |

---

### POST /api/notifications/ingest

**Opis:** Endpoint wewnętrzny do ingestion zdarzeń integracyjnych z innych serwisów (Order, PaymentInvoice, LogisticsTracking). Dostępny bez JWT — autoryzowany przez `X-Internal-Api-Key`. Powiadomienie jest tworzone na podstawie `eventType` i `payload`.

**Rola:** `[AllowAnonymous]` + nagłówek `X-Internal-Api-Key`

**Przykład żądania:**
```json
{
  "sourceService": "Order",
  "eventType": "OrderShipped",
  "payload": "{\"orderId\":\"aab85f64-5717-4562-b3fc-2c963f66afa6\",\"shipmentNumber\":\"SHP-2026-0001\"}",
  "recipientUserId": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
}
```

**Przykład odpowiedzi (200):** `NotificationDto` jak powyżej

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak wymaganych pól |
| `401` | Brak lub nieprawidłowy `X-Internal-Api-Key` |

---

## 2. Pobieranie Powiadomień

### GET /api/notifications/my

**Opis:** Lista powiadomień zalogowanego użytkownika (`userId` z JWT claim `sub`). Zwraca powiadomienia posortowane od najnowszych.

**Rola:** `[Authorize]` — każda rola

**Przykład odpowiedzi (200):**
```json
[
  {
    "notificationId": "aab85f64-5717-4562-b3fc-2c963f66afa6",
    "recipientUserId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "title": "Twoje zamówienie zostało zatwierdzone",
    "body": "Zamówienie ORD-2026-0042 zostało zatwierdzone.",
    "sourceService": "Order",
    "eventType": "OrderApproved",
    "channel": "InApp",
    "status": "Sent",
    "createdAtUtc": "2026-06-02T10:00:00Z",
    "sentAtUtc": "2026-06-02T10:00:05Z",
    "failureReason": null,
    "isRead": false,
    "readAtUtc": null
  }
]
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |

---

### GET /api/notifications

**Opis:** Lista wszystkich powiadomień w systemie — widok administracyjny.

**Rola:** `[Authorize(Roles="Admin")]`

**Przykład odpowiedzi (200):** lista `NotificationDto` jak powyżej

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |

---

### GET /api/notifications/{notificationId}

**Opis:** Szczegóły konkretnego powiadomienia. Admin widzi każde. Inne role widzą tylko swoje (`recipientUserId` musi pasować) — zwraca `404` zamiast `403` w przypadku cudzego powiadomienia.

**Rola:** `[Authorize]` — każda rola

**Przykład odpowiedzi (200):** `NotificationDto`

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |
| `404` | Powiadomienie nie istnieje lub należy do innego użytkownika |

---

## 3. Zmiana Stanu Powiadomień

### PUT /api/notifications/{notificationId}/read

**Opis:** Oznacza powiadomienie jako przeczytane. Użytkownik może oznaczyć tylko własne powiadomienie. Admin może oznaczyć dowolne.

**Rola:** `[Authorize]` — właściciel lub Admin

**Żądanie:** brak body

**Przykład odpowiedzi (200):**
```json
{
  "message": "Notification marked read."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |
| `404` | Powiadomienie nie istnieje lub należy do innego użytkownika |

---

### PUT /api/notifications/{notificationId}/unread

**Opis:** Oznacza powiadomienie jako nieprzeczytane. Analogiczna logika dostępu jak `read`.

**Rola:** `[Authorize]` — właściciel lub Admin

**Żądanie:** brak body

**Przykład odpowiedzi (200):**
```json
{
  "message": "Notification marked unread."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |
| `404` | Powiadomienie nie istnieje lub należy do innego użytkownika |

---

## 4. Administracja Statusów Wysyłki

### PUT /api/notifications/{notificationId}/sent

**Opis:** Oznacza powiadomienie jako wysłane (po rzeczywistym wysłaniu przez worker). Wywoływany przez background worker.

**Rola:** `[Authorize(Roles="Admin")]`

**Żądanie:** brak body

**Przykład odpowiedzi (200):**
```json
{
  "message": "Notification marked sent."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |
| `404` | Powiadomienie nie istnieje |

---

### PUT /api/notifications/{notificationId}/failed

**Opis:** Oznacza powiadomienie jako nieudane z podaniem przyczyny. Wywoływany przez background worker po błędzie wysyłki.

**Rola:** `[Authorize(Roles="Admin")]`

**Przykład żądania:**
```json
{
  "failureReason": "SMTP connection timeout."
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "Notification marked failed."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak `failureReason` |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |
| `404` | Powiadomienie nie istnieje |

---

## Kontrakty Danych

| DTO | Pola | Opis |
|---|---|---|
| `CreateManualNotificationRequest` | `RecipientUserId?`, `Title`, `Body`, `Channel` | Ręczne powiadomienie (Admin) |
| `IngestIntegrationEventRequest` | `SourceService`, `EventType`, `Payload`, `RecipientUserId?` | Zdarzenie z innego serwisu (internal) |
| `MarkNotificationFailedRequest` | `FailureReason` | Powód niepowodzenia wysyłki |
| `NotificationDto` | `NotificationId`, `RecipientUserId?`, `Title`, `Body`, `SourceService`, `EventType`, `Channel`, `Status`, `CreatedAtUtc`, `SentAtUtc?`, `FailureReason?`, `IsRead`, `ReadAtUtc?` | Pełne dane powiadomienia |

## Enumeracje

| Enum | Wartości |
|---|---|
| `NotificationChannel` | `InApp`, `Email`, `Sms` (zależnie od implementacji `Notification.Domain`) |
| `NotificationStatus` | `Pending`, `Sent`, `Failed` |

## Uwagi Autoryzacyjne

- Endpoint `ingest` jest wewnętrzny — nie jest wystawiony przez Ocelot gateway dla użytkowników zewnętrznych. Wymaga nagłówka `X-Internal-Api-Key`.
- Endpointy `read` i `unread` implementują podwójną weryfikację: sprawdzają istnienie powiadomienia, a dopiero potem sprawdzają właściciela — co zapobiega wyciekowi informacji o cudzych powiadomieniach.
- Broadcast powiadomienie (`recipientUserId = null`) jest widoczne przez wszystkich w `/my` — logika filtrowania jest po stronie handlera zapytania.
- Brak dedykowanego endpointu `read-all` — każde powiadomienie oznaczane jest osobno przez `PUT /{id}/read`.
