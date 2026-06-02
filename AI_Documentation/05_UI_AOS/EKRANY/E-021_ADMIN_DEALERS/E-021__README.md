# E-021 DealerListComponent

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-021` |
| Route | `/admin/dealers` |
| Komponent | `DealerListComponent` |
| Guardy | `roleGuard` |
| Role frontendu | `Admin` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` |
| Status faktów | `wniosek z analizy` |

## Cel Ekranu

Panel administratora do zarządzania dealerami. Admin widzi listę wszystkich dealerów z ich statusem (Pending/Active/Rejected). Może zatwierdzić (approve), odrzucić (reject) lub zmienić limit kredytowy. Powiązany proces: [PROC-001_AUTH](../../../../06_PROCESY/PROC-001_AUTH.md) (rejestracja dealera)

Ekran wspiera paginację (page 1, pageSize 20) oraz wyszukiwanie z debounce 300ms. Kliknięcie w wiersz prowadzi do [E-023_ADMIN_DEALERS_ID](/admin/dealers/:id).

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.ts` | Komponent listy dealerów — paginacja, wyszukiwanie |
| `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` | Template tabeli dealerów z statusami |
| `supply-chain-frontend/src/app/core/api/admin-api.service.ts` | `AdminApiService.getDealers()`, `approveDealer()`, `rejectDealer()`, `updateCreditLimit()` |
| `services/IdentityAuth/IdentityAuth.Application/Features/Auth/Queries/` | `GetDealersQueryHandler` |
| `services/IdentityAuth/IdentityAuth.Application/Features/Auth/Commands/` | `ApproveDealerCommandHandler`, `RejectDealerCommandHandler`, `UpdateCreditLimitCommandHandler` |
| `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs` | `UpdateCreditLimitRequestValidator`, `RejectDealerRequestValidator` |

## Główne Wywołania API

| Metoda | Endpoint | Opis |
|---|---|---|
| `GET` | `/identity/api/admin/dealers?page=1&pageSize=20&search=` | Lista dealerów (paginowana) |
| `PUT` | `/identity/api/admin/dealers/{id}/approve` | Zatwierdzenie dealera |
| `PUT` | `/identity/api/admin/dealers/{id}/reject` | Odrzucenie dealera (z powodem) |
| `PUT` | `/identity/api/admin/dealers/{id}/credit-limit` | Zmiana limitu kredytowego |

## Stany Ekranu

| Stan | Warunek | Renderowanie |
|---|---|---|
| Ładowanie | `loading() === true` | Loading indicator |
| Lista dealerów | `loading() === false && dealers().length > 0` | Tabela dealerów z paginacją |
| Pusta lista | `loading() === false && dealers().length === 0` | Empty state |
| Błąd ładowania | błąd HTTP | Toast lub stan błędu; loading = false |

## Dokumenty Atomowe

- [Pola UI](P-021_POLA/P-021__INDEX.md)
- [Akcje UI](A-021_AKCJE/A-021__INDEX.md)
- [Błędy i komunikaty](ERR-021_BLEDY/ERR-021__INDEX.md)
- [Dane testowe](TD-021_DANE_TESTOWE/TD-021__INDEX.md)
- [Testy](TC-021_TESTY/TC-021__INDEX.md)
- [Linki śladu](E-021__LINKI.md)

## Zasada Uzupełniania

Każde pole `P-021-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
