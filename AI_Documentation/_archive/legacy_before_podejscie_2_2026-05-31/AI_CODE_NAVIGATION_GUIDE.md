# AI Code Navigation Guide

## Cel

Ten plik jest instrukcją dla przyszłych agentów AI: jak ustalać fakty w projekcie bez zgadywania i jak przejść od ekranu/przycisku do backendu, logiki biznesowej oraz bazy danych.

## Granica Pracy Agenta

- Agent używa tego przewodnika do dokumentowania aplikacji, nie do zmieniania aplikacji.
- Kod w `supply-chain-frontend/**`, `services/**`, `src/**`, `gateway/**`, testy, migracje i konfiguracje runtime traktuj jako źródła prawdy do odczytu.
- Nie edytuj kodu aplikacji, nawet jeżeli znajdziesz błąd albo brak testu. Zapisz odkrycie w AOS jako lukę, ryzyko, pytanie otwarte albo rekomendację.
- Dozwolone zmiany dotyczą tylko dokumentacji i narzędzi dokumentacyjnych: `AI_Documentation/**`, `AI_Agent_scripts/**`, `AGENTS.md`.
- Jeżeli użytkownik nie poda wprost, że przełącza zadanie na implementację, pozostajesz w trybie dokumentalisty.

## Zasada Źródeł Prawdy

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
- Struktura bazy: `AI_DATABASE_STRUCTURE.md`, a następnie konkretny `DbContext`, encja i skrypt SQL, jeżeli istnieje.
- Integracje między serwisami: `Infrastructure/Integrations`, outbox dispatcher i RabbitMQ consumers.

## Ścieżka Analizy Ekranu

1. Znajdź route w `app.routes.ts`, np. `/orders/:id`.
2. Otwórz komponent z `features/.../*.component.ts`.
3. W komponencie znajdź wstrzyknięte store/services/API.
4. Otwórz metodę API w `core/api/*-api.service.ts`.
5. Zanotuj HTTP method, URL i typy request/response.
6. Przejdź przez Ocelot: dopasuj prefiks `/orders`, `/catalog`, itd. do downstream service.
7. Otwórz kontroler backendowy i metodę z takim route.
8. Zanotuj `[Authorize]`, role, warunki scope i statusy odpowiedzi.
9. Przejdź z kontrolera do `sender.Send(new ...Command/Query)`.
10. Otwórz handler w `Application/Features`.
11. Handler zwykle deleguje do serwisu aplikacyjnego; otwórz `Application/Services`.
12. Jeśli metoda dotyka danych, przejdź do repozytorium i DbContextu.
13. Jeśli metoda zmienia reguły domenowe, sprawdź metodę encji domenowej.
14. Jeśli jest integracja między serwisami, sprawdź gateway HTTP i endpoint internal w drugim serwisie.

## Przykład: Utworzenie Zamówienia

- Frontend: `OrderApiService.createOrder` wysyła `POST /orders/api/orders`.
- Gateway: prefiks `/orders` trafia do Order API.
- Backend: `OrdersController.Create` wymaga roli `Dealer`, pobiera user id z JWT i wysyła `CreateOrderCommand`.
- Application: `CreateOrderCommandHandler` deleguje do `OrderService.CreateOrderAsync`.
- Logika: `OrderService` waliduje request, tworzy `OrderAggregate`, dodaje linie, soft-lockuje stock przez `CatalogInventoryGateway`, sprawdza kredyt przez `PaymentCreditCheckGateway`.
- Persistence: zapis przez `OrderRepository` i `OrderDbContext`.
- Efekty uboczne: outbox event `OrderPlaced` albo `AdminApprovalRequired`, aktualizacja outstanding w PaymentInvoice, start `OrderSagaCoordinator`.
- Baza: `OrderMigrationsDB.dbo.Orders`, `OrderLines`, `OrderStatusHistory`, `OrderSagaStates`, `OutboxMessages`; dodatkowo `CatalogInventoryMigrationsDB.dbo.Products`, `StockTransactions` i `PaymentInvoiceMigrationsDB.dbo.DealerCreditAccounts`, `PaymentRecords`.

## Przykład: Status Przesyłki Z Ekranu

- Route: `shipments/:id` -> `ShipmentDetailComponent`.
- API frontu: `LogisticsApiService.updateStatus` -> `PUT /logistics/api/logistics/shipments/{id}/status`.
- Kontroler: `ShipmentsController.UpdateStatus`.
- Role: Admin/Logistics/Agent; Agent musi być przypisany i mieć zaakceptowane assignment.
- Handler: `UpdateShipmentStatusCommand`.
- Logika: `LogisticsService` i encja `Shipment.UpdateStatus`.
- Persistence: `LogisticsTrackingDbContext` zapisuje `Shipments` i `ShipmentEvents`.
- Baza: `LogisticsTrackingMigrationsDB.dbo.Shipments`, `ShipmentEvents`, opcjonalnie `ShipmentOpsStates` i `OutboxMessages`.

## Jak Ustalić API I DTO

- Najszybciej uruchom `AI_Agent_scripts/Collect-CodeFacts.ps1`.
- Dla szczegółów payloadu otwieraj pliki `Application/DTOs/*Dtos.cs`.
- Porównaj z `core/models/*.ts`; jeśli pola się różnią, traktuj backend jako źródło prawdy, a frontend jako potencjalnie wymagający poprawki.

## Jak Ustalić Walidacje

- Backend: `Application/Validation/*Validators.cs`.
- Dodatkowe reguły są w encjach domenowych, np. `Product`, `OrderAggregate`, `Shipment`.
- Frontend może mieć walidacje formularzy w komponentach, ale nie jest źródłem prawdy dla bezpieczeństwa.

## Jak Ustalić Dane Bazy

- Zacznij od `AI_DATABASE_STRUCTURE.md`, żeby sprawdzić właściwą bazę, schemat, tabelę, kolumny i znane relacje.
- Potem przejdź do właściwego `DbContextu`. To jest aktualne źródło prawdy dla mapowania EF.
- Sprawdź encje domenowe, bo część pól jest wyliczana albo ignorowana w EF (`AvailableStock`, `LineTotal`, `AvailableCredit`).
- Sprawdź repozytorium, żeby ustalić realne filtry, sortowanie, paginację, `Include(...)` i moment zapisu.
- Jeśli istnieje skrypt SQL w `scripts/migrations/*.sql`, porównaj go z EF. Gdy skrypt nie zawiera tabeli albo kolumny obecnej w EF, zapisz rozbieżność w dokumentacji zamiast zgadywać.
- Dla każdego pola UI w AOS spróbuj zejść do poziomu: baza -> schemat -> tabela -> kolumna -> odczyt/zapis -> dowód w kodzie.
- Relacje między serwisami opisuj jako logiczne, jeżeli nie ma fizycznego FK w tej samej bazie.

## Jak Nie Zgubić Się W Projekcie

- Nie analizuj `node_modules`, `bin`, `obj`, `.vs`, `artifacts`, chyba że problem bezpośrednio dotyczy zależności/build outputu.
- Przy wyszukiwaniu preferuj `rg`, np. `rg "CreateOrderCommand" services src`.
- Zawsze idź po wywołaniach: route -> component -> API service -> controller -> command/query -> service -> repository/DbContext/entity.
- Gdy znajdziesz komentarz opisowy, traktuj go jako pomocniczy. Potwierdź zachowanie w kodzie wykonywalnym.
