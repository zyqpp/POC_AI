# A-019-0002 saveWorkflow

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-019-0002` |
| Ekran | [E-019](../E-019__README.md) |
| Nazwa wykryta | `saveWorkflow` |
| Typ detekcji | `click` |
| Źródło | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Zapis stanu workflow kolekcji faktury. Dostępne tylko dla Admin. Wysyła PUT do backend z nowym statusem, datą wymagalności i notatką wewnętrzną. Po sukcesie loguje aktywność `workflow-saved`.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | Przycisk "Save workflow" w panelu Collection Workflow | `wniosek z analizy` |
| Metoda komponentu | `InvoiceDetailComponent.saveWorkflow()` | `wniosek z analizy` |
| Serwis frontend | `InvoiceWorkflowService.update(invoiceId, createdAtUtc, {status, dueAtUtc, internalNote})` | `wniosek z analizy` |
| Endpoint API | `PUT /payments/api/payment/invoices/{id}/workflow` | `wniosek z analizy` |
| Komenda/zapytanie | `UpsertInvoiceWorkflowCommand` → `UpsertInvoiceWorkflowCommandHandler` w `PaymentCommands.cs` | `wniosek z analizy` |
| Walidacje | brak walidacji UI; backend: status musi być jednym z enum InvoiceWorkflowStatus | `wniosek z analizy` |
| Skutek w bazie | Upsert rekordu `InvoiceWorkflowStates` (szacowane) | `wniosek z analizy` |

## Algorytm InvoiceWorkflow (UpsertInvoiceWorkflowCommandHandler)

`UpsertInvoiceWorkflowCommandHandler` deleguje do `IPaymentInvoiceService.UpsertInvoiceWorkflowAsync`. Logika upsert: jeśli rekord workflow dla danego `InvoiceId` istnieje — aktualizuje pola (`Status`, `DueAtUtc`, `InternalNote`, `PromiseToPayAtUtc`, `NextFollowUpAtUtc`). Jeśli nie istnieje — tworzy nowy rekord.

Frontend (`InvoiceWorkflowService.computeAutomationPatch`) automatycznie oblicza patch przy załadowaniu szczegółu: jeśli status `promise-to-pay` i `promiseToPayAtUtc` minął — patch zmienia status na `reminder-sent` (auto follow-up trigger).

## Diagram Przepływu

```mermaid
sequenceDiagram
    actor A as Admin
    participant C as InvoiceDetailComponent
    participant WS as InvoiceWorkflowService
    participant API as PaymentApiService
    participant BE as UpsertInvoiceWorkflowCommandHandler
    A->>C: Ustaw status/dueDate/note, klik "Save workflow"
    C->>C: opsSaving = true
    C->>WS: update(invoiceId, createdAtUtc, {status, dueAtUtc, note})
    WS->>API: PUT /payments/api/payment/invoices/{id}/workflow
    API->>BE: UpsertInvoiceWorkflowCommand
    BE-->>API: InvoiceWorkflowStateDto
    API-->>WS: InvoiceWorkflowState
    WS-->>C: next(state)
    C->>C: applyWorkflow(state); recordActivity('workflow-saved',...)
    C->>C: opsSaving = false; toast.success
```

## Przykład HTTP

```http
PUT /payments/api/payment/invoices/{id}/workflow
Content-Type: application/json
Authorization: Bearer {token}

{
  "status": "reminder-sent",
  "dueAtUtc": "2024-12-31T23:59:59.999Z",
  "internalNote": "Przypomnienie wysłane telefonicznie"
}
```

## Testy

- [Macierz testów ekranu](../TC-019_TESTY/TC-019__INDEX.md)
- Dane wejściowe: `workflowStatus`, `workflowDueDate`, `workflowNote`.
- Oczekiwany rezultat: workflow state zaktualizowany, toast "Collection workflow updated", aktywność `workflow-saved` w historii.

## Linki

- [Indeks akcji](A-019__INDEX.md)
- [Pola ekranu](../P-019_POLA/P-019__INDEX.md)
- [Ślad ekranu](../E-019__LINKI.md)
