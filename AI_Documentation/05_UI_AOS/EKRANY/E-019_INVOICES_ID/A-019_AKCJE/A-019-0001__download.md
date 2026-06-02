# A-019-0001 download

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-019-0001` |
| Ekran | [E-019](../E-019__README.md) |
| Nazwa wykryta | `download` |
| Typ detekcji | `click` |
| Źródło | `supply-chain-frontend/src/app/features/payments/invoice-detail/invoice-detail.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Pobranie PDF faktury. Wywołuje `GET /payments/api/payment/invoices/{id}/download` z `responseType: 'blob'`. Po otrzymaniu blob tworzy URL obiektu i uruchamia pobieranie pliku o nazwie `invoice-{invoiceNumber}.pdf`. Toast błędu jeśli PDF niedostępny.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | Przycisk "Download PDF" (`downloading()` — disabled podczas pobierania) | `wniosek z analizy` |
| Metoda komponentu | `InvoiceDetailComponent.download()` | `wniosek z analizy` |
| Serwis frontend | `PaymentApiService.downloadInvoice(invoiceId)` | `wniosek z analizy` |
| Endpoint API | `GET /payments/api/payment/invoices/{id}/download` → `responseType: 'blob'` | `wniosek z analizy` |
| Komenda/zapytanie | `GetInvoicePdfPathQuery` → `GetInvoicePdfPathQueryHandler` | `wniosek z analizy` |
| Walidacje | brak po stronie UI | `brak w kodzie` |
| Skutek w bazie | brak (odczyt pliku) | `brak w kodzie` |

## Przykład HTTP

```http
GET /payments/api/payment/invoices/{id}/download
Authorization: Bearer {token}

Response: 200 OK
Content-Type: application/pdf
Content-Disposition: attachment; filename="invoice-INV-2024-0001.pdf"
[binary blob]
```

## Testy

- [Macierz testów ekranu](../TC-019_TESTY/TC-019__INDEX.md)
- Dane wejściowe: `invoiceId` (GUID) z trasy URL.
- Oczekiwany rezultat: Plik PDF pobierany jako `invoice-{invoiceNumber}.pdf`. Toast błędu `'PDF not available'` przy HTTP 404/500.

## Linki

- [Indeks akcji](A-019__INDEX.md)
- [Pola ekranu](../P-019_POLA/P-019__INDEX.md)
- [Ślad ekranu](../E-019__LINKI.md)
