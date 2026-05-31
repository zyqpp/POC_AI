# P-006-0009 GST Number

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Ekran | `E-006_PROFILE` |
| Typ UI | display |
| Źródło UI | `profile.component.html` -> pole `GST Number` |
| Wymagalność | readonly; widoczne tylko dla roli `Dealer` |
| Widoczność | `@if (isDealer())` |
| Walidacje | w rejestracji: regex GST, unikalny indeks w DB |
| DTO/API | `UserProfileDto.dealerGstNumber` |
| Encja | `DealerProfile.GstNumber` |
| DbContext | `IdentityAuthDbContext.DealerProfiles` |
| Tabela SQL | `DealerProfiles` |
| Kolumna SQL | `GstNumber`, max 20, `NOT NULL`, indeks unikalny, odczyt `R` |
| Dane Do Test | `TD-006-0002`; przykład `37ABCDE1234F1Z5` |
| Testy | `TC-006-0002` |
