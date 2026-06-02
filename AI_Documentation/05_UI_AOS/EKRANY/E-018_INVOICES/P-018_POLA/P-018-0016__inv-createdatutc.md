# P-018-0016 inv.createdAtUtc

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-018-0016` |
| Ekran | [E-018](../E-018__README.md) |
| Nazwa wykryta | `inv.createdAtUtc` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Data wystawienia faktury w formacie UTC ISO. Wyświetlana w kolumnie "Created" w formacie `dd MMM yyyy` (Angular pipe `date:'dd MMM yyyy'`). Używana do sortowania (default sort malejący po createdAtUtc) oraz filtrowania zakresem dat (fromDate/toDate).

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — pole odczytu z API | `wniosek z analizy` |
| Typ UI | tekst tylko do odczytu (interpolacja), formatowany datą | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` |
| Reguły walidacji | brak walidacji UI — pole wyświetlane | `wniosek z analizy` |
| Komunikaty błędów | [ERR-018](../ERR-018_BLEDY/ERR-018__INDEX.md) | nie dotyczy |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `InvoiceDto.createdAtUtc: string` (ISO 8601) | `wniosek z analizy` |
| Serwis API | `PaymentApiService.getDealerInvoices(dealerId)` | `wniosek z analizy` |
| Endpoint | `GET /payments/api/payment/dealers/{dealerId}/invoices` | `wniosek z analizy` |
| DTO/kontrakt | `InvoiceDto` w `supply-chain-frontend/src/app/core/models/payment.models.ts` | `wniosek z analizy` |
| Encja/model | `Invoice.CreatedAtUtc` w PaymentInvoice domain | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `Invoices` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `CreatedAtUtc` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-018_DANE_TESTOWE/TD-018-0016__inv-createdatutc.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-018__INDEX.md)
- [Akcje ekranu](../A-018_AKCJE/A-018__INDEX.md)
- [Ślad ekranu](../E-018__LINKI.md)
