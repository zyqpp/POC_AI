# AI Documentation Recommendations

## Cel Struktury Dokumentacji

Dokumentacja powinna służyć czterem grupom: analitykom, testerom manualnym, testerom automatycznym i developerom. Nie powinna powielać kodu linia po linii; ma wskazywać źródła prawdy i proces ustalania faktów.

## Rekomendowane Dokumenty Ogólne

- `AI_BUSINESS_PROCESS_MAP.md`: procesy end-to-end, np. rejestracja dealera, zatwierdzenie dealera, zakup, wysyłka, zwrot, faktura, notyfikacja.
- `AI_SCREEN_CATALOG.md`: lista ekranów, role, komponenty Angular, API używane przez ekran, warunki widoczności akcji.
- `AI_DATABASE_STRUCTURE.md`: katalog baz, schematów, tabel, kolumn, relacji, skryptów SQL i mapowania ekranów/procesów do tabel.
- `AI_VALIDATION_RULES.md`: walidacje z backendu i frontendu, z referencją do validatorów i encji domenowych.
- `AI_TEST_STRATEGY.md`: warstwy testów, dane testowe, smoke/regression, kryteria gotowości.
- `AI_TEST_DATA_CATALOG.md`: konta seed, role, przykładowe produkty, statusy, minimalne dane do testów API/UI.
- `AI_E2E_TRACE_MATRIX.md`: mapowanie ekran -> API -> command/query -> tabele/kolumny SQL -> scenariusze testowe.
- `AI_ERROR_CATALOG.md`: kody błędów `{ code, message, retryable }`, statusy HTTP, kiedy występują.
- `AI_SECURITY_AUTHZ_MATRIX.md`: role, endpointy, guardy frontu, kontrolery backendu, internal API key.
- `AI_OPERATIONS_RUNBOOK.md`: jak lokalnie uruchomić infrastrukturę, serwisy, frontend, migracje i diagnostykę.
- `AI_INTEGRATION_EVENTS.md`: eventy outbox, RabbitMQ, Notification ingest, payloady i konsumenci.

## Dla Analityków

- Procesy biznesowe i decyzje: gdzie dealer przechodzi z Pending do Active, kiedy order wpada w OnHold, kiedy można robić return.
- Macierz funkcjonalności po rolach: Admin, Dealer, Warehouse, Logistics, Agent.
- Reguły walidacji i komunikaty użytkownika.
- Diagram statusów dla orderów, shipmentów, faktur i notyfikacji.
- Mapowanie pól ekranu na konkretne tabele i kolumny SQL, żeby dało się kontrolować zgodność z wymaganiami.

## Dla Testerów Manualnych

- Katalog ekranów z rolami i akcjami.
- Scenariusze happy path i error path dla każdego procesu.
- Dane startowe seedowane przez aplikację.
- Oczekiwane statusy HTTP i komunikaty UI/API.
- Checklista regresji po zmianach w danym module.
- Lista tabel i kolumn, które powinny zmienić się po wykonaniu akcji użytkownika.

## Dla Testerów Automatycznych

- Stabilne selektory UI albo rekomendacja ich dodania, jeśli ich brakuje.
- Dane fixture per rola i per proces.
- Mapowanie endpointów i DTO do testów API.
- Warunki setup/teardown dla baz, Redis, RabbitMQ i Mailpit.
- Oddzielne testy kontraktowe backend DTO vs frontend models.
- Macierz `UI -> API -> handler -> service -> repository -> tabela -> kolumna`, używana do budowania testów E2E i API.

## Dla Developerów

- Przewodnik po warstwach i modułach.
- Macierz zależności: który serwis wolno wywoływać z którego serwisu.
- Standard dodawania nowego endpointu: DTO, validator, command/query, service, repository, controller, frontend API service, model TS, test.
- Standard obsługi błędów i correlation ID.
- Lista miejsc, które zwykle wymagają aktualizacji razem: backend DTO + frontend model + API service + ekran + testy + DbContext/migracja + AOS.

## Kolejność Tworzenia Następnych Dokumentów

1. `AI_SCREEN_CATALOG.md`, bo najbardziej pomoże agentom łączyć UI z API.
2. `AI_SECURITY_AUTHZ_MATRIX.md`, bo role są rozproszone między front guardami, gatewayem i kontrolerami.
3. `AI_E2E_TRACE_MATRIX.md`, bo stanie się źródłem prawdy dla testerów automatycznych i powinna korzystać z `AI_DATABASE_STRUCTURE.md`.
4. `AI_VALIDATION_RULES.md`, bo walidacje są w validatorach i encjach.
5. `AI_INTEGRATION_EVENTS.md`, bo outbox/RabbitMQ wymaga osobnego uporządkowania.
