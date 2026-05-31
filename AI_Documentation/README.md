# Dokumentacja Projektowa - Podejście 2

## Cel

Ten katalog zawiera dokumentację projektową tworzoną od zera dla aplikacji B2B Supply Chain. Źródłem prawdy jest wyłącznie kod aplikacji, konfiguracja, migracje, testy i skrypty operacyjne znajdujące się poza archiwum.

## Zasada odcięcia starej dokumentacji

Dotychczasowe dokumenty zostały przeniesione do `AI_Documentation/_archive/legacy_before_podejscie_2_2026-05-31/`. Archiwum jest artefaktem historycznym. Nie wolno używać go jako źródła faktów dla aktywnej dokumentacji.

## Aktywna struktura

- `00_START/` - zasady pracy, zakres, źródła prawdy i kolejność dokumentowania.
- `01_SYSTEM/` - mapa systemu, moduły, uruchomienie i zależności.
- `02_ARCHITEKTURA/` - architektura aplikacji, integracje i przepływy techniczne.
- `03_MODEL_DANYCH/` - bazy danych, `DbContext`, encje, tabele i relacje.
- `04_API/` - endpointy, kontrolery, DTO, autoryzacja i błędy.
- `05_UI_AOS/` - ekrany, route'y Angular i Analityczny Opis Systemu.
- `06_PROCESY/` - procesy end-to-end przez frontend, API, domenę i bazę.
- `07_ROLE_I_UPRAWNIENIA/` - role, guardy, autoryzacja backendu i macierz dostępu.
- `08_TESTY/` - testy istniejące, scenariusze akceptacyjne i luki testowe.
- `09_RYZYKA_I_REKOMENDACJE/` - ryzyka, braki, niespójności i rekomendacje.
- `10_WARSZTAT_AGENTOW/` - skille, narzędzia i bramki jakości dla agentów.

## Status faktów

Każda istotna teza techniczna powinna mieć jeden ze statusów:

- `potwierdzone` - potwierdzone w kodzie, konfiguracji, migracji lub testach.
- `wniosek z analizy` - wynika z powiązania kilku źródeł kodowych.
- `do potwierdzenia` - wymaga uruchomienia aplikacji, danych runtime lub decyzji biznesowej.
- `brak w kodzie` - oczekiwany element nie został znaleziony w kodzie.

