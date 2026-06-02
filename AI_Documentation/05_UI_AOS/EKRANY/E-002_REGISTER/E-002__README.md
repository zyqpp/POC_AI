# E-002 RegisterComponent

Status: `wniosek z analizy`; źródło startowe: routing i komponent Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-002` |
| Route | `/register` |
| Komponent | `RegisterComponent` |
| Guardy | `brak guardów w route` |
| Role frontendu | `brak ról w route` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/auth/register/register.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/auth/register/register.component.html` |
| Status faktów | `do uzupełnienia` |

## Dokumenty Atomowe

- [Pola UI](P-002_POLA/P-002__INDEX.md)
- [Akcje UI](A-002_AKCJE/A-002__INDEX.md)
- [Błędy i komunikaty](ERR-002_BLEDY/ERR-002__INDEX.md)
- [Dane testowe](TD-002_DANE_TESTOWE/TD-002__INDEX.md)
- [Testy](TC-002_TESTY/TC-002__INDEX.md)
- [Linki śladu](E-002__LINKI.md)

## Cel Ekranu

Ekran rejestracji nowego dealera. Formularz jednostronicowy zbiera dane osobowe, firmowe (GST number, numer licencji handlowej, adres, miasto, stan, kod pin) i dane dostępowe. Po sukcesie konto ma status `Pending` i oczekuje na approval admina — dealer NIE może się zalogować natychmiast.

Główne funkcje:
- Formularz rejestracji dealera z 11 polami (email, hasło, pełna nazwa, telefon, nazwa firmy, GST, licencja, adres, miasto, stan, kod pin)
- Walidacja GST (regex indyjski format), formatu email, siły hasła (min. 8 znaków, wielka/mała litera, cyfra, znak specjalny)
- Walidacja numeru telefonu (pattern `^[6-9][0-9]{9}$`), kodu pin (6 cyfr)
- Komunikat o oczekiwaniu na approval po wysłaniu (sygnał `success`)

Powiązany proces: [PROC-001_AUTH](../../../../06_PROCESY/PROC-001_AUTH.md)

## Kluczowe Pliki Kodu

| Rola | Ścieżka |
|---|---|
| Komponent Angular | `supply-chain-frontend/src/app/features/auth/register/register.component.ts` |
| Template HTML | `supply-chain-frontend/src/app/features/auth/register/register.component.html` |
| Serwis API frontend | `supply-chain-frontend/src/app/core/api/auth-api.service.ts` |
| Serwis toast | `supply-chain-frontend/src/app/core/services/toast.service.ts` |
| Kontroler .NET | `services/IdentityAuth/IdentityAuth.API/Controllers/AuthController.cs` |
| Handler MediatR | `services/IdentityAuth/IdentityAuth.Application/Features/Auth/Commands/IdentityAuthCommands.cs` (RegisterDealerCommandHandler) |
| Encje domenowe | `services/IdentityAuth/IdentityAuth.Domain/Entities/User.cs`, `DealerProfile.cs` |

## Główne Wywołania API

| Metoda | Endpoint | Cel | DTO Odpowiedzi |
|---|---|---|---|
| `POST` | `/identity/api/auth/register` | rejestracja dealera; tworzy User + DealerProfile ze statusem Pending | `201` (brak body) lub `{message, errors}` |

## Stany Ekranu

| Stan | Warunek | Zachowanie UI |
|---|---|---|
| Wypełnianie | formularz aktywny | walidacja inline przy opuszczeniu pola (`touched`); metoda `err(field)` zwraca bool |
| Wysyłanie | żądanie w toku (`loading() === true`) | submit nieaktywny / spinner |
| Sukces | 201 z backendu (`success() === true`) | ukrycie formularza; komunikat "Registration submitted — await approval" |
| Email zajęty | 409 / message contains 'email' | `errorMsg` = "Email already registered." |
| GST zajęty | 409 / message contains 'gst' | `errorMsg` = "GST number is already registered." |
| Błąd walidacji | 400 z tablicą `errors` | wyświetlenie pierwszego `errorMessage` z tablicy |

## Zasada Uzupełniania

Każde pole `P-002-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
