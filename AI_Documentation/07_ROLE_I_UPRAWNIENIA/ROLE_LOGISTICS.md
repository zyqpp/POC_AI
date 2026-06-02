# ROLE_LOGISTICS

Status: `potwierdzone` dla `E-016_SHIPMENTS_LIST`, `E-017_SHIPMENT_DETAIL`, `E-014_TRACKING`.

| Obszar | Mechanizm | Role | Efekt |
|---|---|---|---|
| Route `/shipments` (lista) | `roleGuard Admin,Logistics` | `Admin`, `Logistics` | lista wszystkich wysyłek |
| Route `/shipments/assigned` (lista agenta) | `roleGuard Agent` | `Agent` | lista przypisanych wysyłek |
| Route `/shipments/:id` (detail) | `authGuard` + `roleGuard Admin,Logistics,Agent,Dealer` | wg atrybutu | szczegół wysyłki (backend filtruje wg roli) |
| `POST /api/logistics/shipments` | `[Authorize(Roles = "Admin,Logistics")]` | `Admin`, `Logistics` | tworzenie wysyłki |
| `GET /api/logistics/shipments` | `[Authorize(Roles = "Admin,Logistics")]` | `Admin`, `Logistics` | lista wszystkich wysyłek |
| `GET /api/logistics/shipments/assigned` | `[Authorize(Roles = "Agent")]` | `Agent` | lista wysyłek przypisanych do agenta (filtr po `AssignedAgentId`) |
| `GET /api/logistics/shipments/my` | `[Authorize(Roles = "Dealer")]` | `Dealer` | lista wysyłek dealera (filtr po `DealerId`) |
| `GET /api/logistics/shipments/{id}` | `[Authorize(Roles = "Admin,Logistics,Agent,Dealer")]` | wszystkie role | backend sprawdza właściciela dla Dealer i Agent |
| `PUT /api/logistics/shipments/{id}/assign-agent` | `[Authorize(Roles = "Admin,Logistics")]` | `Admin`, `Logistics` | przypisanie agenta do wysyłki |
| `PUT /api/logistics/shipments/{id}/assignment/accept` | `[Authorize(Roles = "Agent")]` | `Agent` | akceptacja przypisania przez agenta |
| `PUT /api/logistics/shipments/{id}/assignment/reject` | `[Authorize(Roles = "Agent")]` | `Agent` | odrzucenie przypisania z powodem |
| `PUT /api/logistics/shipments/{id}/status` | `[Authorize(Roles = "Admin,Logistics,Agent")]` | `Admin`, `Logistics`, `Agent` | zmiana statusu (Agent tylko dla przypisanych i zaakceptowanych) |
| `PUT /api/logistics/shipments/{id}/assign-vehicle` | `[Authorize(Roles = "Admin,Logistics")]` | `Admin`, `Logistics` | przypisanie pojazdu |
| `PUT /api/logistics/shipments/{id}/agent-rating` | `[Authorize(Roles = "Dealer")]` | `Dealer` | ocena agenta po dostawie |
| `GET /api/logistics/shipments/{id}/ops-state` | `[Authorize(Roles = "Admin,Logistics,Agent,Dealer")]` | wszystkie role | odczyt stanu operacyjnego (backend filtruje wg roli) |
| `PUT /api/logistics/shipments/{id}/ops-state` | `[Authorize(Roles = "Admin,Logistics")]` | `Admin`, `Logistics` | upsert stanu operacyjnego |
| `POST /api/logistics/shipments/ops-states/batch` | `[Authorize(Roles = "Admin,Logistics,Agent,Dealer")]` | wszystkie role | batch odczyt ops-state (backend filtruje wg roli) |
| `POST /api/logistics/shipments/chatbot/ask` | `[Authorize(Roles = "Admin,Logistics,Agent,Dealer,Warehouse")]` | wszystkie role | pytanie do chatbota logistycznego |

## Macierz Ekran / Akcja / Endpoint

