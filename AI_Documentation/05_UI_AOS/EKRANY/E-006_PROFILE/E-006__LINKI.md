# E-006 Linki Śladu

Status: `potwierdzone`.

## Źródła Kodu

| Typ | Ścieżka | Użycie |
|---|---|---|
| Route | `supply-chain-frontend/src/app/app.routes.ts` | `/profile` jako route chroniony przez shell `authGuard` |
| Guard | `supply-chain-frontend/src/app/core/guards/auth.guard.ts` | przekierowanie niezalogowanego użytkownika |
| Komponent | `supply-chain-frontend/src/app/features/profile/profile.component.ts` | loading, error, `UsersApiService.getProfile()` |
| Template | `supply-chain-frontend/src/app/features/profile/profile.component.html` | pola profilu i link do dashboardu |
| API Angular | `supply-chain-frontend/src/app/core/api/auth-api.service.ts` | `GET /identity/api/users/profile` |
| Kontroler | `services/IdentityAuth/IdentityAuth.API/Controllers/UsersController.cs` | `[Authorize]`, claim user id, `GetProfileQuery` |
| DTO | `services/IdentityAuth/IdentityAuth.Application/DTOs/AuthDtos.cs` | `UserProfileDto` |
| Serwis | `services/IdentityAuth/IdentityAuth.Application/Services/IdentityAuthService.cs` | `GetProfileAsync` |
| DbContext | `services/IdentityAuth/IdentityAuth.Infrastructure/Persistence/IdentityAuthDbContext.cs` | `Users`, `DealerProfiles` |
| Encje | `services/IdentityAuth/IdentityAuth.Domain/Entities/User.cs`, `services/IdentityAuth/IdentityAuth.Domain/ValueObjects/DealerProfile.cs` | mapowanie pól |
| Testy | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | częściowe testy domeny użytkownika |

## Powiązane Dokumenty

| Typ | Link |
|---|---|
| Pola | [P-006_POLA/P-006__INDEX.md](P-006_POLA/P-006__INDEX.md) |
| Akcje | [A-006_AKCJE/A-006__INDEX.md](A-006_AKCJE/A-006__INDEX.md) |
| Błędy | [ERR-006_BLEDY/ERR-006__INDEX.md](ERR-006_BLEDY/ERR-006__INDEX.md) |
| Dane testowe | [TD-006_DANE_TESTOWE/TD-006__INDEX.md](TD-006_DANE_TESTOWE/TD-006__INDEX.md) |
| Testy | [TC-006_TESTY/TC-006__INDEX.md](TC-006_TESTY/TC-006__INDEX.md) |
| API | [../../../../04_API/API_PROFILE.md](../../../../04_API/API_PROFILE.md) |
| Model danych | [../../../../03_MODEL_DANYCH/MODEL_DANYCH_PROFILE.md](../../../../03_MODEL_DANYCH/MODEL_DANYCH_PROFILE.md) |
| Proces | [../../../../06_PROCESY/PROC-006_PROFILE.md](../../../../06_PROCESY/PROC-006_PROFILE.md) |
| Role | [../../../../07_ROLE_I_UPRAWNIENIA/ROLE_PROFILE.md](../../../../07_ROLE_I_UPRAWNIENIA/ROLE_PROFILE.md) |
| Testy przekrojowe | [../../../../08_TESTY/MACIERZ_TESTOW_PROFILE.md](../../../../08_TESTY/MACIERZ_TESTOW_PROFILE.md) |
