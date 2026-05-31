# Checklista Jakości AOS

Status: `potwierdzone` jako standard pracy dokumentacyjnej.
Źródła: `AGENTS.md`, audyt `99_AUDYT_DOKUMENTACJI`, kod aplikacji, skrypty w `AI_Agent_scripts`.

## Minimalny Ślad

Każdy AOS musi zawierać ślad:

`ekran -> pole/przycisk -> akcja -> frontend -> API -> proces -> walidacje -> encja/model -> baza danych -> schemat -> tabela SQL -> kolumna SQL -> odczyt/zapis danych -> relacje -> testy -> kod`

## Status Faktów

| Status | Kiedy używać |
|---|---|
| `potwierdzone` | Fakt został sprawdzony w kodzie, konfiguracji, migracji, testach albo aktywnym skrypcie. |
| `wniosek z analizy` | Fakt wynika z połączenia kilku źródeł, ale nie jest literalnie zapisany w jednym miejscu. |
| `do potwierdzenia` | Wymaga uruchomienia aplikacji, danych runtime albo decyzji biznesowej. |
| `brak w kodzie` | Oczekiwany element nie został znaleziony w kodzie. |

## Bramka Dla Ekranu

| Obszar | Wymaganie | Bramka |
|---|---|---|
| UI | route, komponent, template, pola, przyciski, role i guardy | każdy element ma plik i linię źródłową |
| API | serwis Angular, endpoint gateway, kontroler, akcja, role, DTO, statusy HTTP | endpoint jest opisany per metoda, nie zbiorczo per kontroler |
| Proces | happy path, błędy, kompensacje, integracje, outbox/saga jeśli występują | proces zawiera ślad do kodu aplikacyjnego |
| Dane | encja, DbContext, tabela, kolumna, typ lub ograniczenie EF, R/W | każde pole krytyczne ma tabelę i kolumnę albo jawny status `brak w kodzie` |
| Role | frontend guard, backend `[Authorize]`, check runtime, internal API | role użytkowników są rozdzielone od ról technicznych i nagłówków |
| Testy | test istniejący, brakujący test, typ testu, priorytet | luka testowa ma wpływ i kryterium zamknięcia |
| Ryzyka | rozjazdy UI/backend, transakcyjność, dane niepersistowane, brak testów | każde ryzyko ma status i dowód |

## Bramka Atomowa

| Element | Wymaganie | Bramka |
|---|---|---|
| Ekran | ma identyfikator `E-001`, katalog `05_UI_AOS/EKRANY/E-001_*` i plik `E-001__README.md` | route, komponent, role i linki są w jednym miejscu |
| Pole | ma osobny plik `P-{screen}-{seq}__*.md` | opisuje wymagalność, widoczność, walidacje, mapowanie DTO/API/DB albo jawny status braku |
| Akcja | ma osobny plik `A-{screen}-{seq}__*.md` | opisuje handler, role, wejście, API, proces, dane, błędy i testy |
| Błąd | ma osobny plik `ERR-{screen}-{seq}__*.md` | opisuje warunek, komunikat, warstwę, status HTTP lub brak API oraz test |
| Dane testowe | mają osobny indeks `TD-{screen}__INDEX.md` i docelowe rekordy `TD-{screen}-{seq}` | wskazują preconditions, poprawne, graniczne i błędne wartości |
| Test | ma indeks `TC-{screen}__INDEX.md` i docelowe przypadki `TC-{screen}-{seq}` | każdy test linkuje do pola, akcji albo błędu |

## Zakaz Źródeł

`AI_Documentation/_archive/**` może być wspomniane tylko jako archiwum historyczne. Nie wolno używać go jako źródła faktów dla aktywnej dokumentacji.

## Wymagany Wynik AOS

Gotowy AOS ma zawierać sekcje:

1. Cel biznesowy i zakres.
2. Role i dostęp.
3. UI: route, komponent, pola, przyciski, stany.
4. Ślad end-to-end.
5. API i kontrakty.
6. Walidacje i błędy.
7. Model danych z tabelami i kolumnami.
8. Relacje fizyczne i logiczne.
9. Testy i luki.
10. Ryzyka i rekomendacje.
