# P-019-0008 l.productName

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-019-0008` |
| Ekran | [E-019](../E-019__README.md) |
| Nazwa wykryta | `l.productName` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Nazwa produktu w pozycji faktury. Wyświetlana w tabeli pozycji faktury (linie). Pochodzi z danych zamówienia przekazanych do `GenerateInvoice` request. Backend waliduje przy generowaniu faktury: `NotEmpty().MaximumLength(220)`.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — przy generowaniu faktury | `potwierdzone` |
| Typ UI | tekst tylko do odczytu (interpolacja w td) | `wniosek z analizy` |
| Reguły walidacji (backend) | `NotEmpty().MaximumLength(220)` — `GenerateInvoiceRequestValidator` w `PaymentValidators.cs` | `potwierdzone` |
| Komunikaty błędów | [ERR-019](../ERR-019_BLEDY/ERR-019__INDEX.md) | nie dotyczy — pole odczytu |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `InvoiceLine.productName: string` w `InvoiceDto.lines[]` | `wniosek z analizy` |
| Serwis API | `PaymentApiService.getInvoiceById(invoiceId)` | `wniosek z analizy` |
| Endpoint | `GET /payments/api/payment/invoices/{id}` | `wniosek z analizy` |
| DTO/kontrakt | `InvoiceDto.lines[].productName` w `supply-chain-frontend/src/app/core/models/payment.models.ts` | `wniosek z analizy` |
| Encja/model | `InvoiceLine.ProductName` w PaymentInvoice domain | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `InvoiceLines` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `ProductName` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-019_DANE_TESTOWE/TD-019-0008__l-productname.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-019__INDEX.md)
- [Akcje ekranu](../A-019_AKCJE/A-019__INDEX.md)
- [Ślad ekranu](../E-019__LINKI.md)
