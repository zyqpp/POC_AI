# AI Code Navigation Guide

## Cel

Ten plik jest instrukcja dla przyszlych agentow AI: jak ustalac fakty w projekcie bez zgadywania i jak przejść od ekranu/przycisku do backendu, logiki biznesowej oraz bazy danych.

## Granica Pracy Agenta

- Agent używa tego przewodnika do dokumentowania aplikacji, nie do zmieniania aplikacji.
- Kod w `supply-chain-frontend/**`, `services/**`, `src/**`, `gateway/**`, testy, migracje i konfiguracje runtime traktuj jako źródła prawdy do odczytu.
- Nie edytuj kodu aplikacji, nawet jeżeli znajdziesz błąd albo brak testu. Zapisz odkrycie w AOS jako lukę, ryzyko, pytanie otwarte albo rekomendację.
- Dozwolone zmiany dotyczą tylko dokumentacji i narzędzi dokumentacyjnych: `AI_Documentation/**`, `AI_Agent_scripts/**`, `AGENTS.md`.
- Jeżeli użytkownik nie poda wprost, że przełącza zadanie na implementację, pozostajesz w trybie dokumentalisty.

## Zasada źródeł prawdy

- Nie ufaj nazwie ekranu jako jedynemu źródłu. Zawsze potwierdzaj ścieżkę w kodzie.
- Frontend: zaczynaj od `supply-chain-frontend/src/app/app.routes.ts`.
- API frontendowe: potem sprawdź `supply-chain-frontend/src/app/core/api/*.service.ts`.
- Kontrakty frontu: sprawdź `supply-chain-frontend/src/app/core/models/*.ts`.
- Gateway: sprawdź `gateway/OcelotGateway/ocelot.json`.
- Backend: kontroler `services/<Service>/<Service>.API/Controllers/*Controller.cs`.
- Use case: komenda/zapytanie w `Application/Features`.
- Logika: serwis aplikacyjny w `Application/Services`.
- Reguły domenowe: encje w `Domain/Entities` i enumy w `Domain/Enums`.
- Persistence: repozytorium i DbContext w `Infrastructure`.
- Integracje między serwisąmi: `Infrastructure/Integrations`, outbox dispatcher i RabbitMQ consumers.

## Ścieżka analizy ekranu

1. Znajdz route w `app.routes.ts`, np. `/orders/:id`.
2. Otwórz komponent z `features/.../*.component.ts`.
3. W komponencie znajdź wstrzykniete store/services/API.
4. Otwórz metodę API w `core/api/*-api.service.ts`.
5. Zanotuj HTTP method, URL i typy request/response.
6. Przejdz przez Ocelot: dopasuj prefiks `/orders`, `/catalog`, itd. do downstream service.
7. Otwórz kontroler backendowy i metodę z takim route.
8. Zanotuj `[Authorize]`, role, warunki scope, statusy odpowiedzi.
9. Przejdz z kontrolera do `sender.Send(new ...Command/Query)`.
10. Otwórz handler w `Application/Features`.
11. Handler zwykle deleguje do serwisu aplikacyjnego; otwórz `Application/Services`.
12. Jeśli metoda dotyka danych, przejdź do repozytorium i DbContextu.
13. Jeśli metoda zmienia reguły domenowe, sprawdź metodę encji domenowej.
14. Jeśli jest integracja między serwisąmi, sprawdź gateway HTTP i endpoint internal w drugim serwisie.

## Przykład: utworzenie zamówienia

- Frontend: `OrderApiService.createOrder` wysyła `POST /orders/api/orders`.
- Gateway: prefiks `/orders` trafia do Order API.
- Backend: `OrdersController.Create` wymaga roli `Dealer`, pobiera user id z JWT i wysyła `CreateOrderCommand`.
- Application: `CreateOrderCommandHandler` deleguje do `OrderService.CreateOrderAsync`.
- Logika: `OrderService` waliduje request, tworzy `OrderAggregate`, dodaje linie, soft-lockuje stock przez `CatalogInventoryGateway`, sprawdza kredyt przez `PaymentCreditCheckGateway`.
- Persistence: zapis przez `OrderRepository` i `OrderDbContext`.
- Efekty uboczne: outbox event `OrderPlaced` albo `AdminApprovalRequired`, aktualizacja outstanding w PaymentInvoice, start `OrderSagaCoordinator`.
- Baza: tabele `Orders`, `OrderLines`, `OrderStatusHistory`, `OrderSagaStates`, `OutboxMessages`.

## Przykład: status przesylki z ekranu

- Route: `shipments/:id` -> `ShipmentDetailComponent`.
- API frontu: `LogisticsApiService.updateStatus` -> `PUT /logistics/api/logistics/shipments/{id}/status`.
- Kontroler: `ShipmentsController.UpdateStatus`.
- Role: Admin/Logistics/Agent; Agent musi być przypisany i mieć zaakceptowane assignment.
- Handler: `UpdateShipmentStatusCommand`.
- Logika: `LogisticsService` i encja `Shipment.UpdateStatus`.
- Persistence: `LogisticsTrackingDbContext` zapisuje `Shipments` i `ShipmentEvents`.

## Jak ustalic API i DTO

- Najszybciej uruchom `AI_Agent_scripts/Collect-CodeFacts.ps1`.
- Dla szczegolow payloadu otwieraj pliki `Application/DTOs/*Dtos.cs`.
- Porownaj z `core/models/*.ts`; jesli pola się różnią, traktuj backend jako źródło prawdy, a frontend jako potencjalnie wymagajacy poprawki.

## Jak ustalic walidacje

- Backend: `Application/Validation/*Validators.cs`.
- Dodatkowe reguły są w encjach domenowych, np. `Product`, `OrderAggregate`, `Shipment`.
- Frontend może mieć walidacje formularzy w komponentach, ale nie jest źródłem prawdy dla bezpieczenstwa.

## Jak ustalic dane bazy

- Zacznij od DbContextu.
- Potem sprawdź encje domenowe, bo część pól jest computed albo ignorowana w EF (`AvailableStock`, `LineTotal`, `AvailableCredit`).
- Jeśli trzeba potwierdzić fizyczna migracje, sprawdź ostatni plik w `Infrastructure/Persistence/Migrations`.

## Jak nie zgubic się w projekcie

- Nie analizuj `node_modules`, `bin`, `obj`, `.vs`, `artifacts`, chyba ze problem bezpośrednio dotyczy zależności/build outputu.
- Przy wyszukiwaniu preferuj `rg`, np. `rg "CreateOrderCommand" services src`.
- Zawsze idz po wywołaniach: route -> component -> API service -> controller -> command/query -> service -> repository/DbContext/entity.
- Gdy znajdźiesz komentarz opisowy, traktuj go jako pomocniczy. Potwierdz zachowanie w kodzie wykonywalnym.
