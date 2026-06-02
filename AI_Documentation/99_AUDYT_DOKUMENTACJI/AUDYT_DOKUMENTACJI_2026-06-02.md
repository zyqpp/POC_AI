# Audyt Dokumentacji - baseline 2026-06-02

Data audytu: 2026-06-02
Poprzedni baseline: `2026-05-31`
Zakres: aktywna dokumentacja i narzędzia dokumentacyjne w `AI_Documentation/**`, `AI_Agent_scripts/**`, `mkdocs-tech.yml`, `mkdocs-user.yml`.

## Executive Summary

Baseline `2026-06-02` został ustabilizowany po audycie. Najważniejsze zmiany wykonane w tej partii:

- portal techniczny ma jawny `nav` i nie wystawia `_archive`, `AOS_Template` ani katalogów template'ów jako treści portalu,
- portal użytkownika został zawężony do aktywnej dokumentacji w `AI_Documentation`, zgodnie ze stanem projektu, w którym osobna dokumentacja użytkownika nie jest utrzymywana,
- helpery `NAV_FILES_BY_FOLDER.md` i `NAV_FOLDER_TREE.md` zostały zregenerowane bez odwołań do archiwum i template'ów,
- błędne linki względne w aktywnych ekranach `E-006` do `E-009` zostały naprawione,
- quality gate analizuje tylko aktywną dokumentację i rozdziela błędy blokujące od ostrzeżeń nawigacyjnych i merytorycznych,
- dla ekranów referencyjnych `/checkout`, `/orders/:id` i `/shipments/:id` dodano realne dokumenty `TC-xxx-*.md`.

W efekcie część dawnych P0 z audytu `2026-05-31` jest już historyczna. Aktywne ryzyka zostały przesunięte z obszaru „braku fundamentu” do obszaru „jakości i kompletności treści”.

## Stan Po Korekcie

| Obszar | Stan | Wniosek |
|---|---|---|
| `AI_Documentation/AI_DATABASE_STRUCTURE.md` | obecny i aktywny | dawny brak aktywnego indeksu bazy jest zamknięty |
| `AI_Documentation/AOS_Template/` | obecny | dawny brak template'u AOS jest zamknięty |
| `mkdocs-tech.yml` | jawny `nav`, `exclude_docs`, brak ekspozycji archiwum | portal techniczny ma czytelny punkt wejścia |
| `mkdocs-user.yml` | źródło ustawione na `AI_Documentation`, portal zawężony do treści użytkowych/AOS | konfiguracja jest zgodna z bieżącym stanem repo |
| `AI_Documentation/NAV_FILES_BY_FOLDER.md` | bez linków do `_archive` | quality gate nie zatrzymuje się już na szumie historycznym |
| `AI_Agent_scripts/Test-Podejscie2DocumentationQuality.ps1` | waliduje aktywne artefakty i rozdziela błędy od ostrzeżeń | bramka jakości jest użyteczna operacyjnie |
| `E-012`, `E-015`, `E-017` | mają realne pliki `TC-xxx-0001__*.md` | piony referencyjne mają minimalny ślad testowy |

## Problemy Aktywne

| Priorytet | Obszar | Problem | Skutek | Następny krok |
|---|---|---|---|---|
| P1 | Treść AOS | część dokumentów nadal używa statusów mieszanych albo opisów pośrednich zamiast czystych statusów faktów | trudniej automatycznie egzekwować spójność standardu | ujednolicić statusy w aktywnych dokumentach referencyjnych |
| P1 | Ekrany atomowe poza pionami referencyjnymi | wiele ekranów nadal pozostaje w statusie `szkielet` albo `do uzupełnienia` | struktura istnieje, ale nie wszystkie ekrany są gotowe do pracy analitycznej end-to-end | rozwijać kolejne ekrany po wzorcu `/checkout`, `/orders/:id`, `/shipments/:id` |
| P2 | Trace tooling | `Export-AosTraceFacts.ps1` pozostaje narzędziem heurystycznym | raport trace jest dobrym punktem startowym, ale nie może być źródłem prawdy | utrzymać ręczną weryfikację w kodzie i dokumentach źródłowych |
| P2 | Portal użytkownika | portal korzysta z tej samej bazy dokumentów co portal techniczny i jest tylko logicznie zawężony przez `nav` i `exclude_docs` | brak osobnej, dedykowanej dokumentacji user-facing | jeśli projekt dojrzeje, wydzielić osobny zestaw treści użytkowych |

## Problemy Historyczne / Zamknięte

| Dawny problem | Status w baseline 2026-06-02 |
|---|---|
| brak aktywnego `AI_DATABASE_STRUCTURE.md` | zamknięty |
| brak aktywnego `AOS_Template/` | zamknięty |
| odwołania helperów nawigacyjnych do `_archive` | zamknięty |
| brak realnych `TC-xxx-*.md` dla ekranów referencyjnych | zamknięty dla `/checkout`, `/orders/:id`, `/shipments/:id` |
| brak jawnego `nav` w portalu technicznym | zamknięty |

## Wnioski

Po tej korekcie dokumentacja ma uporządkowaną warstwę wejścia, nawigacji i bramki jakości. Kolejny etap nie powinien już dotyczyć infrastruktury dokumentacyjnej, tylko domykania treści merytorycznej kolejnych ekranów i procesów.
