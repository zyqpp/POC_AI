# E-018 InvoiceListComponent

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-018` |
| Route | `/invoices` |
| Komponent | `InvoiceListComponent` |
| Guardy | `roleGuard` |
| Role frontendu | `Admin, Dealer` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` |
| Status faktów | `wniosek z analizy` |

## Cel Ekranu

Lista faktur powiązanych z zamówieniami dealera. Dealer widzi faktury do opłacenia i opłacone. Możliwe akcje: pobranie PDF faktury, przejście do szczegółu, inicjacja płatności (jeśli gateway włączony). UWAGA: PaymentGateway.Enabled=false w konfiguracji dev.

Admin widzi panel wyszukiwania po dealer ID — może przeglądać faktury dowolnego dealera. Ekran wspiera zaawansowane workflow kolekcji należności (remind, mark-paid, dispute, escalate) — dostępne tylko dla roli Admin.

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.ts` | Komponent główny — logika filtrowania, workflow, bulk actions |
| `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` | Template listy faktur z tabelą i filtrami |
| `supply-chain-frontend/src/app/core/api/payment-api.service.ts` | `PaymentApiService.getDealerInvoices()`, `getInvoiceById()`, `upsertInvoiceWorkflow()` |
| `supply-chain-frontend/src/app/core/services/invoice-workflow.service.ts` | `InvoiceWorkflowService` — logika stanów workflow |
| `supply-chain-frontend/src/app/core/services/invoice-workflow-activity.service.ts` | `InvoiceWorkflowActivityService` — log aktywności workflow |
| `supply-chain-frontend/src/app/core/api/notification-api.service.ts` | `NotificationApiService.createManual()` — wysyłka powiadomień przy reminder/escalate |

## Główne Wywołania API

| Metoda | Endpoint | Opis |
|---|---|---|
| `GET` | `/payments/api/payment/dealers/{dealerId}/invoices` | Pobieranie listy faktur dealera |
| `GET` | `/payments/api/payment/dealers/{dealerId}/invoice-workflows` | Pobieranie stanów workflow dla faktur |
| `PUT` | `/payments/api/payment/invoices/{invoiceId}/workflow` | Aktualizacja stanu workflow faktury |
| `POST` | `/payments/api/payment/invoices/{invoiceId}/workflow-activities` | Dodanie wpisu do logu aktywności |

## Stany Ekranu

| Stan | Warunek | Renderowanie |
|---|---|---|
| Ładowanie | `loading() === true` | Skeleton `<div class="skeleton" style="height:300px">` |
| Lista faktur | `loading() === false && invoices().length > 0` | Tabela z wierszami faktur, filtrami, bulk actions (Admin) |
| Pusta lista | `loading() === false && invoices().length === 0` | Empty state z ikoną 🧾 i tekstem "No invoices found" |
| Admin — brak dealer ID | `isAdmin() === true && dealerIdInput === ''` | Pole input + przycisk "Load"; brak tabeli do momentu załadowania |
| Błąd ładowania | błąd HTTP | Toast `'Failed to load invoices'`; lista pozostaje pusta |

## Dokumenty Atomowe

- [Pola UI](P-018_POLA/P-018__INDEX.md)
- [Akcje UI](A-018_AKCJE/A-018__INDEX.md)
- [Błędy i komunikaty](ERR-018_BLEDY/ERR-018__INDEX.md)
- [Dane testowe](TD-018_DANE_TESTOWE/TD-018__INDEX.md)
- [Testy](TC-018_TESTY/TC-018__INDEX.md)
- [Linki śladu](E-018__LINKI.md)

## Zasada Uzupełniania

Każde pole `P-018-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
