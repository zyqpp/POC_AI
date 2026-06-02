# PROC-006 Profil Użytkownika

Status: `potwierdzone`.

## Opis

Zalogowany użytkownik wysyła GET do `UsersController.GetProfile`, który odczytuje `Users` i opcjonalnie `DealerProfiles`, zwracając `UserProfileDto` bez modyfikacji bazy.

## Cel

Użytkownik przegląda dane swojego profilu (imię, email, telefon, rola). Dealer dodatkowo widzi dane firmy (NIP, adres, limit kredytowy). Ekran jest tylko do odczytu — zmiana danych odbywa się przez osobny flow zmiany hasła. Proces kończy się wyrenderowaniem pól `P-006` bez zapisu do bazy.

## Przepływ

| Krok | Warstwa | Operacja | Artefakt |
|---|---|---|---|
| 1 | Routing | Użytkownik wchodzi na `/profile`; shell route wymaga `authGuard`. | `app.routes.ts`, `auth.guard.ts` |
| 2 | UI | Komponent pokazuje loading. | `profile.component.html` |
| 3 | Front logic | `ngOnInit()` wywołuje `UsersApiService.getProfile()`. | `profile.component.ts` |
| 4 | API frontend | HTTP `GET /identity/api/users/profile`. | `auth-api.service.ts` |
| 5 | Backend API | `[Authorize]`, odczyt claim `sub` lub `NameIdentifier`. | `UsersController.cs` |
| 6 | Application | `GetProfileQuery` -> `IdentityAuthService.GetProfileAsync`. | `IdentityAuthService.cs` |
| 7 | DB | Odczyt `Users`; dla dealera także `DealerProfiles`. | `IdentityAuthDbContext.cs` |
| 8 | UI | Render pól P-006 albo komunikatu błędu. | `profile.component.html` |

## Braki Testowe

Brak testu e2e lub component testu dla pełnego przepływu. Istnieją tylko testy domenowe `UserTests`, które częściowo potwierdzają tworzenie dealera i zmianę statusu.

## Błędy Procesu

| ID | Warunek | HTTP | Akcja kompensująca | Status |
|---|---|---|---|---|
| `ERR-PROC-006-001` | Token JWT wygasł lub nieważny | 401 | authGuard przekierowuje na `/login`; token odświeżany przez interceptor | `potwierdzone` |
| `ERR-PROC-006-002` | Backend niedostępny | 503 | komponent pokazuje komunikat błędu; brak danych profilu | `wniosek z analizy` |
| `ERR-PROC-006-003` | Użytkownik nie znaleziony (usunięty) | 404 | komponent pokazuje komunikat błędu | `do uzupełnienia` |

## Powiązane Dokumenty

| Typ | Plik | Opis powiązania |
|---|---|---|
| Ekran | [E-006_PROFILE](../05_UI_AOS/EKRANY/E-006_PROFILE/E-006__README.md) | główny ekran profilu użytkownika |
| API | [API_IDENTITY](../04_API/API_IDENTITY.md) | endpoint GET /identity/api/users/profile |
| Role | [ROLE_IDENTITY](../07_ROLE_I_UPRAWNIENIA/ROLE_IDENTITY.md) | macierz uprawnień dla modułu tożsamości |
| Model | [MODEL_DANYCH_PROFILE](../03_MODEL_DANYCH/MODEL_DANYCH_PROFILE.md) | encje Users i DealerProfiles |
| Testy | [MACIERZ_TESTOW_IDENTITY](../08_TESTY/MACIERZ_TESTOW_IDENTITY.md) | przypadki testowe dla profilu |
