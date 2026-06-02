# Instrukcje Dla Agentów

## Język dokumentacji

- Dokumentacja projektowa, analityczna, testowa i techniczna pisana po polsku ma używać poprawnych polskich znaków w UTF-8.
- Nie usuwaj znaków diakrytycznych z tekstu opisowego. Nie pisz `zrodlo`, `sciezka`, `zamowienie`, jeżeli powinno być `źródło`, `ścieżka`, `zamówienie`.
- ASCII jest dopuszczalne w kodzie, nazwach plików, identyfikatorach, komendach, ścieżkach, fragmentach JSON, nazwach API, nazwach tabel/kolumn SQL i przykładach technicznych, jeżeli tak wygląda realne źródło w projekcie.
- Jeżeli dokument miesza opis po polsku z identyfikatorami technicznymi, tłumacz tylko opis. Nie zmieniaj nazw klas, metod, endpointów, tabel, kolumn, enumów ani identyfikatorów AOS.

## Rola Agenta Dokumentacyjnego

- Agent w tym repozytorium działa jako dokumentalista kodu, nie jako implementator zmian w aplikacji.
- Agent może czytać kod, analizować zależności, uruchamiać skrypty raportujące i aktualizować dokumentację, ale nie może modyfikować kodu aplikacji.
- Zakazane są zmiany w kodzie produkcyjnym, testach, konfiguracji runtime, migracjach, kontraktach API, modelach, komponentach frontendu, kontrolerach, serwisach, handlerach i plikach infrastruktury aplikacyjnej.
- Dozwolone obszary pracy dokumentacyjnej to: `AGENTS.md`, `AI_Documentation/**` oraz skrypty pomocnicze w `AI_Agent_scripts/**`, o ile służą wyłącznie generowaniu lub walidacji dokumentacji.
- Jeżeli agent znajdzie błąd, lukę, niespójność, brak testu albo ryzyko w kodzie, ma to opisać w dokumentacji jako fakt/ryzyko/rekomendację. Nie wolno mu naprawiać tego w kodzie bez osobnego, jednoznacznego polecenia użytkownika, które zmienia tryb pracy z dokumentacyjnego na implementacyjny.
- Jeżeli polecenie użytkownika jest niejednoznaczne, agent ma przyjąć bezpieczne założenie: tylko dokumentacja, żadnych zmian w kodzie aplikacji.

## Standard AOS

- AOS opisuje konkretny ekran, pozycję menu, proces użytkownika albo funkcję biznesową end-to-end.
- Minimalny ślad faktów to: `ekran -> pole/przycisk -> akcja -> frontend -> API -> proces -> walidacje -> encja/model -> baza danych -> schemat -> tabela SQL -> kolumna SQL -> odczyt/zapis danych -> relacje -> testy -> kod`.
- Każda teza techniczna musi mieć źródło w kodzie albo status: `potwierdzone`, `do potwierdzenia`, `brak w kodzie`, `wniosek z analizy`.
- Dla pól widocznych na ekranie zawsze próbuj ustalić konkretną tabelę SQL i kolumnę SQL. Jeżeli pole jest wyliczane albo nie jest zapisywane, zapisz to jawnie.
- Dokumentacja ekranu ma być atomowa: ekran ma katalog `E-001_*`, pojedyncze pola mają pliki `P-001-0001__*.md`, akcje `A-001-0001__*.md`, błędy `ERR-001-0001__*.md`, dane testowe `TD-001-*`, a przypadki testowe `TC-001-*`.
- Nie wystarczy tabela zbiorcza pól. Każde istotne pole widoczne lub edytowalne w UI musi mieć osobny opis: widoczność, wymagalność, walidacje, źródło frontendu, DTO/API, encję, tabelę, kolumnę SQL, R/W, dane testowe i linki do akcji oraz błędów.
- Jeżeli opis pola albo akcji nie ma jeszcze ustalonego API lub mapowania DB, zostaw jawny status `do uzupełnienia` albo `brak w kodzie` w dokumencie atomowym; nie ukrywaj braku w opisie zbiorczym.
- Luki, ryzyka i niespójności zapisuj w dokumentacji. Nie poprawiaj kodu aplikacji w ramach pracy dokumentacyjnej.

## Dokumentacja Bazy Danych

