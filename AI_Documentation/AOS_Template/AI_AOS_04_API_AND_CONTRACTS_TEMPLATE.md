# AOS API And Contracts Template

## Cel Pliku

Ten plik opisuje kontrakty API uzywane przez ekran/funkcje. Ma byc zrodlem dla testerow API, automatyzacji, analityka kontrolujacego dane oraz developera zmieniajacego kontrakt.

## Lista Endpointow

| ID API | Cel | Front URL | Gateway route | Downstream endpoint | Metoda | Auth/role | Request DTO | Response DTO |
|---|---|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-API-001` | `<cel>` | `<np. /orders/api/orders>` | `<ocelot route>` | `<api/orders>` | `<GET/POST>` | `<role>` | `<DTO>` | `<DTO>` |

## Szczegoly Endpointu

### `AOS-<MOD>-<SCREEN>-API-001` - `<METHOD path>`

#### Cel

`<Po co endpoint istnieje i jaka operacje wspiera.>`

#### Zrodla W Kodzie

| Warstwa | Plik / symbol |
|---|---|
| Angular API service | `<core/api/...service.ts>` |
| Gateway | `<gateway/OcelotGateway/ocelot.json>` |
| Controller | `<Controller.cs / action>` |
| Command/Query | `<Application/Features/...>` |
| Service | `<Application/Services/...>` |
| DTO backend | `<Application/DTOs/...>` |
| Model frontend | `<core/models/...>` |

#### Request

| Element | Typ | Wymagane | Zrodlo | Walidacja |
|---|---|---|---|---|
| Path param | `<name:type>` | `<tak/nie>` | `<route>` | `<regula>` |
| Query param | `<name:type>` | `<tak/nie>` | `<controller>` | `<regula>` |
| Header | `<name>` | `<tak/nie>` | `<gateway/controller>` | `<regula>` |
| Body | `<DTO>` | `<tak/nie>` | `<DTO file>` | `<validator>` |

#### Request Body Shape

```json
{
  "field": "value"
}
```

#### Response

| Status | Kiedy | Body | Retryable | Uwagi |
|---|---|---|---|---|
| 200 | `<sukces>` | `<DTO>` | `false` | `<uwagi>` |
| 201 | `<utworzono>` | `<DTO>` | `false` | `<uwagi>` |
| 400 | `<walidacja>` | `{ code, message, details }` | `false` | `<uwagi>` |
| 401 | `<brak/niepoprawny token>` | `{ message/code }` | `false` | `<uwagi>` |
| 403 | `<brak roli>` | `<body>` | `false` | `<uwagi>` |
| 404 | `<brak rekordu>` | `<body>` | `false` | `<uwagi>` |
| 409 | `<konflikt biznesowy>` | `{ code, message }` | `false` | `<uwagi>` |
| 503/504 | `<zaleznosc niedostepna>` | `{ code, retryable }` | `true` | `<uwagi>` |

#### Response Body Shape

```json
{
  "field": "value"
}
```

## Mapowanie DTO Frontend-Backend

| Pole biznesowe | Model TS | DTO backend | Typ TS | Typ C# | Uwagi zgodnosci |
|---|---|---|---|---|---|
| `<pole>` | `<model.field>` | `<Dto.Field>` | `<typ>` | `<typ>` | `<OK/roznica>` |

## Kontrakty Bledow

| Kod bledu | HTTP | Kiedy wystepuje | Zrodlo | Komunikat UI |
|---|---|---|---|---|
| `<code>` | `<status>` | `<warunek>` | `<middleware/controller>` | `<tekst>` |

## Kompatybilnosc

- Czy zmiana endpointu jest breaking change: `<tak/nie>`.
- Wplyw na frontend: `<opis>`.
- Wplyw na testy automatyczne: `<opis>`.
- Wplyw na integracje wewnetrzne: `<opis>`.
