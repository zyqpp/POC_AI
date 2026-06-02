# MACIERZ_TESTOW_INVOICES

Status: `potwierdzone` jako wymagania testowe dla `E-018_INVOICES_LIST`, `E-019_INVOICE_DETAIL`.

## Testy Istniejące

| Test | Plik | Pokrycie | Luka |
|---|---|---|---|
| `DealerCreditAccount_AddAndReduceOutstanding_UpdatesAvailableCredit` | `tests/PaymentInvoice.Domain.Tests/UnitTest1.cs` | domena: saldo konta, add/reduce outstanding, `AvailableCredit` | brak API, walidacji, `AddOutstandingCommandHandler` |
| `InvoiceCreate_Interstate_SetsIgstType` | `tests/PaymentInvoice.Domain.Tests/UnitTest1.cs` | domena: tworzenie faktury, typ GST dla interstate | brak testu dla intrastate, brak API |
| `Invoice_AddLine_RecalculatesTotals` | `tests/PaymentInvoice.Domain.Tests/UnitTest1.cs` | domena: linie faktury, subtotal, GST amount, grand total | brak testu API generate invoice z liniami |
| `InvoiceWorkflowState_Update_ClampsReminderCountAndTrimsNote` | `tests/PaymentInvoice.Domain.Tests/UnitTest1.cs` | domena: workflow state, clamp reminderCount do 99, trim note | brak testu API workflow, brak testu status transitions |

## Scenariusze do Przetestowania

| ID | Scenariusz | Typ testu | Dane | Obecny status | Kryterium zamknięcia |
|---|---|---|---|---|---|
| `TC-INVOICES-0001` | Admin generuje fakturę dla zamówienia dealera. | API integration | `{orderId, dealerId, invoiceNumber, ...}` JWT Admin | `brak w kodzie` | `201`, faktura w DB, `InvoiceId` w response. |
| `TC-INVOICES-0002` | Dealer nie może generować faktur. | API auth | JWT Dealer, `POST /api/payment/invoices` | `brak w kodzie` | `403`. |
| `TC-INVOICES-0003` | Dealer pobiera listę własnych faktur. | API integration | JWT Dealer, `GET /dealers/{ownId}/invoices` | `brak w kodzie` | `200`, lista zawiera tylko faktury dla tego dealerId. |
| `TC-INVOICES-0004` | Dealer nie może pobrać faktur innego dealera (`EnsureDealerScope`). | API integration | JWT Dealer A, `GET /dealers/{B_id}/invoices` | `brak w kodzie` | `403`. |
| `TC-INVOICES-0005` | Admin może pobrać faktury dowolnego dealera. | API integration | JWT Admin, dowolny `dealerId` | `brak w kodzie` | `200`, lista faktur dla wskazanego dealera. |
| `TC-INVOICES-0006` | Dealer pobiera PDF faktury (`download`). | API integration | JWT Dealer, istniejąca faktura z PDF | `brak w kodzie` | `200`, odpowiedź `application/pdf`, plik do pobrania. |
| `TC-INVOICES-0007` | PDF nie istnieje na dysku — `404`. | API integration | JWT Dealer, faktura bez pliku PDF | `brak w kodzie` | `404` z komunikatem. |
| `TC-INVOICES-0008` | `AddOutstandingCommandHandler` — dodanie zaległości zwiększa `CurrentOutstanding` i zmniejsza `AvailableCredit`. | unit / API integration | `{dealerId, amount, referenceId, ...}` via internal API | `brak w kodzie` | `AvailableCredit = CreditLimit - CurrentOutstanding` po operacji. |
| `TC-INVOICES-0009` | `SettleOutstandingCommand` — rozliczenie zaległości zmniejsza `CurrentOutstanding`. | API integration | JWT Admin lub Dealer (swoje), `POST /dealers/{id}/settlements` | `brak w kodzie` | `200`, `CurrentOutstanding` zmniejszony o `amount`. |
| `TC-INVOICES-0010` | Settle outstanding przez Dealera dla innego dealera zwraca `403`. | API integration | JWT Dealer A, `POST /dealers/{B_id}/settlements` | `brak w kodzie` | `403`. |
| `TC-INVOICES-0011` | Pobranie workflow faktury po jej wygenerowaniu. | API integration | JWT Admin/Dealer, istniejąca faktura | `brak w kodzie` | `200`, `InvoiceWorkflowStateDto` z domyślnym statusem. |
| `TC-INVOICES-0012` | Upsert workflow faktury zmienia status i notatkę. | API integration | JWT Admin, `PUT /invoices/{id}/workflow` | `brak w kodzie` | `200`, zaktualizowany workflow z nowym statusem. |
| `TC-INVOICES-0013` | `ReminderCount` nie przekracza 99 (clamp). | unit | `state.Update(..., reminderCount: 500)` | `potwierdzone` (test domenowy) | `state.ReminderCount == 99`. |
| `TC-INVOICES-0014` | Faktura interstate ma typ GST `IGST`, intrastate `CGST+SGST`. | unit | `Invoice.Create(..., isInterstate: true/false)` | `potwierdzone częściowo` (test interstate) | `GstType.IGST` dla interstate; `GstType.CGST` dla intrastate. |
| `TC-INVOICES-0015` | Internal API `AddOutstandingInternal` wymaga nagłówka `X-Internal-Api-Key`. | API auth | brak nagłówka / błędny klucz | `brak w kodzie` | `401`. |
| `TC-INVOICES-0016` | `CheckCredit` — sprawdzenie limitu z wystarczającym saldem zwraca `allowed=true`. | API integration | JWT Dealer, kwota < `AvailableCredit` | `brak w kodzie` | `200`, `allowed=true`. |
| `TC-INVOICES-0017` | `CheckCredit` — sprawdzenie limitu z niewystarczającym saldem zwraca `allowed=false`. | API integration | JWT Dealer, kwota > `AvailableCredit` | `brak w kodzie` | `200`, `allowed=false`. |

## Luki Testowe

| Luka | Opis | Priorytet |
|---|---|---|
| `AddOutstandingCommandHandler` | Brak testu handlera — jest to kluczowy komponent wyzwalany przez outbox przy finalizacji zamówień. Brak pokrycia może ukryć błędy w obliczeniu salda. | KRYTYCZNY |
| Invoice workflow status transitions | Brak testu sprawdzającego dozwolone przejścia statusów workflow faktury (np. czy można cofnąć status). | WYSOKI |
| `EnsureDealerScope` dla workflow endpointów | `PUT /invoices/{id}/workflow` i `POST /invoices/{id}/workflow-activities` nie mają `EnsureDealerScope` — brak testu weryfikującego izolację. | KRYTYCZNY |
| PDF generation | Brak testu integracyjnego sprawdzającego generowanie pliku PDF faktury i jego dostępność. | WYSOKI |
| Credit check integration | `CheckCreditQuery` ma test domenowy dla `DealerCreditAccount`, ale brak testu end-to-end flow przy składaniu zamówienia. | WYSOKI |
| Intrastate GST | Test `InvoiceCreate_Interstate` istnieje, ale brak testu dla intrastate (typ `CGST+SGST`). | SREDNI |
| Internal API security | Brak testu weryfikującego że `[AllowAnonymous]` endpointy wymagają `X-Internal-Api-Key` i odrzucają brak klucza. | WYSOKI |
