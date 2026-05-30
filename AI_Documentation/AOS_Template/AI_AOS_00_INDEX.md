# AOS Template Index

AOS oznacza Analityczny Opis Systemu. Ten szablon opisuje ekran, pozycję menu, proces użytkownika albo konkretna funkcje biznesowa aplikacji tak, aby analityk mógł kontrolować zgodność z wymaganiami, tester mógł przygotować testy, a developer lub agent AI mógł szybko dojść od UI do kodu i bazy danych.

## Cel AOS

Dobry AOS nie opisuje tylko "co widać na ekranie". Ma pokazać pełny łańcuch faktów:

`ekran -> pole/przycisk -> akcja -> frontend -> API -> proces -> walidacje -> encja/model -> tabela SQL -> kolumna SQL -> odczyt/zapis danych -> testy -> kod`

Każda informacja techniczna powinna mieć źródło w kodzie albo oznaczony status: `potwierdzone`, `do potwierdzenia`, `brak w kodzie`, `wniosek z analizy`.

## Rekomendowana struktura dla jednego ekranu/funkcji

Twórz folder per ekran albo per logiczna pozycja menu:

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

Dla prostego ekranu można scalić pliki `03-05`, ale nie wolno tracić mapowania UI/API/dane/testy.

## Szablony w tym katalogu

- `AI_AOS_01_SCREEN_OVERVIEW_TEMPLATE.md` - karta ekranu/funkcji i zakres.
- `AI_AOS_02_UI_FIELDS_AND_LAYOUT_TEMPLATE.md` - pola, filtry, kolumny, stany UI, uprawnienia.
- `AI_AOS_03_ACTIONS_AND_PROCESS_TRACE_TEMPLATE.md` - akcje użytkownika i procesy od kliknięcia do skutku.
- `AI_AOS_04_API_AND_CONTRACTS_TEMPLATE.md` - endpointy, DTO, request/response, statusy HTTP.
- `AI_AOS_05_DATA_LINEAGE_TEMPLATE.md` - źródła danych, tabele SQL, kolumny SQL, odczyt/zapis.
- `AI_AOS_06_RULES_VALIDATIONS_ERRORS_TEMPLATE.md` - reguły, walidacje, błędy i komunikaty.
- `AI_AOS_07_TEST_MATRIX_TEMPLATE.md` - testy manualne, API, E2E, automaty i dane testowe.
- `AI_AOS_08_DEV_AI_NAVIGATION_TEMPLATE.md` - ścieżki kodu i instrukcja dla dev/AI.
- `AI_AOS_09_REQUIREMENTS_TRACEABILITY_TEMPLATE.md` - wymagania, kryteria akceptacji i pokrycie.
- `AI_AOS_10_CHANGELOG_REVIEW_GATE_TEMPLATE.md` - historia zmian, review i bramka jakości AOS.

## Identyfikatory śladowania

Każdy istotny element powinien mieć stabilny identyfikator:

- Pole UI: `AOS-<MOD>-<SCREEN>-FLD-001`.
- Akcja: `AOS-<MOD>-<SCREEN>-ACT-001`.
- Regula: `AOS-<MOD>-<SCREEN>-RULE-001`.
- API: `AOS-<MOD>-<SCREEN>-API-001`.
- Dane: `AOS-<MOD>-<SCREEN>-DATA-001`.
- Test: `AOS-<MOD>-<SCREEN>-TC-001`.

Przykład: `AOS-ORD-LIST-ACT-003` dla akcji masowej zmiany statusu na liście zamówień.

## Minimalna definicja gotowości AOS

AOS jest gotowy dopiero gdy:

- wiadomo, dla jakiej roli i procesu biznesowego powstał ekran;
- każde pole UI ma opis źródła danych albo sposobu zapisu;
- każdy przycisk/akcja ma opis procesu i endpointu;
- walidacje i błędy są opisane z dowodem z kodu;
- dane są zmapowane do DTO, encji, tabel SQL i kolumn SQL;
- istnieje macierz testów manualnych, API i automatycznych;
- developer ma podane pliki startowe i ścieżkę dalszej analizy;
- wymagania mają pokrycie w UI, API, danych, regułach i testach;
- dokument przeszedł review analityczne, testowe i techniczne albo ma jawnie opisane luki;
- braki są jawnie oznaczone w sekcji `Otwarte pytania i luki`.

## Zasada aktualizacji

Przy zmianie ekranu aktualizuj dokumenty w tej kolejności:

1. `01_UI_FIELDS_AND_LAYOUT.md` - co widać i co może zrobić użytkownik.
2. `02_ACTIONS_AND_PROCESS_TRACE.md` - co uruchamia akcja.
3. `03_API_AND_CONTRACTS.md` - co zmieniło się w kontrakcie.
4. `04_DATA_LINEAGE.md` - co zmieniło się w odcżycie/zapisię.
5. `05_RULES_VALIDATIONS_ERRORS.md` - co zmieniło się w regułach.
6. `06_TEST_MATRIX.md` - jakie testy trzeba dodać albo poprawić.
7. `08_REQUIREMENTS_TRACEABILITY.md` - czy wymagania nadal mają pokrycie.
8. `09_CHANGELOG_REVIEW_GATE.md` - kto i kiedy potwierdził aktualność.
