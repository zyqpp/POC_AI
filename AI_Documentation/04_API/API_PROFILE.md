# API_PROFILE

Status: `potwierdzone` dla `E-006_PROFILE`.

| ID | Metoda | Ścieżka frontend gateway | Kontroler backend | Role | Request | Response | Statusy | Źródło |
|---|---|---|---|---|---|---|---|---|
| `API-006-0001` | `GET` | `/identity/api/users/profile` | `UsersController.GetProfile` (`api/users/profile`) | `[Authorize]`, dowolny zalogowany użytkownik | brak body | `UserProfileDto` | `200`, `401`, `404` | `services/IdentityAuth/IdentityAuth.API/Controllers/UsersController.cs` |

## Kontrakt `UserProfileDto`

| Pole | Typ | Źródło danych | DB |
|---|---|---|---|
| `userId` | `Guid` | `User.UserId` | `Users.UserId` |
| `fullName` | `string` | `User.FullName` | `Users.FullName` |
| `email` | `string` | `User.Email` | `Users.Email` |
| `role` | `string` | `User.Role.ToString()` | `Users.Role` |
| `status` | `string` | `User.Status.ToString()` | `Users.Status` |
| `creditLimit` | `decimal` | `User.CreditLimit` | `Users.CreditLimit` |
| `dealerBusinessName` | `string?` | `DealerProfile.BusinessName` | `DealerProfiles.BusinessName` |
| `dealerGstNumber` | `string?` | `DealerProfile.GstNumber` | `DealerProfiles.GstNumber` |
| `isInterstate` | `bool?` | `DealerProfile.IsInterstate` | `DealerProfiles.IsInterstate` |

## Powiązania

- Ekran: [E-006_PROFILE](../05_UI_AOS/EKRANY/E-006_PROFILE/E-006__README.md)
- Proces: [PROC-006_PROFILE](../06_PROCESY/PROC-006_PROFILE.md)
- Model danych: [MODEL_DANYCH_PROFILE](../03_MODEL_DANYCH/MODEL_DANYCH_PROFILE.md)
