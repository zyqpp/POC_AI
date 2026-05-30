# AOS Screen Overview Template

## Metryka Dokumentu

| Pole | Wartość |
|---|---|
| AOS ID | `AOS-<MOD>-<SCREEN>` |
| Moduł / menu | `<np. Orders, Logistics, Catalog>` |
| Ekran / funkcja | `<nazwa biznesowa i techniczna>` |
| URL frontendu | `<np. /orders/:id>` |
| Komponent frontend | `<ścieżka do component.ts>` |
| Główne API | `<prefiks API / gateway>` |
| Role | `<Admin, Dealer, Warehouse, Logistics, Agent>` |
| Status dokumentu | `draft / reviewed / approved / stale` |
| Ostatnia weryfikacja z kodem | `<data, commit SHA>` |
| Autor / reviewer | `<osoby albo agent>` |

## Cel Biznesowy

Opisz po co istnieje ekran:

- jaki problem użytkownika rozwiązuje;
- w jakim procesie biznesowym występuje;
- jaka decyzje albo operacje wspiera;
- czego użytkownik ma się dowiedziec albo co ma wykonać.

## Zakres

### W zakresie

- `<funkcje widoczne i obslugiwane w tym AOS>`

### Poza zakresem

- `<funkcje powiązane, ale opisane w innym AOS>`

## Użytkownicy I Role

| Rola | Dostęp do ekranu | Dozwolone operacje | Ograniczenia danych |
|---|---|---|---|
| Admin | `<tak/nie>` | `<operacje>` | `<np. wszystkie rekordy>` |
| Dealer | `<tak/nie>` | `<operacje>` | `<np. tylko własne rekordy>` |
| Warehouse | `<tak/nie>` | `<operacje>` | `<ograniczenia>` |
| Logistics | `<tak/nie>` | `<operacje>` | `<ograniczenia>` |
| Agent | `<tak/nie>` | `<operacje>` | `<np. tylko przypisane rekordy>` |

## Wejścia I Wyjścia Ekranu

| Typ | Opis | Źródło / cel |
|---|---|---|
| Parametry route | `<np. id>` | `<app.routes.ts>` |
| Query params | `<np. page, status>` | `<komponent / API service>` |
| Dane wejściowe z poprzedniego ekranu | `<np. wybrany order>` | `<link albo store>` |
| Wynik operacji | `<np. zmiana statusu, utworzenie rekordu>` | `<API / tabela SQL / event>` |

## Główne Scenariusze Użycia

| ID | Scenariusz | Rola | Wynik biznesowy |
|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-UC-001` | `<nazwa scenariusza>` | `<rola>` | `<wynik>` |

## Powiązane Dokumenty

- UI: `01_UI_FIELDS_AND_LAYOUT.md`.
- Akcje i procesy: `02_ACTIONS_AND_PROCESS_TRACE.md`.
- API: `03_API_AND_CONTRACTS.md`.
- Dane: `04_DATA_LINEAGE.md`.
- Reguły i błędy: `05_RULES_VALIDATIONS_ERRORS.md`.
- Testy: `06_TEST_MATRIX.md`.
- Nawigacja po kodzie: `07_DEV_AI_NAVIGATION.md`.
- Wymagania i pokrycie: `08_REQUIREMENTS_TRACEABILITY.md`.
- Historia zmian i review: `09_CHANGELOG_REVIEW_GATE.md`.

## Otwarte Pytania I Luki

| ID | Pytanie / luka | Wpływ | Decyzja / status |
|---|---|---|---|
| `GAP-001` | `<co jest niejasne>` | `<wysoki/średni/niski>` | `<do decyzji>` |
