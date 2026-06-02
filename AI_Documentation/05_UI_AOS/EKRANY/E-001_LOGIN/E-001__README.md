# E-001 LoginComponent

Status: `wniosek z analizy`; źródło startowe: routing i komponent Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-001` |
| Route | `/login` |
| Komponent | `LoginComponent` |
| Guardy | `brak guardów w route` |
| Role frontendu | `brak ról w route` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/auth/login/login.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/auth/login/login.component.html` |
| Status faktów | `do uzupełnienia` |

## Dokumenty Atomowe

- [Pola UI](P-001_POLA/P-001__INDEX.md)
- [Akcje UI](A-001_AKCJE/A-001__INDEX.md)
- [Błędy i komunikaty](ERR-001_BLEDY/ERR-001__INDEX.md)
- [Dane testowe](TD-001_DANE_TESTOWE/TD-001__INDEX.md)
- [Testy](TC-001_TESTY/TC-001__INDEX.md)
- [Linki śladu](E-001__LINKI.md)

## Cel Ekranu

Ekran logowania dla wszystkich typów użytkowników (Dealer, Admin, Warehouse, Agent). Użytkownik podaje email i hasło; po sukcesie otrzymuje JWT (accessToken 15 min) i refreshToken (7 dni) zapisywane w localStorage. Przekierowanie następuje na `/dashboard` lub `returnUrl`.

Główne funkcje:
- Logowanie z walidacją formularza (email + hasło)
- Obsługa błędów uwierzytelnienia (invalid credentials, account pending)
- Link do rejestracji (`/register`) i odzyskiwania hasła (`/forgot-password`)

Powiązany proces: [PROC-001_AUTH](../../../../06_PROCESY/PROC-001_AUTH.md)

## Kluczowe Pliki Kodu

| Rola | Ścieżka |
|---|---|
| Komponent Angular | `supply-chain-frontend/src/app/features/auth/login/login.component.ts` |
| Template HTML | `supply-chain-frontend/src/app/features/auth/login/login.component.html` |
| Serwis API frontend | `supply-chain-frontend/src/app/core/api/auth-api.service.ts` |
| Store autentykacji | `supply-chain-frontend/src/app/core/stores/auth.store.ts` |
| Kontroler .NET | `services/IdentityAuth/IdentityAuth.API/Controllers/AuthController.cs` |
| Handler MediatR | `services/IdentityAuth/IdentityAuth.Application/Features/Auth/Commands/IdentityAuthCommands.cs` (LoginCommandHandler) |
| Encja domenowa | `services/IdentityAuth/IdentityAuth.Domain/Entities/User.cs` |

## Główne Wywołania API

| Metoda | Endpoint | Cel | DTO Odpowiedzi |
|---|---|---|---|
| `POST` | `/identity/api/auth/login` | logowanie, zwraca tokeny | `AuthTokenDto {accessToken, refreshToken, role, userId, email, mustChangePassword}` |
| `GET` | `/identity/api/users/profile` | pobranie profilu po zalogowaniu | `UserProfileDto {userId, email, role, status, creditLimit, fullName}` |

## Stany Ekranu

| Stan | Warunek | Zachowanie UI |
|---|---|---|
| Ładowanie | żądanie login w toku | przycisk submit nieaktywny / spinner |
| Błąd uwierzytelnienia | 401 z backendu | komunikat "Invalid email or password." |
| Wymuszona zmiana hasła | `mustChangePassword === true` | redirect na /forgot-password?email=&enforced=1 |
| Sukces | 200 + tokeny + profil | zapis do AuthStore; redirect na /dashboard |

## Zasada Uzupełniania

Każde pole `P-001-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
