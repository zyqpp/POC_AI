# Plan Naprawczy Po Audycie Dokumentacji

Data: 2026-06-02
Źródło: `AI_Documentation/99_AUDYT_DOKUMENTACJI/AUDYT_DOKUMENTACJI_2026-06-02.md`
Zakres: dalsze kroki po stabilizacji baseline, tylko dla dokumentacji i narzędzi dokumentacyjnych.

## Stan Wejściowy

Etap stabilizacji został wykonany:

- baseline `2026-06-02` istnieje,
- portal techniczny i użytkownika są uporządkowane,
- helpery nawigacyjne nie prowadzą do archiwum,
- quality gate działa na aktywnej dokumentacji,
- piony referencyjne mają minimalne dokumenty `TC-xxx-*.md`.

Kolejne prace powinny dotyczyć już głównie jakości treści.

## Etap 1 - Ujednolicenie Statusów I Śladu Referencyjnego

| Kolejność | Obszar | Zadanie | Wynik |
|---:|---|---|---|
| 1 | `05_UI_AOS/AOS_CHECKOUT.md`, `AOS_ORDER_DETAIL.md`, `AOS_SHIPMENT_DETAIL.md` | ujednolicić statusy faktów i opisy ryzyk tak, aby nie mieszać statusu dokumentu ze statusem faktu | aktywne AOS-y są spójne i gotowe do automatycznej walidacji |
| 2 | `05_UI_AOS/EKRANY/E-012_*`, `E-015_*`, `E-017_*` | dokończyć README i link graph dla pionów referencyjnych | ekran, AOS, proces, API, model danych i testy tworzą pełny ślad |
| 3 | `08_TESTY/*` | dopiąć macierze testów do nowych dokumentów `TC-xxx-*.md` | testy referencyjne są spięte z ekranami i AOS |

## Etap 2 - Rozszerzenie Wzorca Na Kolejne Ekrany

Priorytet kolejnej fali:

1. `/invoices/:id`
2. `/admin/dealers/:id`
3. `/products/:id`

Dla każdego z tych ekranów należy domknąć:

- README ekranu,
- linki `E-xxx__LINKI.md`,
- powiązanie z AOS, procesem, API, modelem danych, rolami i testami,
- co najmniej jeden realny dokument `TC-xxx-*.md`.

## Etap 3 - Dalsze Wzmocnienie Gate I Warsztatu

| Obszar | Zadanie | Wynik |
|---|---|---|
| `AI_Agent_scripts/Test-Podejscie2DocumentationQuality.ps1` | stopniowo rozszerzać reguły o kolejne wymagania merytoryczne dopiero po ujednoliceniu dokumentów | gate rośnie razem z dojrzałością dokumentacji, bez fałszywych alarmów |
| `AI_Documentation/10_WARSZTAT_AGENTOW/NARZEDZIA.md` | utrzymywać opis ograniczeń trace i generatorów zgodnie z realnym zachowaniem skryptów | agent nie traktuje heurystyk jako źródła prawdy |

## Kryteria Zamknięcia Następnej Fali

- trzy piony referencyjne mają spójne statusy faktów i pełny link graph,
- co najmniej dwa kolejne ekrany biznesowe mają realne `TC-xxx-*.md`,
- quality gate nie zgłasza błędów blokujących dla aktywnej dokumentacji,
- portal techniczny i użytkownika budują się bez warningów dotyczących aktywnych plików objętych bieżącą falą zmian.
