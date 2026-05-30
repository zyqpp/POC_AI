# AOS Test Matrix Template

## Cel Pliku

Ten plik przeklada AOS na testy: manualne, automaty frontendu, testy API/backend i testy regresji. Każdy test powinien wskazywac wymaganie, akcje, dane i oczekiwany rezultat.

## Zakres Testow

| Obszar | Czy testowac | Uwagi |
|---|---|---|
| UI manual | `<tak/nie>` | `<co klikac>` |
| UI automation | `<tak/nie>` | `<Playwright/Cypress/inne>` |
| API automation | `<tak/nie>` | `<endpointy>` |
| Backend unit/domain | `<tak/nie>` | `<encje/serwisy>` |
| Contract tests | `<tak/nie>` | `<DTO TS vs C#>` |
| Regression | `<tak/nie>` | `<krytyczne scenariusze>` |

## Dane Testowe

| ID danych | Rola | Stan poczatkowy | Jak przygotować | Jak posprzatac |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-DATASET-001` | `<rola>` | `<rekordy/statusy>` | `<seed/API/SQL>` | `<rollback/API>` |

## Scenariusze Manualne

| ID testu | Priorytet | Rola | Warunek poczatkowy | Kroki | Oczekiwany wynik | Powiązane ID |
|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-TC-001` | `P1/P2/P3` | `<rola>` | `<stan>` | `<kroki>` | `<wynik>` | `<UC/ACT/RULE/API>` |

## Automaty UI

| ID testu | Selektor / cel UI | Akcja | Mock/API live | Asercje | Ryzyka stabilnosci |
|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-E2E-001` | `<selector>` | `<klik/wpisz>` | `<mock/live>` | `<co sprawdzić>` | `<brak selektorów/data-testid>` |

## Testy API

| ID testu | Endpoint | Request | Auth | Oczekiwany status | Asercje body | Asercje danych |
|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-API-TC-001` | `<method path>` | `<payload>` | `<rola/token>` | `<status>` | `<body>` | `<DB/event/cache>` |

## Testy Backend / Domenowe

| ID testu | Klasą/metoda | Warunek | Asercja | Typ testu |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-DOM-TC-001` | `<Entity/Service>` | `<input>` | `<expected>` | `<unit/integration>` |

## Testy Regresji Po Zmianie

| Zmiana | Minimalna regresja | Dlaczego |
|---|---|---|
| DTO/API | `<testy API + UI>` | `<kontrakt może peknac>` |
| Regula statusu | `<testy domenowe + E2E>` | `<proces może zmienić wynik>` |
| Pole UI | `<test UI + data lineage>` | `<ryzyko zlego mapowania>` |

## Macierz Pokrycia

| Wymaganie / akcja / reguła | Test manualny | Test UI auto | Test API | Test backend |
|---|---|---|---|---|
| `<ACT/RULE/API ID>` | `<TC>` | `<E2E>` | `<API-TC>` | `<DOM-TC>` |

## Luki Testowe

| Luka | Ryzyko | Rekomendowany test |
|---|---|---|
| `<brak testu>` | `<co może się popsuc>` | `<jaki test dodać>` |
