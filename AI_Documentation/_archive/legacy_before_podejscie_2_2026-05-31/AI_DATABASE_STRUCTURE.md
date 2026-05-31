# AI Database Structure

## Cel Dokumentu

Ten dokument opisuje strukturę danych aplikacji w układzie: baza danych -> schemat -> tabela -> kolumny -> relacje -> skrypty SQL -> użycie przez ekrany i procesy.

Ma służyć agentom AI, analitykom, testerom i developerom jako punkt startowy do ustalania, z jakich tabel i kolumn korzysta dany ekran, akcja, API albo proces biznesowy.

## Zasady Ustalania Faktów

- Źródłem prawdy dla aktualnego modelu danych jest kod EF: `DbContext`, encje domenowe i konfiguracje w `services/**/Infrastructure/Persistence`.
- Skrypty SQL w `scripts/migrations/*.sql` są artefaktami wdrożeniowymi. Należy je uwzględniać, ale nie wolno traktować ich jako jedynego źródła prawdy.
- W repozytorium znaleziono rozbieżność: część skryptów SQL nie zawiera nowszych tabel i kolumn obecnych w EF, np. `OrderSagaStates`, `ShipmentOpsStates`, `InvoiceWorkflowStates`, `InvoiceWorkflowActivities`, pola oceny dostawcy i pola decyzji assignmentu przesyłki.
- Nie znaleziono jawnych schematów EF typu `HasDefaultSchema` ani `ToTable(name, schema)`. Dla tabel przyjmowany jest domyślny schemat SQL Server: `dbo`.
- Relacje między mikroserwisami są głównie logiczne przez identyfikatory `Guid`. Fizyczne klucze obce występują zasadniczo tylko wewnątrz jednej bazy danego serwisu.
- Agent dokumentacyjny nie zmienia migracji, encji, konfiguracji EF ani skryptów SQL. Może tylko opisać fakty, luki i rekomendacje w dokumentacji.

## Mapa Baz Danych I Kontekstów

| Obszar | Baza danych | Schemat | Connection string | DbContext | Skrypt SQL |
|---|---|---|---|---|---|
| Identity/Auth | `IdentityAuthMigrationsDB` | `dbo` | `IdentityDb` | `IdentityAuthDbContext` | `scripts/migrations/IdentityAuth.sql` |
| Catalog/Inventory | `CatalogInventoryMigrationsDB` | `dbo` | `InventoryDb` | `CatalogInventoryDbContext` | `scripts/migrations/CatalogInventory.sql` |
| Order | `OrderMigrationsDB` | `dbo` | `OrderDb` | `OrderDbContext` | `scripts/migrations/Order.sql` |
| Logistics/Tracking | `LogisticsTrackingMigrationsDB` | `dbo` | `LogisticsDb` | `LogisticsTrackingDbContext` | `scripts/migrations/LogisticsTracking.sql` |
| Payment/Invoice | `PaymentInvoiceMigrationsDB` | `dbo` | `PaymentDb` | `PaymentInvoiceDbContext` | `scripts/migrations/PaymentInvoice.sql` |
| Notification | `NotificationMigrationsDB` | `dbo` | `NotificationDb` | `NotificationDbContext` | `scripts/migrations/Notification.sql` |

Każda baza EF zwykle zawiera też techniczną tabelę `dbo.__EFMigrationsHistory`, zarządzaną przez Entity Framework.

## Relacje Między Bazami

