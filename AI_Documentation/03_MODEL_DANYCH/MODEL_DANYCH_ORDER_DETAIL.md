# Model Danych: Szczegół Zamówienia `/orders/:id`

Status: `potwierdzone` dla tabel i kolumn Order DB; `wniosek z analizy` dla relacji między mikroserwisami.
Zakres: odczyt szczegółu zamówienia, zmiana statusu, anulowanie, credit hold, zwroty, notatki operacyjne i reorder.

## Źródła

| Obszar | Źródło |
|---|---|
| EF Core mapping | `services/Order/Order.Infrastructure/Persistence/OrderDbContext.cs:7-92` |
| Migracja tabel order | `services/Order/Order.Infrastructure/Persistence/Migrations/20260328174554_InitialCreate.cs:14-141` |
| Migracja sagi | `services/Order/Order.Infrastructure/Persistence/Migrations/20260403105135_AddOrderSagaState.cs:14-30` |
| Agregat i reguły domenowe | `services/Order/Order.Domain/Entities/OrderAggregate.cs:29-170` |
| Return request | `services/Order/Order.Domain/Entities/ReturnRequest.cs:9-40` |
| Repozytorium odczytu | `services/Order/Order.Infrastructure/Repositories/OrderRepository.cs:19-25` |

## Tabele I Kolumny Order DB

