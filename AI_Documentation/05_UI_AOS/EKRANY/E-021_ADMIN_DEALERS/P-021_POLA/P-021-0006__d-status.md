# P-021-0006 d.status

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-021-0006` |
| Ekran | [E-021](../E-021__README.md) |
| Nazwa wykryta | `d.status` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Status konta dealera. Wyświetlany jako kolorowy badge w tabeli: `Active` (zielony `badge-success`), `Pending` (żółty `badge-warning`), `Rejected` (czerwony `badge-error`). Logika badge zdefiniowana w `statusBadge(s: string)` komponentu.

## Wartości Możliwe

| Wartość | Opis | Badge CSS |
|---|---|---|
| `Pending` | Dealer zarejestrowany, czeka na zatwierdzenie admina | `badge badge-warning` |
| `Active` | Dealer zatwierdzony, może składać zamówienia | `badge badge-success` |
| `Rejected` | Rejestracja odrzucona przez admina | `badge badge-error` |

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — pole odczytu z API | `wniosek z analizy` |
| Typ UI | badge tekstowy tylko do odczytu | `wniosek z analizy` |
| Reguły walidacji | brak walidacji UI | `wniosek z analizy` |
| Komunikaty błędów | [ERR-021](../ERR-021_BLEDY/ERR-021__INDEX.md) | nie dotyczy |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `DealerSummaryDto.status: string` | `wniosek z analizy` |
| Serwis API | `AdminApiService.getDealers()` | `wniosek z analizy` |
| Endpoint | `GET /identity/api/admin/dealers` | `wniosek z analizy` |
| DTO/kontrakt | `DealerSummaryDto` w `supply-chain-frontend/src/app/core/models/auth.models.ts` | `wniosek z analizy` |
| Encja/model | `User.Status` lub `DealerProfile.Status` (szacowane) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `Users` lub `DealerProfiles` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `Status` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt; zapis przez approve/reject/approve-credit | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-021_DANE_TESTOWE/TD-021-0006__d-status.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-021__INDEX.md)
- [Akcje ekranu](../A-021_AKCJE/A-021__INDEX.md)
- [Ślad ekranu](../E-021__LINKI.md)
