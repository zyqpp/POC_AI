# ROLE_IDENTITY

Status: `potwierdzone` dla `E-001_LOGIN`, `E-002_REGISTER`, `E-003_FORGOT_PASSWORD`, `E-004_UNAUTHORIZED`, `E-006_PROFILE`.

| Obszar | Mechanizm | Role | Efekt |
|---|---|---|---|
| Route `/login` | brak authGuard (publiczny) | wszyscy (niezalogowani) | dostęp do formularza logowania |
| Route `/register` | brak authGuard (publiczny) | wszyscy (niezalogowani) | dostęp do formularza rejestracji |
| Route `/forgot-password` | brak authGuard (publiczny) | wszyscy (niezalogowani) | dostęp do formularza odzyskiwania hasła |
| Route `/unauthorized` | brak authGuard (publiczny) | wszyscy | wyświetlany po przekierowaniu 403 |
| Route `/profile` | `authGuard` | każdy zalogowany | dostęp do profilu własnego użytkownika |
| `GET /api/users/profile` | `[Authorize]` (wszystkie role) | każdy zalogowany | zwraca profil na podstawie `sub` z JWT |
| `POST /api/auth/login` | `[AllowAnonymous]` | wszyscy | wydaje JWT + ustawia cookie `refreshToken` |
| `POST /api/auth/register` | `[AllowAnonymous]` | wszyscy | tworzy konto Dealer ze statusem `Pending` |
| `POST /api/auth/forgot-password` | `[AllowAnonymous]` | wszyscy | wysyła OTP jeśli konto istnieje |
| `POST /api/auth/reset-password` | `[AllowAnonymous]` | wszyscy | resetuje hasło przez OTP |
| `POST /api/auth/refresh` | `[AllowAnonymous]` | wszyscy (cookie) | rotacja refresh tokena |
| `POST /api/auth/change-password` | `[Authorize]` | każdy zalogowany | zmiana hasła własnego użytkownika |
| `POST /api/auth/logout` | `[Authorize]` | każdy zalogowany | unieważnienie tokena i usunięcie cookie |

## Macierz Ekran / Akcja / Endpoint

| Ekran | Akcja | Frontend | Backend | Role |
|---|---|---|---|---|
| `E-001` | wejście na login | brak authGuard | nie dotyczy | wszyscy |
| `E-001` | submit logowania | brak authGuard | `[AllowAnonymous]` `POST /api/auth/login` | wszyscy |
| `E-001` | refresh tokena | brak authGuard | `[AllowAnonymous]` `POST /api/auth/refresh` | wszyscy (cookie) |
| `E-002` | wejście na rejestrację | brak authGuard | nie dotyczy | wszyscy |
| `E-002` | submit rejestracji | brak authGuard | `[AllowAnonymous]` `POST /api/auth/register` | wszyscy |
| `E-003` | wejście na forgot-password | brak authGuard | nie dotyczy | wszyscy |
| `E-003` | submit forgot-password | brak authGuard | `[AllowAnonymous]` `POST /api/auth/forgot-password` | wszyscy |
| `E-003` | submit reset-password | brak authGuard | `[AllowAnonymous]` `POST /api/auth/reset-password` | wszyscy |
| `E-004` | wyświetlenie strony unauthorized | brak authGuard | nie dotyczy | wszyscy |
| `E-006` | wejście na profil | `authGuard` | nie dotyczy | każdy zalogowany |
| `E-006` | pobranie profilu | `authGuard` | `[Authorize]` `GET /api/users/profile` | każdy zalogowany |
| `E-006` | zmiana hasła | `authGuard` | `[Authorize]` `POST /api/auth/change-password` | każdy zalogowany |
| `E-006` | logout | `authGuard` | `[Authorize]` `POST /api/auth/logout` | każdy zalogowany |

## Uprawnienia per rola

### Admin
- Może się zalogować (status konta nie jest `Pending`).
- Ma dostęp do profilu i zmiany hasła.
- Brak specjalnego DealerProfile — profil zwraca dane ogólne.

### Dealer
- Rejestruje się przez E-002; konto otrzymuje status `Pending`.
- Nie może się zalogować dopóki Admin nie zatwierdzi konta (logika w `LoginCommand`).
- Po zatwierdzeniu ma dostęp do E-006 (profil).
- Profil zawiera sekcję `DealerProfile` (biznes, GST, adres).

### Warehouse
- Może się zalogować (konto tworzone przez Admina bezpośrednio, nie przez rejestrację).
- Ma dostęp do E-006.

### Logistics
- Może się zalogować (konto tworzone przez Admina).
- Ma dostęp do E-006.

### Agent
- Może się zalogować (konto tworzone przez Admina przez E-022).
- Ma dostęp do E-006.

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-ROLE-001-001` | Dealer ze statusem `Pending` lub `Rejected` próbuje logowania — ochrona jest w warstwie aplikacji (`LoginCommand`), nie w atrybucie autoryzacji. Brak testu E2E potwierdzającego blokadę. | `potwierdzone` |
| `RISK-ROLE-001-002` | Refresh token jest przechowywany jako HttpOnly cookie (Secure=false w konfiguracji), co może być ryzykiem w środowisku produkcyjnym bez HTTPS. | `wniosek z analizy` |
| `RISK-ROLE-006-001` | `GET /api/users/profile` nie ma rozróżnienia roli — każdy zalogowany użytkownik widzi swój profil. DealerProfile jest `null` dla ról innych niż Dealer. | `potwierdzone` |