| Ekran | Akcja | Frontend | Backend | Role |
|---|---|---|---|---|
| `E-016` | lista wszystkich wysyłek | `roleGuard Admin,Logistics` | `[Authorize(Roles = "Admin,Logistics")]` `GET /api/logistics/shipments` | `Admin`, `Logistics` |
| `E-016` | lista przypisanych wysyłek | `roleGuard Agent` | `[Authorize(Roles = "Agent")]` `GET /api/logistics/shipments/assigned` | `Agent` |
| `E-016` | lista własnych wysyłek | `roleGuard Dealer` | `[Authorize(Roles = "Dealer")]` `GET /api/logistics/shipments/my` | `Dealer` |
| `E-016` | tworzenie wysyłki | `roleGuard Admin,Logistics` w UI | `[Authorize(Roles = "Admin,Logistics")]` `POST /api/logistics/shipments` | `Admin`, `Logistics` |
| `E-017` | szczegół wysyłki | `authGuard` | `[Authorize(Roles = "Admin,Logistics,Agent,Dealer")]` `GET /api/logistics/shipments/{id}` | wszystkie (filtr wg roli) |
| `E-017` | przypisanie agenta | `isAdmin/isLogistics()` w UI | `[Authorize(Roles = "Admin,Logistics")]` `PUT /{id}/assign-agent` | `Admin`, `Logistics` |
| `E-017` | przypisanie pojazdu | `isAdmin/isLogistics()` w UI | `[Authorize(Roles = "Admin,Logistics")]` `PUT /{id}/assign-vehicle` | `Admin`, `Logistics` |
| `E-017` | akceptacja przypisania | `isAgent()` w UI | `[Authorize(Roles = "Agent")]` `PUT /{id}/assignment/accept` | `Agent` |
| `E-017` | odrzucenie przypisania | `isAgent()` w UI | `[Authorize(Roles = "Agent")]` `PUT /{id}/assignment/reject` | `Agent` |
| `E-017` | zmiana statusu wysyłki | `isAdmin/isLogistics/isAgent()` w UI | `[Authorize(Roles = "Admin,Logistics,Agent")]` `PUT /{id}/status` | `Admin`, `Logistics`, `Agent` (tylko przypisane) |
| `E-017` | ocena agenta | `isDealer()` w UI | `[Authorize(Roles = "Dealer")]` `PUT /{id}/agent-rating` | `Dealer` (tylko własna wysyłka) |
| `E-017` | ops-state odczyt | `authGuard` | `[Authorize(Roles = "Admin,Logistics,Agent,Dealer")]` `GET /{id}/ops-state` | wszystkie (filtr wg roli) |
| `E-017` | ops-state zapis | `isAdmin/isLogistics()` w UI | `[Authorize(Roles = "Admin,Logistics")]` `PUT /{id}/ops-state` | `Admin`, `Logistics` |
| `E-014` | tracking wysyłki | `authGuard` | `GET /{id}` + `GET /{id}/ops-state` | `Admin`, `Logistics`, `Agent`, `Dealer` |

## Uprawnienia per rola

### Admin
- Pełny dostęp do wszystkich wysyłek.
- Może tworzyć wysyłki, przypisywać agentów i pojazdy, zmieniać statusy, upsertować ops-state.
- Może odczytać ops-state dowolnej wysyłki.

### Logistics
- Widzi listę wszystkich wysyłek.
- Może tworzyć wysyłki, przypisywać agentów i pojazdy.
- Może zmieniać statusy wysyłek, upsertować ops-state.

### Agent
- Widzi tylko wysyłki przypisane do siebie (`GET /assigned` filtruje po `AssignedAgentId`).
- Może zaakceptować lub odrzucić przypisanie.
- Może zmienić status wysyłki TYLKO jeśli jest przypisany (`AssignedAgentId == userId`) I akceptacja jest `Accepted` — runtime check w kontrolerze.
- Może odczytać ops-state tylko dla swoich wysyłek.

### Dealer
- Widzi tylko własne wysyłki (`GET /my` filtruje po `DealerId`).
- Może odebrać szczegół wysyłki tylko jeśli `DealerId` == jego ID — backend zwraca 404 w innym przypadku.
- Może ocenić agenta po dostawie.
- Widzi tracking i ops-state tylko dla swoich wysyłek.
- Brak możliwości zapisu.

### Warehouse
- Brak dostępu do ekranów logistycznych (poza chatbotem).

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-ROLE-016-001` | Agent może zmienić status wysyłki tylko przez runtime check (sprawdzenie `AssignedAgentId` i `AssignmentDecisionStatus` w kontrolerze), nie przez deklaratywny atrybut. | `potwierdzone` |
| `RISK-ROLE-016-002` | `POST /ops-states/batch` dla Dealer i Agent wykonuje pętlę `GetShipmentQuery` per ShipmentId — przy dużej liście może generować N+1 zapytań do bazy. | `wniosek z analizy` |
| `RISK-ROLE-016-003` | Dealer może ocenić agenta tylko jeśli `DealerId` zgadza się — sprawdzane przez dodatkowy `GetShipmentQuery` przed zapisem ratingu, co jest redundantne ale poprawne. | `potwierdzone` |
