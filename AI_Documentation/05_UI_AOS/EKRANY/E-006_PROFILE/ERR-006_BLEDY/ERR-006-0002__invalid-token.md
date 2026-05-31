# ERR-006-0002 Invalid token

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | Brak lub niepoprawny claim user id w tokenie |
| Komunikat API | `Invalid access token.` |
| Warstwa | `UsersController.GetProfile` |
| Status HTTP | `401 Unauthorized` |
| Źródło | `services/IdentityAuth/IdentityAuth.API/Controllers/UsersController.cs` |
| Wpływ na dane | brak odczytu profilu i brak zapisu |
| Powiązana akcja | [A-006-0001](../A-006_AKCJE/A-006-0001__load-profile.md) |
| Dane Do Test | `TD-006-0003` |
| Test | `TC-006-0003` |
