# P-006-0008 Business Name

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Ekran | `E-006_PROFILE` |
| Typ UI | display |
| Źródło UI | `profile.component.html` -> pole `Business Name` |
| Wymagalność | readonly; widoczne tylko dla roli `Dealer` |
| Widoczność | `@if (isDealer())` |
| Walidacje | w rejestracji: `NotEmpty`, `MaximumLength(180)` |
| DTO/API | `UserProfileDto.dealerBusinessName` |
| Encja | `DealerProfile.BusinessName` |
| DbContext | `IdentityAuthDbContext.DealerProfiles` |
| Tabela SQL | `DealerProfiles` |
| Kolumna SQL | `BusinessName`, max 180, `NOT NULL`, odczyt `R` |
| Dane Do Test | `TD-006-0002` |
| Testy | `TC-006-0002` |

## Opis Pola

Pole wyświetlające nazwę firmy (business name) dealera. Widoczne wyłącznie dla roli `Dealer`. Nazwa firmy jest podawana podczas rejestracji dealera i nie może być zmieniana z poziomu profilu.

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend | `profile.component.html` — binding `profile()!.dealerBusinessName` | `potwierdzone` |
| DTO | `UserProfileDto.dealerBusinessName` (`string`) | `potwierdzone` |
| Endpoint | `GET /identity/api/users/profile` → `UsersController.GetProfile()` | `potwierdzone` |
| Encja | `DealerProfile.BusinessName` | `potwierdzone` |
| DbContext | `IdentityAuthDbContext.DealerProfiles` | `potwierdzone` |
| Tabela SQL | `DealerProfiles` | `potwierdzone` |
| Kolumna SQL | `BusinessName`, max 180, `NOT NULL` | `potwierdzone` |
| Odczyt/zapis | R (tylko odczyt na profilu) | `potwierdzone` |
