# AOS Screen Overview Template

## Metryka Dokumentu

| Pole | Wartosc |
|---|---|
| AOS ID | `AOS-<MOD>-<SCREEN>` |
| Modul / menu | `<np. Orders, Logistics, Catalog>` |
| Ekran / funkcja | `<nazwa biznesowa i techniczna>` |
| URL frontendu | `<np. /orders/:id>` |
| Komponent frontend | `<sciezka do component.ts>` |
| Glowne API | `<prefiks API / gateway>` |
| Role | `<Admin, Dealer, Warehouse, Logistics, Agent>` |
| Status dokumentu | `draft / reviewed / approved / stale` |
| Ostatnia weryfikacja z kodem | `<data, commit SHA>` |
| Autor / reviewer | `<osoby albo agent>` |

## Cel Biznesowy

Opisz po co istnieje ekran:

- jaki problem uzytkownika rozwiazuje;
- w jakim procesie biznesowym wystepuje;
- jaka decyzje albo operacje wspiera;
- czego uzytkownik ma sie dowiedziec albo co ma wykonac.

## Zakres

### W zakresie

- `<funkcje widoczne i obslugiwane w tym AOS>`

### Poza zakresem

- `<funkcje powiazane, ale opisane w innym AOS>`

## Uzytkownicy I Role

| Rola | Dostep do ekranu | Dozwolone operacje | Ograniczenia danych |
|---|---|---|---|
| Admin | `<tak/nie>` | `<operacje>` | `<np. wszystkie rekordy>` |
| Dealer | `<tak/nie>` | `<operacje>` | `<np. tylko wlasne rekordy>` |
| Warehouse | `<tak/nie>` | `<operacje>` | `<ograniczenia>` |
| Logistics | `<tak/nie>` | `<operacje>` | `<ograniczenia>` |
| Agent | `<tak/nie>` | `<operacje>` | `<np. tylko przypisane rekordy>` |

## Wejscia I Wyjscia Ekranu

| Typ | Opis | Zrodlo / cel |
|---|---|---|
| Parametry route | `<np. id>` | `<app.routes.ts>` |
| Query params | `<np. page, status>` | `<komponent / API service>` |
| Dane wejsciowe z poprzedniego ekranu | `<np. wybrany order>` | `<link albo store>` |
| Wynik operacji | `<np. zmiana statusu, utworzenie rekordu>` | `<API / tabela / event>` |

## Glowne Scenariusze Uzycia

| ID | Scenariusz | Rola | Wynik biznesowy |
|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-UC-001` | `<nazwa scenariusza>` | `<rola>` | `<wynik>` |

## Powiazane Dokumenty

- UI: `01_UI_FIELDS_AND_LAYOUT.md`.
- Akcje i procesy: `02_ACTIONS_AND_PROCESS_TRACE.md`.
- API: `03_API_AND_CONTRACTS.md`.
- Dane: `04_DATA_LINEAGE.md`.
- Reguly i bledy: `05_RULES_VALIDATIONS_ERRORS.md`.
- Testy: `06_TEST_MATRIX.md`.
- Nawigacja po kodzie: `07_DEV_AI_NAVIGATION.md`.
- Wymagania i pokrycie: `08_REQUIREMENTS_TRACEABILITY.md`.
- Historia zmian i review: `09_CHANGELOG_REVIEW_GATE.md`.

## Otwarte Pytania I Luki

| ID | Pytanie / luka | Wplyw | Decyzja / status |
|---|---|---|---|
| `GAP-001` | `<co jest niejasne>` | `<wysoki/sredni/niski>` | `<do decyzji>` |
