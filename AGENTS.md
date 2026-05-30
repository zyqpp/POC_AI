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
- Luki, ryzyka i niespójności zapisuj w dokumentacji. Nie poprawiaj kodu aplikacji w ramach pracy dokumentacyjnej.

## Dokumentacja Bazy Danych

- Przy analizie ekranów, procesów i API zawsze sprawdzaj `AI_Documentation/AI_DATABASE_STRUCTURE.md`.
- Każdy AOS musi wskazywać tabele uczestniczące w procesie, konkretne kolumny SQL odczytywane i zapisywane oraz relacje między tabelami.
- Jeżeli proces przechodzi przez kilka mikroserwisów, rozpisz dane osobno per baza danych i oznacz, które relacje są fizycznymi FK, a które są tylko logiczne przez identyfikatory `Guid`.
- Skrypty SQL w `scripts/migrations/*.sql` uwzględniaj jako artefakty wdrożeniowe, ale aktualność modelu potwierdzaj w EF `DbContext` i encjach.
- Jeżeli znajdziesz rozbieżność między EF, skryptem SQL i dokumentacją, nie poprawiaj kodu ani migracji. Zapisz rozbieżność jako lukę, ryzyko albo rekomendację.

## Automatyzacja pracy AOS

- Do generowania szkieletu AOS używaj `AI_Agent_scripts/New-AosScaffold.ps1`.
- Do zbierania faktów technicznych, kontraktów, mapowania endpointów, DTO i tabel SQL używaj `AI_Agent_scripts/Export-AosTraceFacts.ps1`.
- Wyniki automatycznych analiz traktuj jako punkt startowy. Każdy ważny wniosek potwierdź w kodzie źródłowym przed wpisaniem go jako fakt w AOS.
- Skrypty PowerShell zawierające polskie znaki zapisuj jako UTF-8 z BOM, bo Windows PowerShell 5.1 inaczej może wygenerować dokumenty z uszkodzonymi znakami.