| Identyfikator | Gdzie jest źródło | Gdzie jest używany | Charakter relacji |
|---|---|---|---|
| `UserId` | `IdentityAuthMigrationsDB.dbo.Users.UserId` | `Orders.DealerId`, `Shipments.DealerId`, `Shipments.AssignedAgentId`, `Invoices.DealerId`, `DealerCreditAccounts.DealerId`, `Notifications.RecipientUserId` | logiczna relacja między serwisami, bez fizycznego FK |
| `DealerProfile.UserId` | `IdentityAuthMigrationsDB.dbo.DealerProfiles.UserId` | procesy rejestracji, akceptacji dealerów, zamówień i limitów kredytowych | fizyczny FK tylko do `Users` w bazie Identity |
| `ProductId` | `CatalogInventoryMigrationsDB.dbo.Products.ProductId` | `OrderLines.ProductId`, `InvoiceLines.ProductId`, `StockTransactions.ProductId`, `StockSubscriptions.ProductId` | fizyczny FK tylko w Inventory; w Order/Invoice identyfikator jest kopią logiczną |
| `OrderId` | `OrderMigrationsDB.dbo.Orders.OrderId` | `Shipments.OrderId`, `Invoices.OrderId`, `PaymentRecords.OrderId`, `OrderSagaStates.OrderId` | logiczna relacja między serwisami; `OrderLines`, `OrderStatusHistory`, `ReturnRequests` mają fizyczny FK do `Orders` |
| `ShipmentId` | `LogisticsTrackingMigrationsDB.dbo.Shipments.ShipmentId` | `ShipmentEvents.ShipmentId`, `ShipmentOpsStates.ShipmentId` | fizyczny FK w bazie Logistics |
| `InvoiceId` | `PaymentInvoiceMigrationsDB.dbo.Invoices.InvoiceId` | `InvoiceLines.InvoiceId`, `InvoiceWorkflowStates.InvoiceId`, `InvoiceWorkflowActivities.InvoiceId` | fizyczny FK w bazie Payment/Invoice |

## IdentityAuthMigrationsDB

### Schemat `dbo`

| Tabela | Kolumny | Klucze, indeksy i relacje |
|---|---|---|
| `Users` | `UserId: Guid`, `Email: string`, `PasswordHash: string`, `FullName: string`, `PhoneNumber: string`, `Role: UserRole`, `Status: UserStatus`, `CreditLimit: decimal`, `RejectionReason: string?`, `CreatedAtUtc: DateTime`, `UpdatedAtUtc: DateTime` | PK `UserId`; unikalny indeks `Email`; indeks `Role, Status, CreatedAtUtc`; źródło użytkowników, dealerów, agentów i adminów |
| `DealerProfiles` | `DealerProfileId: Guid`, `UserId: Guid`, `BusinessName: string`, `GstNumber: string`, `TradeLicenseNo: string`, `Address: string`, `City: string`, `State: string`, `PinCode: string`, `IsInterstate: bool` | PK `DealerProfileId`; FK `UserId -> Users.UserId`; unikalny indeks `GstNumber`; profil biznesowy dealera |
| `RefreshTokens` | `RefreshTokenId: Guid`, `UserId: Guid`, `TokenHash: string`, `CreatedAtUtc: DateTime`, `ExpiresAtUtc: DateTime`, `IsRevoked: bool`, `RevokedAtUtc: DateTime?` | PK `RefreshTokenId`; FK `UserId -> Users.UserId`; unikalny indeks `TokenHash`; sesje i odświeżanie tokenów |
| `OtpRecords` | `OtpRecordId: Guid`, `UserId: Guid`, `OtpHash: string`, `CreatedAtUtc: DateTime`, `ExpiresAtUtc: DateTime`, `IsUsed: bool`, `UsedAtUtc: DateTime?` | PK `OtpRecordId`; FK `UserId -> Users.UserId`; reset hasła/OTP |
| `OutboxMessages` | `MessageId: Guid`, `EventType: string`, `Payload: string`, `Status: OutboxStatus`, `CreatedAtUtc: DateTime`, `PublishedAtUtc: DateTime?`, `RetryCount: int`, `Error: string?` | PK `MessageId`; zdarzenia wychodzące z Identity |

### Główne Zapytania I Procesy

| Proces | Tabele | Uwagi |
|---|---|---|
| Logowanie | `Users`, `RefreshTokens` | odczyt użytkownika po `Email`, zapis tokena odświeżającego |
| Rejestracja dealera | `Users`, `DealerProfiles`, `OutboxMessages` | zapis użytkownika i profilu, publikacja zdarzenia |
| Reset hasła / OTP | `Users`, `OtpRecords`, `OutboxMessages` | zapis OTP, później oznaczenie jako użyte |
| Administracja dealerami | `Users`, `DealerProfiles`, `OutboxMessages` | lista, szczegóły, akceptacja/odrzucenie dealera |
| Tworzenie agenta | `Users`, `OutboxMessages` | zapis użytkownika z rolą agenta/logistyki |

