# PROC-001 Uwierzytelnianie i Autoryzacja

Status: `potwierdzone` dla śladu `UI -> API -> proces -> DB`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| Proces | `PROC-001_AUTH` |
| Ekrany | [E-001_LOGIN](../05_UI_AOS/EKRANY/E-001_LOGIN/E-001__README.md), [E-002_REGISTER](../05_UI_AOS/EKRANY/E-002_REGISTER/E-002__README.md), [E-003_FORGOT_PASSWORD](../05_UI_AOS/EKRANY/E-003_FORGOT_PASSWORD/E-003__README.md) |
| Routes | `/login`, `/register`, `/forgot-password` |
| Główne role | publiczny (przed loginem) |
| API | `POST /identity/api/auth/login`, `/register`, `/forgot-password`, `/reset-password`, `/refresh`, `/logout` |
| Kontroler | `services/IdentityAuth/IdentityAuth.API/Controllers/AuthController.cs` |
| Model danych | [MODEL_DANYCH_IDENTITY](../03_MODEL_DANYCH/MODEL_DANYCH_IDENTITY.md) |
| Testy | [MACIERZ_TESTOW_IDENTITY](../08_TESTY/MACIERZ_TESTOW_IDENTITY.md) |

## Cel

Proces obejmuje wszystkie operacje związane z tożsamością użytkownika: logowanie (JWT + Refresh Token), rejestrację dealera (oczekuje na approval admina), odzyskiwanie hasła przez OTP/link, wylogowanie i cichą odnowę tokena. Proces jest krytyczny dla bezpieczeństwa — każda ścieżka musi kończyć się jasnym stanem sesji (zalogowany / wylogowany / oczekujący).

## Przepływ: Logowanie

| Krok | Warstwa | Fakt | Status |
|---|---|---|---|
| 1 | Routing | `/login` jest publiczny (brak authGuard); przekierowanie gdy już zalogowany | `potwierdzone` |
| 2 | UI | Formularz email + hasło z Reactive Forms | `potwierdzone` |
| 3 | UI validation | Walidacja formatu email i minimalnej długości hasła | `potwierdzone` |
| 4 | API call | `AuthApiService.login` → `POST /identity/api/auth/login` z `{email, password}` | `potwierdzone` |
| 5 | Backend | `AuthController.Login` → `LoginCommand` → `LoginCommandHandler` | `potwierdzone` |
| 6 | Walidacja | `LoginRequestValidator` sprawdza format email i obecność hasła | `wniosek z analizy` |
| 7 | Business | `IdentityAuthService` weryfikuje hash hasła (BCrypt), sprawdza status konta | `potwierdzone` |
| 8 | DB read | Odczyt `Users` (email, passwordHash, status); odczyt `DealerProfiles` dla dealera | `potwierdzone` |
| 9 | Token | Generowanie JWT (AccessToken 15 min) + RefreshToken (7 dni); zapis `RefreshTokens` | `potwierdzone` |
| 10 | Response | `{accessToken, refreshToken, role, userId}` → localStorage | `potwierdzone` |
| 11 | UI success | Redirect na `/dashboard` lub zapisany returnUrl | `wniosek z analizy` |

## Przepływ: Rejestracja Dealera

| Krok | Warstwa | Fakt | Status |
|---|---|---|---|
| 1 | UI | Formularz rejestracji: email, hasło, daneFiremy, NIP, adres | `potwierdzone` |
| 2 | API call | `AuthApiService.register` → `POST /identity/api/auth/register` | `potwierdzone` |
| 3 | Backend | `RegisterDealerCommand` → `RegisterDealerCommandHandler` | `potwierdzone` |
| 4 | DB write | Zapis `Users` (status=Pending), `DealerProfiles`, `OutboxMessages(DealerRegistered)` | `potwierdzone` |
| 5 | Notification | Outbox dispatcher wysyła email do admina o nowym dealerze | `wniosek z analizy` |
| 6 | UI success | Komunikat "Rejestracja wysłana — oczekuj na approval" | `wniosek z analizy` |

## Przepływ: Odzyskiwanie Hasła

