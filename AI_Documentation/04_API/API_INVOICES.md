# API_INVOICES

Status: `potwierdzone` na podstawie `PaymentController.cs` i `PaymentDtos.cs`.

Serwis: `PaymentInvoice.API` — gateway prefix `/payments`

| ID | Metoda | Ścieżka | Kontroler | Rola | Request DTO | Response DTO | Statusy |
|---|---|---|---|---|---|---|---|
| `API-INV-001` | `POST` | `/payments/api/payment/invoices` | `PaymentController.GenerateInvoice` | `Admin` | `GenerateInvoiceRequest` | `InvoiceDto` | `201` |
| `API-INV-002` | `GET` | `/payments/api/payment/invoices/{invoiceId}` | `PaymentController.GetInvoiceById` | `Admin,Dealer` | route `invoiceId:guid` | `InvoiceDto` | `200`, `404` |
| `API-INV-003` | `GET` | `/payments/api/payment/dealers/{dealerId}/invoices` | `PaymentController.GetDealerInvoices` | `Admin,Dealer` (Dealer widzi tylko swoje) | route `dealerId:guid` | `IReadOnlyList<InvoiceDto>` | `200`, `403` |
| `API-INV-004` | `GET` | `/payments/api/payment/invoices/{invoiceId}/download` | `PaymentController.DownloadInvoice` | `Admin,Dealer` | route `invoiceId:guid` | PDF plik binarny | `200`, `404` |
| `API-INV-010` | `GET` | `/payments/api/payment/invoices/{invoiceId}/workflow` | `PaymentController.GetInvoiceWorkflow` | `Admin,Dealer` | route `invoiceId:guid` | `InvoiceWorkflowStateDto` | `200`, `404` |
| `API-INV-011` | `PUT` | `/payments/api/payment/invoices/{invoiceId}/workflow` | `PaymentController.UpsertInvoiceWorkflow` | `Admin,Dealer` | route + `UpsertInvoiceWorkflowRequest` | `InvoiceWorkflowStateDto` | `200`, `404` |
| `API-INV-012` | `GET` | `/payments/api/payment/dealers/{dealerId}/invoice-workflows` | `PaymentController.GetDealerInvoiceWorkflows` | `Admin,Dealer` (Dealer widzi tylko swoje) | route `dealerId:guid` | `IReadOnlyList<InvoiceWorkflowStateDto>` | `200`, `403` |
| `API-INV-020` | `GET` | `/payments/api/payment/invoices/{invoiceId}/workflow-activities` | `PaymentController.GetInvoiceWorkflowActivities` | `Admin,Dealer` | route `invoiceId:guid` | `IReadOnlyList<InvoiceWorkflowActivityDto>` | `200` |
| `API-INV-021` | `POST` | `/payments/api/payment/invoices/{invoiceId}/workflow-activities` | `PaymentController.AddInvoiceWorkflowActivity` | `Admin,Dealer` | route + `AddInvoiceWorkflowActivityRequest` | `InvoiceWorkflowActivityDto` | `200`, `404` |
| `API-PAY-001` | `POST` | `/payments/api/payment/gateway/orders` | `PaymentController.CreateGatewayOrder` | `Dealer` | `CreateGatewayOrderRequest` | `GatewayOrderDto` | `200`, `401` |
| `API-PAY-002` | `POST` | `/payments/api/payment/gateway/verify` | `PaymentController.VerifyGatewayPayment` | `Dealer` | `VerifyGatewayPaymentRequest` | `GatewayPaymentVerificationDto` | `200`, `401` |
| `API-PAY-010` | `POST` | `/payments/api/payment/dealers/{dealerId}/account` | `PaymentController.SeedDealerAccount` | `Admin` | route + `SeedDealerAccountRequest` | `DealerCreditAccountDto` | `200` |
| `API-PAY-011` | `GET` | `/payments/api/payment/dealers/{dealerId}/credit-check` | `PaymentController.CheckCredit` | `Admin,Dealer` | route + query `amount:decimal` | `CreditCheckResponse` | `200`, `403` |
| `API-PAY-012` | `PUT` | `/payments/api/payment/dealers/{dealerId}/credit-limit` | `PaymentController.UpdateCreditLimit` | `Admin` | route + `UpdateCreditLimitRequest` | `DealerCreditAccountDto` | `200`, `404` |
| `API-PAY-020` | `POST` | `/payments/api/payment/dealers/{dealerId}/settlements` | `PaymentController.SettleOutstanding` | `Admin,Dealer` (Dealer tylko swoje) | route + `SettleOutstandingRequest` | `DealerCreditAccountDto` | `200`, `403`, `404` |
| `API-INT-001` | `GET` | `/payments/api/payment/internal/dealers/{dealerId}/credit-check` | `PaymentController.CheckCreditInternal` | `[AllowAnonymous]` + `X-Internal-Api-Key` | route + query `amount` | `CreditCheckResponse` | `200`, `401` |
| `API-INT-002` | `PUT` | `/payments/api/payment/internal/dealers/{dealerId}/credit-limit` | `PaymentController.UpdateCreditLimitInternal` | `[AllowAnonymous]` + `X-Internal-Api-Key` | route + `UpdateCreditLimitRequest` | `DealerCreditAccountDto` | `200`, `401`, `404` |
| `API-INT-003` | `POST` | `/payments/api/payment/internal/dealers/{dealerId}/settlements` | `PaymentController.SettleOutstandingInternal` | `[AllowAnonymous]` + `X-Internal-Api-Key` | route + `SettleOutstandingRequest` | `DealerCreditAccountDto` | `200`, `401`, `404` |
| `API-INT-004` | `POST` | `/payments/api/payment/internal/dealers/{dealerId}/outstanding` | `PaymentController.AddOutstandingInternal` | `[AllowAnonymous]` + `X-Internal-Api-Key` | route + `AddOutstandingRequest` | `DealerCreditAccountDto` | `200`, `401`, `404` |