| Tabela | Kolumna | Typ SQL / ograniczenie | Null | R/W dla `/orders/:id` | Źródło |
|---|---|---|---|---|---|
| `Orders` | `OrderId` | `uniqueidentifier`, PK | nie | odczyt i identyfikacja akcji | `InitialCreate.cs:18`, `OrderDbContext.cs:31` |
| `Orders` | `OrderNumber` | `nvarchar(32)`, unique index | nie | odczyt | `InitialCreate.cs:19`, `OrderDbContext.cs:32-33` |
| `Orders` | `DealerId` | `uniqueidentifier`, index z `PlacedAtUtc` | nie | odczyt, data scope dealera | `InitialCreate.cs:20`, `OrderDbContext.cs:34` |
| `Orders` | `Status` | `nvarchar(40)`, enum jako string | nie | odczyt i zapis przy lifecycle | `InitialCreate.cs:21`, `OrderDbContext.cs:36` |
| `Orders` | `TotalAmount` | `decimal(18,2)` | nie | odczyt | `InitialCreate.cs:22`, `OrderDbContext.cs:39` |
| `Orders` | `CreditHoldStatus` | `nvarchar(40)`, enum jako string | nie | odczyt i zapis przy hold approve/reject | `InitialCreate.cs:23`, `OrderDbContext.cs:37` |
| `Orders` | `PaymentMode` | `nvarchar(20)`, enum jako string | nie | odczyt | `InitialCreate.cs:24`, `OrderDbContext.cs:38` |
| `Orders` | `PlacedAtUtc` | `datetime2` | nie | odczyt i fallback okna zwrotu | `InitialCreate.cs:25`, `OrderAggregate.cs:129-134` |
| `Orders` | `CancellationReason` | `nvarchar(400)` | tak | odczyt i zapis przy anulowaniu/reject hold | `InitialCreate.cs:26`, `OrderDbContext.cs:40` |
| `OrderLines` | `OrderLineId` | `uniqueidentifier`, PK | nie | odczyt | `InitialCreate.cs:55`, `OrderLine.cs:9` |
| `OrderLines` | `OrderId` | `uniqueidentifier`, FK cascade do `Orders` | nie | odczyt relacji | `InitialCreate.cs:56`, `InitialCreate.cs:66-71` |
| `OrderLines` | `ProductId` | `uniqueidentifier` | nie | odczyt i reorder przez Catalog API | `InitialCreate.cs:57`, `OrderLine.cs:11` |
| `OrderLines` | `ProductName` | `nvarchar(220)` | nie | odczyt UI | `InitialCreate.cs:58`, `OrderDbContext.cs:59` |
| `OrderLines` | `Sku` | `nvarchar(60)` | nie | odczyt UI | `InitialCreate.cs:59`, `OrderDbContext.cs:60` |
| `OrderLines` | `Quantity` | `int` | nie | odczyt UI i reorder | `InitialCreate.cs:60`, `OrderLine.cs:14` |
| `OrderLines` | `UnitPrice` | `decimal(18,2)` | nie | odczyt UI i line total | `InitialCreate.cs:61`, `OrderDbContext.cs:61` |
| `OrderLines` | `LineTotal` | brak kolumny, właściwość wyliczana | brak | wyliczenie `UnitPrice * Quantity` | `OrderLine.cs:16`, `OrderDbContext.cs:62` |
| `OrderStatusHistory` | `HistoryId` | `uniqueidentifier`, PK | nie | odczyt historii | `InitialCreate.cs:78`, `OrderStatusHistory.cs:11` |
| `OrderStatusHistory` | `OrderId` | `uniqueidentifier`, FK cascade do `Orders` | nie | odczyt relacji | `InitialCreate.cs:79`, `InitialCreate.cs:89-94` |
| `OrderStatusHistory` | `FromStatus` | `nvarchar(40)`, enum jako string | nie | odczyt i zapis przy transition | `InitialCreate.cs:80`, `OrderDbContext.cs:69` |
| `OrderStatusHistory` | `ToStatus` | `nvarchar(40)`, enum jako string | nie | odczyt i zapis przy transition | `InitialCreate.cs:81`, `OrderDbContext.cs:70` |
| `OrderStatusHistory` | `ChangedByUserId` | `uniqueidentifier` | nie | odczyt audytu lifecycle | `InitialCreate.cs:82`, `OrderStatusHistory.cs:15` |
| `OrderStatusHistory` | `ChangedByRole` | `nvarchar(40)` | nie | odczyt audytu lifecycle | `InitialCreate.cs:83`, `OrderDbContext.cs:71` |
| `OrderStatusHistory` | `ChangedAtUtc` | `datetime2` | nie | odczyt historii i okna zwrotu | `InitialCreate.cs:84`, `OrderAggregate.cs:129-134` |
| `ReturnRequests` | `ReturnRequestId` | `uniqueidentifier`, PK | nie | odczyt i identyfikacja zwrotu | `InitialCreate.cs:101`, `ReturnRequest.cs:9` |
| `ReturnRequests` | `OrderId` | `uniqueidentifier`, FK cascade, unique index | nie | relacja 1:1 do orderu | `InitialCreate.cs:102`, `InitialCreate.cs:113-118`, `InitialCreate.cs:137-141` |
| `ReturnRequests` | `RequestedByDealerId` | `uniqueidentifier` | nie | zapis przy request return | `InitialCreate.cs:103`, `ReturnRequest.cs:11` |
| `ReturnRequests` | `Reason` | `nvarchar(500)` | nie | zapis powodu zwrotu | `InitialCreate.cs:104`, `OrderDbContext.cs:78` |
| `ReturnRequests` | `RequestedAtUtc` | `datetime2` | nie | zapis czasu requestu | `InitialCreate.cs:105`, `ReturnRequest.cs:13` |
| `ReturnRequests` | `IsApproved` | `bit` | nie | zapis przy approve/reject return | `InitialCreate.cs:106`, `ReturnRequest.cs:28-39` |
| `ReturnRequests` | `IsRejected` | `bit` | nie | zapis przy approve/reject return | `InitialCreate.cs:107`, `ReturnRequest.cs:28-39` |
| `ReturnRequests` | `ReviewedAtUtc` | `datetime2` | tak | zapis przy approve/reject return | `InitialCreate.cs:108`, `ReturnRequest.cs:16` |
| `OrderSagaStates` | `OrderId` | `uniqueidentifier`, PK | nie | odczyt w `OrderDto.Saga`, zapis lifecycle | `AddOrderSagaState.cs:18`, `OrderDbContext.cs:84` |
| `OrderSagaStates` | `CurrentState` | `nvarchar(64)`, enum jako string | nie | odczyt i zapis lifecycle | `AddOrderSagaState.cs:21`, `OrderDbContext.cs:86` |
| `OrderSagaStates` | `LastMessage` | `nvarchar(500)` | tak | odczyt i zapis komunikatu sagi | `AddOrderSagaState.cs:25`, `OrderDbContext.cs:87` |
| `OutboxMessages` | `MessageId`, `EventType`, `Payload`, `Status`, `Error` | event outbox | mieszane | zapis eventów order/return/hold | `InitialCreate.cs:33-49`, `OrderDbContext.cs:18-26` |

