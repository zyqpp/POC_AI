# Role I Uprawnienia: Shipment Detail I Tracking

Status: `potwierdzone` na podstawie routingu Angular, warunków komponentów, `[Authorize]` w kontrolerach i warunków runtime.
Zakres: `/shipments/:id`, `/orders/:id/tracking`, endpointy LogisticsTracking i powiązany odczyt orderu.

## Macierz Route

| Route | Komponent | Guard frontend | Role frontend | Backend główny | Status |
|---|---|---|---|---|---|
| `/shipments/:id` | `ShipmentDetailComponent` | `authGuard` parent + `roleGuard` | `Admin`, `Logistics`, `Agent`, `Dealer` | `ShipmentsController.GetById` | potwierdzone |
| `/orders/:id/tracking` | `OrderTrackingComponent` | `authGuard` parent + `roleGuard` | `Admin`, `Dealer`, `Logistics`, `Agent` | Order API + Logistics API list endpoints | potwierdzone |

## Macierz Akcji `/shipments/:id`

| Akcja | UI role / warunek | Endpoint | `[Authorize]` | Warunek runtime / data scope | Status |
|---|---|---|---|---|---|
| Odczyt szczegółu | route role | `GET /logistics/api/logistics/shipments/{id}` | `Admin,Logistics,Agent,Dealer` | Dealer tylko `DealerId == userId`; Agent tylko `AssignedAgentId == userId`; inaczej `404` | potwierdzone |
| Odczyt ops-state | route role | `GET .../{id}/ops-state` | `Admin,Logistics,Agent,Dealer` | takie samo scope jak shipment detail | potwierdzone |
| Assign agent | `Admin`, `Logistics`, brak `assignedAgentId` | `PUT .../{id}/assign-agent` | `Admin,Logistics` | validator sprawdza tylko niepusty GUID | potwierdzone; ryzyko Identity |
| Assign vehicle | `Admin`, `Logistics` | `PUT .../{id}/assign-vehicle` | `Admin,Logistics` | validator pojazdu; domena blokuje completed/returned | potwierdzone |
| Accept assignment | `Agent`, własny `AssignedAgentId`, decision `Pending`, status niekońcowy | `PUT .../{id}/assignment/accept` | `Agent` | service wymaga `AssignedAgentId == agentId`; domena blokuje completed/returned | potwierdzone |
| Reject assignment | jak accept + reason wymagany | `PUT .../{id}/assignment/reject` | `Agent` | service wymaga przypisanego agenta; validator reason max 500 | potwierdzone |
| Update status | `Admin`/`Logistics`; Agent tylko accepted assignment | `PUT .../{id}/status` | `Admin,Logistics,Agent` | Agent musi być przypisany i accepted; vehicle wymagany dla statusów transportowych; domena blokuje completed/returned | potwierdzone |
| Mark Out For Delivery | Agent accepted, własny shipment, pojazd, status `Assigned/PickedUp/InTransit` | `PUT .../{id}/status` | `Admin,Logistics,Agent` | backend jak update status | potwierdzone |
| Approve Delivery | Agent accepted, własny shipment, pojazd, status `OutForDelivery/InTransit` | `PUT .../{id}/status` | `Admin,Logistics,Agent` | `Delivered` wymaga pojazdu | potwierdzone |
| Log Attempt | `Admin`, `Logistics`, `Agent` | brak API | brak | localStorage per przeglądarka | potwierdzone jako frontend-only |
| Raise Handover Exception | `Admin`, `Logistics`, ops-state nie completed | `PUT .../{id}/ops-state` | `Admin,Logistics` | notification manual z UI | potwierdzone |
| Schedule Retry | `Admin`, `Logistics`, failure/returned albo retry sugerowany | `PUT .../{id}/ops-state` | `Admin,Logistics` | notification manual z UI | potwierdzone |
| Mark Handover Completed | `Admin`, `Logistics`, ops-state nie completed | `PUT .../{id}/ops-state` | `Admin,Logistics` | sync z shipmentem może utrzymać completed | potwierdzone |
| Rate Delivery Agent | `Dealer`, status `Delivered`, agent przypisany | `PUT .../{id}/agent-rating` | `Dealer` | kontroler sprawdza `shipment.DealerId == dealerId`; domena wymaga delivered i rating 1-5 | potwierdzone |
| Ask Chatbot | UI: `Admin`, `Logistics`, `Agent`, `Dealer` | `POST .../chatbot/ask` | `Admin,Logistics,Agent,Dealer,Warehouse` | role-scoped shipments w serwisie | konflikt UI/backend |
| Escalate Delay | UI: `Admin`, SLA at-risk/delayed/exception | `POST /notifications/api/notifications/manual` | zależne od Notification API | brak zapisu w Logistics DB | potwierdzone |

## Macierz `/orders/:id/tracking`