## CatalogInventoryMigrationsDB

### Schemat `dbo`

| Tabela | Kolumny | Klucze, indeksy i relacje |
|---|---|---|
| `Categories` | `CategoryId: Guid`, `Name: string`, `ParentCategoryId: Guid?` | PK `CategoryId`; self-FK `ParentCategoryId -> Categories.CategoryId`; hierarchia kategorii |
| `Products` | `ProductId: Guid`, `Sku: string`, `Name: string`, `Description: string`, `CategoryId: Guid`, `UnitPrice: decimal`, `MinOrderQty: int`, `TotalStock: int`, `ReservedStock: int`, `IsActive: bool`, `ImageUrl: string?`, `CreatedAtUtc: DateTime`, `UpdatedAtUtc: DateTime` | PK `ProductId`; FK `CategoryId -> Categories.CategoryId`; unikalny indeks `Sku`; `AvailableStock` jest wyliczane, nie jest kolumną |
| `StockTransactions` | `TxId: Guid`, `ProductId: Guid`, `TransactionType: StockTransactionType`, `Quantity: int`, `ReferenceId: string`, `CreatedAtUtc: DateTime` | PK `TxId`; FK `ProductId -> Products.ProductId`; historia zmian stocku |
| `StockSubscriptions` | `StockSubscriptionId: Guid`, `DealerId: Guid`, `ProductId: Guid`, `CreatedAtUtc: DateTime` | PK `StockSubscriptionId`; FK `ProductId -> Products.ProductId`; unikalny indeks `DealerId, ProductId`; subskrypcje powiadomień o stocku |
| `OutboxMessages` | `MessageId: Guid`, `EventType: string`, `Payload: string`, `Status: OutboxStatus`, `CreatedAtUtc: DateTime`, `PublishedAtUtc: DateTime?`, `RetryCount: int`, `Error: string?` | PK `MessageId`; zdarzenia wychodzące z Inventory |

### Główne Zapytania I Procesy

| Proces | Tabele | Uwagi |
|---|---|---|
| Lista produktów | `Products`, `Categories` | filtrowanie, sortowanie i paginacja po produktach |
| Szczegóły produktu | `Products`, `Categories` | odczyt danych produktu i kategorii |
| Utworzenie/edycja produktu | `Products`, `Categories`, `OutboxMessages` | walidacja kategorii i SKU, zapis produktu |
| Rezerwacja stocku przy zamówieniu | `Products`, `StockTransactions`, `OutboxMessages` | soft-lock stocku, zapis transakcji magazynowej |
| Subskrypcja stocku | `StockSubscriptions`, `Products` | zapis pary `DealerId + ProductId` |

## OrderMigrationsDB

### Schemat `dbo`

| Tabela | Kolumny | Klucze, indeksy i relacje |
|---|---|---|
| `Orders` | `OrderId: Guid`, `OrderNumber: string`, `DealerId: Guid`, `Status: OrderStatus`, `TotalAmount: decimal`, `CreditHoldStatus: CreditHoldStatus`, `PaymentMode: PaymentMode`, `PlacedAtUtc: DateTime`, `CancellationReason: string?` | PK `OrderId`; unikalny indeks `OrderNumber`; indeksy `DealerId, PlacedAtUtc` oraz `Status, PlacedAtUtc`; `DealerId` to logiczna relacja do Identity |
| `OrderLines` | `OrderLineId: Guid`, `OrderId: Guid`, `ProductId: Guid`, `ProductName: string`, `Sku: string`, `Quantity: int`, `UnitPrice: decimal` | PK `OrderLineId`; FK `OrderId -> Orders.OrderId`; `LineTotal` jest wyliczane; `ProductId` jest logiczną kopią z Catalog |
| `OrderStatusHistory` | `HistoryId: Guid`, `OrderId: Guid`, `FromStatus: OrderStatus`, `ToStatus: OrderStatus`, `ChangedByUserId: Guid`, `ChangedByRole: string`, `ChangedAtUtc: DateTime` | PK `HistoryId`; FK `OrderId -> Orders.OrderId`; historia statusów |
| `ReturnRequests` | `ReturnRequestId: Guid`, `OrderId: Guid`, `RequestedByDealerId: Guid`, `Reason: string`, `RequestedAtUtc: DateTime`, `IsApproved: bool`, `IsRejected: bool`, `ReviewedAtUtc: DateTime?` | PK `ReturnRequestId`; relacja 1:1 `OrderId -> Orders.OrderId`; obsługa zwrotów |
| `OrderSagaStates` | `OrderId: Guid`, `OrderNumber: string`, `DealerId: Guid`, `CurrentState: OrderSagaState`, `StartedAtUtc: DateTime`, `UpdatedAtUtc: DateTime`, `CompletedAtUtc: DateTime?`, `LastMessage: string?` | PK `OrderId`; stan sagi zamówienia; w EF brak jawnego FK do `Orders`, ale relacja jest logiczna przez `OrderId` |
| `OutboxMessages` | `MessageId: Guid`, `EventType: string`, `Payload: string`, `Status: OutboxStatus`, `CreatedAtUtc: DateTime`, `PublishedAtUtc: DateTime?`, `RetryCount: int`, `Error: string?` | PK `MessageId`; zdarzenia wychodzące z Order |

