---
name: aos-documentation-from-code
description: Tworzy atomowy Analityczny Opis Systemu na podstawie kodu aplikacji, routingu frontendowego, serwisów API, kontrolerów .NET, DTO, walidatorów, encji, DbContextów, migracji i testów. Użyj, gdy zadanie dotyczy opisu ekranu, menu, procesu użytkownika albo funkcji end-to-end bez korzystania ze starej dokumentacji.
---

# AOS Documentation From Code

## Workflow

1. Zacznij od katalogu ekranu `AI_Documentation/05_UI_AOS/EKRANY/E-...`.
2. Uzupełnij opis ekranu `E-...__README.md` tylko faktami z kodu albo jawnie oznaczonym statusem.
3. Rozpisz każde pole w osobnym `P-...` z wymagalnością, walidacją, źródłem danych i mapowaniem do bazy.
4. Rozpisz każdą akcję w osobnym `A-...` ze śladem UI -> metoda komponentu -> serwis -> API -> proces -> baza.
5. Rozpisz błędy w `ERR-...`, dane testowe w `TD-...` i przypadki testowe w `TC-...`.
6. Dopasuj serwisy frontendu w `supply-chain-frontend/src/app/core/api/**`.
7. Dopasuj endpoint gateway, kontroler backendu, DTO, komendę albo zapytanie MediatR.
8. Ustal encje domenowe, `DbContext`, tabele, kolumny, relacje i odczyt/zapis.
9. Sprawdź testy w `tests/**` oraz `*.spec.ts`.

## Reguły

- Nie używaj `AI_Documentation/_archive/**` jako źródła.
- Nie naprawiaj kodu aplikacji w ramach pracy dokumentacyjnej.
- Agregat `AOS_*.md` nie zastępuje dokumentów atomowych `E/P/A/ERR/TD/TC`.
- Każdy fakt techniczny ma mieć status: `potwierdzone`, `wniosek z analizy`, `do potwierdzenia`, `do uzupełnienia` albo `brak w kodzie`.
- Jeżeli ślad urywa się w kodzie, zapisz lukę zamiast zgadywać.

## Artefakt Wyjściowy

AOS powinien zawierać linkowalny katalog ekranów i procesów, w którym każde pole, akcja i błąd ma własny identyfikator, własny dokument, źródła kodowe, mapowanie danych i wymagania testowe.
