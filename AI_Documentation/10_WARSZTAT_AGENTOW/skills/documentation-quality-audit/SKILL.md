---
name: documentation-quality-audit
description: Przeprowadza kompleksowy audyt pokrycia i jakości dokumentacji: uruchamia skrypt heurystyczny, ocenia sensowność treści (nie tylko obecność struktury), identyfikuje szkielety ekranów, luki w procesach i nieudokumentowane algorytmy, po czym generuje raport do `99_AUDYT_DOKUMENTACJI/`. Używaj przed sprintem dokumentacyjnym, po partii zmian lub jako regularny baseline.
---

# Documentation Quality Audit

## Kiedy Uruchamiać

- Przed zaplanowaniem kolejnego sprintu dokumentacyjnego — aby ustalić priorytety
- Po większej partii zmian w `AI_Documentation/` — aby sprawdzić, czy nowe dokumenty mają realną treść
- Cyklicznie (np. raz na dwa tygodnie) — jako baseline pokrycia
- Gdy quality gate przechodzi, ale dokumentacja może być formalnie poprawna, a merytorycznie pusta

## Workflow

1. Uruchom skrypt audytu:
   ```powershell
   powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\Invoke-DocumentationAudit.ps1
   ```
   Skrypt produkuje:
   - `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/documentation-audit.json` — dane strukturalne
   - `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/DOCUMENTATION_AUDIT_REPORT.md` — raport heurystyczny

2. Przeczytaj sekcję "Podsumowanie Wykonawcze" raportu. Zanotuj obszary z najniższym pokryciem %.

3. **Ocena ekranów (Ekrany):** Dla każdego ekranu oznaczonego `szkielet` wejdź do katalogu `E-NNN` i sprawdź:
   - Czy pliki `P-NNN-NNNN__*.md` mają strukturę: `Opis Pola`, `Widoczność i Warunki`, `Mapowanie Danych` z realnymi wartościami (nie `do uzupełnienia` w każdej komórce)?
   - Czy pliki `A-NNN-NNNN__*.md` mają diagram Mermaid i przykłady JSON żądania/odpowiedzi?
   - Czy istnieją realne pliki `TC-NNN-NNNN__*.md` (nie tylko INDEX) z kolumnami Given/When/Then?
   - Czy sekcja `Kluczowe Pliki Kodu` w README ma wypełnione kontrolery, handlery, encje?

4. **Ocena procesów (Procesy):** Dla każdego PROC/E2E z lukami oceń:
   - Czy brak sekcji wynika z trywialności procesu, czy z pominięcia?
   - Czy opisano co najmniej jedną ścieżkę błędu i akcję kompensującą?
   - Czy PROC zawiera referencje do ekranów (`E-NNN`) i endpointów API?

5. **Ocena algorytmów (Algorytmy):** Dla każdego nieudokumentowanego handlera MediatR:
   - Czy handler jest objęty istniejącym PROC lub plikiem E2E? Jeśli tak — wystarczy wzmianka.
   - Czy opisane są reguły biznesowe (warunki, limity, side-effecty), a nie tylko sam fakt wywołania?
   - Sprawdź walidatory (`AbstractValidator`): czy reguły walidacji są wpisane do dokumentacji pól `P-NNN`?

6. Sporządź raport jakościowy i zapisz jako:
   `AI_Documentation/99_AUDYT_DOKUMENTACJI/AUDYT_DOKUMENTACJI_YYYY-MM-DD.md`
   Format musi być spójny z istniejącymi raportami audytowymi (sekcje: Executive Summary, Stan Po Korekcie, Problemy Aktywne P0/P1/P2, Problemy Historyczne, Wnioski).

## Jak Oceniać Jakość Treści (Nie Tylko Obecność)

**Pola (P-NNN)** są merytorycznie kompletne gdy:
- `Kolumna SQL` i `DTO/kontrakt` zawierają realne nazwy (nie `do uzupełnienia`)
- `Opis Pola` ma wypełnione: co wyświetla, źródło danych, kiedy widoczne
- Status faktu to `potwierdzone` lub `wniosek z analizy`

**Akcje (A-NNN)** są kompletne gdy:
- Diagram Mermaid ma uzupełnione rzeczywiste nazwy metod, endpointów i handlerów
- Przykład żądania HTTP zawiera realny endpoint i choćby szkielet payloadu
- Co najmniej trzy warstwy śladu technicznego mają wartość inną niż `do uzupełnienia`

**Procesy (PROC/E2E)** są kompletne gdy opisują ścieżkę błędu, akcję kompensującą i zawierają referencje do ekranów i API.

**Algorytmy (handlery MediatR)** są udokumentowane gdy ich nazwa lub nazwa żądania pojawia się w pliku PROC lub A-NNN z opisem reguł biznesowych.

## Reguły

- Nie oznaczaj dokumentu jako kompletny na podstawie samej struktury — sprawdź treść.
- `do uzupełnienia` we wszystkich komórkach tabeli = szkielet, nawet jeśli plik istnieje.
- Handlery bez wzmianki w dokumentacji procesowej są luką analityczną, nie tylko dokumentacyjną.
- Raport audytowy w `99_AUDYT_DOKUMENTACJI/` zawsze ma status `wniosek z analizy` — nie `potwierdzone`.
- Skrypt daje snapshot heurystyczny; ocena AI daje warstwę jakości. Obie są potrzebne.
- Nie modyfikuj kodu produkcyjnego, testów, migracji ani kontraktów API — tylko dokumentacja.

## Artefakt Wyjściowy

- `fakty/DOCUMENTATION_AUDIT_REPORT.md` — automatyczny raport heurystyczny (ze skryptu)
- `99_AUDYT_DOKUMENTACJI/AUDYT_DOKUMENTACJI_YYYY-MM-DD.md` — raport jakościowy AI z executive summary, listą P0/P1/P2 i decyzją, czy dokumentacja jest gotowa do kolejnego sprintu
