# ROLE_ADMIN

Status: `potwierdzone` dla `E-021_ADMIN_DEALERS`, `E-022_ADMIN_AGENTS_CREATE`, `E-023_ADMIN_DEALERS_DETAIL`.

| Obszar | Mechanizm | Role | Efekt |
|---|---|---|---|
| Route `/admin/dealers` | `roleGuard Admin` | `Admin` | lista dealerów oczekujących i aktywnych |
| Route `/admin/agents/create` | `roleGuard Admin` | `Admin` | formularz tworzenia konta agenta |
| Route `/admin/dealers/:id` | `roleGuard Admin` | `Admin` | szczegół i zarządzanie dealerem |
| `GET /api/admin/dealers` | `[Authorize(Roles = "Admin")]` | `Admin` | lista dealerów (paginacja, search) |
| `GET /api/admin/dealers/{id}` | `[Authorize(Roles = "Admin")]` | `Admin` | szczegół dealera |
| `PUT /api/admin/dealers/{id}/approve` | `[Authorize(Roles = "Admin")]` | `Admin` | zatwierdzenie dealera (status Active) |
| `PUT /api/admin/dealers/{id}/reject` | `[Authorize(Roles = "Admin")]` | `Admin` | odrzucenie dealera z powodem |
| `PUT /api/admin/dealers/{id}/credit-limit` | `[Authorize(Roles = "Admin")]` | `Admin` | zmiana limitu kredytowego dealera |
| `GET /api/admin/users/agents` | `[Authorize(Roles = "Admin,Logistics")]` | `Admin`, `Logistics` | lista agentów (do przypisania wysyłek) |
| `POST /api/admin/users/agents` | `[Authorize(Roles = "Admin")]` | `Admin` | tworzenie konta agenta |

## Macierz Ekran / Akcja / Endpoint

| Ekran | Akcja | Frontend | Backend | Role |
|---|---|---|---|---|
| `E-021` | lista dealerów | `roleGuard Admin` | `[Authorize(Roles = "Admin")]` `GET /api/admin/dealers` | `Admin` |
| `E-021` | search dealerów | `roleGuard Admin` | `[Authorize(Roles = "Admin")]` `GET /api/admin/dealers?search=...` | `Admin` |
| `E-022` | wejście na create agent | `roleGuard Admin` | nie dotyczy | `Admin` |
| `E-022` | tworzenie agenta | `roleGuard Admin` | `[Authorize(Roles = "Admin")]` `POST /api/admin/users/agents` | `Admin` |
| `E-022` | lista agentów (wyszukiwanie) | `roleGuard Admin` | `[Authorize(Roles = "Admin,Logistics")]` `GET /api/admin/users/agents` | `Admin` (+ `Logistics` przez backend) |
| `E-023` | szczegół dealera | `roleGuard Admin` | `[Authorize(Roles = "Admin")]` `GET /api/admin/dealers/{id}` | `Admin` |
| `E-023` | zatwierdzenie dealera | `roleGuard Admin` | `[Authorize(Roles = "Admin")]` `PUT /api/admin/dealers/{id}/approve` | `Admin` |
| `E-023` | odrzucenie dealera | `roleGuard Admin` | `[Authorize(Roles = "Admin")]` `PUT /api/admin/dealers/{id}/reject` | `Admin` |
| `E-023` | zmiana credit limit | `roleGuard Admin` | `[Authorize(Roles = "Admin")]` `PUT /api/admin/dealers/{id}/credit-limit` | `Admin` |

## Uprawnienia per rola

### Admin
- Pełny dostęp do wszystkich ekranów panelu administracyjnego.
- Może zatwierdzać i odrzucać dealerów.
- Może zmieniać limity kredytowe dealerów.
- Może tworzyć konta agentów.
- Może przeglądać listę agentów.
- Zmiana credit-limit przez `PUT /api/admin/dealers/{id}/credit-limit` wywołuje równolegle endpoint `PaymentInvoice` (`PUT /payment/internal/dealers/{id}/credit-limit`) — pośrednio przez `UpdateCreditLimitCommand`.

### Logistics
- Ma dostęp do `GET /api/admin/users/agents` (lista agentów do przypisywania wysyłek).
- Brak dostępu do żadnego ekranu panelu admin (E-021, E-022, E-023) — ochrona na poziomie `roleGuard Admin` w frontendzie.

### Dealer / Warehouse / Agent
- Brak jakiegokolwiek dostępu do ekranów panelu admin.
- Backend chroniony przez `[Authorize(Roles = "Admin")]` — każda próba zwraca 403.

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-ROLE-021-001` | `GET /api/admin/users/agents` ma `[Authorize(Roles = "Admin,Logistics")]` — Logistics może pobierać listę agentów przez API nawet bez dostępu do UI E-022. | `potwierdzone` |
| `RISK-ROLE-021-002` | Zatwierdzenie dealera przez `PUT /approve` zmienia status na `Active`, ale nie weryfikuje czy konto kredytowe (`DealerCreditAccount`) zostało wcześniej utworzone w serwisie `PaymentInvoice`. | `wniosek z analizy` |
| `RISK-ROLE-021-003` | Dealer ze statusem `Pending` lub `Rejected` nie może się zalogować — walidacja w `LoginCommand`, ale brak testu integracyjnego który potwierdza ten flow E2E. | `potwierdzone` |
