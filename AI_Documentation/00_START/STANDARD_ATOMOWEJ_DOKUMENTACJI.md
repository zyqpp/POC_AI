# Standard Atomowej Dokumentacji AOS

Status: `potwierdzone` jako obowiązujący standard kolejnych inkrementów dokumentacji.
Zakres: ekrany frontendu, pola, akcje, błędy, procesy, API, model danych i testy.

## Cel

Dokumentacja ma być rozdrobniona do poziomu pojedynczego elementu UI, operacji i błędu. Pliki zbiorcze mogą istnieć jako indeksy, ale źródłowy opis pola, akcji, błędu lub danych testowych ma mieć osobny dokument z własnym identyfikatorem i linkami do powiązanych dokumentów.

## Typy Identyfikatorów

| Prefix | Znaczenie | Format | Przykład |
|---|---|---|---|
| `E` | ekran, route, widok frontendu | `E-001` | `E-014` dla `/orders/:id/tracking` |
| `P` | pojedyncze pole UI albo wartość prezentowana użytkownikowi | `P-{screen}-{seq}` | `P-014-0001` |
| `A` | pojedyncza akcja UI, przycisk, submit, link, komenda użytkownika | `A-{screen}-{seq}` | `A-014-0001` |
| `ERR` | błąd, walidacja, komunikat, stan pusty albo blokada akcji | `ERR-{screen}-{seq}` | `ERR-014-0001` |
| `TD` | dane testowe wymagane do testu pola albo akcji | `TD-{screen}-{seq}` | `TD-014-0001` |
| `TC` | przypadek testowy | `TC-{screen}-{seq}` | `TC-014-0001` |
| `API` | kontrakt endpointu powiązany z ekranem albo akcją | `API-{screen}-{seq}` | `API-014-0001` |
| `DB` | mapowanie tabeli, kolumny albo relacji | `DB-{screen}-{seq}` | `DB-014-0001` |
| `PROC` | proces end-to-end | `PROC-{screen}` | `PROC-014_ORDERS_ID_TRACKING` |

Numery ekranów `E-001`, `E-002` są nadawane deterministycznie z kolejności aktywnych route'ów Angular w `app.routes.ts`, z pominięciem redirectów i wrapperów bez komponentu.

## Struktura Katalogu Ekranu

```text
AI_Documentation/05_UI_AOS/EKRANY/E-014_ORDERS_ID_TRACKING/
  E-014__README.md
  E-014__LINKI.md
  P-014_POLA/
    P-014__INDEX.md
    P-014-0001__nazwa-pola.md
  A-014_AKCJE/
    A-014__INDEX.md
    A-014-0001__nazwa-akcji.md
  ERR-014_BLEDY/
    ERR-014__INDEX.md
    ERR-014-0001__nazwa-bledu.md
  TD-014_DANE_TESTOWE/
    TD-014__INDEX.md
    TD-014-0001__nazwa-pola.md
  TC-014_TESTY/
    TC-014__INDEX.md
```

Indeksy mogą podsumowywać elementy, ale pełny opis elementu musi być w pliku atomowym.

## Widok Ekranu

Każdy dokument `E-*__README.md` musi mieć sekcję `Widok` przed listą dokumentów atomowych. Widok ma być prostym wireframe narysowanym z kresek w bloku `text`, aby czytelnik mógł szybko zobaczyć układ ekranu bez uruchamiania aplikacji.

Minimalny widok musi pokazywać:

| Element | Wymaganie |
|---|---|
| Sekcje | nagłówek, główny formularz/tabela/lista, panele boczne, modale, stany empty/loading/error |
| Pola | identyfikatory albo czytelne nazwy pól `P-*`, szczególnie pola wymagane i readonly |
| Akcje | przyciski/linki `A-*`, w tym submit, cancel, akcje warunkowe i akcje zależne od roli |
| Warunki | ukryte albo warunkowe elementy, np. `Admin only`, `Dealer only`, `if isEdit` |
| Zakres | widok nie zastępuje opisu pól, ale musi spinać pole z miejscem na ekranie |

Przykład:

```text
+----------------------------------------------------------------------------+
| Nazwa Ekranu                                                    [A-001]     |
+----------------------------------------------------------------------------+
| [sekcja filtrów / formularza]                                             |
| P-001 [___________]   P-002 [___________]                 [A-002]          |
|                                                                            |
| +------------------------------------------------------------------------+ |
| | tabela/lista/karta: P-003, P-004, P-005                                | |
| +------------------------------------------------------------------------+ |
+----------------------------------------------------------------------------+
```

## Minimalny Opis Pola

Każdy dokument `P-*` ma zawierać:

| Obszar | Wymaganie |
|---|---|
| Identyfikacja | ID pola, ekran, route, komponent, źródło HTML/TS |
| Widoczność | role, warunek widoczności, stan loading/empty/error |
| Typ UI | input/select/textarea/display/badge/table column/link |
| Wymagalność | required/optional/readonly/disabled, status potwierdzenia |
| Walidacje | UI validator, backend validator, limity długości, regex, enum |
| Dane | DTO, endpoint, encja, `DbContext`, tabela, kolumna, typ SQL, nullability, R/W |
| Testy | dane poprawne, graniczne, błędne, seed/precondition, powiązane `TC-*` |
| Linki | akcje `A-*`, błędy `ERR-*`, endpointy `API-*`, mapowania `DB-*` |

Jeżeli mapowanie do API albo bazy nie jest jeszcze ustalone, pole musi mieć jawny status `do uzupełnienia` albo `brak w kodzie`, a nie opis zbiorczy.

## Minimalny Opis Akcji

Każdy dokument `A-*` ma zawierać:

| Obszar | Wymaganie |
|---|---|
| Identyfikacja | ID akcji, ekran, element UI, handler, źródło HTML/TS |
| Dostęp | role, guard, warunek disabled/hidden, backend `[Authorize]` |
| Wejście | pola `P-*`, dane formularza, parametry route |
| API | endpoint, metoda, DTO request/response, statusy HTTP |
| Proces | handler frontend, serwis Angular, kontroler, handler/serwis backend, domena |
| Dane | tabele/kolumny R/W albo `brak w kodzie` |
| Błędy | linki do `ERR-*` |
| Testy | linki do `TD-*` i `TC-*` |

## Minimalny Opis Błędu

Każdy dokument `ERR-*` ma zawierać: warunek wystąpienia, powiązane pole albo akcję, komunikat, warstwę, status HTTP jeśli istnieje, obsługę w UI, wpływ na dane, oczekiwany test i link do danych testowych.

## Linkowanie

- Dokument ekranu `E-*` linkuje do indeksów pól, akcji, błędów, danych testowych i testów.
- Pole `P-*` linkuje do akcji `A-*`, które go odczytują albo zapisują.
- Akcja `A-*` linkuje do endpointu `API-*`, procesu `PROC-*`, mapowania `DB-*`, błędów `ERR-*` i przypadków testowych `TC-*`.
- Dokumenty zbiorcze `AOS_*.md` pozostają indeksami lub opisami wysokiego poziomu, ale nie zastępują dokumentów atomowych.

## Kolejność Wypełniania

1. Front: route, komponent, template, widok, pola, akcje, błędy UI, dane testowe frontu.
2. API: endpointy, DTO, role backendu, statusy i walidacje.
3. Dane: encje, DbContext, tabele, kolumny, nullability, relacje.
4. Procesy: ścieżki end-to-end i integracje.
5. Testy: przypadki, dane, braki i priorytety.

Braki API/DB mogą mieć status `do uzupełnienia`, ale nie mogą być opisane ogólnikiem bez jawnego statusu.
