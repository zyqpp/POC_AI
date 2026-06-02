# P-021-0008 d.registeredAtUtc

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-021-0008` |
| Ekran | [E-021](../E-021__README.md) |
| Nazwa wykryta | `d.registeredAtUtc` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Data rejestracji dealera w systemie (UTC ISO). Wyświetlana w tabeli listy dealerów jako data rejestracji. Odpowiada `createdAt` z procesu rejestracji ([PROC-001_AUTH](../../../../06_PROCESY/PROC-001_AUTH.md)).

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — pole odczytu z API | `wniosek z analizy` |
| Typ UI | tekst tylko do odczytu (interpolacja), formatowany datą | `wniosek z analizy` |
| Reguły walidacji | brak walidacji UI | `wniosek z analizy` |
| Komunikaty błędów | [ERR-021](../ERR-021_BLEDY/ERR-021__INDEX.md) | nie dotyczy |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `DealerSummaryDto.registeredAtUtc: string` (ISO 8601) | `wniosek z analizy` |
| Serwis API | `AdminApiService.getDealers()` | `wniosek z analizy` |
| Endpoint | `GET /identity/api/admin/dealers` | `wniosek z analizy` |
| DTO/kontrakt | `DealerSummaryDto` w `supply-chain-frontend/src/app/core/models/auth.models.ts` | `wniosek z analizy` |
| Encja/model | `User.CreatedAt` lub `DealerProfile.RegisteredAtUtc` (szacowane) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `Users` lub `DealerProfiles` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `RegisteredAtUtc` lub `CreatedAt` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-021_DANE_TESTOWE/TD-021-0008__d-registeredatutc.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-021__INDEX.md)
- [Akcje ekranu](../A-021_AKCJE/A-021__INDEX.md)
- [Ślad ekranu](../E-021__LINKI.md)
