# Ryzyka I Rekomendacje

| Ryzyko | Dowód | Skutek | Rekomendacja | Status |
|---|---|---|---|---|
| Push na GitHub wymaga jawnej zgody bezpieczeństwa | próba `git push -u origin HEAD` została zablokowana przez sandbox | gałąź może pozostać lokalna do czasu zgody | uzyskać jednoznaczną zgodę użytkownika na eksport do `https://github.com/zyqpp/POC_AI.git` | potwierdzone |
| Archiwum może zostać przypadkowo użyte jako źródło | stara dokumentacja nadal istnieje w `_archive` | zanieczyszczenie podejścia od zera | walidator jakości blokuje linki do archiwum jako źródła | wniosek z analizy |
| Konfiguracja zawiera wartości dev-only | `appsettings.json` pokazuje lokalne connection stringi i dev internal API key | ryzyko błędnego użycia w produkcji | oznaczać jako POC/dev, nie dokumentować jako bezpieczny wzorzec produkcyjny | potwierdzone |
| Brak pełnych AOS dla wszystkich route'ów na starcie | pierwszy przebieg tworzy mapę, nie pełny opis każdego ekranu | dokumentacja nie jest jeszcze kompletna funkcjonalnie | generować AOS partiami według priorytetu procesu | wniosek z analizy |
| Skrypty ekstrakcji używają analizy statycznej | regex/parsowanie tekstowe nie zastępuje kompilatora ani runtime | możliwe pominięcia atrybutów lub dynamicznych zachowań | traktować JSON z narzędzi jako punkt startowy i potwierdzać ręcznie w kodzie | wniosek z analizy |

