# TD-006 Dane Testowe

Status: `potwierdzone`.

| ID | Dane | Cel | Dokument |
|---|---|---|---|
| `TD-006-0001` | aktywny użytkownik `Admin` | pola wspólne bez sekcji dealera | [TD-006-0001__admin-profile.md](TD-006-0001__admin-profile.md) |
| `TD-006-0002` | aktywny użytkownik `Dealer` z profilem dealera | pola wspólne i sekcja dealer | [TD-006-0002__dealer-profile.md](TD-006-0002__dealer-profile.md) |
| `TD-006-0003` | brak/niepoprawny JWT | błąd 401 i redirect guard/interceptor | [TD-006-0003__invalid-token.md](TD-006-0003__invalid-token.md) |
| `TD-006-0004` | user id z tokenu bez rekordu `Users` | odpowiedź `404 NotFound` | [TD-006-0004__missing-user.md](TD-006-0004__missing-user.md) |
