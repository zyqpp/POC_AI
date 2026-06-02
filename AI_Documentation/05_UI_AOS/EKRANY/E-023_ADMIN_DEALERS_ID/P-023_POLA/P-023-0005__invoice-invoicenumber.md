# P-023-0005 invoice.invoiceNumber

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-023-0005` |
| Ekran | [E-023](../E-023__README.md) |
| Nazwa wykryta | `invoice.invoiceNumber` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Numer faktury wyświetlany w tabeli faktur dealera na ekranie szczegółu. Najnowsze 5 faktur (`latestAgingInvoices()`) wyświetlane w sekcji "Invoice Aging" panelu ryzyka kredytowego. Klikalne — prowadzi do [E-019_INVOICES_ID](/invoices/:id).

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — pole odczytu z API | `wniosek z analizy` |
| Typ UI | tekst tylko do odczytu; link routerLink do E-019 | `wniosek z analizy` |
| Reguły walidacji | brak walidacji UI przy odczycie | `wniosek z analizy` |
| Komunikaty błędów | [ERR-023](../ERR-023_BLEDY/ERR-023__INDEX.md) | nie dotyczy |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `InvoiceDto.invoiceNumber: string` | `wniosek z analizy` |
| Serwis API | `PaymentApiService.getDealerInvoices(dealerId)` | `wniosek z analizy` |
| Endpoint | `GET /payments/api/payment/dealers/{dealerId}/invoices` | `wniosek z analizy` |
| DTO/kontrakt | `InvoiceDto` w `supply-chain-frontend/src/app/core/models/payment.models.ts` | `wniosek z analizy` |
| Encja/model | `Invoice.InvoiceNumber` w PaymentInvoice domain | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `Invoices` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `InvoiceNumber` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-023_DANE_TESTOWE/TD-023-0005__invoice-invoicenumber.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-023__INDEX.md)
- [Akcje ekranu](../A-023_AKCJE/A-023__INDEX.md)
- [Ślad ekranu](../E-023__LINKI.md)
