# AI Documentation Recommendations

## Cel struktury dokumentacji

Dokumentacja powinna sluzyc czterem grupom: analitykom, testerom manualnym, testerom automatycznym i developerom. Nie powinna powielac kodu linia po linii; ma wskazywac zrodla prawdy i proces ustalania faktow.

## Rekomendowane dokumenty ogolne

- `AI_BUSINESS_PROCESS_MAP.md`: procesy end-to-end, np. rejestracja dealera, zatwierdzenie dealera, zakup, wysylka, zwrot, faktura, notyfikacja.
- `AI_SCREEN_CATALOG.md`: lista ekranow, role, komponenty Angular, API uzywane przez ekran, warunki widocznosci akcji.
- `AI_VALIDATION_RULES.md`: walidacje z backendu i frontendu, z referencja do validatorow i encji domenowych.
- `AI_TEST_STRATEGY.md`: warstwy testow, dane testowe, smoke/regression, kryteria gotowosci.
- `AI_TEST_DATA_CATALOG.md`: konta seed, role, przykladowe produkty, statusy, minimalne dane do testow API/UI.
- `AI_E2E_TRACE_MATRIX.md`: mapowanie ekran -> API -> command/query -> tabele -> scenariusze testowe.
- `AI_ERROR_CATALOG.md`: kody bledow `{ code, message, retryable }`, statusy HTTP, kiedy wystepuja.
- `AI_SECURITY_AUTHZ_MATRIX.md`: role, endpointy, guardy frontu, kontrolery backendu, internal API key.
- `AI_OPERATIONS_RUNBOOK.md`: jak lokalnie uruchomic infrastrukture, serwisy, frontend, migracje i diagnostyke.
- `AI_INTEGRATION_EVENTS.md`: eventy outbox, RabbitMQ, Notification ingest, payloady i konsumenci.

## Dla analitykow

- Procesy biznesowe i decyzje: gdzie dealer przechodzi z Pending do Active, kiedy order wpada w OnHold, kiedy mozna robic return.
- Macierz funkcjonalnosci po rolach: Admin, Dealer, Warehouse, Logistics, Agent.
- Reguly walidacji i komunikaty uzytkownika.
- Diagram statusow dla orderow, shipmentow, faktur i notyfikacji.

## Dla testerow manualnych

- Katalog ekranow z rolami i akcjami.
- Scenariusze happy path i error path dla kazdego procesu.
- Dane startowe seedowane przez aplikacje.
- Oczekiwane statusy HTTP i komunikaty UI/API.
- Checklista regresji po zmianach w danym module.

## Dla testerow automatycznych

- Stabilne selektory UI albo rekomendacja ich dodania, jesli ich brakuje.
- Dane fixture per rola i per proces.
- Mapowanie endpointow i DTO do testow API.
- Warunki setup/teardown dla baz, Redis, RabbitMQ i Mailpit.
- Oddzielne testy kontraktowe backend DTO vs frontend models.

## Dla developerow

- Przewodnik po warstwach i modulach.
- Macierz zaleznosci: ktory serwis wolno wywolywac z ktorego serwisu.
- Standard dodawania nowego endpointu: DTO, validator, command/query, service, repository, controller, frontend API service, model TS, test.
- Standard obslugi bledow i correlation ID.
- Lista miejsc, ktore zwykle wymagaja aktualizacji razem: backend DTO + frontend model + API service + ekran + testy.

## Kolejnosc tworzenia nastepnych dokumentow

1. `AI_SCREEN_CATALOG.md`, bo najbardziej pomoze agentom laczyc UI z API.
2. `AI_SECURITY_AUTHZ_MATRIX.md`, bo role sa rozproszone miedzy front guardami, gatewayem i kontrolerami.
3. `AI_E2E_TRACE_MATRIX.md`, bo stanie sie zrodlem prawdy dla testerow automatycznych.
4. `AI_VALIDATION_RULES.md`, bo walidacje sa w validatorach i encjach.
5. `AI_INTEGRATION_EVENTS.md`, bo outbox/RabbitMQ wymaga osobnego uporzadkowania.
