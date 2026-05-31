---
name: documentation-quality-gate
description: Sprawdza jakość dokumentacji projektowej tworzonej od zera: źródła faktów, brak użycia archiwum jako źródła, polskie znaki, kompletność struktury atomowej E/P/A/ERR/TD/TC, statusy faktów, luki, ryzyka i spójność śladów AOS. Użyj przed commitem dokumentacji lub po większej partii zmian.
---

# Documentation Quality Gate

## Workflow

1. Uruchom `powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\Test-Podejscie2DocumentationQuality.ps1`.
2. Sprawdź `git diff --name-status`, czy zmiany są tylko w `AGENTS.md`, `AI_Documentation/**` i `AI_Agent_scripts/**`.
3. Użyj `rg "_archive|do potwierdzenia|do uzupełnienia|brak w kodzie" AI_Documentation` do szybkiego przeglądu ryzyk.
4. Zweryfikuj, czy każdy ważny fakt ma źródło kodowe lub jawny status.
5. Dla ekranów sprawdź, czy każdy katalog `E-...` ma indeksy `P`, `A`, `ERR`, `TD`, `TC` i linki między nimi.
6. Jeżeli walidator zgłasza błąd, popraw dokumentację albo dopisz świadome ryzyko.

## Reguły

- Aktywna dokumentacja może wspominać archiwum wyłącznie jako artefakt historyczny, nie jako źródło.
- Nie zostawiaj placeholderów roboczych w skillach i dokumentach przekazywanych do commita.
- `do uzupełnienia` jest dopuszczalne w szkielecie, ale musi wskazywać konkretny brak i kolejny obszar analizy.
- Nie usuwaj polskich znaków z dokumentacji opisowej.
- Nie oznaczaj faktu jako `potwierdzone`, jeśli nie został sprawdzony w kodzie, konfiguracji, migracji lub teście.

## Artefakt Wyjściowy

Raport jakości powinien zawierać wynik walidacji, listę błędów, listę świadomych luk i decyzję, czy dokumentacja nadaje się do commita.
