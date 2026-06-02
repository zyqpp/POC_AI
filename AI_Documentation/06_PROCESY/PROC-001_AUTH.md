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

## Opis

Użytkownik wysyła dane uwierzytelniające do `AuthController`, który weryfikuje hash BCrypt w tabeli `Users`, generuje JWT AccessToken (15 min) i RefreshToken (7 dni) zapisywany w `RefreshTokens`, po czym frontend przechowuje tokeny w localStorage.

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

## Zmiana Hasła (Change Password)

| Krok | Warstwa | Fakt | Status |
|---|---|---|---|
| 1 | UI | Formularz zmiany hasła: `currentPassword` + `newPassword` | `wniosek z analizy` |
| 2 | API call | `POST /identity/api/auth/change-password` z `{currentPassword, newPassword}` | `wniosek z analizy` |
| 3 | Backend | `ChangePasswordCommand` → `ChangePasswordCommandHandler` | `wniosek z analizy` |
| 4 | Walidacja | `ChangePasswordRequestValidator`: currentPassword `NotEmpty()`; newPassword `NotEmpty().MinimumLength(8).Matches("[A-Z]").Matches("[0-9]")` | `potwierdzone` |
| 5 | Business | Weryfikacja currentPassword (BCrypt hash check); zapis nowego hash | `wniosek z analizy` |
| 6 | DB write | Aktualizacja `Users.PasswordHash` | `wniosek z analizy` |

**Walidator backend (`ChangePasswordRequestValidator`)**
Plik: `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs`
```csharp
RuleFor(x => x.CurrentPassword).NotEmpty();
RuleFor(x => x.NewPassword)
    .NotEmpty()
    .MinimumLength(8)
    .Matches("[A-Z]").WithMessage("Password must contain at least one uppercase letter.")
    .Matches("[0-9]").WithMessage("Password must contain at least one number.");
```

## Walidatory Backendu

Wszystkie walidatory znajdują się w `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs` (FluentValidation):

| Walidator | Plik | Opis reguł |
|---|---|---|
| `LoginRequestValidator` | `AuthValidators.cs` | email format, password required | `potwierdzone` |
| `RegisterDealerRequestValidator` | `AuthValidators.cs` | email, password (min 8, uppercase, cyfra), fullName max 120, phone Indian 10-digit, GST regex, businessName max 180, tradeLicenseNo max 80, address max 300, city/state max 100, pinCode 6 cyfr | `potwierdzone` |
| `ResetPasswordRequestValidator` | `AuthValidators.cs` | email format, otpCode `^\d{6}$`, newPassword min 8 + uppercase + cyfra | `potwierdzone` |
| `ChangePasswordRequestValidator` | `AuthValidators.cs` | currentPassword required, newPassword min 8 + uppercase + cyfra (używany przy zmianie hasła przez zalogowanego użytkownika — brak dedykowanego ekranu w AOS) | `wniosek z analizy` |
| `CreateAgentRequestValidator` | `AuthValidators.cs` | email format, temporaryPassword min 8 + uppercase + cyfra, fullName max 120, phone Indian 10-digit (używany przez Admin przy tworzeniu konta agenta) | `wniosek z analizy` |
| `RejectDealerRequestValidator` | `AuthValidators.cs` | reason max 400 (używany przy odrzuceniu rejestracji dealera przez Admin) | `wniosek z analizy` |
| `UpdateCreditLimitRequestValidator` | `AuthValidators.cs` | creditLimit >= 0 (używany przez Admin przy aktualizacji limitu kredytowego dealera) | `wniosek z analizy` |

## Luki

| ID | Luka | Status |
|---|---|---|
| `GAP-PROC-001-001` | Brak lockoutu konta po N błędnych próbach logowania | `brak w kodzie` |
| `GAP-PROC-001-002` | idempotencyKey z UI przy refresh jest nieużywany przez backend | `brak w kodzie` |
| `GAP-PROC-001-003` | Brak testu E2E dla pełnego flow login → refresh → logout | `brak w kodzie` |
| `GAP-PROC-001-004` | `ChangePasswordRequestValidator` — brak ekranu AOS dla zmiany hasła przez zalogowanego użytkownika; zmiana hasła odbywa się przez `/forgot-password` (OTP flow) | `wniosek z analizy` |
| `GAP-PROC-001-005` | `CreateAgentRequestValidator` — brak ekranu E-AOS dla tworzenia agenta; akcja dostępna przez Admin panel | `do uzupełnienia` |

## Powiązane Dokumenty

| Typ | Plik | Opis powiązania |
|---|---|---|
| Ekran | [E-001_LOGIN](../05_UI_AOS/EKRANY/E-001_LOGIN/E-001__README.md) | ekran logowania |
| Ekran | [E-002_REGISTER](../05_UI_AOS/EKRANY/E-002_REGISTER/E-002__README.md) | ekran rejestracji dealera |
| Ekran | [E-003_FORGOT_PASSWORD](../05_UI_AOS/EKRANY/E-003_FORGOT_PASSWORD/E-003__README.md) | ekran odzyskiwania hasła |
| API | [API_IDENTITY](../04_API/API_IDENTITY.md) | endpointy auth i users używane w procesie |
| Role | [ROLE_IDENTITY](../07_ROLE_I_UPRAWNIENIA/ROLE_IDENTITY.md) | macierz uprawnień dla modułu tożsamości |
| Testy | [MACIERZ_TESTOW_IDENTITY](../08_TESTY/MACIERZ_TESTOW_IDENTITY.md) | przypadki testowe dla uwierzytelniania |
