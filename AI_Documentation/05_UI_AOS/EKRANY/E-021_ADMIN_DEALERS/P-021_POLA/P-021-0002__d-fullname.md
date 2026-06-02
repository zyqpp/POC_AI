# P-021-0002 d.fullName

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-021-0002` |
| Ekran | [E-021](../E-021__README.md) |
| Nazwa wykryta | `d.fullName` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Imię i nazwisko dealera (właściciela konta). Wyświetlane w kolumnie tabeli listy dealerów jako identyfikator osoby. Pochodzi z profilu użytkownika zarejestrowanego jako dealer.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — rejestracja: `NotEmpty().MaximumLength(120)` | `potwierdzone` |
| Typ UI | tekst tylko do odczytu (interpolacja w td) | `wniosek z analizy` |
| Reguły walidacji | brak walidacji UI przy odczycie | `wniosek z analizy` |
| Komunikaty błędów | [ERR-021](../ERR-021_BLEDY/ERR-021__INDEX.md) | nie dotyczy |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `DealerSummaryDto.fullName: string` | `wniosek z analizy` |
| Serwis API | `AdminApiService.getDealers()` | `wniosek z analizy` |
| Endpoint | `GET /identity/api/admin/dealers` | `wniosek z analizy` |
| DTO/kontrakt | `DealerSummaryDto` w `supply-chain-frontend/src/app/core/models/auth.models.ts` | `wniosek z analizy` |
| Encja/model | `User.FullName` (szacowane) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `Users` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `FullName` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-021_DANE_TESTOWE/TD-021-0002__d-fullname.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-021__INDEX.md)
- [Akcje ekranu](../A-021_AKCJE/A-021__INDEX.md)
- [Ślad ekranu](../E-021__LINKI.md)
