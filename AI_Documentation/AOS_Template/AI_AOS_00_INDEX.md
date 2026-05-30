# AOS Template Index

AOS oznacza Analityczny Opis Systemu. Ten szablon opisuje ekran, pozycje menu albo mala funkcje aplikacji tak, aby analityk mogl kontrolowac zgodnosc z wymaganiami, tester mogl przygotowac testy, a developer lub agent AI mogl szybko dojsc od UI do kodu i bazy danych.

## Cel AOS

Dobry AOS nie opisuje tylko "co widac na ekranie". Ma pokazac pelny lancuch faktow:

`ekran -> pole/przycisk -> akcja -> frontend -> API -> proces -> walidacje -> zapis/odczyt danych -> testy -> kod`

Kazda informacja techniczna powinna miec zrodlo w kodzie albo oznaczony status: `potwierdzone`, `do potwierdzenia`, `brak w kodzie`, `wniosek z analizy`.

## Rekomendowana struktura dla jednego ekranu/funkcji

Tworz folder per ekran albo per logiczna pozycja menu:

```text
AI_Documentation/AOS/<modul>/<screen_or_feature_id>/
|-- 00_SCREEN_OVERVIEW.md
|-- 01_UI_FIELDS_AND_LAYOUT.md
|-- 02_ACTIONS_AND_PROCESS_TRACE.md
|-- 03_API_AND_CONTRACTS.md
|-- 04_DATA_LINEAGE.md
|-- 05_RULES_VALIDATIONS_ERRORS.md
|-- 06_TEST_MATRIX.md
|-- 07_DEV_AI_NAVIGATION.md
|-- 08_REQUIREMENTS_TRACEABILITY.md
+-- 09_CHANGELOG_REVIEW_GATE.md
```

Dla prostego ekranu mozna scalic pliki `03-05`, ale nie wolno tracic mapowania UI/API/dane/testy.

## Szablony w tym katalogu

- `AI_AOS_01_SCREEN_OVERVIEW_TEMPLATE.md` - karta ekranu/funkcji i zakres.
- `AI_AOS_02_UI_FIELDS_AND_LAYOUT_TEMPLATE.md` - pola, filtry, kolumny, stany UI, uprawnienia.
- `AI_AOS_03_ACTIONS_AND_PROCESS_TRACE_TEMPLATE.md` - akcje uzytkownika i procesy od klikniecia do skutku.
- `AI_AOS_04_API_AND_CONTRACTS_TEMPLATE.md` - endpointy, DTO, request/response, statusy HTTP.
- `AI_AOS_05_DATA_LINEAGE_TEMPLATE.md` - zrodla danych, tabele, pola, odczyt/zapis.
- `AI_AOS_06_RULES_VALIDATIONS_ERRORS_TEMPLATE.md` - reguly, walidacje, bledy i komunikaty.
- `AI_AOS_07_TEST_MATRIX_TEMPLATE.md` - testy manualne, API, E2E, automaty i dane testowe.
- `AI_AOS_08_DEV_AI_NAVIGATION_TEMPLATE.md` - sciezki kodu i instrukcja dla dev/AI.
- `AI_AOS_09_REQUIREMENTS_TRACEABILITY_TEMPLATE.md` - wymagania, kryteria akceptacji i pokrycie.
- `AI_AOS_10_CHANGELOG_REVIEW_GATE_TEMPLATE.md` - historia zmian, review i bramka jakosci AOS.

## Identyfikatory sladowania

Kazdy istotny element powinien miec stabilny identyfikator:

- Pole UI: `AOS-<MOD>-<SCREEN>-FLD-001`.
- Akcja: `AOS-<MOD>-<SCREEN>-ACT-001`.
- Regula: `AOS-<MOD>-<SCREEN>-RULE-001`.
- API: `AOS-<MOD>-<SCREEN>-API-001`.
- Dane: `AOS-<MOD>-<SCREEN>-DATA-001`.
- Test: `AOS-<MOD>-<SCREEN>-TC-001`.

Przyklad: `AOS-ORD-LIST-ACT-003` dla akcji masowej zmiany statusu na liscie zamowien.

## Minimalna definicja gotowosci AOS

AOS jest gotowy dopiero gdy:

- wiadomo, dla jakiej roli i procesu biznesowego powstal ekran;
- kazde pole UI ma opis zrodla danych albo sposobu zapisu;
- kazdy przycisk/akcja ma opis procesu i endpointu;
- walidacje i bledy sa opisane z dowodem z kodu;
- dane sa zmapowane do DTO, encji, tabel i pol;
- istnieje macierz testow manualnych, API i automatycznych;
- developer ma podane pliki startowe i sciezke dalszej analizy;
- wymagania maja pokrycie w UI, API, danych, regulach i testach;
- dokument przeszedl review analityczne, testowe i techniczne albo ma jawnie opisane luki;
- braki sa jawnie oznaczone w sekcji `Otwarte pytania i luki`.

## Zasada aktualizacji

Przy zmianie ekranu aktualizuj dokumenty w tej kolejnosci:

1. `01_UI_FIELDS_AND_LAYOUT.md` - co widac i co moze zrobic uzytkownik.
2. `02_ACTIONS_AND_PROCESS_TRACE.md` - co uruchamia akcja.
3. `03_API_AND_CONTRACTS.md` - co zmienilo sie w kontrakcie.
4. `04_DATA_LINEAGE.md` - co zmienilo sie w odczycie/zapisie.
5. `05_RULES_VALIDATIONS_ERRORS.md` - co zmienilo sie w regulach.
6. `06_TEST_MATRIX.md` - jakie testy trzeba dodac albo poprawic.
7. `08_REQUIREMENTS_TRACEABILITY.md` - czy wymagania nadal maja pokrycie.
8. `09_CHANGELOG_REVIEW_GATE.md` - kto i kiedy potwierdzil aktualnosc.
