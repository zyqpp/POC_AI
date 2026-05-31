# ERR-010-0012 Silent Update Error

Status: `brak w kodzie` jako luka UX.

| Atrybut | Wartość |
|---|---|
| Akcja | [A-010-0001](../A-010_AKCJE/A-010-0001__submit.md) |
| Warunek | `updateProduct()` zwraca błąd HTTP albo błąd sieci |
| UI | error handler wykonuje tylko `loading=false` |
| Komunikat | brak toastu i brak komunikatu w formularzu |
| DB | brak pewności użytkownika, czy zapis się odbył; faktyczny zapis zależy od odpowiedzi API |
| Test | [TC-010-0006](../TC-010_TESTY/TC-010__INDEX.md) |