---

## 1. Faktury (Invoices)

### POST /api/payment/invoices

**Opis:** Generuje fakturę dla zamówienia. Wywoływany przez serwis `Order` po zatwierdzeniu zamówienia (lub manualnie przez Admina). Tworzy PDF i zapisuje ścieżkę.

**Rola:** `[Authorize(Roles="Admin")]`

**Przykład żądania:**
```json
{
  "orderId": "aab85f64-5717-4562-b3fc-2c963f66afa6",
  "dealerId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "isInterstate": false,
  "paymentMode": "Credit",
  "lines": [
    {
      "productId": "1bc95f64-5717-4562-b3fc-2c963f66afa6",
      "productName": "Śruba M6x20",
      "sku": "SCREW-M6-20",
      "hsnCode": "7318",
      "quantity": 100,
      "unitPrice": 0.50
    }
  ]
}
```

**Przykład odpowiedzi (201):**
```json
{
  "invoiceId": "9ff95f64-5717-4562-b3fc-2c963f66afa6",
  "invoiceNumber": "INV-2026-0001",
  "orderId": "aab85f64-5717-4562-b3fc-2c963f66afa6",
  "dealerId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "idempotencyKey": "order-aab85f64",
  "gstType": "CGST+SGST",
  "gstRate": 18.0,
  "subtotal": 50.00,
  "gstAmount": 9.00,
  "grandTotal": 59.00,
  "pdfStoragePath": "/invoices/INV-2026-0001.pdf",
  "createdAtUtc": "2026-06-02T10:00:00Z",
  "lines": [
    {
      "invoiceLineId": "1aa00000-0000-0000-0000-000000000001",
      "productId": "1bc95f64-5717-4562-b3fc-2c963f66afa6",
      "productName": "Śruba M6x20",
      "sku": "SCREW-M6-20",
      "hsnCode": "7318",
      "quantity": 100,
      "unitPrice": 0.50,
      "lineTotal": 50.00
    }
  ]
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Walidacja — brak linii, nieprawidłowe dane |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |
| `409` | Faktura dla tego zamówienia już istnieje (idempotency key) |

---

### GET /api/payment/invoices/{invoiceId}

**Opis:** Szczegóły faktury. Dealer może pobierać tylko własne faktury (weryfikacja `dealerId` po pobraniu).

**Rola:** `[Authorize(Roles="Admin,Dealer")]`

**Przykład odpowiedzi (200):** identyczny format jak `GenerateInvoice`

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Dealer |
| `404` | Faktura nie istnieje |

---

### GET /api/payment/dealers/{dealerId}/invoices

**Opis:** Lista wszystkich faktur dealera. Dealer może pobierać tylko własne faktury (`dealerId` z tokenu musi pasować). Dla kont demo (`@supplychain.local`) dane mogą być seetowane automatycznie.

**Rola:** `[Authorize(Roles="Admin,Dealer")]`

**Przykład odpowiedzi (200):**
```json
[
  {
    "invoiceId": "9ff95f64-5717-4562-b3fc-2c963f66afa6",
    "invoiceNumber": "INV-2026-0001",
    "grandTotal": 59.00,
    "createdAtUtc": "2026-06-02T10:00:00Z"
  }
]
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Dealer próbuje pobrać faktury innego dealera |

