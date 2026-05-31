# PROC-006 Profil Użytkownika

Status: `potwierdzone`.

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
