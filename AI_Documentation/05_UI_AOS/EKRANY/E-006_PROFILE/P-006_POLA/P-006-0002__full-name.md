# P-006-0002 Full name

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Ekran | `E-006_PROFILE` |
| Typ UI | display, nagłówek profilu |
| Źródło UI | `profile.component.html` -> binding `profile()!.fullName` |
| Wymagalność | readonly; backend model wymaga wartości |
| Widoczność | widoczne po sukcesie `A-006-0001` |
| Walidacje | dla rejestracji/tworzenia usera: `NotEmpty`, `MaximumLength(120)` w `AuthValidators.cs`; na profilu brak edycji |
| DTO/API | `UserProfileDto.fullName` |
| Encja | `User.FullName` |
| DbContext | `IdentityAuthDbContext.Users` |
| Tabela SQL | `Users` |
| Kolumna SQL | `FullName`, max 120, `NOT NULL`, odczyt `R` |
| Dane Do Test | `TD-006-0001`, `TD-006-0002`; wartości: `Admin User`, `Demo Dealer` |
| Testy | `TC-006-0001`, `TC-006-0002` |

## Opis Pola

Pole wyświetlające pełne imię i nazwisko zalogowanego użytkownika. Dane są readonly — używane też do generowania awatara (pierwsza litera). Pochodzi z `UserProfileDto.fullName`.

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend | `profile.component.html` — binding `profile()!.fullName` | `potwierdzone` |
| DTO | `UserProfileDto.fullName` (`string`) | `potwierdzone` |
| Endpoint | `GET /identity/api/users/profile` → `UsersController.GetProfile()` | `potwierdzone` |
| Encja | `User.FullName` | `potwierdzone` |
| DbContext | `IdentityAuthDbContext.Users` | `potwierdzone` |
| Tabela SQL | `Users` | `potwierdzone` |
| Kolumna SQL | `FullName`, max 120, `NOT NULL` | `potwierdzone` |
| Odczyt/zapis | R (tylko odczyt na profilu) | `potwierdzone` |
