# Instrukcje Dla Agentów

## Język dokumentacji

- Dokumentacja projektowa, analityczna, testowa i techniczna pisana po polsku ma używać poprawnych polskich znaków w UTF-8.
- Nie usuwaj znaków diakrytycznych z tekstu opisowego. Nie pisz `zrodlo`, `sciezka`, `zamowienie`, jeżeli powinno być `źródło`, `ścieżka`, `zamówienie`.
- ASCII jest dopuszczalne w kodzie, nazwach plików, identyfikatorach, komendach, ścieżkach, fragmentach JSON, nazwach API, nazwach tabel/kolumn SQL i przykładach technicznych, jeżeli tak wygląda realne źródło w projekcie.
- Jeżeli dokument miesza opis po polsku z identyfikatorami technicznymi, tłumacz tylko opis. Nie zmieniaj nazw klas, metod, endpointów, tabel, kolumn, enumów ani identyfikatorów AOS.

## Standard AOS

- AOS opisuje konkretny ekran, pozycję menu, proces użytkownika albo funkcję biznesową end-to-end.
- Minimalny ślad faktów to: `ekran -> pole/przycisk -> akcja -> frontend -> API -> proces -> walidacje -> encja/model -> tabela SQL -> kolumna SQL -> odczyt/zapis danych -> testy -> kod`.
- Każda teza techniczna musi mieć źródło w kodzie albo status: `potwierdzone`, `do potwierdzenia`, `brak w kodzie`, `wniosek z analizy`.
- Dla pól widocznych na ekranie zawsze próbuj ustalić konkretną tabelę SQL i kolumnę SQL. Jeżeli pole jest wyliczane albo nie jest zapisywane, zapisz to jawnie.
- Luki, ryzyka i niespójności zapisuj w dokumentacji. Nie poprawiaj kodu aplikacji bez osobnej decyzji użytkownika.

## Automatyzacja pracy AOS

- Do generowania szkieletu AOS używaj `AI_Agent_scripts/New-AosScaffold.ps1`.
- Do zbierania faktów technicznych, kontraktów, mapowania endpointów, DTO i tabel SQL używaj `AI_Agent_scripts/Export-AosTraceFacts.ps1`.
- Wyniki automatycznych analiz traktuj jako punkt startowy. Każdy ważny wniosek potwierdź w kodzie źródłowym przed wpisaniem go jako fakt w AOS.
- Skrypty PowerShell zawierające polskie znaki zapisuj jako UTF-8 z BOM, bo Windows PowerShell 5.1 inaczej może wygenerować dokumenty z uszkodzonymi znakami.
