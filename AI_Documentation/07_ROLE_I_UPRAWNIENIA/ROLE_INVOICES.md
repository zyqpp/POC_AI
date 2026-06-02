# ROLE_INVOICES

Status: `potwierdzone` dla `E-018_INVOICES_LIST`, `E-019_INVOICE_DETAIL`.

| Obszar | Mechanizm | Role | Efekt |
|---|---|---|---|
| Route `/invoices` (lista) | `authGuard` + `roleGuard Admin,Dealer` | `Admin`, `Dealer` | lista faktur (Admin wszystkich, Dealer tylko swoich) |
| Route `/invoices/:id` (detail) | `authGuard` + `roleGuard Admin,Dealer` | `Admin`, `Dealer` | szczegół faktury |
| `POST /api/payment/invoices` | `[Authorize(Roles = "Admin")]` | `Admin` | generowanie faktury |
| `GET /api/payment/invoices/{id}` | `[Authorize(Roles = "Admin,Dealer")]` | `Admin`, `Dealer` | szczegół faktury |
| `GET /api/payment/dealers/{dealerId}/invoices` | `[Authorize(Roles = "Admin,Dealer")]` + `EnsureDealerScope()` | `Admin`, `Dealer` | lista faktur dealera (Dealer tylko swoje) |
| `GET /api/payment/invoices/{id}/download` | `[Authorize(Roles = "Admin,Dealer")]` | `Admin`, `Dealer` | pobieranie PDF faktury |
| `GET /api/payment/invoices/{id}/workflow` | `[Authorize(Roles = "Admin,Dealer")]` | `Admin`, `Dealer` | odczyt workflow faktury |
| `GET /api/payment/dealers/{dealerId}/invoice-workflows` | `[Authorize(Roles = "Admin,Dealer")]` + `EnsureDealerScope()` | `Admin`, `Dealer` | lista workflow faktur dealera |
| `PUT /api/payment/invoices/{id}/workflow` | `[Authorize(Roles = "Admin,Dealer")]` | `Admin`, `Dealer` | upsert workflow faktury |
| `GET /api/payment/invoices/{id}/workflow-activities` | `[Authorize(Roles = "Admin,Dealer")]` | `Admin`, `Dealer` | historia aktywności workflow |
| `POST /api/payment/invoices/{id}/workflow-activities` | `[Authorize(Roles = "Admin,Dealer")]` | `Admin`, `Dealer` | dodanie aktywności do workflow |
| `GET /api/payment/dealers/{dealerId}/credit-check` | `[Authorize(Roles = "Admin,Dealer")]` + `EnsureDealerScope()` | `Admin`, `Dealer` | sprawdzenie limitu kredytowego |
| `POST /api/payment/dealers/{dealerId}/settlements` | `[Authorize(Roles = "Admin,Dealer")]` + `EnsureDealerScope()` | `Admin`, `Dealer` | rozliczenie zaległości |
| `PUT /api/payment/dealers/{dealerId}/credit-limit` | `[Authorize(Roles = "Admin")]` | `Admin` | zmiana limitu kredytowego |
| `POST /api/payment/dealers/{dealerId}/account` | `[Authorize(Roles = "Admin")]` | `Admin` | seed konta kredytowego dealera |
| `POST /api/payment/gateway/orders` | `[Authorize(Roles = "Dealer")]` | `Dealer` | inicjacja płatności przez gateway |
| `POST /api/payment/gateway/verify` | `[Authorize(Roles = "Dealer")]` | `Dealer` | weryfikacja płatności gateway |
| `POST /api/payment/internal/...` | `[AllowAnonymous]` + `X-Internal-Api-Key` | serwisy wewnętrzne | internal API (credit-check, settlements, outstanding) |

## Macierz Ekran / Akcja / Endpoint

