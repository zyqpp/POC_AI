# E-006 Profil Użytkownika

Status: `potwierdzone` dla śladu front -> API -> IdentityAuth DB -> testy.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-006` |
| Route | `/profile` |
| Komponent | `ProfileComponent` |
| Guardy | `authGuard` dziedziczony z shell route w `app.routes.ts` |
| Role frontendu | brak listy ról na route; dostęp dla każdego zalogowanego użytkownika |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/profile/profile.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/profile/profile.component.html` |
| Serwis Angular | `UsersApiService.getProfile()` w `supply-chain-frontend/src/app/core/api/auth-api.service.ts` |
| Endpoint | `GET /identity/api/users/profile` |
| Backend | `services/IdentityAuth/IdentityAuth.API/Controllers/UsersController.cs` |
| Proces | [PROC-006-0001 Profil użytkownika](../../../06_PROCESY/PROC-006_PROFILE.md) |
| API | [API_PROFILE](../../../04_API/API_PROFILE.md) |
| Model danych | [MODEL_DANYCH_PROFILE](../../../03_MODEL_DANYCH/MODEL_DANYCH_PROFILE.md) |
| Role | [ROLE_PROFILE](../../../07_ROLE_I_UPRAWNIENIA/ROLE_PROFILE.md) |
| Testy | [MACIERZ_TESTOW_PROFILE](../../../08_TESTY/MACIERZ_TESTOW_PROFILE.md) |

## Cel Ekranu

Ekran pokazuje dane aktualnie zalogowanego użytkownika pobrane z tokenu i bazy `IdentityAuth`. Dla roli `Dealer` pokazuje dodatkowo dane dealera: limit kredytowy, nazwę firmy, GST i flagę interstate.

## Widok

```text
+----------------------------------------------------------------------------+
| Profile                                                                    |
+----------------------------------------------------------------------------+
| +------------------------------------------------------------------------+ |
| | User                                                                    | |
| | Full name        [P-006: fullName]                                      | |
| | Email            [P-006: email]                                         | |
| | Role             [P-006: role]                                          | |
| | Status           [P-006: status / active flag]                          | |
| +------------------------------------------------------------------------+ |
|                                                                            |
| +------------------------------------------------------------------------+ |
| | Dealer details (visible when profile has Dealer data)                    | |
| | Company          [P-006: companyName]                                   | |
| | GST              [P-006: gstNumber]                                     | |
| | Interstate       [P-006: isInterstate]                                  | |
| | Credit limit     [P-006: creditLimit]                                   | |
| +------------------------------------------------------------------------+ |
|                                                                            |
| [loading state] [error state if profile API fails]                         |
+----------------------------------------------------------------------------+
```

## Dokumenty Atomowe

- [Pola UI](P-006_POLA/P-006__INDEX.md)
- [Akcje UI](A-006_AKCJE/A-006__INDEX.md)
- [Błędy i komunikaty](ERR-006_BLEDY/ERR-006__INDEX.md)
- [Dane testowe](TD-006_DANE_TESTOWE/TD-006__INDEX.md)
- [Testy](TC-006_TESTY/TC-006__INDEX.md)
- [Linki śladu](E-006__LINKI.md)

## Ślad End-To-End

| Krok | Fakt | Źródło | Status |
|---|---|---|---|
| Wejście | Route `/profile` jest dzieckiem shell route chronionego `authGuard`. | `app.routes.ts` | `potwierdzone` |
| Front | `ngOnInit()` wywołuje `usersApi.getProfile()`. | `profile.component.ts` | `potwierdzone` |
| API Angular | `UsersApiService.getProfile()` robi `GET /identity/api/users/profile`. | `auth-api.service.ts` | `potwierdzone` |
| Backend | `UsersController.GetProfile()` wymaga `[Authorize]` i odczytuje user id z claim `sub` albo `NameIdentifier`. | `UsersController.cs` | `potwierdzone` |
| Aplikacja | `GetProfileQuery` trafia do `IdentityAuthService.GetProfileAsync`. | `IdentityAuthService.cs` | `potwierdzone` |
| Baza | Dane pochodzą z `Users` oraz opcjonalnie `DealerProfiles`. | `IdentityAuthDbContext.cs`, `User.cs`, `DealerProfile.cs` | `potwierdzone` |
| Testy | Istnieją testy domenowe `UserTests`, ale brak testów API/component dla profilu. | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs`, `supply-chain-frontend/src/app/smoke.spec.ts` | `potwierdzone` |

## Luki I Ryzyka

| ID | Luka | Wpływ | Następny krok |
|---|---|---|---|
| `GAP-E-006-001` | Brak testu komponentu Angular dla loading/success/error. | Regresja UI profilu może przejść niezauważona. | Dodać test komponentu lub e2e po zmianie trybu pracy na implementacyjny. |
| `GAP-E-006-002` | Brak testu API `GET /api/users/profile`. | Nie ma automatycznej kontroli claim parsing i odpowiedzi 401/404. | Dodać test integracyjny IdentityAuth API. |
