# P-006-0010 Interstate

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Ekran | `E-006_PROFILE` |
| Typ UI | display, boolean label |
| Źródło UI | `profile.component.html` -> binding `profile()!.isInterstate ? 'Yes' : 'No'` |
| Wymagalność | readonly; widoczne tylko dla roli `Dealer` |
| Widoczność | `@if (isDealer())` |
| Walidacje | boolean; brak dodatkowej walidacji na profilu |
| DTO/API | `UserProfileDto.isInterstate` |
| Encja | `DealerProfile.IsInterstate` |
| DbContext | `IdentityAuthDbContext.DealerProfiles` |
| Tabela SQL | `DealerProfiles` |
| Kolumna SQL | `IsInterstate`, boolean/bit, odczyt `R` |
| Dane Do Test | `TD-006-0002`; warianty `true` i `false` |
| Testy | `TC-006-0002` |
