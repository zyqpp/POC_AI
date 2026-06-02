# A-019-0005 markPaid

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-019-0005` |
| Ekran | [E-019](../E-019__README.md) |
| Nazwa wykryta | `markPaid` |
| Typ detekcji | `click` |
| Źródło | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Oznaczenie faktury jako zapłaconej. Dostępne tylko dla Admin. Zmienia status workflow na `paid`. Loguje aktywność `marked-paid`. Po oznaczeniu jako opłacone akcje reminder/escalate/dispute są zablokowane.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | Przycisk "Mark Paid" (disabled gdy `workflowComputedStatus() === 'paid'` lub `opsActionLoading()`) | `wniosek z analizy` |
| Metoda komponentu | `InvoiceDetailComponent.markPaid()` | `wniosek z analizy` |
| Serwis frontend | `InvoiceWorkflowService.update(invoiceId, createdAtUtc, {status: 'paid'})` | `wniosek z analizy` |
| Endpoint API | `PUT /payments/api/payment/invoices/{id}/workflow` z `{status: 'paid'}` | `wniosek z analizy` |
| Komenda/zapytanie | `UpsertInvoiceWorkflowCommand` → `UpsertInvoiceWorkflowCommandHandler` | `wniosek z analizy` |
| Walidacje | brak UI; backend: status enum | `wniosek z analizy` |
| Skutek w bazie | `InvoiceWorkflowStates.Status = 'paid'` (szacowane) | `wniosek z analizy` |

## Testy

- [Macierz testów ekranu](../TC-019_TESTY/TC-019__INDEX.md)
- Dane wejściowe: `invoiceId` z trasy URL.
- Oczekiwany rezultat: `workflowComputedStatus() === 'paid'`; badge "Paid" zielony; toast "Invoice marked as paid".

## Linki

- [Indeks akcji](A-019__INDEX.md)
- [Pola ekranu](../P-019_POLA/P-019__INDEX.md)
- [Ślad ekranu](../E-019__LINKI.md)
