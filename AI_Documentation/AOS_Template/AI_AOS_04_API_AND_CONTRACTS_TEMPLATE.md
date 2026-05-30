# AOS API And Contracts Template

## Cel Pliku

Ten plik opisuje kontrakty API używane przez ekran/funkcje. Ma być źródłem dla testerów API, automatyzacji, analityka kontrolującego dane oraz developera zmieniającego kontrakt.

## Lista Endpointów

| ID API | Cel | Front URL | Gateway route | Downstream endpoint | Metoda | Auth/role | Request DTO | Response DTO |
|---|---|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-API-001` | `<cel>` | `<np. /orders/api/orders>` | `<ocelot route>` | `<api/orders>` | `<GET/POST>` | `<role>` | `<DTO>` | `<DTO>` |

## Szczegóły Endpointu

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

| Element | Typ | Wymagane | Źródło | Walidacja |
|---|---|---|---|---|
| Path param | `<name:type>` | `<tak/nie>` | `<route>` | `<reguła>` |
| Query param | `<name:type>` | `<tak/nie>` | `<controller>` | `<reguła>` |
| Header | `<name>` | `<tak/nie>` | `<gateway/controller>` | `<reguła>` |
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
| 400 | `<walidacja>` | `{ code, messąge, details }` | `false` | `<uwagi>` |
| 401 | `<brak/niepoprawny token>` | `{ messąge/code }` | `false` | `<uwagi>` |
| 403 | `<brak roli>` | `<body>` | `false` | `<uwagi>` |
| 404 | `<brak rekordu>` | `<body>` | `false` | `<uwagi>` |
| 409 | `<konflikt biznesowy>` | `{ code, messąge }` | `false` | `<uwagi>` |
| 503/504 | `<zależność niedostępna>` | `{ code, retryable }` | `true` | `<uwagi>` |

#### Response Body Shape

```json
{
  "field": "value"
}
```

## Mapowanie DTO Frontend-Backend

| Pole biznesowe | Model TS | DTO backend | Typ TS | Typ C# | Uwagi zgodnośći |
|---|---|---|---|---|---|
| `<pole>` | `<model.field>` | `<Dto.Field>` | `<typ>` | `<typ>` | `<OK/różnica>` |

## Kontrakty Bledow

| Kod błędu | HTTP | Kiedy wystepuje | Źródło | Komunikat UI |
|---|---|---|---|---|
| `<code>` | `<status>` | `<warunek>` | `<middleware/controller>` | `<tekst>` |

## Kompatybilnosc

- Czy zmiana endpointu jest breaking change: `<tak/nie>`.
- Wpływ na frontend: `<opis>`.
- Wpływ na testy automatyczne: `<opis>`.
- Wpływ na integracje wewnętrzne: `<opis>`.
