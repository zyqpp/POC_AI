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