### Główne Zapytania I Procesy

| Proces | Tabele | Uwagi |
|---|---|---|
| Checkout / utworzenie zamówienia | `Orders`, `OrderLines`, `OrderStatusHistory`, `OrderSagaStates`, `OutboxMessages` | zapis agregatu zamówienia, historii statusu, stanu sagi i zdarzeń |
| Lista zamówień dealera | `Orders`, `OrderLines`, `OrderStatusHistory`, `ReturnRequests` | odczyt po `DealerId`, sortowanie po `PlacedAtUtc` |
| Admin listuje zamówienia | `Orders`, `OrderLines`, `OrderStatusHistory`, `ReturnRequests` | filtrowanie po statusie i paginacja |
| Zmiana statusu zamówienia | `Orders`, `OrderStatusHistory`, `OutboxMessages` | aktualizacja statusu i dopisanie historii |
| Zwrot zamówienia | `ReturnRequests`, `Orders`, `OrderStatusHistory`, `OutboxMessages` | zapis wniosku i decyzji zwrotowej |
| Analityka zamówień | `Orders`, `OrderLines` | agregacje przychodów, top dealerów i top produktów |

## LogisticsTrackingMigrationsDB

### Schemat `dbo`

| Tabela | Kolumny | Klucze, indeksy i relacje |
|---|---|---|
| `Shipments` | `ShipmentId: Guid`, `OrderId: Guid`, `DealerId: Guid`, `ShipmentNumber: string`, `DeliveryAddress: string`, `City: string`, `State: string`, `PostalCode: string`, `AssignedAgentId: Guid?`, `VehicleNumber: string?`, `AssignmentDecisionStatus: AssignmentDecisionStatus`, `AssignmentDecisionReason: string?`, `AssignmentDecisionAtUtc: DateTime?`, `DeliveryAgentRating: int?`, `DeliveryAgentRatingComment: string?`, `DeliveryAgentRatedAtUtc: DateTime?`, `DeliveryAgentRatedByUserId: Guid?`, `Status: ShipmentStatus`, `CreatedAtUtc: DateTime`, `DeliveredAtUtc: DateTime?` | PK `ShipmentId`; unikalny indeks `ShipmentNumber`; indeksy `DealerId, CreatedAtUtc`, `AssignedAgentId, CreatedAtUtc`, `CreatedAtUtc`; `OrderId`, `DealerId`, `AssignedAgentId` są relacjami logicznymi do innych baz |
| `ShipmentEvents` | `ShipmentEventId: Guid`, `ShipmentId: Guid`, `Status: ShipmentStatus`, `Note: string`, `UpdatedByUserId: Guid`, `UpdatedByRole: string`, `CreatedAtUtc: DateTime` | PK `ShipmentEventId`; FK `ShipmentId -> Shipments.ShipmentId`; historia statusów przesyłki |
| `ShipmentOpsStates` | `ShipmentId: Guid`, `HandoverState: HandoverState`, `HandoverExceptionReason: string?`, `RetryRequired: bool`, `RetryCount: int`, `RetryReason: string?`, `NextRetryAtUtc: DateTime?`, `LastRetryScheduledAtUtc: DateTime?`, `UpdatedAtUtc: DateTime` | PK `ShipmentId`; FK 1:1 `ShipmentId -> Shipments.ShipmentId`; operacyjny stan handover/retry |
| `OutboxMessages` | `MessageId: Guid`, `EventType: string`, `Payload: string`, `Status: OutboxStatus`, `CreatedAtUtc: DateTime`, `PublishedAtUtc: DateTime?`, `RetryCount: int`, `Error: string?` | PK `MessageId`; zdarzenia wychodzące z Logistics |