| Ekran | Akcja | Frontend | Backend | Role |
|---|---|---|---|---|
| `E-018` | lista faktur Dealera | `authGuard` + `roleGuard Dealer` | `[Authorize(Roles = "Admin,Dealer")]` `GET /dealers/{id}/invoices` z `EnsureDealerScope()` | `Dealer` (tylko swoje) |
| `E-018` | lista wszystkich faktur | `roleGuard Admin` w UI | `[Authorize(Roles = "Admin,Dealer")]` `GET /dealers/{id}/invoices` | `Admin` (dowolny `dealerId`) |
| `E-018` | generowanie faktury | `isAdmin()` w UI | `[Authorize(Roles = "Admin")]` `POST /api/payment/invoices` | `Admin` |
| `E-019` | szczegół faktury | `authGuard` + `roleGuard Admin,Dealer` | `[Authorize(Roles = "Admin,Dealer")]` `GET /invoices/{id}` | `Admin`, `Dealer` |
| `E-019` | pobieranie PDF | `authGuard` | `[Authorize(Roles = "Admin,Dealer")]` `GET /invoices/{id}/download` | `Admin`, `Dealer` |
| `E-019` | podgląd workflow | `authGuard` | `[Authorize(Roles = "Admin,Dealer")]` `GET /invoices/{id}/workflow` | `Admin`, `Dealer` |
| `E-019` | upsert workflow | `isAdmin()` w UI | `[Authorize(Roles = "Admin,Dealer")]` `PUT /invoices/{id}/workflow` | `Admin`, `Dealer` (atrybut nie ogranicza, UI tak) |
| `E-019` | dodanie aktywności workflow | `isAdmin()` w UI | `[Authorize(Roles = "Admin,Dealer")]` `POST /invoices/{id}/workflow-activities` | `Admin`, `Dealer` (atrybut nie ogranicza) |
| `E-019` | settle outstanding | `isAdmin()` lub `isDealer()` w UI | `[Authorize(Roles = "Admin,Dealer")]` `POST /dealers/{id}/settlements` z `EnsureDealerScope()` | `Admin`, `Dealer` (tylko swoje) |

## Uprawnienia per rola

### Admin
- Widzi faktury wszystkich dealerów.
- Może generować faktury dla dowolnego dealera.
- Może zmieniać limit kredytowy dealera.
- Może seedować konto kredytowe dealera.
- Może przeglądać i modyfikować workflow faktur.
- Może rozliczać zaległości dowolnego dealera.

### Dealer
- Widzi tylko swoje faktury (wymuszane przez `EnsureDealerScope()` — porównanie `dealerId` z `sub` w JWT).
- Może pobierać PDF swoich faktur.
- Może sprawdzić swój limit kredytowy.
- Może rozliczyć swoje zaległości.
- Może inicjować i weryfikować płatności przez gateway.
- Może modyfikować workflow swoich faktur (atrybut nie ogranicza, `EnsureDealerScope` tak).
- Nie może generować faktur.

### Warehouse / Logistics / Agent
- Brak dostępu do ekranów faktur.
- Dostęp tylko przez internal API (np. `AddOutstandingInternal` przy finalizacji zamówienia).

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-ROLE-018-001` | `PUT /invoices/{id}/workflow` i `POST /invoices/{id}/workflow-activities` mają `[Authorize(Roles = "Admin,Dealer")]` — Dealer może modyfikować workflow faktury, jeśli zna `invoiceId`. Brak `EnsureDealerScope` na tych endpointach (tylko na listach). | `potwierdzone` |
| `RISK-ROLE-018-002` | Internal API endpointy (`/internal/...`) używają `[AllowAnonymous]` + nagłówek `X-Internal-Api-Key`. Jeśli klucz wycieknie, zewnętrzny podmiot może modyfikować salda kredytowe. | `wniosek z analizy` |
| `RISK-ROLE-018-003` | Demo seed faktur jest aktywowany dla Dealerów z domeną email `@supplychain.local` (konfigurowalny). Może niepotrzebnie wyzwalać się w środowisku testowym. | `potwierdzone` |
