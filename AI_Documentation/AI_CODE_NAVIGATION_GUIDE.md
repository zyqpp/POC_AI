# AI Code Navigation Guide

## Cel

Ten plik jest instrukcja dla przyszlych agentow AI: jak ustalac fakty w projekcie bez zgadywania i jak przejsc od ekranu/przycisku do backendu, logiki biznesowej oraz bazy danych.

## Zasada zrodel prawdy

- Nie ufaj nazwie ekranu jako jedynemu zrodlu. Zawsze potwierdzaj sciezke w kodzie.
- Frontend: zaczynaj od `supply-chain-frontend/src/app/app.routes.ts`.
- API frontendowe: potem sprawdz `supply-chain-frontend/src/app/core/api/*.service.ts`.
- Kontrakty frontu: sprawdz `supply-chain-frontend/src/app/core/models/*.ts`.
- Gateway: sprawdz `gateway/OcelotGateway/ocelot.json`.
- Backend: kontroler `services/<Service>/<Service>.API/Controllers/*Controller.cs`.
- Use case: komenda/zapytanie w `Application/Features`.
- Logika: serwis aplikacyjny w `Application/Services`.
- Reguly domenowe: encje w `Domain/Entities` i enumy w `Domain/Enums`.
- Persistence: repozytorium i DbContext w `Infrastructure`.
- Integracje miedzy serwisami: `Infrastructure/Integrations`, outbox dispatcher i RabbitMQ consumers.

## Sciezka analizy ekranu

1. Znajdz route w `app.routes.ts`, np. `/orders/:id`.
2. Otworz komponent z `features/.../*.component.ts`.
3. W komponencie znajdz wstrzykniete store/services/API.
4. Otworz metode API w `core/api/*-api.service.ts`.
5. Zanotuj HTTP method, URL i typy request/response.
6. Przejdz przez Ocelot: dopasuj prefiks `/orders`, `/catalog`, itd. do downstream service.
7. Otworz kontroler backendowy i metode z takim route.
8. Zanotuj `[Authorize]`, role, warunki scope, statusy odpowiedzi.
9. Przejdz z kontrolera do `sender.Send(new ...Command/Query)`.
10. Otworz handler w `Application/Features`.
11. Handler zwykle deleguje do serwisu aplikacyjnego; otworz `Application/Services`.
12. Jesli metoda dotyka danych, przejdz do repozytorium i DbContextu.
13. Jesli metoda zmienia reguly domenowe, sprawdz metode encji domenowej.
14. Jesli jest integracja miedzy serwisami, sprawdz gateway HTTP i endpoint internal w drugim serwisie.

## Przyklad: utworzenie zamowienia

- Frontend: `OrderApiService.createOrder` wysyla `POST /orders/api/orders`.
- Gateway: prefiks `/orders` trafia do Order API.
- Backend: `OrdersController.Create` wymaga roli `Dealer`, pobiera user id z JWT i wysyla `CreateOrderCommand`.
- Application: `CreateOrderCommandHandler` deleguje do `OrderService.CreateOrderAsync`.
- Logika: `OrderService` waliduje request, tworzy `OrderAggregate`, dodaje linie, soft-lockuje stock przez `CatalogInventoryGateway`, sprawdza kredyt przez `PaymentCreditCheckGateway`.
- Persistence: zapis przez `OrderRepository` i `OrderDbContext`.
- Efekty uboczne: outbox event `OrderPlaced` albo `AdminApprovalRequired`, aktualizacja outstanding w PaymentInvoice, start `OrderSagaCoordinator`.
- Baza: tabele `Orders`, `OrderLines`, `OrderStatusHistory`, `OrderSagaStates`, `OutboxMessages`.

## Przyklad: status przesylki z ekranu

- Route: `shipments/:id` -> `ShipmentDetailComponent`.
- API frontu: `LogisticsApiService.updateStatus` -> `PUT /logistics/api/logistics/shipments/{id}/status`.
- Kontroler: `ShipmentsController.UpdateStatus`.
- Role: Admin/Logistics/Agent; Agent musi byc przypisany i miec zaakceptowane assignment.
- Handler: `UpdateShipmentStatusCommand`.
- Logika: `LogisticsService` i encja `Shipment.UpdateStatus`.
- Persistence: `LogisticsTrackingDbContext` zapisuje `Shipments` i `ShipmentEvents`.

## Jak ustalic API i DTO

- Najszybciej uruchom `AI_Agent_scripts/Collect-CodeFacts.ps1`.
- Dla szczegolow payloadu otwieraj pliki `Application/DTOs/*Dtos.cs`.
- Porownaj z `core/models/*.ts`; jesli pola sie roznia, traktuj backend jako zrodlo prawdy, a frontend jako potencjalnie wymagajacy poprawki.

## Jak ustalic walidacje

- Backend: `Application/Validation/*Validators.cs`.
- Dodatkowe reguly sa w encjach domenowych, np. `Product`, `OrderAggregate`, `Shipment`.
- Frontend moze miec walidacje formularzy w komponentach, ale nie jest zrodlem prawdy dla bezpieczenstwa.

## Jak ustalic dane bazy

- Zacznij od DbContextu.
- Potem sprawdz encje domenowe, bo czesc pol jest computed albo ignorowana w EF (`AvailableStock`, `LineTotal`, `AvailableCredit`).
- Jesli trzeba potwierdzic fizyczna migracje, sprawdz ostatni plik w `Infrastructure/Persistence/Migrations`.

## Jak nie zgubic sie w projekcie

- Nie analizuj `node_modules`, `bin`, `obj`, `.vs`, `artifacts`, chyba ze problem bezposrednio dotyczy zaleznosci/build outputu.
- Przy wyszukiwaniu preferuj `rg`, np. `rg "CreateOrderCommand" services src`.
- Zawsze idz po wywolaniach: route -> component -> API service -> controller -> command/query -> service -> repository/DbContext/entity.
- Gdy znajdziesz komentarz opisowy, traktuj go jako pomocniczy. Potwierdz zachowanie w kodzie wykonywalnym.
