# AOS Changelog Review Gate Template

## Cel Pliku

Ten plik kontroluje życie dokumentu AOS: kto go zmieniał, co zostało zweryfikowane z kodem, jakie role go zaakceptowały i czy dokument może być traktowany jako źródło prawdy.

## Status Dokumentu

| Pole | Wartość |
|---|---|
| AOS ID | `AOS-<MOD>-<SCREEN>` |
| Aktualny status | `draft / in-review / approved / stale / archived` |
| Ostatni commit kodu sprawdźony przez dokument | `<commit SHA>` |
| Ostatnia data weryfikacji | `<YYYY-MM-DD>` |
| Właściciel analityczny | `<osoba/rola>` |
| Właściciel techniczny | `<osoba/rola>` |
| Właściciel testów | `<osoba/rola>` |

## Historia Zmian

| Data | Autor | Zmiana | Powod | Powiązane pliki / commit |
|---|---|---|---|---|
| `<YYYY-MM-DD>` | `<autor>` | `<co zmieniono>` | `<dlaczego>` | `<plik/commit/PR>` |

## Review Analityczne

| Pytanie kontrolne | Status | Dowod / uwagi |
|---|---|---|
| Czy cel biznesowy ekranu jest jasny? | `<OK/luka>` | `<uwagi>` |
| Czy role i ograniczenia danych są opisane? | `<OK/luka>` | `<uwagi>` |
| Czy wymagania mają kryteria akceptacji? | `<OK/luka>` | `<REQ/AC>` |
| Czy opis procesu zgadza się z oczekiwaniem biznesu? | `<OK/luka>` | `<ACT/DEC>` |

## Review Testowe

| Pytanie kontrolne | Status | Dowod / uwagi |
|---|---|---|
| Czy każda akcja ma test albo jawną lukę testową? | `<OK/luka>` | `<TC IDs>` |
| Czy są dane testowe dla scenariuszy pozytywnych i negatywnych? | `<OK/luka>` | `<DATASET>` |
| Czy opis błędów pozwala testowac komunikaty UI i statusy API? | `<OK/luka>` | `<ERR/API>` |
| Czy automaty UI mają stabilne selektóry albo wskazane braki? | `<OK/luka>` | `<E2E/luka>` |

## Review Techniczne

| Pytanie kontrolne | Status | Dowod / uwagi |
|---|---|---|
| Czy każde twierdzenie techniczne ma źródło w kodzie? | `<OK/luka>` | `<pliki>` |
| Czy endpointy i DTO zgadzaja się z implementacja? | `<OK/luka>` | `<API/DTO>` |
| Czy mapowanie danych wskazuje encje, tabele SQL i kolumny SQL? | `<OK/luka>` | `<DATA>` |
| Czy opis reguły wskazuje warstwe, która ja egzekwuje? | `<OK/luka>` | `<RULE>` |
| Czy opis uwzglednia efekty uboczne, eventy i integracje? | `<OK/luka>` | `<ACT>` |

## Bramka Jakosci AOS

AOS można oznaczyc jako `approved`, jeżeli:

- wszystkie główne akcje są opisane od UI do danych;
- każde wymaganie `MUST` ma kryterium akceptacji i test;
- endpointy, DTO, reguły i dane mają źródło w kodzie;
- luki są jawnie opisane, mają właściciela i status;
- analityk, tester i developer rozumieja, co jest źródłem prawdy.

## Otwarte Ryzyka Dokumentacyjne

| ID | Ryzyko | Objaw | Wpływ | Decyzja |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-DOC-RISK-001` | `<ryzyko>` | `<po czym poznac>` | `<wpływ>` | `<co zrobić>` |