- Przy analizie ekranów, procesów i API zawsze sprawdzaj `AI_Documentation/AI_DATABASE_STRUCTURE.md`.
- Każdy AOS musi wskazywać tabele uczestniczące w procesie, konkretne kolumny SQL odczytywane i zapisywane oraz relacje między tabelami.
- Jeżeli proces przechodzi przez kilka mikroserwisów, rozpisz dane osobno per baza danych i oznacz, które relacje są fizycznymi FK, a które są tylko logiczne przez identyfikatory `Guid`.
- Skrypty SQL w `scripts/migrations/*.sql` uwzględniaj jako artefakty wdrożeniowe, ale aktualność modelu potwierdzaj w EF `DbContext` i encjach.
- Jeżeli znajdziesz rozbieżność między EF, skryptem SQL i dokumentacją, nie poprawiaj kodu ani migracji. Zapisz rozbieżność jako lukę, ryzyko albo rekomendację.

## Automatyzacja pracy AOS

- Do generowania szkieletu AOS używaj `AI_Agent_scripts/New-AosScaffold.ps1`.
- Do generowania zagnieżdżonej struktury ekranów frontendu używaj `AI_Agent_scripts/New-FrontendScreenScaffold.ps1`.
- Do zbierania faktów technicznych, kontraktów, mapowania endpointów, DTO i tabel SQL używaj `AI_Agent_scripts/Export-AosTraceFacts.ps1`.
- Wyniki automatycznych analiz traktuj jako punkt startowy. Każdy ważny wniosek potwierdź w kodzie źródłowym przed wpisaniem go jako fakt w AOS.
- Skrypty PowerShell zawierające polskie znaki zapisuj jako UTF-8 z BOM, bo Windows PowerShell 5.1 inaczej może wygenerować dokumenty z uszkodzonymi znakami.

# Instrukcje dla agentów Codexa — dokumentacja MkDocs

## Cel

Repozytorium zawiera dokumentację Markdown utrzymywaną razem z kodem aplikacji. Dokumentacja ma być prezentowana przez dwa osobne portale MkDocs / Material for MkDocs:

1. dokumentacja techniczna,
2. dokumentacja użytkownika.

## Zasady pracy

- Nie usuwaj istniejących plików dokumentacji bez wyraźnego powodu.
- Nie przenoś dokumentacji bez zgody użytkownika.
- Nie nadpisuj istniejących plików `.md`.
- Zmiany mają być małe, jawne i możliwe do przejrzenia w diffie.
- Wszystkie ścieżki w `nav` muszą być zgodne z realną strukturą katalogów.
- Preferuj dwa pliki konfiguracyjne:
  - `mkdocs-tech.yml`
  - `mkdocs-user.yml`
- Preferuj osobne katalogi build:
  - `site-tech/`
  - `site-user/`
- Do lokalnego podglądu używaj `mkdocs serve`.
- Do publikacji używaj `mkdocs build` i statycznego hostingu.
- Nie wystawiaj `mkdocs serve` jako produkcyjnego serwera www.

## Porty lokalne

- W tym repo domyślnie używaj `127.0.0.1:8100` dla portalu technicznego i `127.0.0.1:8101` dla portalu użytkownika.
- Przed uruchomieniem sprawdzaj zajętość portów. Jeżeli są zajęte, wybierz inną wolną parę (np. `8010/8011`).

## Standard techniczny

- Python dependencies dla dokumentacji trzymaj w `requirements-docs.txt`.
- Wirtualne środowisko lokalne: `.venv`.
- Pliki wygenerowane przez MkDocs ignoruj w `.gitignore`.
- Na start użyj `mkdocs-material==9.*`.
- Użyj języka polskiego w motywie Material.
- Włącz wyszukiwarkę.
- Włącz podstawowe rozszerzenia Markdown:
  - admonition
  - tables
  - toc
  - pymdownx.details
  - pymdownx.superfences

## Portale

Portal techniczny:
- konfiguracja: `mkdocs-tech.yml`
- źródło: `AI_Documentation`
- wynik build: `site-tech/`

Portal użytkownika:
- status: obecnie brak osobnej dokumentacji użytkownika.
- konfiguracja: `mkdocs-user.yml` (nieaktywne)
- źródło: brak (nieaktywne)
- wynik build: `site-user/` (nieaktywne)

## Kryteria akceptacji

- `python -m mkdocs serve -f mkdocs-tech.yml -a 127.0.0.1:8100` uruchamia dokumentację techniczną lokalnie.
- `python -m mkdocs serve -f mkdocs-user.yml -a 127.0.0.1:8101` uruchamia dokumentację użytkownika lokalnie.
- `python -m mkdocs build -f mkdocs-tech.yml` buduje `site-tech/`.
- `python -m mkdocs build -f mkdocs-user.yml` buduje `site-user/`.
- Menu odpowiada realnym plikom Markdown.
- Nie ma błędów brakujących ścieżek w `nav`.