### Główne Zapytania I Procesy

| Proces | Tabele | Uwagi |
|---|---|---|
| Lista przesyłek | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates` | filtrowanie zależne od roli: dealer, agent, admin/logistics |
| Szczegóły przesyłki | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates` | odczyt przesyłki, historii i stanu operacyjnego |
| Aktualizacja statusu przesyłki | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | zapis statusu, eventu i ewentualnego stanu retry/handover |
| Przypisanie agenta | `Shipments`, `ShipmentEvents`, `OutboxMessages` | zapis `AssignedAgentId`, statusu decyzji i historii |
| Ocena dostawcy | `Shipments` | zapis pól `DeliveryAgentRating*` |

## PaymentInvoiceMigrationsDB

### Schemat `dbo`

| Tabela | Kolumny | Klucze, indeksy i relacje |
|---|---|---|
| `DealerCreditAccounts` | `AccountId: Guid`, `DealerId: Guid`, `CreditLimit: decimal`, `CurrentOutstanding: decimal` | PK `AccountId`; unikalny indeks `DealerId`; `AvailableCredit` jest wyliczane, nie jest kolumną |
| `Invoices` | `InvoiceId: Guid`, `InvoiceNumber: string`, `OrderId: Guid`, `DealerId: Guid`, `IdempotencyKey: string`, `Subtotal: decimal`, `GstType: GstType`, `GstRate: decimal`, `GstAmount: decimal`, `GrandTotal: decimal`, `PdfStoragePath: string`, `CreatedAtUtc: DateTime` | PK `InvoiceId`; unikalne indeksy `InvoiceNumber`, `IdempotencyKey`; indeks `DealerId, CreatedAtUtc`; `OrderId` i `DealerId` to relacje logiczne do innych baz |
| `InvoiceLines` | `InvoiceLineId: Guid`, `InvoiceId: Guid`, `ProductId: Guid`, `ProductName: string`, `Sku: string`, `HsnCode: string`, `Quantity: int`, `UnitPrice: decimal` | PK `InvoiceLineId`; FK `InvoiceId -> Invoices.InvoiceId`; `ProductId` to relacja logiczna do Catalog |
| `InvoiceWorkflowStates` | `InvoiceId: Guid`, `Status: InvoiceWorkflowStatus`, `DueAtUtc: DateTime`, `PromiseToPayAtUtc: DateTime?`, `NextFollowUpAtUtc: DateTime?`, `InternalNote: string`, `ReminderCount: int`, `LastReminderAtUtc: DateTime?`, `UpdatedAtUtc: DateTime` | PK `InvoiceId`; FK 1:1 `InvoiceId -> Invoices.InvoiceId`; bieżący stan windykacyjno-operacyjny faktury |
| `InvoiceWorkflowActivities` | `ActivityId: Guid`, `InvoiceId: Guid`, `Type: InvoiceWorkflowActivityType`, `Message: string`, `CreatedByRole: string`, `CreatedAtUtc: DateTime` | PK `ActivityId`; FK `InvoiceId -> Invoices.InvoiceId`; indeks `InvoiceId, CreatedAtUtc`; historia działań workflow |
| `PaymentRecords` | `PaymentRecordId: Guid`, `OrderId: Guid`, `DealerId: Guid`, `PaymentMode: PaymentMode`, `Amount: decimal`, `ReferenceNo: string?`, `CreatedAtUtc: DateTime` | PK `PaymentRecordId`; płatności powiązane logicznie z Order i Dealer |
| `OutboxMessages` | `MessageId: Guid`, `EventType: string`, `Payload: string`, `Status: OutboxStatus`, `CreatedAtUtc: DateTime`, `PublishedAtUtc: DateTime?`, `RetryCount: int`, `Error: string?` | PK `MessageId`; zdarzenia wychodzące z Payment/Invoice |