---

### GET /api/payment/invoices/{invoiceId}/download

**Opis:** Pobiera plik PDF faktury. Zwraca `application/pdf` z nagłówkiem `Content-Disposition`.

**Rola:** `[Authorize(Roles="Admin,Dealer")]`

**Odpowiedź (200):** strumień binarny PDF

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Dealer |
| `404` | Faktura nie istnieje lub plik PDF nie jest dostępny |

---

## 2. Workflow Faktur

### GET /api/payment/invoices/{invoiceId}/workflow

**Opis:** Pobiera stan workflow windykacji dla faktury.

**Rola:** `[Authorize(Roles="Admin,Dealer")]`

**Przykład odpowiedzi (200):**
```json
{
  "invoiceId": "9ff95f64-5717-4562-b3fc-2c963f66afa6",
  "status": "Pending",
  "dueAtUtc": "2026-06-30T00:00:00Z",
  "promiseToPayAtUtc": null,
  "nextFollowUpAtUtc": "2026-06-10T09:00:00Z",
  "internalNote": "Pierwszy kontakt — brak odpowiedzi.",
  "reminderCount": 1,
  "lastReminderAtUtc": "2026-06-05T10:00:00Z",
  "updatedAtUtc": "2026-06-05T10:01:00Z"
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Dealer |
| `404` | Workflow dla tej faktury nie istnieje |

---

### PUT /api/payment/invoices/{invoiceId}/workflow

**Opis:** Upsert (utwórz lub zaktualizuj) stan workflow dla faktury. Używany przez moduł InvoiceJet do śledzenia statusu płatności.

**Rola:** `[Authorize(Roles="Admin,Dealer")]`

**Przykład żądania:**
```json
{
  "status": "FollowUp",
  "dueAtUtc": "2026-06-30T00:00:00Z",
  "promiseToPayAtUtc": "2026-06-20T00:00:00Z",
  "nextFollowUpAtUtc": "2026-06-15T09:00:00Z",
  "internalNote": "Dealer obiecał zapłatę do 20 czerwca.",
  "reminderCount": 2,
  "lastReminderAtUtc": "2026-06-08T10:00:00Z"
}
```

**Przykład odpowiedzi (200):** identyczny format jak `GetInvoiceWorkflow`

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Walidacja — brak `status`, `dueAtUtc` |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Dealer |
| `404` | Faktura nie istnieje |

---

### GET /api/payment/dealers/{dealerId}/invoice-workflows

**Opis:** Lista stanów workflow wszystkich faktur dealera.

**Rola:** `[Authorize(Roles="Admin,Dealer")]` (Dealer widzi tylko swoje)

**Przykład odpowiedzi (200):**
```json
[
  {
    "invoiceId": "9ff95f64-...",
    "status": "FollowUp",
    "dueAtUtc": "2026-06-30T00:00:00Z"
  }
]
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Dealer próbuje pobrać dane innego dealera |

---

## 3. Aktywności Workflow

### GET /api/payment/invoices/{invoiceId}/workflow-activities

**Opis:** Historia działań windykacyjnych (telefony, emaile, notatki) dla danej faktury.

**Rola:** `[Authorize(Roles="Admin,Dealer")]`

**Przykład odpowiedzi (200):**
```json
[
  {
    "activityId": "aab00000-0000-0000-0000-000000000001",
    "invoiceId": "9ff95f64-5717-4562-b3fc-2c963f66afa6",
    "type": "Call",
    "message": "Zadzwoniono — brak odpowiedzi.",
    "createdByRole": "Admin",
    "createdAtUtc": "2026-06-05T10:00:00Z"
  }
]
```

---

### POST /api/payment/invoices/{invoiceId}/workflow-activities

**Opis:** Dodaje nową aktywność windykacyjną do faktury.

**Rola:** `[Authorize(Roles="Admin,Dealer")]`

**Przykład żądania:**
```json
{
  "type": "Email",
  "message": "Wysłano drugi przypomnienie o płatności.",
  "createdByRole": "Admin"
}
```

