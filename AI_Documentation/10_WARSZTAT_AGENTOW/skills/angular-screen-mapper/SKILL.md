---
name: angular-screen-mapper
description: Mapuje ekrany Angular na podstawie app.routes.ts, komponentów, template'ów, guardów, modeli TypeScript i serwisów API. Użyj, gdy trzeba utworzyć lub uzupełnić atomową dokumentację ekranu E, pól P, akcji A, błędów ERR, danych testowych TD i testów TC.
---

# Angular Screen Mapper

## Workflow

1. Uruchom `AI_Agent_scripts/Export-Podejscie2AngularRoutes.ps1`.
2. Uruchom `AI_Agent_scripts/New-FrontendScreenScaffold.ps1`, jeżeli brakuje zagnieżdżonej struktury `05_UI_AOS/EKRANY/E-...`.
3. Potwierdź route, guardy i role w `supply-chain-frontend/src/app/app.routes.ts`.
4. Otwórz komponent `.ts` i template `.html` danego route'u.
5. Dla każdego widocznego pola utwórz albo uzupełnij osobny dokument `P-...`.
6. Dla każdej akcji użytkownika utwórz albo uzupełnij osobny dokument `A-...`.
7. Dla komunikatów walidacyjnych i błędów utwórz albo uzupełnij dokumenty `ERR-...`.
8. Przekaż ślad do skilli API, EF i AOS, gdy opis ma zejść do endpointów, DTO, encji, tabel i kolumn SQL.

## Heurystyki Detekcji

- Pola: `formControlName`, `[(ngModel)]`, `name`, `id`, `placeholder`, kolumny tabel i interpolacje prezentujące dane biznesowe.
- Akcje: `(click)`, `(ngSubmit)`, `routerLink`, przyciski `button`, linki `a`, akcje formularzy i nawigacje.
- Błędy: `mat-error`, bloki `*ngIf` z `error`, `invalid`, `hasError`, obsługa `catchError`, `toast.error`, `snackBar.open`, lokalne `errorMessage`.

## Reguły

- Nie opisuj funkcji jako potwierdzonej, jeżeli widzisz tylko tekst bez akcji albo powiązania w komponencie.
- Role frontendu nie zastępują autoryzacji backendu; dokumentuj oba poziomy osobno.
- Każde pole `P-...` musi docelowo mieć wymagalność, walidacje, mapowanie do API/DTO, encji, tabeli SQL, kolumny SQL i dane testowe.
- Jeżeli automatyczny skaner znalazł tylko kandydata, zostaw status `do uzupełnienia`.
- Nie używaj `AI_Documentation/_archive/**` jako źródła faktów.

## Artefakt Wyjściowy

Minimalny wynik pracy to katalog ekranu `E-...` z indeksami `P`, `A`, `ERR`, `TD`, `TC` i linkami między dokumentami. Pełny wynik to ślad UI -> API -> proces -> baza -> testy.
