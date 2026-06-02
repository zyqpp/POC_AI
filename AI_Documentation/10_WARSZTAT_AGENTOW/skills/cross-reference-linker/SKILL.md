---
name: cross-reference-linker
description: Uzupełnia powiązania między dokumentami AOS — linki w LINKI.md, sekcję "Kluczowe Pliki Kodu" w README ekranów, referencje E-NNN w plikach PROC, powiązania API/PROC/ROLE/MODEL. Używaj po zakończeniu dokumentacji ekranów i procesów, aby powiązać wszystkie artefakty. Uwaga: mechaniczne odnajdywanie linków wspiera skrypt `Invoke-UpdateDocumentationLinks.ps1` — uruchom go PRZED uruchomieniem tego skilla.
---

# Cross-Reference Linker

## Kiedy Uruchamiać

- Po zakończeniu dokumentowania ekranów i procesów
- Gdy plik LINKI.md ma pozycje `do uzupełnienia` w tabeli Powiązania
- Gdy sekcja `Kluczowe Pliki Kodu` w README ekranu ma `do uzupełnienia`
- Gdy plik PROC-NNN nie ma linków do powiązanych E-NNN ekranów

## Workflow

1. Najpierw uruchom skrypt mechaniczny:
   ```powershell
   powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\Invoke-UpdateDocumentationLinks.ps1
   ```
   Skrypt wypełnia oczywiste linki na podstawie nazw plików i numerów ID.

2. Sprawdź każdy plik `E-NNN__LINKI.md` — pozycje które skrypt oznaczył jako `znaleziono` są dobre; uzupełnij ręcznie te oznaczone `nie znaleziono`.

3. **Uzupełnij "Kluczowe Pliki Kodu"** w każdym `E-NNN__README.md`:
   - Odczytaj `AI_Documentation/10_WARSZTAT_AGENTOW/fakty/AI_AOS_TRACE_REPORT.md`
   - Znajdź wiersz macierzy dla tego ekranu (po route lub nazwie serwisu)
   - Wypełnij: Serwis API frontend, Kontroler .NET, Handler MediatR, Encja domenowa

4. **Uzupełnij powiązania w PROC-NNN**:
   - Sprawdź czy plik PROC zawiera linki do wszystkich E-NNN które dokumentuje
   - Dodaj sekcję `## Referencje` jeśli brak, z linkami do: E-NNN ekrany, 04_API, 03_MODEL_DANYCH, 07_ROLE_I_UPRAWNIENIA

5. **Uzupełnij LINKI.md** — dla każdej pozycji `do uzupełnienia`:
   - `API`: sprawdź `04_API/` — czy istnieje `API_NAZWA.md` pasująca do tej trasy?
   - `Proces`: sprawdź `06_PROCESY/` — czy istnieje `PROC-NNN.md` lub `*_E2E.md` odwołujące się do tego ekranu?
   - `Role`: sprawdź `07_ROLE_I_UPRAWNIENIA/` — czy istnieje `ROLE_NAZWA.md`?
   - `Model danych`: sprawdź `03_MODEL_DANYCH/` — czy istnieje `MODEL_DANYCH_NAZWA.md`?

6. Oznacz uzupełnione linki statusem `potwierdzone`; te których nie znalazłeś — `do uzupełnienia`.

## Reguły

- Nie twórz dokumentów — tylko uzupełniaj linki w istniejących plikach.
- Link do nieistniejącego pliku to błąd — sprawdź że plik naprawdę istnieje.
- Jeśli pasującego dokumentu nie ma — zostaw `do uzupełnienia` z komentarzem dlaczego.
- Skrypt `Invoke-UpdateDocumentationLinks.ps1` robi mechaniczną część; ten skill robi semantyczną.

## Artefakt Wyjściowy

- Zaktualizowane pliki `E-NNN__LINKI.md` z wypełnionymi linkami
- Zaktualizowane `E-NNN__README.md` z wypełnioną sekcją "Kluczowe Pliki Kodu"
- Zaktualizowane pliki `PROC-NNN*.md` z linkami do powiązanych ekranów i artefaktów
