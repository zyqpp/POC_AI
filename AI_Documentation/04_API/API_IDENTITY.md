# API_IDENTITY

Status: `potwierdzone` na podstawie kontrolerów `AuthController`, `UsersController`, `AdminDealersController`, `AdminUsersController`.

Serwis: `IdentityAuth.API` — gateway prefix `/identity`

| ID | Metoda | Ścieżka | Kontroler | Rola | Request DTO | Response DTO | Statusy |
|---|---|---|---|---|---|---|---|
| `API-ID-001` | `POST` | `/identity/api/auth/register` | `AuthController.Register` | `[AllowAnonymous]` | `RegisterDealerRequest` | `RegisterDealerResponse` | `201` |
| `API-ID-002` | `POST` | `/identity/api/auth/login` | `AuthController.Login` | `[AllowAnonymous]` | `LoginRequest` | `AuthResponse` (RefreshToken pusty — w cookie) | `200` |
| `API-ID-003` | `POST` | `/identity/api/auth/refresh` | `AuthController.Refresh` | `[AllowAnonymous]` | cookie `refreshToken` | `AuthResponse` | `200`, `401` |
| `API-ID-004` | `POST` | `/identity/api/auth/forgot-password` | `AuthController.ForgotPassword` | `[AllowAnonymous]` | `ForgotPasswordRequest` | `{ message }` | `200` |
| `API-ID-005` | `POST` | `/identity/api/auth/reset-password` | `AuthController.ResetPassword` | `[AllowAnonymous]` | `ResetPasswordRequest` | `{ message }` | `200` |
| `API-ID-006` | `POST` | `/identity/api/auth/change-password` | `AuthController.ChangePassword` | `[Authorize]` (każda rola) | `ChangePasswordRequest` | `{ message }` | `200`, `401` |
| `API-ID-007` | `POST` | `/identity/api/auth/logout` | `AuthController.Logout` | `[Authorize]` (każda rola) | `LogoutRequest?` (opcjonalny body) | `{ message }` | `200`, `401` |
| `API-ID-010` | `GET` | `/identity/api/users/profile` | `UsersController.GetProfile` | `[Authorize]` (każda rola) | brak | `UserProfileDto` | `200`, `401`, `404` |
| `API-ID-020` | `GET` | `/identity/api/admin/dealers` | `AdminDealersController.GetDealers` | `[Authorize(Roles="Admin")]` | query: `page`, `pageSize`, `search?` | `PagedResult<DealerSummaryDto>` | `200`, `401`, `403` |
| `API-ID-021` | `GET` | `/identity/api/admin/dealers/{id}` | `AdminDealersController.GetDealerById` | `[Authorize(Roles="Admin")]` | route `id:guid` | `DealerDetailDto` | `200`, `401`, `403`, `404` |
| `API-ID-022` | `PUT` | `/identity/api/admin/dealers/{id}/approve` | `AdminDealersController.ApproveDealer` | `[Authorize(Roles="Admin")]` | route `id:guid` | `{ message }` | `200`, `401`, `403`, `404` |
| `API-ID-023` | `PUT` | `/identity/api/admin/dealers/{id}/reject` | `AdminDealersController.RejectDealer` | `[Authorize(Roles="Admin")]` | route `id:guid`, body `RejectDealerRequest` | `{ message }` | `200`, `401`, `403`, `404` |
| `API-ID-024` | `PUT` | `/identity/api/admin/dealers/{id}/credit-limit` | `AdminDealersController.UpdateCreditLimit` | `[Authorize(Roles="Admin")]` | route `id:guid`, body `UpdateCreditLimitRequest` | `CreditLimitUpdateResult` | `200`, `401`, `403`, `404`, `502` |
| `API-ID-030` | `GET` | `/identity/api/admin/users/agents` | `AdminUsersController.GetAgents` | `[Authorize(Roles="Admin,Logistics")]` | query: `page`, `pageSize`, `search?` | `PagedResult<AgentSummaryDto>` | `200`, `401`, `403` |
| `API-ID-031` | `POST` | `/identity/api/admin/users/agents` | `AdminUsersController.CreateAgent` | `[Authorize(Roles="Admin")]` | `CreateAgentRequest` | `CreateAgentResponse` | `201`, `401`, `403` |

---

## 1. Auth

### POST /api/auth/register

**Opis:** Rejestracja nowego dealera. Konto jest tworzone ze statusem oczekującym na zatwierdzenie przez administratora.

**Rola:** publiczny (`[AllowAnonymous]`)

