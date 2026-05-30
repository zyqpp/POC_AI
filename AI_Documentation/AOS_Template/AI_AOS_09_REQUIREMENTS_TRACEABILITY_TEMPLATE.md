# AOS Requirements Traceability Template

## Cel Pliku

Ten plik laczy opis ekranu z wymaganiami biznesowymi, kryteriami akceptacji i testami. Ma pokazać, czy wymaganie jest faktycznie pokryte przez UI, API, logike, dane i testy.

## Zakres Biznesowy

| Obszar | Opis |
|---|---|
| Proces biznesowy | `<np. obsluga zamówienia, przyjecie dostawy, sledzenie przesylki>` |
| Krok procesu | `<konkretny krok, który wspiera ekran>` |
| Decyzje użytkownika | `<jakie decyzje podejmuje użytkownik na ekranie>` |
| Wynik biznesowy | `<co ma być prawdą po zakończeniu operacji>` |
| Systemy / moduly zależne | `<frontend, gateway, service, integracje>` |

## Wymagania Funkcjonalne

| ID wymagania | Opis | Priorytet | Rola | Powiązany scenariusz | Status |
|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-REQ-001` | `<co system ma robic>` | `MUST/SHOULD/COULD` | `<rola>` | `<UC/ACT ID>` | `<potwierdzone/do decyzji/brak w kodzie>` |

## Wymagania Niefunkcjonalne Dla Ekranu

| ID | Obszar | Wymaganie | Jak mierzyc | Źródło / test |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-NFR-001` | Performance | `<np. lista laduje się ponizej X s dla Y rekordow>` | `<metryka>` | `<test/monitoring>` |
| `AOS-<MOD>-<SCREEN>-NFR-002` | Security | `<np. Dealer widzi tylko swoje dane>` | `<test roli>` | `<AUTH/TC>` |
| `AOS-<MOD>-<SCREEN>-NFR-003` | Audit | `<np. zmiana statusu jest odtwarzalna>` | `<tabela SQL / event / log>` | `<DATA/TC>` |

## Kryteria Akceptacji

| ID kryterium | Given | When | Then | Pokryte przez |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-AC-001` | `<stan poczatkowy>` | `<akcja użytkownika>` | `<oczekiwany wynik>` | `<ACT/RULE/API/DATA/TC IDs>` |

## Macierz Sladowania

| Wymaganie | UI | Akcja/proces | API | Dane | Reguły/walidacje | Testy |
|---|---|---|---|---|---|---|
| `REQ-001` | `<FLD/COL/BTN>` | `<ACT>` | `<API>` | `<DATA>` | `<RULE/VFE/VBE>` | `<TC/E2E/API-TC>` |

## Decyzje Analityczne

| ID decyzji | Decyzja | Uzasądnienie | Wpływ na system | Data / autor |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-DEC-001` | `<decyzja>` | `<dlaczego>` | `<UI/API/dane/testy>` | `<data>` |

## Reguły Interpretacji Dla Testerow

| Sytuacja | Jak interpretowac zgodność | Co jest błędem |
|---|---|---|
| `<np. brak danych>` | `<co powinno być widoczne>` | `<co oznacza niezgodność>` |
| `<np. walidacja pola>` | `<czy walidacja front/back musi być identyczna>` | `<różnica komunikatu / brak blokady>` |

## Luki W Wymaganiach

| ID luki | Opis | Ryzyko | Właściciel decyzji | Status |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-GAP-REQ-001` | `<czego nie wiadomo>` | `<wpływ>` | `<analityk/PO/dev>` | `<open/closed>` |
