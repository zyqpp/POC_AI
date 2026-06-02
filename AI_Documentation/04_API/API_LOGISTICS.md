# API_LOGISTICS

Status: `potwierdzone` na podstawie `ShipmentsController.cs` i `LogisticsDtos.cs`.

Serwis: `LogisticsTracking.API` — gateway prefix `/logistics`

| ID | Metoda | Ścieżka | Kontroler | Rola | Request DTO | Response DTO | Statusy |
|---|---|---|---|---|---|---|---|
| `API-LOG-001` | `POST` | `/logistics/api/logistics/shipments` | `ShipmentsController.Create` | `Admin,Logistics` | `CreateShipmentRequest` | `ShipmentDto` | `201` |
| `API-LOG-002` | `GET` | `/logistics/api/logistics/shipments/{shipmentId}` | `ShipmentsController.GetById` | `Admin,Logistics,Agent,Dealer` (scope) | route `shipmentId:guid` | `ShipmentDto` | `200`, `401`, `404` |
| `API-LOG-003` | `GET` | `/logistics/api/logistics/shipments/my` | `ShipmentsController.GetMine` | `Dealer` | brak | `IReadOnlyList<ShipmentDto>` | `200`, `401` |
| `API-LOG-004` | `GET` | `/logistics/api/logistics/shipments` | `ShipmentsController.GetAll` | `Admin,Logistics` | brak | `IReadOnlyList<ShipmentDto>` | `200`, `401`, `403` |
| `API-LOG-005` | `GET` | `/logistics/api/logistics/shipments/assigned` | `ShipmentsController.GetAssigned` | `Agent` | brak | `IReadOnlyList<ShipmentDto>` | `200`, `401`, `403` |
| `API-LOG-010` | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/assign-agent` | `ShipmentsController.AssignAgent` | `Admin,Logistics` | `AssignAgentRequest` | `{ message }` | `200`, `404` |
| `API-LOG-011` | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/assignment/accept` | `ShipmentsController.AcceptAssignment` | `Agent` | brak | `{ message }` | `200`, `404` |
| `API-LOG-012` | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/assignment/reject` | `ShipmentsController.RejectAssignment` | `Agent` | `RejectAssignmentRequest` | `{ message }` | `200`, `404` |
| `API-LOG-013` | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/assign-vehicle` | `ShipmentsController.AssignVehicle` | `Admin,Logistics` | `AssignVehicleRequest` | `{ message }` | `200`, `404` |
| `API-LOG-014` | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/status` | `ShipmentsController.UpdateStatus` | `Admin,Logistics,Agent` (Agent tylko przypisane i zaakceptowane) | `UpdateShipmentStatusRequest` | `{ message }` | `200`, `404`, `409` |
| `API-LOG-015` | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/agent-rating` | `ShipmentsController.RateDeliveryAgent` | `Dealer` (tylko własne przesyłki) | `RateDeliveryAgentRequest` | `{ message }` | `200`, `401`, `404` |
| `API-LOG-020` | `GET` | `/logistics/api/logistics/shipments/{shipmentId}/ops-state` | `ShipmentsController.GetOpsState` | `Admin,Logistics,Agent,Dealer` (scope) | route `shipmentId:guid` | `ShipmentOpsStateDto` | `200`, `401`, `404` |
| `API-LOG-021` | `POST` | `/logistics/api/logistics/shipments/ops-states/batch` | `ShipmentsController.GetOpsStatesBatch` | `Admin,Logistics,Agent,Dealer` (scope) | `GetShipmentOpsStatesRequest` | `IReadOnlyList<ShipmentOpsStateDto>` | `200`, `401` |
| `API-LOG-022` | `PUT` | `/logistics/api/logistics/shipments/{shipmentId}/ops-state` | `ShipmentsController.UpsertOpsState` | `Admin,Logistics` | `UpsertShipmentOpsStateRequest` | `ShipmentOpsStateDto` | `200`, `404` |
| `API-LOG-030` | `POST` | `/logistics/api/logistics/shipments/chatbot/ask` | `ShipmentsController.AskChatbot` | `Admin,Logistics,Agent,Dealer,Warehouse` | `LogisticsChatbotRequest` | `LogisticsChatbotResponseDto` | `200`, `400` |

