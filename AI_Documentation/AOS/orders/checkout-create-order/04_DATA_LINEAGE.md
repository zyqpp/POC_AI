# AOS Checkout Create Order - Data Lineage

## Cel Pliku

Ten plik pokazuje skąd ekran checkout bierze dane, jak je transformuje oraz gdzie proces utworzenia zamówienia czyta i zapisuje dane w SQL.

## Kontekst Danych

| Obszar | Opis |
|---|---|
| Główne encje | `OrderAggregate`, `OrderLine`, `OrderStatusHistory`, `OrderSagaStateEntity` |
| Główne tabele SQL | `Orders`, `OrderLines`, `OrderStatusHistory`, `OrderSagaStates`, `OutboxMessages` |
| Zależne tabele SQL | `Products`, `StockTransactions`, `DealerCreditAccounts`, `PaymentRecords` |
| Główne DTO | TS/C# `CreateOrderRequest`, `OrderDto`, `ProductDto`, `CreditCheckResponse` |
| Główne API odczytu | `GET /catalog/api/products/{id}`, `GET /payments/api/payment/dealers/{dealerId}/credit-check` |
| Główne API zapisu | `POST /orders/api/orders`, internal `soft-lock`, internal `outstanding`, payment gateway verify |

## Mapowanie Pól UI Do Danych