## Odczyt Szczegółu Zamówienia

| Dane UI | Źródło DTO | Encja / tabela | Kolumna | Status |
|---|---|---|---|---|
| Numer zamówienia | `OrderDto.OrderNumber` | `Orders` | `OrderNumber` | potwierdzone |
| Status | `OrderDto.Status` | `Orders` | `Status` | potwierdzone |
| Payment | `OrderDto.PaymentMode` | `Orders` | `PaymentMode` | potwierdzone |
| Credit hold | `OrderDto.CreditHoldStatus` | `Orders` | `CreditHoldStatus` | potwierdzone |
| Total | `OrderDto.TotalAmount` | `Orders` | `TotalAmount` | potwierdzone |
| Placed at | `OrderDto.PlacedAtUtc` | `Orders` | `PlacedAtUtc` | potwierdzone |
| Dealer ID | `OrderDto.DealerId` | `Orders` | `DealerId` | potwierdzone |
| Cancellation reason | `OrderDto.CancellationReason` | `Orders` | `CancellationReason` | potwierdzone |
| Linie zamówienia | `OrderDto.Lines[]` | `OrderLines` | `ProductName`, `Sku`, `Quantity`, `UnitPrice`; `LineTotal` wyliczane | potwierdzone |
| Historia statusów | `OrderDto.StatusHistory[]` | `OrderStatusHistory` | `FromStatus`, `ToStatus`, `ChangedByUserId`, `ChangedByRole`, `ChangedAtUtc` | potwierdzone |
| Zwrot | `OrderDto.ReturnRequest` | `ReturnRequests` | `Reason`, `RequestedAtUtc`, `IsApproved`, `IsRejected`, `ReviewedAtUtc` | potwierdzone |
| Saga | `OrderDto.Saga` po stronie backendu | `OrderSagaStates` | `CurrentState`, `LastMessage`, daty | potwierdzone w backendzie; brak pola `saga` w TS `OrderDto` |

## Zapisy Per Akcja

| Akcja | Tabele zapisywane | Kolumny | Integracje / efekty uboczne | Status |
|---|---|---|---|---|
| `Update Status` | `Orders`, `OrderStatusHistory`, `OutboxMessages`, `OrderSagaStates` | `Orders.Status`; historia `FromStatus`, `ToStatus`, `ChangedByUserId`, `ChangedByRole`; `OutboxMessages.EventType=Order{status}` | przy `InTransit` hard deduct stock; przy `Cancelled` release soft lock | potwierdzone |
| `Cancel Order` | `Orders`, `OrderStatusHistory`, `OutboxMessages`, `OrderSagaStates` | `Orders.Status=Cancelled`, `CancellationReason`; historia statusu; `OrderCancelled` | może zwolnić reserved stock | potwierdzone |
| `Request Return` | `ReturnRequests`, `Orders`, `OrderStatusHistory`, `OutboxMessages` | `Reason`, `RequestedByDealerId`, `RequestedAtUtc`, `Orders.Status=ReturnRequested`; `ReturnRequested` | brak natychmiastowego restock/settlement | potwierdzone |
| `Approve Return` | `ReturnRequests`, `Orders`, `OrderStatusHistory`, `OutboxMessages` | `IsApproved=true`, `IsRejected=false`, `ReviewedAtUtc`; `Orders.Status=ReturnApproved`; `ReturnApproved` | restock w CatalogInventory i settle outstanding w PaymentInvoice | potwierdzone |
| `Reject Return` | `ReturnRequests`, `Orders`, `OrderStatusHistory`, `OutboxMessages` | `IsRejected=true`, `IsApproved=false`, `ReviewedAtUtc`; `Orders.Status=ReturnRejected`; `ReturnRejected` | brak restock/settlement | potwierdzone |
| `Approve Hold` | `Orders`, `OrderStatusHistory`, `OutboxMessages`, `OrderSagaStates` | `CreditHoldStatus=Approved`, `Status=Processing`; `OrderApproved` | saga completed approved | potwierdzone |
| `Reject Hold` | `Orders`, `OrderStatusHistory`, `OutboxMessages`, `OrderSagaStates` | `CreditHoldStatus=Rejected`, `Status=Cancelled`, `CancellationReason`; `OrderCancelled` | release stock, saga completed rejected | potwierdzone |
| `Operations Notes & Tags` | brak tabeli SQL | brak | `localStorage` pod kluczem `scp.order-ops-notes.v1` | potwierdzone |
| `Reorder Items` | brak tabeli SQL w tej akcji | brak | odczyt `Products` przez Catalog API i zapis do lokalnego koszyka | potwierdzone |