### Główne Zapytania I Procesy

| Proces | Tabele | Uwagi |
|---|---|---|
| Sprawdzenie limitu kredytowego | `DealerCreditAccounts` | odczyt `CreditLimit`, `CurrentOutstanding`, wyliczenie dostępnego limitu |
| Aktualizacja outstanding | `DealerCreditAccounts`, `OutboxMessages` | zmiana zadłużenia dealera |
| Wystawienie faktury | `Invoices`, `InvoiceLines`, `InvoiceWorkflowStates`, `OutboxMessages` | zapis faktury, pozycji i stanu workflow |
| Lista faktur | `Invoices`, `InvoiceLines`, `InvoiceWorkflowStates` | odczyt po dealerze lub dla admina |
| Szczegóły faktury | `Invoices`, `InvoiceLines`, `InvoiceWorkflowStates`, `InvoiceWorkflowActivities` | pełny obraz faktury i działań |
| Aktywność workflow faktury | `InvoiceWorkflowStates`, `InvoiceWorkflowActivities`, `OutboxMessages` | zmiana statusu, obietnica zapłaty, przypomnienia |
| Rejestracja płatności | `PaymentRecords`, `DealerCreditAccounts`, `OutboxMessages` | zapis płatności i korekta outstanding |

## NotificationMigrationsDB

### Schemat `dbo`

| Tabela | Kolumny | Klucze, indeksy i relacje |
|---|---|---|
| `Notifications` | `NotificationId: Guid`, `RecipientUserId: Guid?`, `Title: string`, `Body: string`, `SourceService: string`, `EventType: string`, `Channel: NotificationChannel`, `Status: NotificationStatus`, `CreatedAtUtc: DateTime`, `SentAtUtc: DateTime?`, `FailureReason: string?` | PK `NotificationId`; indeksy `RecipientUserId`, `CreatedAtUtc`, `RecipientUserId, CreatedAtUtc`; `RecipientUserId` to logiczna relacja do Identity |
| `OutboxMessages` | `MessageId: Guid`, `EventType: string`, `Payload: string`, `Status: OutboxStatus`, `CreatedAtUtc: DateTime`, `PublishedAtUtc: DateTime?`, `RetryCount: int`, `Error: string?` | PK `MessageId`; zdarzenia wychodzące z Notification |

### Główne Zapytania I Procesy

| Proces | Tabele | Uwagi |
|---|---|---|
| Lista powiadomień użytkownika | `Notifications` | odczyt po `RecipientUserId`, sortowanie po `CreatedAtUtc` |
| Utworzenie powiadomienia | `Notifications`, `OutboxMessages` | zapis wiadomości i zdarzenia wysyłkowego |
| Wysłanie/oznaczenie statusu | `Notifications` | aktualizacja `Status`, `SentAtUtc`, `FailureReason` |

## Skrypty Bazodanowe I Zapytania

| Plik | Cel | Uwagi dla agenta |
|---|---|---|
| `scripts/apply-migrations.ps1` | Uruchamia `dotnet ef database update` dla sześciu DbContextów. | To skrypt operacyjny. Nie edytować w trybie dokumentacyjnym. |
| `scripts/generate-migration-sql.ps1` | Generuje idempotentne skrypty SQL do `scripts/migrations/*.sql`. | Używany do odtworzenia artefaktów migracyjnych z EF. |
| `scripts/apply-indexing-patch.ps1` | Uruchamia `sqlcmd` dla `scripts/migrations/IndexingPatch.sql`. | Wymaga lokalnego SQL Server i `sqlcmd`. |
| `scripts/migrations/IdentityAuth.sql` | Skrypt migracyjny Identity. | Porównać z `IdentityAuthDbContext` przed uznaniem za aktualny. |
| `scripts/migrations/CatalogInventory.sql` | Skrypt migracyjny Catalog/Inventory. | Porównać z `CatalogInventoryDbContext` przed uznaniem za aktualny. |
| `scripts/migrations/Order.sql` | Skrypt migracyjny Order. | Może nie zawierać wszystkich nowszych tabel sagi. |
| `scripts/migrations/LogisticsTracking.sql` | Skrypt migracyjny Logistics. | Może nie zawierać wszystkich nowszych pól operacyjnych przesyłek. |
| `scripts/migrations/PaymentInvoice.sql` | Skrypt migracyjny Payment/Invoice. | Może nie zawierać wszystkich nowszych tabel workflow faktury. |
| `scripts/migrations/Notification.sql` | Skrypt migracyjny Notification. | Porównać z `NotificationDbContext` przed uznaniem za aktualny. |
| `scripts/migrations/IndexingPatch.sql` | Ręczny patch indeksów wydajnościowych. | Dodaje indeksy do tabel `Users`, `Orders`, `Shipments`, `Invoices`, `Notifications`. |