---

## 1. Zarządzanie Przesyłkami

### POST /api/logistics/shipments

**Opis:** Tworzy nową przesyłkę dla zamówienia. Wywoływany przez serwis `Order` po zatwierdzeniu lub manualnie przez Admina/Logistics. Aktor (userId i rola) jest pobierany z JWT i zapisywany w pierwszym zdarzeniu przesyłki.

**Rola:** `[Authorize(Roles="Admin,Logistics")]`

**Przykład żądania:**
```json
{
  "orderId": "aab85f64-5717-4562-b3fc-2c963f66afa6",
  "dealerId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "deliveryAddress": "ul. Handlowa 12",
  "city": "Warszawa",
  "state": "Mazowieckie",
  "postalCode": "00-001"
}
```

**Przykład odpowiedzi (201):**
```json
{
  "shipmentId": "bbc95f64-5717-4562-b3fc-2c963f66afa6",
  "orderId": "aab85f64-5717-4562-b3fc-2c963f66afa6",
  "dealerId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "shipmentNumber": "SHP-2026-0001",
  "deliveryAddress": "ul. Handlowa 12",
  "city": "Warszawa",
  "state": "Mazowieckie",
  "postalCode": "00-001",
  "assignedAgentId": null,
  "vehicleNumber": null,
  "assignmentDecisionStatus": "NotAssigned",
  "assignmentDecisionReason": null,
  "assignmentDecisionAtUtc": null,
  "deliveryAgentRating": null,
  "deliveryAgentRatingComment": null,
  "deliveryAgentRatedAtUtc": null,
  "deliveryAgentRatedByUserId": null,
  "status": "Created",
  "createdAtUtc": "2026-06-02T10:00:00Z",
  "deliveredAtUtc": null,
  "events": [
    {
      "shipmentEventId": "e0000001-0000-0000-0000-000000000001",
      "status": "Created",
      "note": "Shipment created.",
      "updatedByUserId": "admin-id",
      "updatedByRole": "Admin",
      "createdAtUtc": "2026-06-02T10:00:00Z"
    }
  ]
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak wymaganych pól |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Logistics |

---

### GET /api/logistics/shipments/{shipmentId}

**Opis:** Szczegóły przesyłki z pełną historią zdarzeń. Scope: Admin i Logistics widzą wszystko. Dealer widzi tylko swoje (`dealerId`). Agent widzi tylko przypisane (`assignedAgentId`).

**Rola:** `[Authorize(Roles="Admin,Logistics,Agent,Dealer")]`

**Przykład odpowiedzi (200):** `ShipmentDto` jak powyżej

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |
| `404` | Przesyłka nie istnieje lub należy do innego dealera/agenta |

---

### GET /api/logistics/shipments/my

**Opis:** Lista wszystkich przesyłek zalogowanego dealera.

**Rola:** `[Authorize(Roles="Dealer")]`

**Przykład odpowiedzi (200):** `IReadOnlyList<ShipmentDto>`

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |
| `403` | Rola inna niż Dealer |

---

### GET /api/logistics/shipments

**Opis:** Lista wszystkich przesyłek w systemie — widok operacyjny dla Admin i Logistics.

**Rola:** `[Authorize(Roles="Admin,Logistics")]`

**Przykład odpowiedzi (200):** `IReadOnlyList<ShipmentDto>`

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Logistics |

---

### GET /api/logistics/shipments/assigned

**Opis:** Lista przesyłek przypisanych do zalogowanego agenta.

**Rola:** `[Authorize(Roles="Agent")]`

**Przykład odpowiedzi (200):** `IReadOnlyList<ShipmentDto>`

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |
| `403` | Rola inna niż Agent |

---

## 2. Przydzielanie i Zarządzanie Agentami

### PUT /api/logistics/shipments/{shipmentId}/assign-agent

**Opis:** Przypisuje agenta do przesyłki. Po przypisaniu status `AssignmentDecisionStatus` zmienia się na `Pending` — agent musi zaakceptować lub odrzucić.

**Rola:** `[Authorize(Roles="Admin,Logistics")]`

**Przykład żądania:**
```json
{
  "agentId": "4ab95f64-5717-4562-b3fc-2c963f66afa6"
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "Agent assigned."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Logistics |
| `404` | Przesyłka nie istnieje |

---

### PUT /api/logistics/shipments/{shipmentId}/assignment/accept

**Opis:** Agent akceptuje przypisanie do przesyłki. `AssignmentDecisionStatus` zmienia się na `Accepted`.

**Rola:** `[Authorize(Roles="Agent")]`

**Żądanie:** brak body

**Przykład odpowiedzi (200):**
```json
{
  "message": "Assignment accepted."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Agent |
| `404` | Przesyłka nie istnieje lub agent nie jest przypisany |

---

### PUT /api/logistics/shipments/{shipmentId}/assignment/reject

**Opis:** Agent odrzuca przypisanie z podaniem powodu. `AssignmentDecisionStatus` zmienia się na `Rejected`.

**Rola:** `[Authorize(Roles="Agent")]`

**Przykład żądania:**
```json
{
  "reason": "Brak dostępności w dniu dostawy."
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "Assignment rejected."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak `reason` |
| `401` | Brak tokenu |
| `403` | Rola inna niż Agent |
| `404` | Przesyłka nie istnieje lub agent nie jest przypisany |

---

### PUT /api/logistics/shipments/{shipmentId}/assign-vehicle

**Opis:** Przypisuje numer pojazdu do przesyłki.

**Rola:** `[Authorize(Roles="Admin,Logistics")]`

**Przykład żądania:**
```json
{
  "vehicleNumber": "WZ1234AB"
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "Vehicle assigned."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak `vehicleNumber` |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Logistics |
| `404` | Przesyłka nie istnieje |

---

## 3. Status i Ocena

### PUT /api/logistics/shipments/{shipmentId}/status

**Opis:** Aktualizuje status przesyłki. Agent może zmieniać status tylko dla przypisanej i zaakceptowanej przesyłki. Zmiana statusu tworzy nowe zdarzenie `ShipmentEventDto`.

**Rola:** `[Authorize(Roles="Admin,Logistics,Agent")]`

**Wartości `Status`** (enum `ShipmentStatus`): `Created`, `Dispatched`, `InTransit`, `OutForDelivery`, `Delivered`, `DeliveryFailed`, `Returned`

**Przykład żądania:**
```json
{
  "status": "InTransit",
  "note": "Paczka odebrana od spedytora. ETA: 04.06.2026."
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "Shipment status updated."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak `status` lub `note` |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Logistics/Agent |
| `404` | Przesyłka nie istnieje lub agent nie jest przypisany |
| `409` | Agent próbuje zmienić status przed zaakceptowaniem przypisania |

---

### PUT /api/logistics/shipments/{shipmentId}/agent-rating

**Opis:** Dealer ocenia agenta po dostawie. Weryfikacja `dealerId` z tokenu — dealer może oceniać tylko własne przesyłki.

**Rola:** `[Authorize(Roles="Dealer")]`

**Przykład żądania:**
```json
{
  "rating": 5,
  "comment": "Bardzo profesjonalna obsługa, dostawa na czas."
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "Delivery agent rated."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | `rating` poza zakresem (zwykle 1-5) |
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |
| `403` | Rola inna niż Dealer |
| `404` | Przesyłka nie istnieje lub należy do innego dealera |

---

## 4. Ops State (Stan Operacyjny)

### GET /api/logistics/shipments/{shipmentId}/ops-state

**Opis:** Pobiera stan operacyjny przesyłki — używany przez background workery do śledzenia prób dostawy, wyjątków i retryów. Scope identyczny jak `GetById`.

**Rola:** `[Authorize(Roles="Admin,Logistics,Agent,Dealer")]`

**Przykład odpowiedzi (200):**
```json
{
  "shipmentId": "bbc95f64-5717-4562-b3fc-2c963f66afa6",
  "handoverState": "Attempted",
  "handoverExceptionReason": "Odbiorca nieobecny.",
  "retryRequired": true,
  "retryCount": 1,
  "retryReason": "Pierwsza próba nieudana.",
  "nextRetryAtUtc": "2026-06-03T09:00:00Z",
  "lastRetryScheduledAtUtc": "2026-06-02T15:00:00Z",
  "updatedAtUtc": "2026-06-02T15:05:00Z"
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |
| `404` | Stan nie istnieje lub brak dostępu do przesyłki |

---

### POST /api/logistics/shipments/ops-states/batch

**Opis:** Pobiera stany operacyjne dla listy przesyłek. Dealer i Agent widzą tylko dostępne dla nich przesyłki — niedostępne są pomijane (brak błędu 403).

**Rola:** `[Authorize(Roles="Admin,Logistics,Agent,Dealer")]`

**Przykład żądania:**
```json
{
  "shipmentIds": [
    "bbc95f64-5717-4562-b3fc-2c963f66afa6",
    "ccd06a75-5717-4562-b3fc-2c963f66afa6"
  ]
}
```

**Przykład odpowiedzi (200):** `IReadOnlyList<ShipmentOpsStateDto>`

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |

---

### PUT /api/logistics/shipments/{shipmentId}/ops-state

**Opis:** Upsert stanu operacyjnego przesyłki. Wywoływany przez background workery po próbie dostawy.

**Rola:** `[Authorize(Roles="Admin,Logistics")]`

**Przykład żądania:**
```json
{
  "handoverState": "Attempted",
  "handoverExceptionReason": "Odbiorca nieobecny.",
  "retryRequired": true,
  "retryCount": 1,
  "retryReason": "Pierwsza próba nieudana.",
  "nextRetryAtUtc": "2026-06-03T09:00:00Z",
  "lastRetryScheduledAtUtc": "2026-06-02T15:00:00Z"
}
```

**Przykład odpowiedzi (200):** `ShipmentOpsStateDto`

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin/Logistics |
| `404` | Przesyłka nie istnieje |

---

## 5. Chatbot AI

### POST /api/logistics/shipments/chatbot/ask

**Opis:** Zadaje pytanie chatbotowi logistycznemu opartemu na AI. Chatbot ma dostęp do danych przesyłek aktualnego użytkownika i odpowiada w języku naturalnym. Zwraca intent, odpowiedź, źródła danych i sugerowane kolejne pytania.

**Rola:** `[Authorize(Roles="Admin,Logistics,Agent,Dealer,Warehouse")]`

**Przykład żądania:**
```json
{
  "message": "Gdzie jest moja przesyłka SHP-2026-0001?"
}
```

**Przykład odpowiedzi (200):**
```json
{
  "intent": "ShipmentStatusQuery",
  "reply": "Przesyłka SHP-2026-0001 jest w trasie (InTransit). Szacowana dostawa: 04.06.2026.",
  "sources": [
    {
      "type": "Shipment",
      "reference": "SHP-2026-0001",
      "detail": "Status: InTransit, ostatnia aktualizacja: 02.06.2026 10:00 UTC"
    }
  ],
  "suggestedPrompts": [
    "Kiedy zostanie dostarczona przesyłka SHP-2026-0001?",
    "Kto jest agentem dostawy dla SHP-2026-0001?"
  ],
  "createdAtUtc": "2026-06-02T10:05:00Z"
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Puste pole `message` |
| `401` | Brak tokenu |
| `403` | Rola nie ma dostępu do chatbota |

---

## Kontrakty Danych

| DTO | Pola kluczowe | Opis |
|---|---|---|
| `CreateShipmentRequest` | `OrderId`, `DealerId`, `DeliveryAddress`, `City`, `State`, `PostalCode` | Tworzenie przesyłki |
| `AssignAgentRequest` | `AgentId` | Przypisanie agenta |
| `AssignVehicleRequest` | `VehicleNumber` | Przypisanie pojazdu |
| `RejectAssignmentRequest` | `Reason` | Odrzucenie przypisania przez agenta |
| `RateDeliveryAgentRequest` | `Rating`, `Comment?` | Ocena agenta przez dealera |
| `UpdateShipmentStatusRequest` | `Status` (enum `ShipmentStatus`), `Note` | Zmiana statusu przesyłki |
| `GetShipmentOpsStatesRequest` | `ShipmentIds: IReadOnlyList<Guid>` | Batch request stanów operacyjnych |
| `UpsertShipmentOpsStateRequest` | `HandoverState?`, `HandoverExceptionReason?`, `RetryRequired?`, `RetryCount?`, `RetryReason?`, `NextRetryAtUtc?`, `LastRetryScheduledAtUtc?` | Upsert stanu operacyjnego |
| `LogisticsChatbotRequest` | `Message` | Pytanie do chatbota |
| `ShipmentDto` | `ShipmentId`, `OrderId`, `DealerId`, `ShipmentNumber`, `DeliveryAddress`, `City`, `State`, `PostalCode`, `AssignedAgentId?`, `VehicleNumber?`, `AssignmentDecisionStatus`, `AssignmentDecisionReason?`, `AssignmentDecisionAtUtc?`, `DeliveryAgentRating?`, `DeliveryAgentRatingComment?`, `DeliveryAgentRatedAtUtc?`, `DeliveryAgentRatedByUserId?`, `Status`, `CreatedAtUtc`, `DeliveredAtUtc?`, `Events[]` | Pełna przesyłka |
| `ShipmentEventDto` | `ShipmentEventId`, `Status`, `Note`, `UpdatedByUserId`, `UpdatedByRole`, `CreatedAtUtc` | Zdarzenie w historii przesyłki |
| `ShipmentOpsStateDto` | `ShipmentId`, `HandoverState`, `HandoverExceptionReason?`, `RetryRequired`, `RetryCount`, `RetryReason?`, `NextRetryAtUtc?`, `LastRetryScheduledAtUtc?`, `UpdatedAtUtc` | Stan operacyjny przesyłki |
| `LogisticsChatbotResponseDto` | `Intent`, `Reply`, `Sources[]`, `SuggestedPrompts[]`, `CreatedAtUtc` | Odpowiedź chatbota |
| `LogisticsChatbotSourceDto` | `Type`, `Reference`, `Detail` | Źródło danych chatbota |

## Enumeracje

| Enum | Wartości |
|---|---|
| `ShipmentStatus` | `Created`, `Dispatched`, `InTransit`, `OutForDelivery`, `Delivered`, `DeliveryFailed`, `Returned` |
| `AssignmentDecisionStatus` | `NotAssigned`, `Pending`, `Accepted`, `Rejected` |

## Uwagi Autoryzacyjne

- Scope dla Dealer i Agent jest egzekwowany bezpośrednio w kontrolerze (nie middleware) — brak dostępu zwraca `404` zamiast `403` żeby uniknąć wycieku informacji.
- Agent może zmienić status przesyłki dopiero po zaakceptowaniu przypisania — naruszenie zwraca `409 Conflict`.
- Chatbot ma dostęp do danych przesyłek w zakresie roli wywołującego — Agent widzi tylko przypisane, Dealer widzi tylko własne.
- Pełna historia zdarzeń (`Events`) jest wbudowana w `ShipmentDto` — brak osobnego endpointu `/events`.
- Szczegółowy opis ekranu `E-SHIPMENT_DETAIL` i jego interakcji z API jest w `AI_Documentation/04_API/API_SHIPMENT_DETAIL.md`.
