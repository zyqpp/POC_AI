---
name: aos-documentation-from-code
description: Tworzy Analityczny Opis Systemu na podstawie kodu aplikacji, routingu frontendowego, serwisów API, kontrolerów .NET, DTO, walidatorów, encji, DbContextów, migracji i testów. Użyj, gdy zadanie dotyczy opisu ekranu, menu, procesu użytkownika albo funkcji end-to-end bez korzystania ze starej dokumentacji.
---

# AOS Documentation From Code

## Workflow

1. Zacznij od route'u lub procesu biznesowego i ustal komponent Angular, guardy oraz role.
2. Przejdź do serwisów frontendu w `supply-chain-frontend/src/app/core/api/**`.
3. Dopasuj endpoint gateway i kontroler backendu.
4. Ustal komendę/zapytanie MediatR, usługę aplikacyjną, walidator i DTO.
5. Ustal encje domenowe, `DbContext`, tabele, kolumny i relacje.
6. Sprawdź testy w `tests/**` oraz `*.spec.ts`.
7. Zapisz status każdego faktu: `potwierdzone`, `wniosek z analizy`, `do potwierdzenia` albo `brak w kodzie`.

## Reguły

- Nie używaj `AI_Documentation/_archive/**` jako źródła.
- Nie naprawiaj kodu aplikacji w ramach pracy dokumentacyjnej.
- Dla każdego pola lub akcji UI próbuj wskazać konkretny endpoint, DTO, encję i tabelę.
- Jeżeli ślad urywa się w kodzie, zapisz lukę zamiast zgadywać.

## Artefakt Wyjściowy

AOS powinien zawierać: cel biznesowy, role, route, komponenty, pola, akcje, API, walidacje, model danych, odczyty/zapisy, testy, ryzyka i źródła kodowe.

