# P-018-0013 inv.orderId

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-018-0013` |
| Ekran | [E-018](../E-018__README.md) |
| Nazwa wykryta | `inv.orderId` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/payments/invoice-list/invoice-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Identyfikator zamówienia powiązanego z fakturą. Wyświetlany skrócony (pierwsze 8 znaków GUID + `...`) w kolumnie "Order ID". Używany jako kryterium wyszukiwania w `searchQuery`. Stanowi link do zamówienia [E-015_ORDERS_ID](/orders/:id).

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — pole odczytu z API | `wniosek z analizy` |
| Typ UI | tekst tylko do odczytu (interpolacja z pipe `slice:0:8`), klasa `text-xs text-secondary` | `wniosek z analizy` |
| Reguły walidacji | brak walidacji UI | `wniosek z analizy` |
| Komunikaty błędów | [ERR-018](../ERR-018_BLEDY/ERR-018__INDEX.md) | nie dotyczy |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `InvoiceDto.orderId: string` | `wniosek z analizy` |
| Serwis API | `PaymentApiService.getDealerInvoices(dealerId)` | `wniosek z analizy` |
| Endpoint | `GET /payments/api/payment/dealers/{dealerId}/invoices` | `wniosek z analizy` |
| DTO/kontrakt | `InvoiceDto` w `supply-chain-frontend/src/app/core/models/payment.models.ts` | `wniosek z analizy` |
| Encja/model | `Invoice.OrderId` w PaymentInvoice domain | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `Invoices` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `OrderId` (szacowane, FK na Orders) | `wniosek z analizy` |
| Odczyt/zapis | odczyt | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-018_DANE_TESTOWE/TD-018-0013__inv-orderid.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-018__INDEX.md)
- [Akcje ekranu](../A-018_AKCJE/A-018__INDEX.md)
- [Ślad ekranu](../E-018__LINKI.md)
