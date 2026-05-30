# AOS UI Fields And Layout Template

## Cel Pliku

Ten plik opisuje wszystko, co uzytkownik widzi albo moze wprowadzic na ekranie: sekcje, pola, tabele, filtry, sortowania, przyciski, stany i uprawnienia UI.

## Struktura Ekranu

| Sekcja | Opis | Widocznosc | Zrodlo w kodzie |
|---|---|---|---|
| `<naglowek / lista / formularz / panel>` | `<co pokazuje>` | `<role / warunki>` | `<plik component.html/scss/ts>` |

## Pola Widoczne Na Ekranie

| ID pola | Etykieta UI | Typ UI | Widoczne dla rol | Read-only? | Zrodlo danych | Format | Pusty stan | Zrodlo w kodzie |
|---|---|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-FLD-001` | `<label>` | `<input/select/date/badge/text>` | `<role>` | `<tak/nie>` | `<DTO.pole / store / computed>` | `<np. currency/date/status>` | `<co pokazac gdy null>` | `<component/model>` |

## Pola Formularza

| ID pola | Nazwa formularza | Etykieta | Typ | Wymagane | Domyslna wartosc | Walidacja front | Walidacja backend | Zapis do |
|---|---|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-FORM-001` | `<formControlName>` | `<label>` | `<input/select>` | `<tak/nie>` | `<wartosc>` | `<regula>` | `<validator / domain>` | `<DTO -> tabela_sql.kolumna_sql>` |

## Kolumny Tabeli / Listy

| ID kolumny | Naglowek | Pole DTO | Sortowanie | Filtrowanie | Format | Akcje w wierszu | Zrodlo danych |
|---|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-COL-001` | `<header>` | `<DTO.field>` | `<tak/nie>` | `<tak/nie>` | `<format>` | `<akcje>` | `<API / store>` |

## Filtry I Wyszukiwanie

| ID filtra | Nazwa UI | Typ | Parametr API/query | Domyslnie | Dzialanie | Edge cases |
|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-FLT-001` | `<status>` | `<select>` | `<status>` | `<all>` | `<jak filtruje>` | `<brak wynikow, niepoprawna wartosc>` |

## Przyciski I Operacje UI

| ID akcji | Etykieta / ikona | Lokalizacja | Rola | Warunek aktywnosci | Co uruchamia | Dokument procesu |
|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-ACT-001` | `<button>` | `<sekcja>` | `<role>` | `<np. status == Placed>` | `<metoda TS / API>` | `02_ACTIONS_AND_PROCESS_TRACE.md` |

## Stany Ekranu

| Stan | Kiedy wystepuje | Zachowanie UI | Komunikat | Zrodlo |
|---|---|---|---|---|
| Loading | `<kiedy>` | `<spinner/skeleton>` | `<tekst>` | `<store/interceptor/component>` |
| Empty | `<brak danych>` | `<pusty stan>` | `<tekst>` | `<component>` |
| Error | `<blad API>` | `<toast/banner>` | `<tekst/kod>` | `<error interceptor/API>` |
| Unauthorized | `<brak roli>` | `<redirect/403>` | `<tekst>` | `<guard/backend>` |

## Dostepnosc I UX

| Obszar | Wymaganie | Status | Uwagi |
|---|---|---|---|
| Keyboard | `<czy operacje sa dostepne z klawiatury>` | `<OK/luka>` | `<uwagi>` |
| Labeling | `<czy pola maja label>` | `<OK/luka>` | `<uwagi>` |
| Error display | `<czy blad jest przy polu/globalny>` | `<OK/luka>` | `<uwagi>` |
| Responsive | `<desktop/mobile>` | `<OK/luka>` | `<uwagi>` |

## Zrzuty / Referencje Wizualne

- `<sciezka do screenshotu, jezeli istnieje>`
- `<opis wariantu roli/statusu>`