**Przykład odpowiedzi (200):**
```json
{
  "activityId": "bbc11111-0000-0000-0000-000000000002",
  "invoiceId": "9ff95f64-5717-4562-b3fc-2c963f66afa6",
  "type": "Email",
  "message": "Wysłano drugi przypomnienie o płatności.",
  "createdByRole": "Admin",
  "createdAtUtc": "2026-06-08T10:00:00Z"
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak `type` lub `message` |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Dealer |
| `404` | Faktura nie istnieje |

---

## 4. Gateway Płatniczy

### POST /api/payment/gateway/orders

**Opis:** Tworzy zlecenie płatności w zewnętrznej bramce (np. Razorpay). Dealer inicjuje płatność online.

**Rola:** `[Authorize(Roles="Dealer")]`

**Przykład żądania:**
```json
{
  "amount": 59.00,
  "currency": "INR",
  "description": "Faktura INV-2026-0001",
  "receipt": "INV-2026-0001"
}
```

**Przykład odpowiedzi (200):**
```json
{
  "provider": "Razorpay",
  "keyId": "rzp_test_xxxx",
  "gatewayOrderId": "order_ABC123",
  "amountMinor": 5900,
  "amount": 59.00,
  "currency": "INR",
  "receipt": "INV-2026-0001",
  "description": "Faktura INV-2026-0001",
  "testMode": true
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak `amount` |
| `401` | Brak tokenu lub nieprawidłowy `sub` |
| `403` | Rola inna niż Dealer |

---

### POST /api/payment/gateway/verify

**Opis:** Weryfikuje podpis płatności z bramki po zakończeniu transakcji przez dealera.

**Rola:** `[Authorize(Roles="Dealer")]`

**Przykład żądania:**
```json
{
  "gatewayOrderId": "order_ABC123",
  "gatewayPaymentId": "pay_XYZ789",
  "signature": "hmac_sha256_...",
  "amount": 59.00,
  "currency": "INR",
  "receipt": "INV-2026-0001",
  "description": "Faktura INV-2026-0001"
}
```

**Przykład odpowiedzi (200):**
```json
{
  "verified": true,
  "provider": "Razorpay",
  "gatewayOrderId": "order_ABC123",
  "gatewayPaymentId": "pay_XYZ789",
  "failureReason": null
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Nieprawidłowy podpis |
| `401` | Brak tokenu lub nieprawidłowy `sub` |
| `403` | Rola inna niż Dealer |

---

## 5. Konto Kredytowe Dealera

### POST /api/payment/dealers/{dealerId}/account

**Opis:** Inicjuje konto kredytowe dealera (seed). Wywoływany po zatwierdzeniu dealera przez Admina.

**Rola:** `[Authorize(Roles="Admin")]`

**Przykład żądania:**
```json
{
  "initialCreditLimit": 50000.00
}
```

**Przykład odpowiedzi (200):**
```json
{
  "accountId": "ccc00000-0000-0000-0000-000000000001",
  "dealerId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "creditLimit": 50000.00,
  "currentOutstanding": 0.00,
  "availableCredit": 50000.00
}
```

---

### GET /api/payment/dealers/{dealerId}/credit-check

**Opis:** Sprawdza, czy dealer ma wystarczający dostępny kredyt dla podanej kwoty.

**Rola:** `[Authorize(Roles="Admin,Dealer")]` (Dealer tylko swoje — weryfikacja `dealerId`)

**Parametr query:** `amount=59.00`

**Przykład odpowiedzi (200):**
```json
{
  "approved": true,
  "availableCredit": 49941.00,
  "creditLimit": 50000.00,
  "currentOutstanding": 59.00
}
```

---

### PUT /api/payment/dealers/{dealerId}/credit-limit

**Opis:** Aktualizuje limit kredytowy dealera w PaymentInvoice. Wywoływane przez IdentityAuth po zmianie limitu przez Admina.

**Rola:** `[Authorize(Roles="Admin")]`

**Przykład żądania:**
```json
{
  "creditLimit": 100000.00
}
```

**Przykład odpowiedzi (200):** `DealerCreditAccountDto` z nowym limitem.

---

### POST /api/payment/dealers/{dealerId}/settlements

**Opis:** Rozlicza część lub całość zaległości dealera (np. po wpływie przelewu).

**Rola:** `[Authorize(Roles="Admin,Dealer")]` (Dealer tylko swoje)

**Przykład żądania:**
```json
{
  "amount": 59.00,
  "referenceNo": "PRZELEW-20260602"
}
```

**Przykład odpowiedzi (200):** `DealerCreditAccountDto` z zaktualizowanym `currentOutstanding`.

---

## 6. Endpointy Wewnętrzne (Internal)

Dostępne wyłącznie dla komunikacji service-to-service. Wymagają nagłówka `X-Internal-Api-Key`.

| Endpoint | Opis |
|---|---|
| `GET /internal/dealers/{dealerId}/credit-check` | Sprawdzenie kredytu przez Order service przed przyjęciem zamówienia |
| `PUT /internal/dealers/{dealerId}/credit-limit` | Synchronizacja limitu z IdentityAuth |
| `POST /internal/dealers/{dealerId}/settlements` | Rozliczenie z Order service |
| `POST /internal/dealers/{dealerId}/outstanding` | Dodanie zaległości po zatwierdzeniu zamówienia kredytowego (`AddOutstandingRequest`: `OrderId`, `PaymentMode`, `Amount`, `ReferenceNo?`) |

**Błędy wspólne dla internal:**
| Kod | Opis |
|---|---|
| `401` | Brak lub nieprawidłowy nagłówek `X-Internal-Api-Key` |
| `404` | Dealer/konto nie istnieje |

---

## Kontrakty Danych

| DTO | Pola kluczowe | Opis |
|---|---|---|
| `GenerateInvoiceRequest` | `OrderId`, `DealerId`, `IsInterstate`, `PaymentMode`, `Lines[]` | Dane do generowania faktury |
| `InvoiceLineInput` | `ProductId`, `ProductName`, `Sku`, `HsnCode`, `Quantity`, `UnitPrice` | Linia faktury (wejście) |
| `InvoiceDto` | `InvoiceId`, `InvoiceNumber`, `OrderId`, `DealerId`, `GstType`, `GstRate`, `Subtotal`, `GstAmount`, `GrandTotal`, `PdfStoragePath`, `CreatedAtUtc`, `Lines[]` | Pełna faktura |
| `InvoiceLineDto` | `InvoiceLineId`, `ProductId`, `ProductName`, `Sku`, `HsnCode`, `Quantity`, `UnitPrice`, `LineTotal` | Linia faktury (wyjście) |
| `UpsertInvoiceWorkflowRequest` | `Status`, `DueAtUtc`, `PromiseToPayAtUtc?`, `NextFollowUpAtUtc?`, `InternalNote`, `ReminderCount`, `LastReminderAtUtc?` | Upsert workflow faktury |
| `InvoiceWorkflowStateDto` | `InvoiceId`, `Status`, `DueAtUtc`, `PromiseToPayAtUtc?`, `NextFollowUpAtUtc?`, `InternalNote`, `ReminderCount`, `LastReminderAtUtc?`, `UpdatedAtUtc` | Stan workflow |
| `AddInvoiceWorkflowActivityRequest` | `Type`, `Message`, `CreatedByRole` | Nowa aktywność windykacyjna |
| `InvoiceWorkflowActivityDto` | `ActivityId`, `InvoiceId`, `Type`, `Message`, `CreatedByRole`, `CreatedAtUtc` | Zapis aktywności |
| `DealerCreditAccountDto` | `AccountId`, `DealerId`, `CreditLimit`, `CurrentOutstanding`, `AvailableCredit` | Konto kredytowe dealera |
| `CreditCheckResponse` | `Approved`, `AvailableCredit`, `CreditLimit`, `CurrentOutstanding` | Wynik sprawdzenia kredytu |
| `AddOutstandingRequest` | `OrderId`, `PaymentMode`, `Amount`, `ReferenceNo?` | Dodanie zaległości (internal) |
| `SettleOutstandingRequest` | `Amount`, `ReferenceNo?` | Rozliczenie zaległości |
| `CreateGatewayOrderRequest` | `Amount`, `Currency?`, `Description?`, `Receipt?` | Zlecenie bramki płatniczej |
| `GatewayOrderDto` | `Provider`, `KeyId`, `GatewayOrderId`, `AmountMinor`, `Amount`, `Currency`, `Receipt`, `Description`, `TestMode` | Odpowiedź bramki |
| `VerifyGatewayPaymentRequest` | `GatewayOrderId`, `GatewayPaymentId`, `Signature`, `Amount`, `Currency?`, `Receipt?`, `Description?` | Weryfikacja płatności |
| `GatewayPaymentVerificationDto` | `Verified`, `Provider`, `GatewayOrderId`, `GatewayPaymentId`, `FailureReason?` | Wynik weryfikacji |

## Uwagi

- Endpoint `/download` zwraca plik fizyczny przez `PhysicalFile` — brak JSON w odpowiedzi.
- Scope dealera jest weryfikowany przez pomocniczą metodę `EnsureDealerScope` — Dealer może operować tylko na własnym `dealerId` (z JWT claim `sub`).
- Konta demo (`@supplychain.local`) mają automatyczne seedy faktur przy pierwszym zapytaniu listy.
- Endpointy internal nie są wystawione przez Ocelot gateway — dostępne wyłącznie w sieci wewnętrznej Docker.
