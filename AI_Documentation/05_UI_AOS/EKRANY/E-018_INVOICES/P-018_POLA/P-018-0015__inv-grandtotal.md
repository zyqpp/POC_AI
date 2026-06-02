# P-018-0015 inv.grandTotal

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-018-0015` |
| Ekran | [E-018](../E-018__README.md) |
| Nazwa wykryta | `inv.grandTotal` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Łączna kwota faktury (subtotal + GST). Wyświetlana w kolumnie "Grand Total" z formatowaniem INR (Angular pipe `currency:'INR':'symbol':'1.2-2'`). Styl `fw-600 text-primary`. Używana do filtrowania (minAmount/maxAmount) i sumowania selectedAmount/overdueAmount.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — pole odczytu z API | `wniosek z analizy` |
| Typ UI | tekst tylko do odczytu (interpolacja), formatowany jako waluta INR | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` |
| Reguły walidacji | brak walidacji UI — pole wyświetlane | `wniosek z analizy` |
| Komunikaty błędów | [ERR-018](../ERR-018_BLEDY/ERR-018__INDEX.md) | nie dotyczy |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `InvoiceDto.grandTotal: number` | `wniosek z analizy` |
| Serwis API | `PaymentApiService.getDealerInvoices(dealerId)` | `wniosek z analizy` |
| Endpoint | `GET /payments/api/payment/dealers/{dealerId}/invoices` | `wniosek z analizy` |
| DTO/kontrakt | `InvoiceDto` w `supply-chain-frontend/src/app/core/models/payment.models.ts` | `wniosek z analizy` |
| Encja/model | `Invoice.GrandTotal` w PaymentInvoice domain | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `Invoices` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `GrandTotal` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-018_DANE_TESTOWE/TD-018-0015__inv-grandtotal.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-018__INDEX.md)
- [Akcje ekranu](../A-018_AKCJE/A-018__INDEX.md)
- [Ślad ekranu](../E-018__LINKI.md)
