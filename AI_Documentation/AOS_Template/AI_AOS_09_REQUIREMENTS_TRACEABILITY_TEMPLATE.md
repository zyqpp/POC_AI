# AOS Requirements Traceability Template

## Cel Pliku

Ten plik laczy opis ekranu z wymaganiami biznesowymi, kryteriami akceptacji i testami. Ma pokazac, czy wymaganie jest faktycznie pokryte przez UI, API, logike, dane i testy.

## Zakres Biznesowy

| Obszar | Opis |
|---|---|
| Proces biznesowy | `<np. obsluga zamowienia, przyjecie dostawy, sledzenie przesylki>` |
| Krok procesu | `<konkretny krok, ktory wspiera ekran>` |
| Decyzje uzytkownika | `<jakie decyzje podejmuje uzytkownik na ekranie>` |
| Wynik biznesowy | `<co ma byc prawda po zakonczeniu operacji>` |
| Systemy / moduly zalezne | `<frontend, gateway, service, integracje>` |

## Wymagania Funkcjonalne

| ID wymagania | Opis | Priorytet | Rola | Powiazany scenariusz | Status |
|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-REQ-001` | `<co system ma robic>` | `MUST/SHOULD/COULD` | `<rola>` | `<UC/ACT ID>` | `<potwierdzone/do decyzji/brak w kodzie>` |

## Wymagania Niefunkcjonalne Dla Ekranu

| ID | Obszar | Wymaganie | Jak mierzyc | Zrodlo / test |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-NFR-001` | Performance | `<np. lista laduje sie ponizej X s dla Y rekordow>` | `<metryka>` | `<test/monitoring>` |
| `AOS-<MOD>-<SCREEN>-NFR-002` | Security | `<np. Dealer widzi tylko swoje dane>` | `<test roli>` | `<AUTH/TC>` |
| `AOS-<MOD>-<SCREEN>-NFR-003` | Audit | `<np. zmiana statusu jest odtwarzalna>` | `<tabela/event/log>` | `<DATA/TC>` |

## Kryteria Akceptacji

| ID kryterium | Given | When | Then | Pokryte przez |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-AC-001` | `<stan poczatkowy>` | `<akcja uzytkownika>` | `<oczekiwany wynik>` | `<ACT/RULE/API/DATA/TC IDs>` |

## Macierz Sladowania

| Wymaganie | UI | Akcja/proces | API | Dane | Reguly/walidacje | Testy |
|---|---|---|---|---|---|---|
| `REQ-001` | `<FLD/COL/BTN>` | `<ACT>` | `<API>` | `<DATA>` | `<RULE/VFE/VBE>` | `<TC/E2E/API-TC>` |

## Decyzje Analityczne

| ID decyzji | Decyzja | Uzasadnienie | Wplyw na system | Data / autor |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-DEC-001` | `<decyzja>` | `<dlaczego>` | `<UI/API/dane/testy>` | `<data>` |

## Reguly Interpretacji Dla Testerow

| Sytuacja | Jak interpretowac zgodnosc | Co jest bledem |
|---|---|---|
| `<np. brak danych>` | `<co powinno byc widoczne>` | `<co oznacza niezgodnosc>` |
| `<np. walidacja pola>` | `<czy walidacja front/back musi byc identyczna>` | `<roznica komunikatu / brak blokady>` |

## Luki W Wymaganiach

| ID luki | Opis | Ryzyko | Wlasciciel decyzji | Status |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-GAP-REQ-001` | `<czego nie wiadomo>` | `<wplyw>` | `<analityk/PO/dev>` | `<open/closed>` |
