# AOS Changelog Review Gate Template

## Cel Pliku

Ten plik kontroluje zycie dokumentu AOS: kto go zmienial, co zostalo zweryfikowane z kodem, jakie role go zaakceptowaly i czy dokument moze byc traktowany jako zrodlo prawdy.

## Status Dokumentu

| Pole | Wartosc |
|---|---|
| AOS ID | `AOS-<MOD>-<SCREEN>` |
| Aktualny status | `draft / in-review / approved / stale / archived` |
| Ostatni commit kodu sprawdzony przez dokument | `<commit SHA>` |
| Ostatnia data weryfikacji | `<YYYY-MM-DD>` |
| Wlasciciel analityczny | `<osoba/rola>` |
| Wlasciciel techniczny | `<osoba/rola>` |
| Wlasciciel testow | `<osoba/rola>` |

## Historia Zmian

| Data | Autor | Zmiana | Powod | Powiazane pliki / commit |
|---|---|---|---|---|
| `<YYYY-MM-DD>` | `<autor>` | `<co zmieniono>` | `<dlaczego>` | `<plik/commit/PR>` |

## Review Analityczne

| Pytanie kontrolne | Status | Dowod / uwagi |
|---|---|---|
| Czy cel biznesowy ekranu jest jasny? | `<OK/luka>` | `<uwagi>` |
| Czy role i ograniczenia danych sa opisane? | `<OK/luka>` | `<uwagi>` |
| Czy wymagania maja kryteria akceptacji? | `<OK/luka>` | `<REQ/AC>` |
| Czy opis procesu zgadza sie z oczekiwaniem biznesu? | `<OK/luka>` | `<ACT/DEC>` |

## Review Testowe

| Pytanie kontrolne | Status | Dowod / uwagi |
|---|---|---|
| Czy kazda akcja ma test albo jawna luke testowa? | `<OK/luka>` | `<TC IDs>` |
| Czy sa dane testowe dla scenariuszy pozytywnych i negatywnych? | `<OK/luka>` | `<DATASET>` |
| Czy opis bledow pozwala testowac komunikaty UI i statusy API? | `<OK/luka>` | `<ERR/API>` |
| Czy automaty UI maja stabilne selektory albo wskazane braki? | `<OK/luka>` | `<E2E/luka>` |

## Review Techniczne

| Pytanie kontrolne | Status | Dowod / uwagi |
|---|---|---|
| Czy kazde twierdzenie techniczne ma zrodlo w kodzie? | `<OK/luka>` | `<pliki>` |
| Czy endpointy i DTO zgadzaja sie z implementacja? | `<OK/luka>` | `<API/DTO>` |
| Czy mapowanie danych wskazuje encje, tabele SQL i kolumny SQL? | `<OK/luka>` | `<DATA>` |
| Czy opis reguly wskazuje warstwe, ktora ja egzekwuje? | `<OK/luka>` | `<RULE>` |
| Czy opis uwzglednia efekty uboczne, eventy i integracje? | `<OK/luka>` | `<ACT>` |

## Bramka Jakosci AOS

AOS mozna oznaczyc jako `approved`, jezeli:

- wszystkie glowne akcje sa opisane od UI do danych;
- kazde wymaganie `MUST` ma kryterium akceptacji i test;
- endpointy, DTO, reguly i dane maja zrodlo w kodzie;
- luki sa jawnie opisane, maja wlasciciela i status;
- analityk, tester i developer rozumieja, co jest zrodlem prawdy.

## Otwarte Ryzyka Dokumentacyjne

| ID | Ryzyko | Objaw | Wplyw | Decyzja |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-DOC-RISK-001` | `<ryzyko>` | `<po czym poznac>` | `<wplyw>` | `<co zrobic>` |
