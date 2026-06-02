# E-019 InvoiceDetailComponent

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-019` |
| Route | `/invoices/:id` |
| Komponent | `InvoiceDetailComponent` |
| Guardy | `roleGuard` |
| Role frontendu | `Admin, Dealer` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` |
| Status faktów | `wniosek z analizy` |

## Cel Ekranu

Szczegółowy widok faktury z pozycjami (produkty, ilości, ceny), danymi dealera i podsumowaniem. Umożliwia płatność gateway (wyłączony w dev) lub pobranie PDF. Workflow faktur jest zarządzany przez `InvoiceWorkflow` w PaymentInvoice service.

Admin widzi panel kolekcji należności (Collection Workflow) z możliwością: ustawienia dueDate, zmiany statusu, wysłania przypomnienia, ustawienia promise-to-pay, oznaczenia jako zapłacone lub eskalacji. Historia działań (workflow activities) jest logowana per faktura.

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.ts` | Komponent szczegółu faktury — workflow, download, activities |
| `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` | Template z detalami faktury, tabelą pozycji, panelem workflow |
| `supply-chain-frontend/src/app/core/api/payment-api.service.ts` | `getInvoiceById()`, `downloadInvoice()`, `upsertInvoiceWorkflow()`, `addInvoiceWorkflowActivity()` |
| `supply-chain-frontend/src/app/core/services/invoice-workflow.service.ts` | `InvoiceWorkflowService.get()`, `update()`, `markReminderSent()`, `setPromiseToPay()`, `computeAutomationPatch()` |
| `supply-chain-frontend/src/app/core/services/invoice-workflow-activity.service.ts` | `InvoiceWorkflowActivityService.list()`, `add()` |
| `services/PaymentInvoice/PaymentInvoice.Application/Features/Payments/Commands/PaymentCommands.cs` | `UpsertInvoiceWorkflowCommandHandler`, `AddInvoiceWorkflowActivityCommandHandler` |
| `services/PaymentInvoice/PaymentInvoice.Application/Features/Payments/Queries/PaymentQueries.cs` | `GetInvoiceWorkflowQueryHandler`, `GetDealerInvoiceWorkflowsQueryHandler`, `GetInvoiceWorkflowActivitiesQueryHandler` |

## Główne Wywołania API

| Metoda | Endpoint | Opis |
|---|---|---|
| `GET` | `/payments/api/payment/invoices/{id}` | Pobieranie danych faktury |
| `GET` | `/payments/api/payment/invoices/{id}/workflow` | Pobieranie stanu workflow |
| `PUT` | `/payments/api/payment/invoices/{id}/workflow` | Aktualizacja workflow (status, dueDate, note) |
| `GET` | `/payments/api/payment/invoices/{id}/workflow-activities` | Historia aktywności workflow |
| `POST` | `/payments/api/payment/invoices/{id}/workflow-activities` | Dodanie wpisu do logu aktywności |
| `GET` | `/payments/api/payment/invoices/{id}/download` | Pobranie PDF faktury (blob) |

## Stany Ekranu

| Stan | Warunek | Renderowanie |
|---|---|---|
| Ładowanie | `loading() === true` | Skeleton komponentu |
| Szczegół faktury | `loading() === false && invoice() !== null` | Dane faktury, tabela pozycji, panel workflow (Admin), przyciski akcji |
| Błąd 404 / brak faktury | `loading() === false && invoice() === null` | Komunikat błędu; brak danych faktury |
| Płatność w toku | `opsActionLoading() === true` | Przyciski workflow disabled, loading indicator |
| Pobieranie PDF | `downloading() === true` | Przycisk "Download PDF" disabled z loading state |

## Dokumenty Atomowe

- [Pola UI](P-019_POLA/P-019__INDEX.md)
- [Akcje UI](A-019_AKCJE/A-019__INDEX.md)
- [Błędy i komunikaty](ERR-019_BLEDY/ERR-019__INDEX.md)
- [Dane testowe](TD-019_DANE_TESTOWE/TD-019__INDEX.md)
- [Testy](TC-019_TESTY/TC-019__INDEX.md)
- [Linki śladu](E-019__LINKI.md)

## Zasada Uzupełniania

Każde pole `P-019-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
