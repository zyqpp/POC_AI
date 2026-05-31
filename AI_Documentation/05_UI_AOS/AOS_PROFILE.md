# AOS_PROFILE

Status: `potwierdzone` dla ekranu `E-006_PROFILE`.

## Zakres

Ten AOS opisuje ekran profilu użytkownika `/profile`. Ekran jest odczytowy, nie ma formularza edycji i nie zapisuje danych.

## End-To-End

| Ekran | API | Proces | Model danych | Role | Testy |
|---|---|---|---|---|---|
| [E-006_PROFILE](EKRANY/E-006_PROFILE/E-006__README.md) | [API_PROFILE](../04_API/API_PROFILE.md) | [PROC-006_PROFILE](../06_PROCESY/PROC-006_PROFILE.md) | [MODEL_DANYCH_PROFILE](../03_MODEL_DANYCH/MODEL_DANYCH_PROFILE.md) | [ROLE_PROFILE](../07_ROLE_I_UPRAWNIENIA/ROLE_PROFILE.md) | [MACIERZ_TESTOW_PROFILE](../08_TESTY/MACIERZ_TESTOW_PROFILE.md) |

## Model Danych

Główne tabele: `Users`, opcjonalnie `DealerProfiles`. Wszystkie pola na ekranie są odczytywane; ekran nie zapisuje danych.

## API I Kontrakty

`GET /identity/api/users/profile` zwraca `UserProfileDto`. Backend ustala użytkownika z tokenu, więc frontend nie przekazuje `userId`.

## Testy I Luki

Istnieją testy domenowe użytkownika, ale brak testów component/API/e2e dla profilu. Luki są opisane w [MACIERZ_TESTOW_PROFILE](../08_TESTY/MACIERZ_TESTOW_PROFILE.md).

## Ryzyka

Największe ryzyko to brak automatycznego testu autoryzacji i warunkowej sekcji dealera.
