# E-003 ForgotPasswordComponent

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular, AuthApiService i AuthValidators.cs.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-003` |
| Route | `/forgot-password` |
| Komponent | `ForgotPasswordComponent` |
| Guardy | `brak guardów w route` |
| Role frontendu | `brak ról w route` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/auth/forgot-password/forgot-password.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/auth/forgot-password/forgot-password.component.html` |
| Serwis Angular | `AuthApiService.forgotPassword()`, `AuthApiService.resetPassword()` w `supply-chain-frontend/src/app/core/api/auth-api.service.ts` |
| Endpoint (krok 1) | `POST /identity/api/auth/forgot-password` |
| Endpoint (krok 2) | `POST /identity/api/auth/reset-password` |
| Backend | `services/IdentityAuth/IdentityAuth.API/Controllers/AuthController.cs` |
| Walidator | `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs` — `ResetPasswordRequestValidator` |
| Status faktów | `wniosek z analizy` |

## Cel Ekranu

Ekran odzyskiwania hasła. Użytkownik podaje email → system wysyła OTP/link na email przez outbox → użytkownik klika link i trafia na ekran reset-password. Powiązany proces: [PROC-001_AUTH](../../../../06_PROCESY/PROC-001_AUTH.md)

Komponent obsługuje **dwa kroki** w jednym widoku (signal `step`):
- Krok `email`: formularz z polem email; po submit wywoływane `sendOtp()` → `POST /identity/api/auth/forgot-password`
- Krok `reset`: formularz z kodem OTP (6 cyfr) i nowym hasłem; po submit wywoływane `resetPassword()` → `POST /identity/api/auth/reset-password`

Ekran wspiera też `forcedFlow` — gdy URL zawiera `?enforced=1&email=...` (np. po pierwszym logowaniu z wymuszonym resetem hasła), formularz jest wstępnie uzupełniony i OTP jest wysyłany automatycznie.

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/auth/forgot-password/forgot-password.component.ts` | Komponent Angular — logika dwuetapowego formularza |
| `supply-chain-frontend/src/app/features/auth/forgot-password/forgot-password.component.html` | Szablon UI |
| `supply-chain-frontend/src/app/core/api/auth-api.service.ts` | `AuthApiService.forgotPassword()`, `AuthApiService.resetPassword()` |
| `services/IdentityAuth/IdentityAuth.API/Controllers/AuthController.cs` | Kontroler endpointów forgot/reset |
| `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs` | `ResetPasswordRequestValidator` (email, OTP, nowe hasło) |

## Główne Wywołania API

| Krok | Metoda | URL | Payload | Odpowiedź |
|---|---|---|---|---|
| Wysłanie OTP | `POST` | `/identity/api/auth/forgot-password` | `{ email }` | `{ message }` |
| Reset hasła | `POST` | `/identity/api/auth/reset-password` | `{ email, otpCode, newPassword }` | `{ message }` |

## Stany Ekranu

| Stan | Opis |
|---|---|
| `step = 'email'` | Formularz z polem email; przycisk "Send OTP"; loading signal wyłącza przycisk podczas wywołania |
| `step = 'reset'` (po sendOtp) | Formularz z polami OTP i nowe hasło; po błędzie API pole OTP jest resetowane |
| Sukces reset | Toast "Password reset successful. Please sign in." + redirect `/login` |
| Błąd reset | `errorMsg` z `err.error?.message` albo "Invalid OTP. Please try again." |
| Forced flow | `forcedFlow=true`: parametry z URL, OTP wysyłany automatycznie, możliwy brak przycisku cofnięcia |

## Dokumenty Atomowe

- [Pola UI](P-003_POLA/P-003__INDEX.md)
- [Akcje UI](A-003_AKCJE/A-003__INDEX.md)
- [Błędy i komunikaty](ERR-003_BLEDY/ERR-003__INDEX.md)
- [Dane testowe](TD-003_DANE_TESTOWE/TD-003__INDEX.md)
- [Testy](TC-003_TESTY/TC-003__INDEX.md)
- [Linki śladu](E-003__LINKI.md)

## Zasada Uzupełniania

Każde pole `P-003-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
