# ROLE_ORDERS

Status: `potwierdzone` dla `E-013_ORDERS_LIST`, `E-014_TRACKING`, `E-015_ORDER_DETAIL`.

| Obszar | Mechanizm | Role | Efekt |
|---|---|---|---|
| Route `/orders` (lista) | `authGuard` + `roleGuard Dealer` | `Dealer` | lista własnych zamówień |
| Route `/orders/:id` (detail) | `authGuard` | każdy zalogowany | szczegół zamówienia (backend filtruje wg roli) |
| Route `/admin/orders` (admin lista) | `roleGuard Admin,Warehouse,Logistics` | `Admin`, `Warehouse`, `Logistics` | lista wszystkich zamówień |
| `GET /api/orders/my` | `[Authorize(Roles = "Dealer")]` | `Dealer` | zwraca zamówienia filtrowane po `DealerId` z JWT |
| `GET /api/orders/{id}` | `[Authorize]` | każdy zalogowany | backend sprawdza `userId` i `role`; Dealer widzi tylko swoje |
| `POST /api/orders` | `[Authorize(Roles = "Dealer")]` | `Dealer` | tworzy zamówienie dla zalogowanego Dealera |
| `POST /api/orders/{id}/cancel` | `[Authorize(Roles = "Dealer,Admin")]` | `Dealer`, `Admin` | anulowanie zamówienia |
| `POST /api/orders/{id}/returns` | `[Authorize(Roles = "Dealer")]` | `Dealer` | zgłoszenie zwrotu dostarczonego zamówienia |
| `PUT /api/orders/{id}/status` | `[Authorize]` + `CanManageOrderStatus()` | `Admin`, `Logistics` | zmiana statusu zamówienia (runtime check) |
| `GET /api/admin/orders` | `[Authorize(Roles = "Admin,Warehouse,Logistics")]` | `Admin`, `Warehouse`, `Logistics` | lista wszystkich zamówień z filtrem status |
| `GET /api/admin/orders/analytics` | `[Authorize(Roles = "Admin,Warehouse,Logistics")]` | `Admin`, `Warehouse`, `Logistics` | analityka zamówień |
| `POST /api/admin/orders/bulk-status` | `[Authorize(Roles = "Admin,Logistics")]` | `Admin`, `Logistics` | masowa zmiana statusów |
| `PUT /api/admin/orders/{id}/approve-hold` | `[Authorize(Roles = "Admin")]` | `Admin` | zatwierdzenie zamówienia on-hold |
| `PUT /api/admin/orders/{id}/reject-hold` | `[Authorize(Roles = "Admin")]` | `Admin` | odrzucenie zamówienia on-hold |
| `PUT /api/admin/orders/{id}/approve-return` | `[Authorize(Roles = "Admin")]` | `Admin` | zatwierdzenie zwrotu |
| `PUT /api/admin/orders/{id}/reject-return` | `[Authorize(Roles = "Admin")]` | `Admin` | odrzucenie zwrotu |

## Macierz Ekran / Akcja / Endpoint

| Ekran | Akcja | Frontend | Backend | Role |
|---|---|---|---|---|
| `E-013` | lista zamówień Dealera | `authGuard` + `roleGuard Dealer` | `[Authorize(Roles = "Dealer")]` `GET /api/orders/my` | `Dealer` |
| `E-013` | lista wszystkich zamówień | `roleGuard Admin,Warehouse,Logistics` | `[Authorize(Roles = "Admin,Warehouse,Logistics")]` `GET /api/admin/orders` | `Admin`, `Warehouse`, `Logistics` |
| `E-013` | analityka zamówień | `roleGuard Admin,Warehouse,Logistics` | `[Authorize(Roles = "Admin,Warehouse,Logistics")]` `GET /api/admin/orders/analytics` | `Admin`, `Warehouse`, `Logistics` |
| `E-013` | bulk zmiana statusów | `roleGuard Admin,Logistics` | `[Authorize(Roles = "Admin,Logistics")]` `POST /api/admin/orders/bulk-status` | `Admin`, `Logistics` |
| `E-014` | podgląd trackingu zamówienia | `authGuard` | `[Authorize]` `GET /api/orders/{id}/saga` | każdy zalogowany (backend filtruje) |
| `E-015` | szczegół zamówienia | `authGuard` | `[Authorize]` `GET /api/orders/{id}` | każdy zalogowany (backend filtruje wg roli) |
| `E-015` | anulowanie zamówienia | `isDealer()` lub `isAdmin()` w UI | `[Authorize(Roles = "Dealer,Admin")]` `POST /api/orders/{id}/cancel` | `Dealer`, `Admin` |
| `E-015` | zgłoszenie zwrotu | `isDealer()` w UI | `[Authorize(Roles = "Dealer")]` `POST /api/orders/{id}/returns` | `Dealer` |
| `E-015` | approve/reject on-hold | `isAdmin()` w UI | `[Authorize(Roles = "Admin")]` `PUT /api/admin/orders/{id}/approve-hold` / `reject-hold` | `Admin` |
| `E-015` | approve/reject return | `isAdmin()` w UI | `[Authorize(Roles = "Admin")]` `PUT /api/admin/orders/{id}/approve-return` / `reject-return` | `Admin` |

## Uprawnienia per rola

### Admin
- Widzi listę wszystkich zamówień (`GET /api/admin/orders`).
- Może anulować dowolne zamówienie.
- Może zatwierdzić/odrzucić zamówienia on-hold i zwroty.
- Może wykonać masową zmianę statusów.
- Widzi analitykę zamówień.

### Dealer
- Widzi tylko swoje zamówienia (`GET /api/orders/my` filtruje po `DealerId` z JWT).
- Może złożyć zamówienie.
- Może anulować swoje zamówienia w statusie `Pending`.
- Może zgłosić zwrot dla dostarczonego zamówienia.
- Nie ma dostępu do panelu admin zamówień.

### Warehouse
- Widzi listę wszystkich zamówień i analitykę (`GET /api/admin/orders`, `analytics`).
- Nie może zmieniać statusów ani wykonywać bulk-status.
- Nie może anulować ani zatwierdzać zamówień.

### Logistics
- Widzi listę wszystkich zamówień i analitykę.
- Może wykonać masową zmianę statusów (`bulk-status`).
- Może zmienić status pojedynczego zamówienia (`PUT /api/orders/{id}/status` przez runtime check `CanManageOrderStatus`).
- Nie może zatwierdzać/odrzucać on-hold ani zwrotów.

### Agent
- Brak bezpośredniego dostępu do ekranów zamówień.
- Tracking wysyłki powiązanej z zamówieniem dostępny przez E-014 (LogisticsTracking).

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-ROLE-013-001` | `PUT /api/orders/{id}/status` używa runtime check `CanManageOrderStatus()` zamiast `[Authorize(Roles=...)]` — ochrona jest poprawna, ale niedeklaratywna i trudniejsza do audytu. | `potwierdzone` |
| `RISK-ROLE-013-002` | `GET /api/orders/{id}` jest dostępny dla każdego zalogowanego, a filtrowanie właściciela odbywa się w serwisie aplikacji — brak walidacji na poziomie atrybutu. | `potwierdzone` |
| `RISK-ROLE-013-003` | Warehouse widzi listę wszystkich zamówień, ale nie może nic zmienić — brak granularnej kontroli odczytu vs zapisu na poziomie roli. | `wniosek z analizy` |