| Akcja | UI role / warunek | Endpoint | Backend role / scope | Ryzyko | Status |
|---|---|---|---|---|---|
| Wejście na route | `Admin`, `Dealer`, `Logistics`, `Agent` | brak jednego endpointu tracking | route frontend tylko | brak backendowego kontraktu tracking | potwierdzone |
| Odczyt orderu | route role | `GET /orders/api/orders/{id}` | `[Authorize]`; `Admin`, `Warehouse`, `Logistics` albo Dealer właściciel | Agent route istnieje, ale order detail zwykle `404` | potwierdzone |
| Lista shipmentów Dealer | `Dealer` | `GET /logistics/api/logistics/shipments/my` | `Dealer` | filtr po orderId dopiero w UI | potwierdzone |
| Lista shipmentów Agent | `Agent` | `GET /logistics/api/logistics/shipments/assigned` | `Agent` | order detail może być null, ale tracking shipmentów działa | potwierdzone |
| Lista shipmentów Admin/Logistics | `Admin`, `Logistics` | `GET /logistics/api/logistics/shipments` | `Admin`, `Logistics` | pobiera wszystkie shipmenty i filtruje w przeglądarce | potwierdzone |
| Accept/reject assignment z tracking | `Agent`, własny shipment | endpointy assignment | `Agent` + przypisanie | jak w shipment detail | potwierdzone |
| Mark out for delivery z tracking | `Agent`, accepted assignment, status allowed | `PUT .../status` | `Agent` + accepted + vehicle required | UI tracking nie sprawdza pojazdu | potwierdzone jako rozjazd |
| Approve delivery z tracking | `Agent`, accepted assignment, status allowed | `PUT .../status` | `Agent` + accepted + vehicle required | UI tracking nie sprawdza pojazdu | potwierdzone jako rozjazd |

## Rozdzielenie Ról

| Rola | Uprawnienia w tym pionie | Ograniczenia | Status |
|---|---|---|---|
| `Admin` | pełny odczyt shipmentów, assign agent/vehicle, status update, ops-state, escalation, chatbot, tracking wszystkich shipmentów | rating tylko Dealer; assignment decision tylko Agent | potwierdzone |
| `Logistics` | jak Admin w logistyce poza escalation tylko jeśli UI dopuszcza Admin dla delay escalation | nie ocenia agenta; nie accept/reject assignment | potwierdzone |
| `Agent` | odczyt przypisanych shipmentów, accept/reject assignment, status update po accepted, tracking z poziomu order tracking | brak assign vehicle/agent, brak PUT ops-state, brak dostępu do cudzych shipmentów | potwierdzone |
| `Dealer` | odczyt własnych shipmentów, rating po dostawie, tracking swoich shipmentów, chatbot | brak update status, brak ops-state PUT, brak assign | potwierdzone |
| `Warehouse` | backend chatbot dopuszcza Warehouse | frontend route `/shipments/:id` i chatbot UI nie dopuszczają Warehouse | konflikt potwierdzony |

## Data Scope

| Obszar | Reguła | Sposób egzekucji | Status |
|---|---|---|---|
| Shipment detail Dealer | `shipment.DealerId == userId` | kontroler po pobraniu shipmentu, inaczej `404` | potwierdzone |
| Shipment detail Agent | `shipment.AssignedAgentId == userId` | kontroler po pobraniu shipmentu, inaczej `404` | potwierdzone |
| Ops-state Dealer/Agent | najpierw sprawdzany shipment i scope, potem ops-state | kontroler `GetOpsState` i `GetOpsStatesBatch` | potwierdzone |
| Shipment list Dealer | tylko `DealerId == dealerId` | repo `GetDealerShipmentsAsync` | potwierdzone |
| Shipment list Agent | tylko `AssignedAgentId == agentId` | repo `GetAgentShipmentsAsync` | potwierdzone |
| Order tracking Order API | `Admin/Warehouse/Logistics` albo Dealer właściciel | `OrderService.GetOrderAsync`; Agent nie jest admin-like | potwierdzone |
| Assign agent | brak weryfikacji, że `AgentId` należy do roli Agent | tylko `Guid.NotEmpty()` | ryzyko potwierdzone |

## Konflikty I Luki Ról

| Priorytet | Konflikt / luka | Dowód | Rekomendacja |
|---|---|---|---|
| P0 | Delivery attempts mają tylko frontendowe role i localStorage, bez autoryzacji backendowej. | `ShipmentDeliveryAttemptsService` | Jeżeli próby dostawy są biznesowo istotne, wymagany backend audit. |
| P1 | `/orders/:id/tracking` dopuszcza Agenta, ale Order API nie daje mu order detail. | `OrderTrackingComponent` obsługuje brak orderu komunikatem | Opisać jako świadomy UX albo dodać tracking DTO dla Agenta. |
| P1 | Admin/Logistics tracking pobiera wszystkie shipmenty. | `getAllShipments()` i filtr w UI | Endpoint server-side po `orderId` albo ograniczenie payloadu. |
| P1 | Tracking Agent action nie sprawdza pojazdu, backend sprawdza. | `OrderTrackingComponent.canMarkOutForDelivery`, `LogisticsService.RequiresVehicleForAgentStatus` | Ujednolicić UI i backend w osobnym zadaniu. |
| P1 | Chatbot backend dopuszcza Warehouse, UI nie. | `ShipmentsController.cs:265`, `shipment-detail.component.ts:156` | Decyzja, czy Warehouse ma mieć route/UI do chatbota. |
| P1 | Assign agent nie waliduje aktywnego agenta w IdentityAuth. | `AssignAgentRequestValidator` | Dodać test i integracyjny check w osobnym zadaniu implementacyjnym. |
