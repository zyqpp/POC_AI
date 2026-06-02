# ROLE_NOTIFICATIONS

Status: `potwierdzone` dla `E-020_NOTIFICATIONS`.

| Obszar | Mechanizm | Role | Efekt |
|---|---|---|---|
| Route `/notifications` | `authGuard` | każdy zalogowany | lista własnych powiadomień |
| `GET /api/notifications/my` | `[Authorize]` (brak ograniczenia roli) | każdy zalogowany | lista powiadomień filtrowana po `RecipientUserId` z JWT |
| `GET /api/notifications` | `[Authorize(Roles = "Admin")]` | `Admin` | lista wszystkich powiadomień w systemie |
| `GET /api/notifications/{id}` | `[Authorize]` | każdy zalogowany | szczegół powiadomienia (backend filtruje wg właściciela) |
| `PUT /api/notifications/{id}/read` | `[Authorize]` | każdy zalogowany | oznaczenie jako przeczytane (backend sprawdza właściciela) |
| `PUT /api/notifications/{id}/unread` | `[Authorize]` | każdy zalogowany | oznaczenie jako nieprzeczytane (backend sprawdza właściciela) |
| `PUT /api/notifications/{id}/sent` | `[Authorize(Roles = "Admin")]` | `Admin` | ręczne oznaczenie jako wysłane |
| `PUT /api/notifications/{id}/failed` | `[Authorize(Roles = "Admin")]` | `Admin` | ręczne oznaczenie jako nieudane |
| `POST /api/notifications/manual` | `[Authorize(Roles = "Admin")]` | `Admin` | ręczne tworzenie powiadomienia |
| `POST /api/notifications/ingest` | `[AllowAnonymous]` + `X-Internal-Api-Key` | serwisy wewnętrzne (outbox) | ingestion zdarzeń integracyjnych z outboxu |

## Macierz Ekran / Akcja / Endpoint

| Ekran | Akcja | Frontend | Backend | Role |
|---|---|---|---|---|
| `E-020` | lista własnych powiadomień | `authGuard` | `[Authorize]` `GET /api/notifications/my` | każdy zalogowany |
| `E-020` | szczegół powiadomienia | `authGuard` | `[Authorize]` `GET /api/notifications/{id}` | każdy zalogowany (backend filtruje właściciela) |
| `E-020` | oznaczenie jako przeczytane | `authGuard` | `[Authorize]` `PUT /{id}/read` | każdy zalogowany (backend sprawdza właściciela) |
| `E-020` | oznaczenie jako nieprzeczytane | `authGuard` | `[Authorize]` `PUT /{id}/unread` | każdy zalogowany (backend sprawdza właściciela) |
| `E-020` | lista wszystkich powiadomień | `isAdmin()` w UI | `[Authorize(Roles = "Admin")]` `GET /api/notifications` | `Admin` |
| `E-020` | tworzenie ręcznego powiadomienia | `isAdmin()` w UI | `[Authorize(Roles = "Admin")]` `POST /api/notifications/manual` | `Admin` |
| `E-020` | mark sent / mark failed | `isAdmin()` w UI | `[Authorize(Roles = "Admin")]` `PUT /{id}/sent` / `PUT /{id}/failed` | `Admin` |

## Uprawnienia per rola

### Admin
- Widzi listę wszystkich powiadomień w systemie.
- Może tworzyć ręczne powiadomienia dla dowolnego odbiorcy.
- Może oznaczać powiadomienia jako wysłane lub nieudane (zarządzanie outboxem).
- Może oznaczać swoje i cudze powiadomienia jako przeczytane/nieprzeczytane (brak runtime check dla Admina).
- Ma dostęp do szczegółu dowolnego powiadomienia (brak sprawdzenia właściciela dla Admina).

### Dealer
- Widzi tylko swoje powiadomienia (`GET /my` filtruje po `RecipientUserId` z JWT).
- Może oznaczać swoje powiadomienia jako przeczytane lub nieprzeczytane.
- Nie może tworzyć ani zarządzać powiadomieniami systemowymi.

### Warehouse
- Widzi tylko swoje powiadomienia (jeśli system generuje powiadomienia dla roli Warehouse).
- Może oznaczać swoje jako przeczytane/nieprzeczytane.

### Logistics
- Widzi tylko swoje powiadomienia.
- Może oznaczać swoje jako przeczytane/nieprzeczytane.

### Agent
- Widzi tylko swoje powiadomienia.
- Może oznaczać swoje jako przeczytane/nieprzeczytane.
- Powiadomienia dot. przypisania wysyłek (`ShipmentAssignmentAccepted`, `ShipmentAssignmentRejected`) trafiają przez kanał Email.

## Mechanizm dostarczania

| Kanał | Zdarzenia | Mechanizm |
|---|---|---|
| `Email` | `PasswordResetRequested`, `ShipmentAssignmentAccepted`, `ShipmentAssignmentRejected` | `NotificationMessage.CreateFromEvent()` rozpoznaje event type |
| `InApp` | wszystkie pozostałe zdarzenia | fallback kanał |
| `Ingest` | integracyjny — zdarzenia z outboxu innych serwisów | `POST /ingest` z `X-Internal-Api-Key` |

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-ROLE-020-001` | `GET /api/notifications/{id}` i operacje mark-read/unread sprawdzają właściciela przez runtime check; Admin omija ten check. Brak testu weryfikującego izolację między użytkownikami. | `potwierdzone` |
| `RISK-ROLE-020-002` | `POST /api/notifications/ingest` jest `[AllowAnonymous]` — ochrona wyłącznie przez `X-Internal-Api-Key` w nagłówku. Brak walidacji TLS/mTLS między serwisami. | `wniosek z analizy` |
| `RISK-ROLE-020-003` | Powiadomienia z `RecipientUserId = null` (broadcast) są zwracane przez `GET /my` — brak filtru w zapytaniu query. Admin widzi wszystkie przez `GET /` (wszystkich). | `wniosek z analizy` |
