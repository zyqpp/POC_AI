# P-021-0004 d.businessName

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-021-0004` |
| Ekran | [E-021](../E-021__README.md) |
| Nazwa wykryta | `d.businessName` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Oficjalna nazwa firmy dealera. Wyświetlana w tabeli listy dealerów. Pobrana z profilu firmy zarejestrowanego przy rejestracji dealera. Backend waliduje przy rejestracji: `NotEmpty().MaximumLength(180)`.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — rejestracja: `NotEmpty().MaximumLength(180)` — `RegisterDealerRequestValidator` | `potwierdzone` |
| Typ UI | tekst tylko do odczytu (interpolacja w td) | `wniosek z analizy` |
| Reguły walidacji | brak walidacji UI przy odczycie | `wniosek z analizy` |
| Komunikaty błędów | [ERR-021](../ERR-021_BLEDY/ERR-021__INDEX.md) | nie dotyczy |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `DealerSummaryDto.businessName: string` | `wniosek z analizy` |
| Serwis API | `AdminApiService.getDealers()` | `wniosek z analizy` |
| Endpoint | `GET /identity/api/admin/dealers` | `wniosek z analizy` |
| DTO/kontrakt | `DealerSummaryDto` w `supply-chain-frontend/src/app/core/models/auth.models.ts` | `wniosek z analizy` |
| Encja/model | `DealerProfile.BusinessName` (szacowane) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `DealerProfiles` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `BusinessName` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-021_DANE_TESTOWE/TD-021-0004__d-businessname.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-021__INDEX.md)
- [Akcje ekranu](../A-021_AKCJE/A-021__INDEX.md)
- [Ślad ekranu](../E-021__LINKI.md)
