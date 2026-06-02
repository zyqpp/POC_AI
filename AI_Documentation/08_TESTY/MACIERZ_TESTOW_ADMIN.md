# MACIERZ_TESTOW_ADMIN

Status: `potwierdzone` jako wymagania testowe dla `E-021_ADMIN_DEALERS`, `E-022_ADMIN_AGENTS_CREATE`, `E-023_ADMIN_DEALERS_DETAIL`.

## Testy Istniejące

| Test | Plik | Pokrycie | Luka |
|---|---|---|---|
| `CreateDealer_SetsDealerRolePendingStatusAndProfile` | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | domena: dealer tworzony ze statusem Pending | brak testu że Pending blokuje login |
| `ApproveDealer_ActivatesUserAndClearsRejectionReason` | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | domena: approve zmienia status na Active, czyści `RejectionReason` | brak testu API approve + efekt uboczny (login możliwy) |
| `RejectDealer_SetsRejectedStatusAndTrimmedReason` | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | domena: reject zmienia status na Rejected, trim powodu | brak testu API reject + blokada loginu |
| `UpdateCreditLimit_StoresNewValue` | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | domena: zmiana `CreditLimit` w encji User | brak testu że zmiana propaguje do `PaymentInvoice` serwisu |

## Scenariusze do Przetestowania

| ID | Scenariusz | Typ testu | Dane | Obecny status | Kryterium zamknięcia |
|---|---|---|---|---|---|
| `TC-ADMIN-0001` | Admin pobiera listę dealerów z paginacją. | API integration | JWT Admin, `?page=1&pageSize=20` | `brak w kodzie` | `200`, `PagedResult<DealerSummaryDto>` z `TotalCount`, `Page`, `Items`. |
| `TC-ADMIN-0002` | Admin wyszukuje dealera po nazwie/emailu. | API integration | JWT Admin, `?search=demo` | `brak w kodzie` | `200`, lista zawiera tylko pasujące rekordy. |
| `TC-ADMIN-0003` | Admin pobiera szczegół dealera po ID. | API integration | JWT Admin, istniejący `dealerId` | `brak w kodzie` | `200`, `DealerDetailDto` z pełnym profilem. |
| `TC-ADMIN-0004` | Admin zatwierdza dealera — status zmienia się na `Active`. | API integration | JWT Admin, Pending dealer | `brak w kodzie` | `200`, `UserStatus.Active` w DB. |
| `TC-ADMIN-0005` | Po zatwierdzeniu dealer może się zalogować. | API integration (E2E) | JWT Admin, zatwierdzone konto Dealer | `brak w kodzie` | `POST /login` dla Dealer zwraca `200` i JWT. |
| `TC-ADMIN-0006` | Admin odrzuca dealera z powodem — status `Rejected`, powód zapisany. | API integration | JWT Admin, Pending dealer, `{reason: "missing docs"}` | `brak w kodzie` | `200`, `UserStatus.Rejected`, `RejectionReason` w DB. |
| `TC-ADMIN-0007` | Dealer ze statusem `Rejected` NIE MOŻE się zalogować. | API integration (E2E) | konto Rejected, `POST /login` | `brak w kodzie` | `401`/`403`, brak JWT. |
| `TC-ADMIN-0008` | Dealer ze statusem `Pending` NIE MOŻE się zalogować. | API integration (E2E) | konto Pending, `POST /login` | `brak w kodzie` | `401`/`403`, brak JWT. **To jest KRYTYCZNY przypadek — brak testu jest luką bezpieczeństwa.** |
| `TC-ADMIN-0009` | Admin aktualizuje limit kredytowy dealera. | API integration | JWT Admin, dealerId, `{creditLimit: 500000}` | `brak w kodzie` | `200`, `CreditLimit` w `Users` zaktualizowany, `PaymentInvoice` zsynchronizowany. |
| `TC-ADMIN-0010` | Zmiana credit-limit propaguje do `DealerCreditAccount` w serwisie `PaymentInvoice`. | API integration | JWT Admin, dealerId | `brak w kodzie` | Odczyt `GET /payment/dealers/{id}/credit-check` zwraca nowy limit. |
| `TC-ADMIN-0011` | Admin tworzy konto agenta. | API integration | JWT Admin, `{email, password, fullName, ...}` | `brak w kodzie` | `201`, `CreateAgentResponse` z `UserId`, konto w DB z rolą `Agent`. |
| `TC-ADMIN-0012` | Admin nie może stworzyć agenta z duplikatem emaila. | API integration | JWT Admin, email który już istnieje | `brak w kodzie` | `400`/`409`, brak nowego rekordu w DB. |
| `TC-ADMIN-0013` | Dealer nie może wywoływać żadnych endpointów `/api/admin/dealers`. | API auth | JWT Dealer | `brak w kodzie` | `403` dla GET, PUT. |
| `TC-ADMIN-0014` | Warehouse nie może wywoływać endpointów `/api/admin/dealers`. | API auth | JWT Warehouse | `brak w kodzie` | `403`. |
| `TC-ADMIN-0015` | Logistics nie może wywoływać endpointów `/api/admin/dealers`, ale może `GET /api/admin/users/agents`. | API auth | JWT Logistics | `brak w kodzie` | `403` dla dealers; `200` dla agents. |
| `TC-ADMIN-0016` | Admin pobiera listę agentów z paginacją i search. | API integration | JWT Admin, `?page=1&search=jan` | `brak w kodzie` | `200`, `PagedResult<AgentSummaryDto>`. |
| `TC-ADMIN-0017` | Próba pobrania nieistniejącego dealera przez Admin — `404`. | API integration | JWT Admin, nieistniejący GUID | `brak w kodzie` | `404`. |

## Luki Testowe

| Luka | Opis | Priorytet |
|---|---|---|
| **Blokada loginu Pending** | Brak testu integracyjnego/E2E weryfikującego że dealer ze statusem `Pending` NIE MOŻE się zalogować. Jest to krytyczna kontrola bezpieczeństwa — bez tego testu reguła biznesowa może zostać przypadkowo usunięta. | KRYTYCZNY |
| **Blokada loginu Rejected** | Analogicznie — brak testu dla statusu `Rejected`. | KRYTYCZNY |
| Propagacja credit-limit do PaymentInvoice | Zmiana limitu przez `PUT /api/admin/dealers/{id}/credit-limit` wywołuje cross-service update do `PaymentInvoice`. Brak testu integracyjnego który weryfikuje że oba serwisy są zsynchronizowane. | WYSOKI |
| Approve dealer — efekt uboczny | Testy domenowe sprawdzają zmianę statusu, ale brak testu API który po approve weryfikuje że dealer może się faktycznie zalogować (`Active` umożliwia login). | WYSOKI |
| Autoryzacja admin endpoints | Brak automatycznych testów weryfikujących że Dealer, Warehouse, Logistics nie mają dostępu do panel admin. Ochrona jest wyłącznie deklaratywna przez `[Authorize(Roles = "Admin")]`. | WYSOKI |
| Create agent — walidacja | Brak testu walidacji formularza tworzenia agenta (duplikat email, puste wymagane pola). | SREDNI |
| Search/paginacja | Brak testu dla paginacji i wyszukiwania dealerów (edge cases: pusta lista, ostatnia strona, search bez wyników). | NISKI |