**Przykład żądania:**
```json
{
  "email": "dealer@example.com",
  "password": "S3cur3P@ss!",
  "fullName": "Jan Kowalski",
  "phoneNumber": "+48501234567",
  "businessName": "Kowalski Sp. z o.o.",
  "gstNumber": "GST123456789",
  "tradeLicenseNo": "TL-2024-001",
  "address": "ul. Handlowa 12",
  "city": "Warszawa",
  "state": "Mazowieckie",
  "pinCode": "00-001",
  "isInterstate": false
}
```

**Przykład odpowiedzi (201):**
```json
{
  "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "status": "Pending",
  "message": "Registration successful. Awaiting admin approval."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Walidacja — brak wymaganych pól, niepoprawny email, słabe hasło |
| `409` | Email już zarejestrowany |

---

### POST /api/auth/login

**Opis:** Logowanie użytkownika. Token odświeżający jest ustawiany jako `HttpOnly` cookie (`refreshToken`). W body odpowiedzi pole `RefreshToken` jest puste.

**Rola:** publiczny (`[AllowAnonymous]`)

**Przykład żądania:**
```json
{
  "email": "dealer@example.com",
  "password": "S3cur3P@ss!"
}
```

**Przykład odpowiedzi (200):**
```json
{
  "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "email": "dealer@example.com",
  "role": "Dealer",
  "accessToken": "eyJhbGciOi...",
  "accessTokenExpiresAtUtc": "2026-06-02T12:00:00Z",
  "refreshToken": "",
  "refreshTokenExpiresAtUtc": "2026-06-09T10:00:00Z",
  "mustChangePassword": false
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak wymaganych pól |
| `401` | Nieprawidłowe hasło lub email |
| `403` | Konto oczekuje na zatwierdzenie lub zostało odrzucone |

---

### POST /api/auth/refresh

**Opis:** Odświeżenie access tokenu przy użyciu cookie `refreshToken`. Nowy refresh token jest zapisywany w cookie. W body odpowiedzi pole `RefreshToken` jest puste.

**Rola:** publiczny (`[AllowAnonymous]`)

**Żądanie:** brak body — cookie `refreshToken` (HttpOnly, wysyłany automatycznie przez przeglądarkę)

**Przykład odpowiedzi (200):** identyczny format jak `login`

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Cookie `refreshToken` brak lub wygasł lub unieważniony |

---

### POST /api/auth/forgot-password

**Opis:** Inicjuje reset hasła — wysyła OTP na podany email. Odpowiedź jest zawsze `200` niezależnie od tego, czy konto istnieje (zapobiega enumeracji).

**Rola:** publiczny (`[AllowAnonymous]`)

**Przykład żądania:**
```json
{
  "email": "dealer@example.com"
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "If the account exists, an OTP has been sent."
}
```

---

### POST /api/auth/reset-password

**Opis:** Ustawia nowe hasło przy użyciu kodu OTP przesłanego e-mailem.

**Rola:** publiczny (`[AllowAnonymous]`)

**Przykład żądania:**
```json
{
  "email": "dealer@example.com",
  "otpCode": "123456",
  "newPassword": "N3wS3cur3P@ss!"
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "Password reset successful."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | OTP nieprawidłowy lub wygasł |
| `404` | Konto nie istnieje |

---

### POST /api/auth/change-password

**Opis:** Zmiana hasła przez zalogowanego użytkownika (wymaga podania aktualnego hasła). `userId` jest pobierany z JWT claim `sub`.

**Rola:** `[Authorize]` — każda rola

**Przykład żądania:**
```json
{
  "currentPassword": "S3cur3P@ss!",
  "newPassword": "N3wS3cur3P@ss!"
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "Password changed successfully."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Aktualne hasło nieprawidłowe |
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |

---

### POST /api/auth/logout

**Opis:** Wylogowanie — unieważnia access token (blacklista JTI) i refresh token. Usuwa cookie `refreshToken`. Body jest opcjonalny (można przekazać `refreshToken` explicite).

**Rola:** `[Authorize]` — każda rola

**Przykład żądania (opcjonalny body):**
```json
{
  "refreshToken": null
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "Logged out successfully."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |

---

## 2. Users

### GET /api/users/profile

**Opis:** Pobiera profil zalogowanego użytkownika. `userId` jest pobierany z JWT claim `sub`. Dealer dostaje dodatkowe pola `dealerBusinessName`, `dealerGstNumber`, `isInterstate`.

**Rola:** `[Authorize]` — każda rola

**Przykład odpowiedzi (200):**
```json
{
  "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "fullName": "Jan Kowalski",
  "email": "dealer@example.com",
  "role": "Dealer",
  "status": "Approved",
  "creditLimit": 50000.00,
  "dealerBusinessName": "Kowalski Sp. z o.o.",
  "dealerGstNumber": "GST123456789",
  "isInterstate": false
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu lub nieprawidłowy claim `sub` |
| `404` | Użytkownik nie istnieje |

---

## 3. Admin — Dealers

### GET /api/admin/dealers

**Opis:** Stronicowana lista dealerów z opcjonalnym filtrem tekstowym (email, imię, firma).

**Rola:** `[Authorize(Roles="Admin")]`

**Parametry query:**
| Parametr | Typ | Domyślnie | Opis |
|---|---|---|---|
| `page` | int | 1 | Numer strony |
| `pageSize` | int | 20 | Rozmiar strony |
| `search` | string? | — | Opcjonalny filtr tekstowy |

**Przykład odpowiedzi (200):**
```json
{
  "items": [
    {
      "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "fullName": "Jan Kowalski",
      "email": "dealer@example.com",
      "businessName": "Kowalski Sp. z o.o.",
      "gstNumber": "GST123456789",
      "status": "Pending",
      "creditLimit": 0.00,
      "registeredAtUtc": "2026-06-01T08:00:00Z"
    }
  ],
  "totalCount": 42,
  "page": 1,
  "pageSize": 20
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |

---

### GET /api/admin/dealers/{id}

**Opis:** Szczegółowe dane dealera — zawiera pełne dane adresowe, handlowe i historię.

**Rola:** `[Authorize(Roles="Admin")]`

**Przykład odpowiedzi (200):**
```json
{
  "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "fullName": "Jan Kowalski",
  "email": "dealer@example.com",
  "phoneNumber": "+48501234567",
  "status": "Pending",
  "creditLimit": 0.00,
  "rejectionReason": null,
  "businessName": "Kowalski Sp. z o.o.",
  "gstNumber": "GST123456789",
  "tradeLicenseNo": "TL-2024-001",
  "address": "ul. Handlowa 12",
  "city": "Warszawa",
  "state": "Mazowieckie",
  "pinCode": "00-001",
  "isInterstate": false,
  "registeredAtUtc": "2026-06-01T08:00:00Z"
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |
| `404` | Dealer nie istnieje |

---

### PUT /api/admin/dealers/{id}/approve

**Opis:** Zatwierdza rejestrację dealera. Status zmienia się z `Pending` na `Approved`.

**Rola:** `[Authorize(Roles="Admin")]`

**Żądanie:** brak body

**Przykład odpowiedzi (200):**
```json
{
  "message": "Dealer approved."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |
| `404` | Dealer nie istnieje |

---

### PUT /api/admin/dealers/{id}/reject

**Opis:** Odrzuca rejestrację dealera z podaniem powodu. Status zmienia się na `Rejected`.

**Rola:** `[Authorize(Roles="Admin")]`

**Przykład żądania:**
```json
{
  "reason": "Nieprawidłowe dane GST."
}
```

**Przykład odpowiedzi (200):**
```json
{
  "message": "Dealer rejected."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Brak pola `reason` |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |
| `404` | Dealer nie istnieje |

---

### PUT /api/admin/dealers/{id}/credit-limit

**Opis:** Aktualizuje limit kredytowy dealera. Wywołuje synchronizację do serwisu `PaymentInvoice` przez event/kanał wewnętrzny.

**Rola:** `[Authorize(Roles="Admin")]`

**Przykład żądania:**
```json
{
  "creditLimit": 100000.00
}
```

**Przykład odpowiedzi (200):**
```json
{
  "succeeded": true,
  "message": "Credit limit updated."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Nieprawidłowa wartość `creditLimit` (np. ujemna) |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |
| `404` | Dealer nie istnieje |
| `502` | Błąd synchronizacji z PaymentInvoice |

---

## 4. Admin — Agents

### GET /api/admin/users/agents

**Opis:** Stronicowana lista agentów (rola `Logistics`/`Agent`). Dostępna również dla roli `Logistics` do wyboru agenta przy przydzielaniu przesyłki.

**Rola:** `[Authorize(Roles="Admin,Logistics")]`

**Parametry query:**
| Parametr | Typ | Domyślnie | Opis |
|---|---|---|---|
| `page` | int | 1 | Numer strony |
| `pageSize` | int | 50 | Rozmiar strony |
| `search` | string? | — | Opcjonalny filtr tekstowy |

**Przykład odpowiedzi (200):**
```json
{
  "items": [
    {
      "userId": "4ab95f64-5717-4562-b3fc-2c963f66afa6",
      "fullName": "Piotr Nowak",
      "email": "agent@supplychain.local",
      "phoneNumber": "+48600111222",
      "status": "Active",
      "createdAtUtc": "2026-01-15T09:00:00Z"
    }
  ],
  "totalCount": 5,
  "page": 1,
  "pageSize": 50
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin lub Logistics |

---

### POST /api/admin/users/agents

**Opis:** Tworzy konto agenta z tymczasowym hasłem. Agent musi zmienić hasło przy pierwszym logowaniu (`mustChangePassword: true`).

**Rola:** `[Authorize(Roles="Admin")]`

**Przykład żądania:**
```json
{
  "email": "newagent@supplychain.local",
  "temporaryPassword": "Temp@1234!",
  "fullName": "Marek Wiśniewski",
  "phoneNumber": "+48700333444"
}
```

**Przykład odpowiedzi (201):**
```json
{
  "userId": "5bc06a75-6828-5673-c4gd-3d074g77bgb7",
  "email": "newagent@supplychain.local",
  "fullName": "Marek Wiśniewski",
  "status": "Active",
  "message": "Agent account created successfully."
}
```

**Błędy:**
| Kod | Opis |
|---|---|
| `400` | Walidacja — brak wymaganych pól, słabe hasło |
| `401` | Brak tokenu |
| `403` | Rola inna niż Admin |
| `409` | Email już istnieje |

---

## Kontrakty Danych

| DTO | Pola | Opis |
|---|---|---|
| `RegisterDealerRequest` | `Email`, `Password`, `FullName`, `PhoneNumber`, `BusinessName`, `GstNumber`, `TradeLicenseNo`, `Address`, `City`, `State`, `PinCode`, `IsInterstate` | Dane rejestracji dealera |
| `RegisterDealerResponse` | `UserId`, `Status`, `Message` | Potwierdzenie rejestracji |
| `LoginRequest` | `Email`, `Password` | Dane logowania |
| `AuthResponse` | `UserId`, `Email`, `Role`, `AccessToken`, `AccessTokenExpiresAtUtc`, `RefreshToken` (pusty w body), `RefreshTokenExpiresAtUtc`, `MustChangePassword` | Odpowiedź autoryzacyjna |
| `ForgotPasswordRequest` | `Email` | Inicjacja resetu hasła |
| `ResetPasswordRequest` | `Email`, `OtpCode`, `NewPassword` | Reset hasła z OTP |
| `ChangePasswordRequest` | `CurrentPassword`, `NewPassword` | Zmiana hasła przez zalogowanego |
| `LogoutRequest` | `RefreshToken?` | Opcjonalny explicite token do unieważnienia |
| `UserProfileDto` | `UserId`, `FullName`, `Email`, `Role`, `Status`, `CreditLimit`, `DealerBusinessName?`, `DealerGstNumber?`, `IsInterstate?` | Profil użytkownika |
| `DealerSummaryDto` | `UserId`, `FullName`, `Email`, `BusinessName`, `GstNumber`, `Status`, `CreditLimit`, `RegisteredAtUtc` | Skrócone dane dealera (lista) |
| `DealerDetailDto` | `UserId`, `FullName`, `Email`, `PhoneNumber`, `Status`, `CreditLimit`, `RejectionReason?`, `BusinessName`, `GstNumber`, `TradeLicenseNo`, `Address`, `City`, `State`, `PinCode`, `IsInterstate`, `RegisteredAtUtc` | Pełne dane dealera |
| `RejectDealerRequest` | `Reason` | Powód odrzucenia dealera |
| `UpdateCreditLimitRequest` | `CreditLimit` | Nowy limit kredytowy |
| `CreditLimitUpdateResult` | `Succeeded`, `Message` | Wynik aktualizacji limitu |
| `AgentSummaryDto` | `UserId`, `FullName`, `Email`, `PhoneNumber`, `Status`, `CreatedAtUtc` | Dane agenta (lista) |
| `CreateAgentRequest` | `Email`, `TemporaryPassword`, `FullName`, `PhoneNumber` | Tworzenie konta agenta |
| `CreateAgentResponse` | `UserId`, `Email`, `FullName`, `Status`, `Message` | Potwierdzenie utworzenia agenta |
| `PagedResult<T>` | `Items`, `TotalCount`, `Page`, `PageSize` | Wrapper stronicowania |

## Uwagi Autoryzacyjne

- Refresh token jest przechowywany wyłącznie w `HttpOnly` cookie `refreshToken` — nie pojawia się w body JSON.
- Wylogowanie blacklistuje JTI tokenu dostępu do chwili jego wygaśnięcia.
- Dealer z nowym statusem `Pending` lub `Rejected` nie może się zalogować.
- Credit limit w IdentityAuth i PaymentInvoice jest synchronizowany — zmiana przez `PUT /admin/dealers/{id}/credit-limit` propaguje do `PaymentController`.
- `AdminUsersController` jest ozdobiony `[Authorize]` na poziomie klasy, poszczególne metody mają nadrzędne `[Authorize(Roles=...)]`.
