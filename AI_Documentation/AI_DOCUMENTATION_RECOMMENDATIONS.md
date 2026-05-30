# AI Documentation Recommendations

## Cel struktury dokumentacji

Dokumentacja powinna slużyć czterem grupom: analitykom, testerom manualnym, testerom automatycznym i developerom. Nie powinna powielac kodu linia po linii; ma wskazywac źródła prawdy i proces ustalania faktów.

## Rekomendowane dokumenty ogolne

- `AI_BUSINESS_PROCESS_MAP.md`: procesy end-to-end, np. rejestracja dealera, zatwierdzenie dealera, zakup, wysylka, zwrot, faktura, notyfikacja.
- `AI_SCREEN_CATALOG.md`: lista ekranow, role, komponenty Angular, API używane przez ekran, warunki widocznośći akcji.
- `AI_VALIDATION_RULES.md`: walidacje z backendu i frontendu, z referencja do validatorow i encji domenowych.
- `AI_TEST_STRATEGY.md`: warstwy testów, dane testowe, smoke/regression, kryteria gotowości.
- `AI_TEST_DATA_CATALOG.md`: konta seed, role, przykładowe produkty, statusy, minimalne dane do testów API/UI.
- `AI_E2E_TRACE_MATRIX.md`: mapowanie ekran -> API -> command/query -> tabele -> scenariusze testowe.
- `AI_ERROR_CATALOG.md`: kody błędów `{ code, messąge, retryable }`, statusy HTTP, kiedy wystepuja.
- `AI_SECURITY_AUTHZ_MATRIX.md`: role, endpointy, guardy frontu, kontrolery backendu, internal API key.
- `AI_OPERATIONS_RUNBOOK.md`: jak lokalnie uruchomić infrastrukture, serwisy, frontend, migracje i diagnostyke.
- `AI_INTEGRATION_EVENTS.md`: eventy outbox, RabbitMQ, Notification ingest, payloady i konsumenci.

## Dla analitykow

- Procesy biznesowe i decyzje: gdzie dealer przechodzi z Pending do Active, kiedy order wpada w OnHold, kiedy można robic return.
- Macierz funkcjonalnosci po rolach: Admin, Dealer, Warehouse, Logistics, Agent.
- Reguły walidacji i komunikaty użytkownika.
- Diagram statusów dla orderow, shipmentow, faktur i notyfikacji.

## Dla testerów manualnych

- Katalog ekranow z rolami i akcjami.
- Scenariusze happy path i error path dla każdego procesu.
- Dane startowe seedowane przez aplikacje.
- Oczekiwane statusy HTTP i komunikaty UI/API.
- Checklista regresji po zmianach w danym module.

## Dla testerów automatycznych

- Stabilne selektóry UI albo rekomendacja ich dodania, jesli ich brakuje.
- Dane fixture per rola i per proces.
- Mapowanie endpointów i DTO do testów API.
- Warunki setup/teardown dla baz, Redis, RabbitMQ i Mailpit.
- Oddzielne testy kontraktowe backend DTO vs frontend models.

## Dla developerow

- Przewodnik po warstwach i modulach.
- Macierz zależności: który serwis wolno wywoływać z którego serwisu.
- Standard dodawania nowego endpointu: DTO, validator, command/query, service, repository, controller, frontend API service, model TS, test.
- Standard obslugi błędów i correlation ID.
- Lista miejsc, które zwykle wymagaja aktualizacji razem: backend DTO + frontend model + API service + ekran + testy.

## Kolejność tworzenia następnych dokumentów

1. `AI_SCREEN_CATALOG.md`, bo najbardziej pomoże agentom laczyc UI z API.
2. `AI_SECURITY_AUTHZ_MATRIX.md`, bo role są rozproszone między front guardami, gatewayem i kontrolerami.
3. `AI_E2E_TRACE_MATRIX.md`, bo stanie się źródłem prawdy dla testerów automatycznych.
4. `AI_VALIDATION_RULES.md`, bo walidacje są w validatorach i encjach.
5. `AI_INTEGRATION_EVENTS.md`, bo outbox/RabbitMQ wymaga osobnego uporzadkowania.
