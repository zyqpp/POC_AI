# A-006-0001 Załaduj profil

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Ekran | `E-006_PROFILE` |
| Trigger | `ProfileComponent.ngOnInit()` |
| Handler frontend | `usersApi.getProfile().subscribe(...)` |
| Serwis Angular | `UsersApiService.getProfile()` |
| Endpoint | `GET /identity/api/users/profile` |
| Kontroler | `UsersController.GetProfile` |
| Autoryzacja | `[Authorize]`; route chroniony `authGuard` |
| DTO response | `UserProfileDto` |
| Proces | [PROC-006_PROFILE](../../../../06_PROCESY/PROC-006_PROFILE.md) |
| Dane R/W | odczyt `Users`, opcjonalnie `DealerProfiles`; brak zapisu DB |
| Błędy | [ERR-006-0001](../ERR-006_BLEDY/ERR-006-0001__failed-to-load-profile.md), [ERR-006-0002](../ERR-006_BLEDY/ERR-006-0002__invalid-token.md), [ERR-006-0003](../ERR-006_BLEDY/ERR-006-0003__profile-not-found.md) |
| Dane Do Test | `TD-006-0001` do `TD-006-0004` |

## Ślad

`/profile` -> `ProfileComponent.ngOnInit()` -> `UsersApiService.getProfile()` -> `GET /identity/api/users/profile` -> `UsersController.GetProfile()` -> `GetProfileQuery` -> `IdentityAuthService.GetProfileAsync()` -> `Users` / `DealerProfiles`.
