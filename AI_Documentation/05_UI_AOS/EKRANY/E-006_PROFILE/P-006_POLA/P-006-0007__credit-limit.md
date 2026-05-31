# P-006-0007 Credit Limit

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Ekran | `E-006_PROFILE` |
| Typ UI | display, currency |
| Źródło UI | `profile.component.html` -> pole `Credit Limit` |
| Wymagalność | readonly; widoczne tylko dla roli `Dealer` |
| Widoczność | `@if (isDealer())` |
| Walidacje | brak walidacji UI; formatowanie Angular `currency:'INR'` |
| DTO/API | `UserProfileDto.creditLimit` |
| Encja | `User.CreditLimit` |
| DbContext | `IdentityAuthDbContext.Users` |
| Tabela SQL | `Users` |
| Kolumna SQL | `CreditLimit`, precision 18,2, odczyt `R` |
| Dane Do Test | `TD-006-0002`; wartość np. `500000.00` |
| Testy | `TC-006-0002` |

## Uwagi

Profil tylko odczytuje limit. Zmiana limitu jest w obszarze administracji dealerów, nie na tym ekranie.
