# ERR-006-0001 Failed to load profile

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Warunek | `UsersApiService.getProfile()` zwraca błąd HTTP lub observable error |
| Komunikat UI | `Failed to load profile.` |
| Warstwa | Angular component |
| Źródło | `profile.component.ts` -> `error: () => { this.error.set('Failed to load profile.'); ... }` |
| Status HTTP | dowolny błąd endpointu; komponent nie rozróżnia kodów |
| Wpływ na dane | brak zapisu; profil pozostaje `null` |
| Powiązana akcja | [A-006-0001](../A-006_AKCJE/A-006-0001__load-profile.md) |
| Dane Do Test | `TD-006-0003`, `TD-006-0004` |
| Test | `TC-006-0003`, `TC-006-0004` |
