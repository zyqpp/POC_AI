# P-006-0001 Avatar/initial

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Ekran | `E-006_PROFILE` |
| Typ UI | display, avatar text |
| Źródło UI | `profile.component.html`, `profile-avatar` |
| Źródło TS | `ProfileComponent.initial()` |
| Wymagalność | readonly; wymagane do wyświetlenia po sukcesie ładowania |
| Widoczność | widoczne, gdy `profile()` nie jest `null` |
| Walidacje | brak walidacji UI; wartość wyliczana jako pierwsza litera `fullName` albo `?` |
| DTO/API | `UserProfileDto.fullName`, `GET /identity/api/users/profile` |
| Encja | `IdentityAuth.Domain.Entities.User.FullName` |
| DbContext | `IdentityAuthDbContext.Users` |
| Tabela SQL | `Users` |
| Kolumna SQL | `FullName`, max 120, `NOT NULL`, odczyt `R` |
| Dane Do Test | `TD-006-0001`, `TD-006-0002`; sprawdzić pierwszą literę imienia i fallback `?` |
| Powiązane akcje | [A-006-0001](../A-006_AKCJE/A-006-0001__load-profile.md) |

## Uwagi

Pole nie zapisuje danych. Jest wyliczeniem frontendowym z wartości pobranej z bazy.
