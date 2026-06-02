# E-023 DealerDetailComponent

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-023` |
| Route | `/admin/dealers/:id` |
| Komponent | `DealerDetailComponent` |
| Guardy | `roleGuard` |
| Role frontendu | `Admin` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.html` |
| Status faktów | `wniosek z analizy` |

## Cel Ekranu

Szczegółowy widok dealera dla administratora — dane firmy, historia zamówień, aktualny limit kredytowy i status. Admin może tu wykonać approve/reject/update-credit-limit (te same akcje co na liście, ale w kontekście jednego dealera).

Ekran ładuje równolegle dane dealera (IdentityAuth API) i konto kredytowe (PaymentInvoice API) oraz listę faktur dealera. Zawiera panel "Risk Assessment" z klasyfikacją Healthy/Watchlist/Overdue Risk opartą na procencie wykorzystania limitu kredytowego i aging faktur.

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.ts` | Komponent szczegółu dealera — approve/reject/credit/settle |
| `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.html` | Template z danymi dealera, panelem ryzyka, fakturami |
| `supply-chain-frontend/src/app/core/api/admin-api.service.ts` | `getDealerById()`, `approveDealer()`, `rejectDealer()`, `updateCreditLimit()` |
| `supply-chain-frontend/src/app/core/api/payment-api.service.ts` | `checkCredit()`, `getDealerInvoices()`, `settleOutstanding()`, `seedDealerAccount()` |
| `services/IdentityAuth/IdentityAuth.Application/Features/Auth/` | `GetDealerByIdQueryHandler`, `ApproveDealerCommandHandler`, `RejectDealerCommandHandler`, `UpdateCreditLimitCommandHandler` |

## Główne Wywołania API

| Metoda | Endpoint | Opis |
|---|---|---|
| `GET` | `/identity/api/admin/dealers/{id}` | Dane szczegółowe dealera |
| `PUT` | `/identity/api/admin/dealers/{id}/approve` | Zatwierdzenie dealera |
| `PUT` | `/identity/api/admin/dealers/{id}/reject` | Odrzucenie dealera (z powodem) |
| `PUT` | `/identity/api/admin/dealers/{id}/credit-limit` | Zmiana limitu kredytowego |
| `GET` | `/payments/api/payment/dealers/{id}/credit-check?amount=0` | Odczyt konta kredytowego |
| `GET` | `/payments/api/payment/dealers/{id}/invoices` | Lista faktur dealera |
| `POST` | `/payments/api/payment/dealers/{id}/settlements` | Rozliczenie należności |

## Stany Ekranu

| Stan | Warunek | Renderowanie |
|---|---|---|
| Ładowanie | `loading() === true` | Loading indicator |
| Szczegół dealera | `loading() === false && dealer() !== null` | Dane dealera, panel ryzyka, faktury, przyciski akcji |
| Błąd 404 / brak dealera | `loading() === false && dealer() === null` | Komunikat błędu |
| Akcja w toku | `actionLoading() === true` | Przyciski approve/reject/credit disabled |

## Dokumenty Atomowe

- [Pola UI](P-023_POLA/P-023__INDEX.md)
- [Akcje UI](A-023_AKCJE/A-023__INDEX.md)
- [Błędy i komunikaty](ERR-023_BLEDY/ERR-023__INDEX.md)
- [Dane testowe](TD-023_DANE_TESTOWE/TD-023__INDEX.md)
- [Testy](TC-023_TESTY/TC-023__INDEX.md)
- [Linki śladu](E-023__LINKI.md)

## Zasada Uzupełniania

Każde pole `P-023-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
