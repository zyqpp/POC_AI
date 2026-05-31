# ERR-006-0003 Profile not found

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | Claim user id jest poprawnym `Guid`, ale `IdentityAuthService.GetProfileAsync` nie znajduje użytkownika |
| Komunikat API | brak body w kontrolerze; `NotFound()` |
| Warstwa | backend/API |
| Status HTTP | `404 NotFound` |
| Źródło | `UsersController.GetProfile`, `IdentityAuthService.GetProfileAsync` |
| Wpływ na dane | brak zapisu; UI pokaże ogólny komunikat `Failed to load profile.` |
| Powiązana akcja | [A-006-0001](../A-006_AKCJE/A-006-0001__load-profile.md) |
| Dane Do Test | `TD-006-0004` |
| Test | `TC-006-0004` |