| Krok | Warstwa | Fakt | Status |
|---|---|---|---|
| 1 | UI | Formularz z emailem na `/forgot-password` | `potwierdzone` |
| 2 | API call | `AuthApiService.forgotPassword` → `POST /identity/api/auth/forgot-password` | `potwierdzone` |
| 3 | Backend | `ForgotPasswordCommand` → `ForgotPasswordCommandHandler` | `potwierdzone` |
| 4 | DB write | Zapis `OtpRecords` z kodem i TTL | `potwierdzone` |
| 5 | Email | Outbox wysyła email z linkiem/OTP | `wniosek z analizy` |
| 6 | Reset | Użytkownik klika link → `POST /identity/api/auth/reset-password` z tokenem i nowym hasłem | `potwierdzone` |
| 7 | DB write | Aktualizacja `Users.PasswordHash`, usunięcie `OtpRecords` | `wniosek z analizy` |

## Przepływ: Odnowienie Tokena (Silent Refresh)

| Krok | Warstwa | Fakt | Status |
|---|---|---|---|
| 1 | Interceptor | HTTP interceptor wykrywa 401 lub czas wygaśnięcia AccessToken | `wniosek z analizy` |
| 2 | API call | `AuthApiService.refresh` → `POST /identity/api/auth/refresh` z `{refreshToken}` | `potwierdzone` |
| 3 | Backend | `RefreshTokenCommand` → `RefreshTokenCommandHandler` | `potwierdzone` |
| 4 | DB | Odczyt `RefreshTokens`; walidacja TTL i użycia; rotacja tokena | `potwierdzone` |
| 5 | Response | Nowy `{accessToken, refreshToken}` → localStorage | `potwierdzone` |

## Dane I Transakcje

| Encja | Operacja | Klucze |
|---|---|---|
| `Users` | R (login), W (register, reset-password) | `UserId`, `Email`, `PasswordHash`, `Status` |
| `DealerProfiles` | W (register), R (login, profile) | `DealerId` FK `Users.UserId` |
| `RefreshTokens` | W (login), R+W (refresh), D (logout) | `Token`, `UserId`, `ExpiresAt` |
| `OtpRecords` | W (forgot-password), D (reset-password) | `Email`, `Code`, `ExpiresAt` |
| `OutboxMessages` | W (register, forgot-password) | `EventType`, `Payload` |

## Błędy Procesu

| ID | Warunek | HTTP | Akcja kompensująca | Status |
|---|---|---|---|---|
| `ERR-PROC-001-001` | Nieprawidłowe hasło lub email | 401 | brak lockoutu po N próbach (ryzyko P0 RYZYKA.md); komunikat "Invalid credentials" | `potwierdzone` |
| `ERR-PROC-001-002` | Konto Pending (niezatwierdzone) | 403 | komunikat "Your account is pending approval" | `potwierdzone` |
| `ERR-PROC-001-003` | Konto zablokowane | 403 | komunikat "Account suspended" | `wniosek z analizy` |
| `ERR-PROC-001-004` | Email już zarejestrowany | 409 | komunikat "Email already registered" | `wniosek z analizy` |
| `ERR-PROC-001-005` | RefreshToken wygasł lub unieważniony | 401 | interceptor wylogowuje; redirect na `/login` | `wniosek z analizy` |
| `ERR-PROC-001-006` | OTP wygasł (forgot-password) | 400 | komunikat "Link wygasł — wyślij ponownie" | `wniosek z analizy` |
| `ERR-PROC-001-007` | Backend IdentityAuth niedostępny | 503 | UI pokazuje komunikat błędu; brak częściowego zapisu | `wniosek z analizy` |

## Luki

| ID | Luka | Status |
|---|---|---|
| `GAP-PROC-001-001` | Brak lockoutu konta po N błędnych próbach logowania | `brak w kodzie` |
| `GAP-PROC-001-002` | idempotencyKey z UI przy refresh jest nieużywany przez backend | `brak w kodzie` |
| `GAP-PROC-001-003` | Brak testu E2E dla pełnego flow login → refresh → logout | `brak w kodzie` |