## Relacje

| Relacja | Typ | Status | Źródło |
|---|---|---|---|
| `OrderLines.OrderId -> Orders.OrderId` | fizyczna FK cascade | potwierdzone | `InitialCreate.cs:66-71` |
| `OrderStatusHistory.OrderId -> Orders.OrderId` | fizyczna FK cascade | potwierdzone | `InitialCreate.cs:89-94` |
| `ReturnRequests.OrderId -> Orders.OrderId` | fizyczna FK 1:1, unique index | potwierdzone | `InitialCreate.cs:113-141` |
| `OrderSagaStates.OrderId -> Orders.OrderId` | logiczna w tej samej bazie, bez FK w snapshot | potwierdzone | `OrderDbContext.cs:81-87`, `OrderDbContextModelSnapshot.cs:225` |
| `Orders.DealerId -> IdentityAuth.Users.UserId` | logiczna między bazami | wniosek z analizy | brak fizycznego FK |
| `OrderLines.ProductId -> CatalogInventory.Products.ProductId` | logiczna między bazami | wniosek z analizy | brak fizycznego FK |

## Luki Danych

| Luka | Dowód | Wpływ | Status |
|---|---|---|---|
| `OrderDto.Saga` istnieje w backendzie, ale TypeScript `OrderDto` nie ma pola `saga`. | `OrderDtos.cs:93-106`, `order.models.ts:85-98` | UI szczegółu nie pokazuje sagi mimo dostępności w API. | potwierdzone |
| Notatki operacyjne nie są w bazie i nie mają backendowego audytu. | `order-ops-notes.service.ts:12-18`, `order-ops-notes.service.ts:77-84` | Notatki są lokalne dla przeglądarki i mogą zniknąć. | potwierdzone |
| `CancelOrderAsync` nie sprawdza `DealerId` dla roli Dealer. | `OrdersController.cs:108-119`, `OrderService.cs:368-394` | Dealer może anulować cudze zamówienie, jeśli zna `OrderId`. | potwierdzone jako ryzyko |
| `scripts/migrations/Order.sql` nie zawiera `OrderSagaStates`, chociaż EF migracja ją tworzy. | `scripts/migrations/Order.sql:17`, `scripts/migrations/Order.sql:54`, `scripts/migrations/Order.sql:90`, `20260403105135_AddOrderSagaState.cs:14-30` | Wdrożenie oparte na skrypcie SQL może nie mieć danych sagi. | potwierdzone jako rozbieżność |
| `MarkCreditHold()` ustawia `Orders.Status=OnHold` bez `OrderStatusHistory`. | `OrderAggregate.cs:76-80` | Historia statusów może nie zawierać wejścia w hold. | potwierdzone jako luka audytu |