## Indeksy Z `IndexingPatch.sql`

| Baza | Tabela | Indeks logiczny |
|---|---|---|
| `IdentityAuthMigrationsDB` | `Users` | `Role, Status, CreatedAtUtc` |
| `OrderMigrationsDB` | `Orders` | `DealerId, PlacedAtUtc` |
| `OrderMigrationsDB` | `Orders` | `Status, PlacedAtUtc` |
| `LogisticsTrackingMigrationsDB` | `Shipments` | `DealerId, CreatedAtUtc` |
| `LogisticsTrackingMigrationsDB` | `Shipments` | `AssignedAgentId, CreatedAtUtc` |
| `LogisticsTrackingMigrationsDB` | `Shipments` | `CreatedAtUtc` |
| `PaymentInvoiceMigrationsDB` | `Invoices` | `DealerId, CreatedAtUtc` |
| `NotificationMigrationsDB` | `Notifications` | `RecipientUserId, CreatedAtUtc` |

## Mapa Ekranów I Procesów Do Tabel

Ta tabela jest punktem startowym. Każdy konkretny AOS musi doprecyzować kolumny odczytywane i zapisywane dla danego pola UI, przycisku i API.

| Ekran/proces | Route / obszar | Tabele uczestniczące | Relacje i uwagi |
|---|---|---|---|
| Logowanie | `login` | `Users`, `RefreshTokens` | `RefreshTokens.UserId -> Users.UserId`; po loginie frontend zwykle pobiera profil użytkownika |
| Rejestracja dealera | `register` | `Users`, `DealerProfiles`, `OutboxMessages` | `DealerProfiles.UserId -> Users.UserId`; `GstNumber` musi być unikalny |
| Reset hasła | `forgot-password` | `Users`, `OtpRecords`, `OutboxMessages` | `OtpRecords.UserId -> Users.UserId`; OTP ma czas ważności i status użycia |
| Profil użytkownika | `profile` | `Users`, `DealerProfiles` | dane konta i profil biznesowy dealera |
| Dashboard | `dashboard` | `Orders`, `OrderLines`, `Shipments`, `ShipmentEvents`, `Products`, `Categories`, `DealerCreditAccounts`, `Invoices`, `Notifications`, `Users`, `DealerProfiles` | ekran agregacyjny; fakty trzeba rozbijać według widgetu i roli |
| Lista produktów | `products` | `Products`, `Categories`, `StockSubscriptions` | `Products.CategoryId -> Categories.CategoryId`; subskrypcje są po `DealerId + ProductId` |
| Nowy/edycja produktu | `products/new`, `products/:id/edit` | `Products`, `Categories`, `OutboxMessages` | zapis produktu wymaga istniejącej kategorii |
| Szczegóły produktu | `products/:id` | `Products`, `Categories`, `StockTransactions`, `StockSubscriptions` | stock i subskrypcje wymagają osobnego potwierdzenia w API ekranu |
| Koszyk | `cart` | `Products` | koszyk jest głównie stanem frontendu; DB jest używana do odświeżenia danych produktu przed zamówieniem |
| Checkout / Create Order | `checkout` | `Products`, `StockTransactions`, `Orders`, `OrderLines`, `OrderStatusHistory`, `OrderSagaStates`, `DealerCreditAccounts`, `PaymentRecords`, `OutboxMessages` | proces przechodzi przez Catalog, Order i Payment; szczegóły w AOS `orders/checkout-create-order` |
| Lista zamówień | `orders` | `Orders`, `OrderLines`, `OrderStatusHistory`, `ReturnRequests`, `OrderSagaStates` | odczyt po dealerze albo administracyjnie po statusie |
| Szczegóły zamówienia | `orders/:id` | `Orders`, `OrderLines`, `OrderStatusHistory`, `ReturnRequests`, `OutboxMessages` | zmiany statusu dopisują historię i zdarzenia |
| Tracking zamówienia | `orders/:id/tracking` | `Orders`, `Shipments`, `ShipmentEvents`, `ShipmentOpsStates` | `Orders.OrderId` jest logicznie powiązane z `Shipments.OrderId` |
| Lista przesyłek | `shipments` | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates` | filtrowanie po `DealerId` albo `AssignedAgentId` zależnie od roli |
| Szczegóły przesyłki | `shipments/:id` | `Shipments`, `ShipmentEvents`, `ShipmentOpsStates`, `OutboxMessages` | status, assignment, handover, retry i rating zapisują różne kolumny `Shipments` / `ShipmentOpsStates` |
| Lista faktur | `invoices` | `Invoices`, `InvoiceLines`, `InvoiceWorkflowStates`, `DealerCreditAccounts`, `PaymentRecords` | zależnie od roli: dealer widzi swoje faktury, admin widzi więcej danych finansowych |
| Szczegóły faktury | `invoices/:id` | `Invoices`, `InvoiceLines`, `InvoiceWorkflowStates`, `InvoiceWorkflowActivities`, `Notifications`, `OutboxMessages` | workflow faktury może generować aktywności i powiadomienia |
| Powiadomienia | `notifications` | `Notifications`, `OutboxMessages` | odczyt po `RecipientUserId`; status wysyłki zapisany w `Notifications` |
| Administracja dealerami | `admin/dealers`, `admin/dealers/:id` | `Users`, `DealerProfiles`, `DealerCreditAccounts`, `Invoices`, `PaymentRecords`, `OutboxMessages` | Identity jest źródłem konta, Payment źródłem finansów |
| Tworzenie agenta | `admin/agents/create` | `Users`, `OutboxMessages` | zapis użytkownika z odpowiednią rolą |

## Wymagany Format Mapowania W AOS

Dla każdego opisywanego ekranu, menu albo procesu AOS musi zawierać:

| Element | Co wpisać |
|---|---|
| Ekran/pole/akcja | nazwa pola UI, przycisku, filtra, kolumny tabeli lub operacji |
| API | endpoint frontendowy i backendowy, metoda HTTP, DTO wejścia/wyjścia |
| Proces | handler, serwis aplikacyjny, metoda domenowa, integracje |
| Odczyt danych | baza, schemat, tabela, kolumna, filtr, sortowanie, paginacja |
| Zapis danych | baza, schemat, tabela, kolumna, warunek zapisu, transakcja, efekty uboczne |
| Relacje | FK fizyczny albo relacja logiczna przez `Guid`; wskazać obie strony relacji |
| Walidacje | walidator, reguła domenowa, ograniczenie DB, unikalny indeks |
| Dowód | plik kodu: komponent, API service, kontroler, handler, serwis, repozytorium, DbContext, encja albo skrypt SQL |
| Status faktu | `potwierdzone`, `do potwierdzenia`, `brak w kodzie`, `wniosek z analizy` |

## Minimalna Ścieżka Dla Agenta

1. Zacznij od route i komponentu frontendu.
2. Znajdź metodę Angular API i DTO.
3. Przejdź przez Ocelot do kontrolera backendowego.
4. Przejdź do command/query handlera i serwisu aplikacyjnego.
5. Znajdź repozytorium i `DbContext`.
6. Potwierdź tabelę, kolumny, indeksy i relacje w encji oraz konfiguracji EF.
7. Jeżeli istnieje skrypt SQL, porównaj go z EF i zapisz zgodność albo rozbieżność.
8. Dopiero wtedy wpisz tabelę i kolumnę w AOS jako fakt.