| ID pola UI | Etykieta UI | Pole DTO front | Pole DTO backend | Encja/model | Tabela SQL | Kolumna SQL | Odczyt/Zapis | Transformacja | Źródło w kodzie |
|---|---|---|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-DATA-001` | Product name | `CartItem.productName` | `CreateOrderLineRequest.ProductName` | `OrderLine.ProductName` | `OrderLines` | `ProductName` | R/W | Front odświeża z `ProductDto.name`; backend trim | `CartStore`, `CheckoutComponent`, `OrderLine.Create`, `OrderDbContext` |
| `AOS-ORD-CHECKOUT-DATA-002` | SKU | `CartItem.sku` | `CreateOrderLineRequest.Sku` | `OrderLine.Sku` | `OrderLines` | `Sku` | R/W | Backend trim + uppercase | `OrderLine.Create`, `OrderDbContext` |
| `AOS-ORD-CHECKOUT-DATA-003` | Quantity | `CartItem.quantity` | `CreateOrderLineRequest.Quantity` | `OrderLine.Quantity` | `OrderLines` | `Quantity` | R/W | Front normalizuje do MOQ/stock; backend sprawdza >0 i >= MOQ | `CartStore.normalizeQuantity`, `OrderLine.Create` |
| `AOS-ORD-CHECKOUT-DATA-004` | Unit price | `CartItem.unitPrice` | `CreateOrderLineRequest.UnitPrice` | `OrderLine.UnitPrice` | `OrderLines` | `UnitPrice` | R/W | Front odświeża z Catalog; backend wymaga >0 | `CheckoutComponent`, `OrderLine.Create` |
| `AOS-ORD-CHECKOUT-DATA-005` | Line total | `CartItem.lineTotal` | `OrderLineDto.LineTotal` | `OrderLine.LineTotal` | Brak kolumny | Brak kolumny | Computed | `UnitPrice * Quantity`; EF `Ignore(x => x.LineTotal)` | `CartStore`, `OrderLine`, `OrderDbContext` |
| `AOS-ORD-CHECKOUT-DATA-006` | Total | `cartStore.total()` | `OrderDto.TotalAmount` | `OrderAggregate.TotalAmount` | `Orders` | `TotalAmount` | R/W | Backend liczy z linii po `AddLine` | `CartStore`, `OrderAggregate.AddLine` |
| `AOS-ORD-CHECKOUT-DATA-007` | Payment method | `paymentMode` | `CreateOrderRequest.PaymentMode` | `OrderAggregate.PaymentMode` | `Orders` | `PaymentMode` | R/W | Enum jako string w DB | `CheckoutComponent`, `OrderDbContext` |
| `AOS-ORD-CHECKOUT-DATA-008` | Credit info | `CreditCheckResponse.*` | `CreditCheckResponse.*` | `DealerCreditAccount` | `DealerCreditAccounts` | `CreditLimit`, `CurrentOutstanding` | R/W | `AvailableCredit` computed, brak kolumny | `PaymentInvoiceService.CheckCreditAsync`, `PaymentInvoiceDbContext` |
| `AOS-ORD-CHECKOUT-DATA-009` | Order status after create | n/a | `OrderDto.Status` | `OrderAggregate.Status` | `Orders` | `Status` | W | `Processing` gdy credit approved, `OnHold` gdy failed | `OrderService.CreateOrderAsync` |
| `AOS-ORD-CHECKOUT-DATA-010` | Product availability | `ProductDto.availableStock` | n/a | `Product.AvailableStock` | Brak kolumny | Brak kolumny | Computed | `TotalStock - ReservedStock` | `Product`, `CatalogInventoryDbContext` |
| `AOS-ORD-CHECKOUT-DATA-011` | Reserved stock | n/a | `SoftLockStockRequest.Quantity` | `Product.ReservedStock` | `Products` | `ReservedStock` | W | `ReservedStock += quantity` | `CatalogInventoryService.SoftLockStockAsync` |

## Odczyt Danych

| Krok | Źródło | Operacja | Filtry | Sortowanie | Paginacja | Wynik |
|---|---|---|---|---|---|---|
| 1 | `localStorage sc_cart` | Read | Brak | Brak | Brak | `CartItem[]` |
| 2 | Catalog API | `GET /catalog/api/products/{id}` | `ProductId` | Brak | Brak | `ProductDto` |
| 3 | Payment API UI | `GET /payments/api/payment/dealers/{dealerId}/credit-check?amount=...` | `DealerId`, `amount` | Brak | Brak | `CreditCheckResponse` |
| 4 | Payment internal | `GET /api/payment/internal/dealers/{dealerId}/credit-check?amount=...` | `DealerId`, `amount` | Brak | Brak | `CreditCheckResult` |

## Zapis Danych

| Akcja | API | DTO wejścia | Encja/model | Tabela SQL | Kolumny SQL zapisywane | Transakcja | Efekty uboczne |
|---|---|---|---|---|---|---|---|
| `AOS-ORD-CHECKOUT-ACT-003` | `POST /orders/api/orders` | `CreateOrderRequest` | `OrderAggregate` | `Orders` | `OrderId`, `OrderNumber`, `DealerId`, `Status`, `TotalAmount`, `CreditHoldStatus`, `PaymentMode`, `PlacedAtUtc`, `CancellationReason` | `SaveChangesAsync` w Order DB | outbox, saga |
| `AOS-ORD-CHECKOUT-ACT-003` | `POST /orders/api/orders` | `CreateOrderRequest.Lines[]` | `OrderLine` | `OrderLines` | `OrderLineId`, `OrderId`, `ProductId`, `ProductName`, `Sku`, `Quantity`, `UnitPrice` | razem z order | `LineTotal` nie jest kolumną |
| `AOS-ORD-CHECKOUT-ACT-003` | `POST /orders/api/orders` | status transition | `OrderStatusHistory` | `OrderStatusHistory` | `HistoryId`, `OrderId`, `FromStatus`, `ToStatus`, `ChangedByUserId`, `ChangedByRole`, `ChangedAtUtc` | razem z order | Dla credit approved powstaje `Placed -> Processing`; dla `MarkCreditHold` brak historii |
| `AOS-ORD-CHECKOUT-ACT-003` | internal soft-lock | `SoftLockStockRequest` | `Product` | `Products` | `ReservedStock`, `UpdatedAtUtc` | osobne `SaveChangesAsync` w Catalog DB | cache + outbox |
| `AOS-ORD-CHECKOUT-ACT-003` | internal soft-lock | `SoftLockStockRequest` | `StockTransaction` | `StockTransactions` | `TxId`, `ProductId`, `TransactionType`, `Quantity`, `ReferenceId`, `CreatedAtUtc` | razem z Product | `TransactionType=SoftLock`, `ReferenceId=orderId:N` |
| `AOS-ORD-CHECKOUT-ACT-003` | Order outbox | object payload | `OutboxMessage` | `OutboxMessages` w Order DB | `MessageId`, `EventType`, `Payload`, `Status`, `CreatedAtUtc`, `PublishedAtUtc`, `RetryCount`, `Error` | razem z order | `OrderPlaced` albo `AdminApprovalRequired` |
| `AOS-ORD-CHECKOUT-ACT-003` | Saga | n/a | `OrderSagaStateEntity` | `OrderSagaStates` | `OrderId`, `OrderNumber`, `DealerId`, `CurrentState`, `StartedAtUtc`, `UpdatedAtUtc`, `CompletedAtUtc`, `LastMessage` | osobny zapis w saga coordinator | Stan finalny approved/awaiting manual |
| `AOS-ORD-CHECKOUT-ACT-003` | internal add outstanding | `AddOutstandingRequest` | `DealerCreditAccount` | `DealerCreditAccounts` | `CurrentOutstanding`; ewentualnie nowy `AccountId`, `DealerId`, `CreditLimit` | Payment DB | tylko gdy credit approved |
| `AOS-ORD-CHECKOUT-ACT-003` | internal add outstanding | `AddOutstandingRequest` | `PaymentRecord` | `PaymentRecords` | `PaymentRecordId`, `OrderId`, `DealerId`, `PaymentMode`, `Amount`, `ReferenceNo`, `CreatedAtUtc` | Payment DB | idempotencja po `OrderId` w repository/service |

## Dane Wyliczane

| Pole | Formula / logika | Gdzie liczona | Czy zapisywana w DB | Testy |
|---|---|---|---|---|
| `CartItem.lineTotal` | `quantity * unitPrice` | `CartStore` | Nie | UI/unit suggested |
| `OrderLine.LineTotal` | `UnitPrice * Quantity` | Domain getter | Nie, EF ignore | backend unit suggested |
| `OrderAggregate.TotalAmount` | suma `Lines.LineTotal` po dodaniu linii | `OrderAggregate.AddLine()` | Tak, `Orders.TotalAmount` | backend unit/integration suggested |
| `Product.AvailableStock` | `TotalStock - ReservedStock` | Domain getter | Nie, EF ignore | Catalog unit suggested |
| `DealerCreditAccount.AvailableCredit` | `CreditLimit - CurrentOutstanding` | Domain getter | Nie, EF ignore | Payment unit/API suggested |

## Słowniki I Enumy

| Nazwa | Wartość | Znaczenie biznesowe | Backend enum | Frontend enum | Wpływ na UI |
|---|---|---|---|---|---|
| `PaymentMode` | `0/COD` | Płatność przy odbiorze | `Order.Domain.Enums.PaymentMode`, `PaymentInvoice.Domain.Enums.PaymentMode` | `PaymentMode.COD` | Radio `Cash on Delivery` |
| `PaymentMode` | `1/PrePaid` | PrePaid/credit/gateway flow | j.w. | `PaymentMode.PrePaid` | Radio `Credit (PrePaid)`, credit info i Razorpay |
| `OrderStatus` | `Placed` | Status startowy agregatu | `OrderStatus.Placed` | `OrderStatus.Placed` | Nie widoczny po sukcesie checkout, bo zwykle zmienia się dalej |
| `OrderStatus` | `Processing` | Credit approved | `OrderStatus.Processing` | `OrderStatus.Processing` | Szczegóły zamówienia/lista |
| `OrderStatus` | `OnHold` | Credit failed/manual approval | `OrderStatus.OnHold` | `OrderStatus.OnHold` | Szczegóły zamówienia/lista |
| `CreditHoldStatus` | `Approved` | Credit approved | `CreditHoldStatus.Approved` | `CreditHoldStatus.Approved` | Szczegóły zamówienia |
| `CreditHoldStatus` | `PendingApproval` | Wymaga decyzji admina | `CreditHoldStatus.PendingApproval` | `CreditHoldStatus.PendingApproval` | Szczegóły/lista/admin |

## Retencja, Historia I Audyt

| Dane | Czy jest historia | Gdzie | Co pozwala odtworzyć |
|---|---|---|---|
| Status orderu | Częściowo | `OrderStatusHistory` | Zmiany przez `TransitionTo`; brak wpisu dla `MarkCreditHold()` |
| Eventy orderu | Tak | `OutboxMessages` w Order DB | Event `OrderPlaced` albo `AdminApprovalRequired` z payload JSON |
| Rezerwacja stocku | Tak | `StockTransactions`, `OutboxMessages` w Catalog DB | Soft-lock per product/order |
| Saga | Tak, stan aktualny | `OrderSagaStates` | Ostatni stan i komunikat, nie pełna historia |
| Payment/gateway verify | Tak | `PaymentRecords`, `OutboxMessages` w Payment DB | Payment captured/failed; przy verify `OrderId` w PaymentRecord = `Guid.Empty` |

## Luki Danych

| Luka | Objaw | Wpływ | Rekomendacja |
|---|---|---|---|
| Backend ufa `ProductName`, `Sku`, `UnitPrice` z requestu. | Brak backendowego pobrania produktu przed zapisem `OrderLine`. | Ryzyko manipulacji wartością zamówienia. | Backend powinien pobierać cenę/SKU z Catalog albo mieć podpisany koszyk. |
| `idempotencyKey` nie jest używany w Order create. | Request ma pole, ale brak widocznej idempotencji. | Ryzyko duplikatów. | Włączyć `IIdempotentRequest`/store albo unikalny klucz w DB. |
| `CartItem.note` nie jest zapisywane. | Notatka widoczna w UI, brak pola w DTO/DB. | Utrata danych z koszyka. | Dodać pole do `CreateOrderLineRequest`, `OrderLine`, migracji i UI. |
| Brak historii dla `Placed -> OnHold`. | `MarkCreditHold()` ustawia status bez `OrderStatusHistory`. | Niepełny audyt procesu credit hold. | Rozważyć transition z historią albo osobny event history. |
