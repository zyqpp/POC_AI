---
name: process-documenter
description: Uzupełnia i tworzy dokumenty PROC-NNN opisujące procesy biznesowe ekranów. Odczytuje ślad z `fakty/AI_AOS_TRACE_FACTS.json`, istniejących plików AOS i kodu źródłowego, po czym uzupełnia wymagane sekcje — Cel, Przepływ (tabela kroków), Błędy (z akcją kompensującą) i Referencje do ekranów. Używaj gdy plik PROC-NNN jest szkieletem lub nie istnieje.
---

# Process Documenter

## Kiedy Uruchamiać

- Gdy plik PROC-NNN brakuje sekcji `## Cel`, `## Przepływ` lub `## Błędy`
- Gdy plik PROC-NNN nie istnieje dla danego procesu biznesowego
- Po zakończeniu dokumentacji ekranów AOS — procesy spinają ekrany w end-to-end

## Workflow

1. Zidentyfikuj plik procesu do uzupełnienia (istniejący szkielet lub nowy).

2. Odczytaj dane kontekstowe:
   - `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/AI_AOS_TRACE_REPORT.md` — macierz UI→API→Handler→DB
   - Powiązane pliki `05_UI_AOS/EKRANY/E-NNN/` (README, pola, akcje)
   - Kod źródłowy: Angular component (`.ts`, `.html`), kontroler .NET, handler MediatR, serwis

3. Uzupełnij lub napisz sekcje PROC-NNN w tej kolejności:

   **## Identyfikacja** (tabela metadanych):
   ```
   | Atrybut | Wartość |
   | Proces | PROC-NNN_NAZWA |
   | Ekran | link do E-NNN |
   | Route | /ścieżka |
   | Role | lista ról |
   | API | link do 04_API |
   | Model danych | link do 03_MODEL_DANYCH |
   ```

   **## Cel** (2–4 zdania):
   - Co robi ten proces z perspektywy użytkownika
   - Jaki jest rezultat biznesowy
   - Jakie dane są zmieniane w bazie
   - Jakie zdarzenia (outbox/events) są emitowane

   **## Przepływ** (tabela kroków):
   ```
   | Krok | Warstwa | Fakt | Status |
   | 1 | Routing | opis | potwierdzone |
   ...
   ```
   Każdy krok musi mieć: warstwę (Routing/UI/API/Backend/DB), opis operacji, status faktu.

   **## Błędy Procesu** (tabela):
   ```
   | ID | Warunek | HTTP | Akcja kompensująca | Status |
   | ERR-NNN-001 | opis błędu | 400 | co system robi | potwierdzone |
   ```
   Dla każdego błędu opisz: warunek wystąpienia, kod HTTP, akcję kompensującą (rollback, komunikat, retry).

   **## Luki** (jeśli istnieją):
   ```
   | ID | Luka | Status |
   | GAP-PROC-NNN-001 | opis | brak w kodzie |
   ```

4. Zapisz plik PROC-NNN z wszystkimi sekcjami. Oznacz fakty statusem: `potwierdzone`, `wniosek z analizy`, `do uzupełnienia`, `brak w kodzie`.

5. Upewnij się że w pliku PROC są linki do: powiązanych E-NNN ekranów, pliku API, pliku modelu danych.

## Reguły

- Fakty muszą być potwierdzone w kodzie lub oznaczone odpowiednim statusem.
- `## Błędy Procesu` musi zawierać akcję kompensującą — nie wystarczy tylko opis błędu.
- Nie modyfikuj kodu produkcyjnego — tylko `AI_Documentation/`.
- Użyj polskich znaków diakrytycznych w treści opisowej.
- Sekcje `## Cel` i `## Błędy Procesu` są OBOWIĄZKOWE dla każdego PROC.

## Artefakt Wyjściowy

- Kompletny plik `AI_Documentation/06_PROCESY/PROC-NNN_NAZWA.md` z sekcjami: Identyfikacja, Cel, Przepływ, Błędy Procesu, Luki
