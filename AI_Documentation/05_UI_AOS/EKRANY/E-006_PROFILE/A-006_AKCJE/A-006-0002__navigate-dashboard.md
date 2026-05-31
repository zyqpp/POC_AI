# A-006-0002 Powrót do dashboardu

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Ekran | `E-006_PROFILE` |
| Element UI | link `Dashboard` |
| Źródło UI | `profile.component.html` -> `routerLink="/dashboard"` |
| Handler frontend | Angular Router |
| Endpoint | brak API |
| Autoryzacja | docelowy route `/dashboard` jest w shellu z `authGuard` |
| Dane R/W | brak odczytu/zapisu DB przez samą akcję |
| Błędy | brak lokalnego błędu; ewentualny brak sesji obsługuje guard/interceptor |
| Dane Do Test | `TD-006-0001` |
| Test | `TC-006-0005` |
