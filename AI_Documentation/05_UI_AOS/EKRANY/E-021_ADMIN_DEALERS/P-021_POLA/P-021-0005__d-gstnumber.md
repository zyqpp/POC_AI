# P-021-0005 d.gstNumber

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-021-0005` |
| Ekran | [E-021](../E-021__README.md) |
| Nazwa wykryta | `d.gstNumber` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Numer identyfikacji podatkowej GST dealera (indyjski GSTIN). Format: `[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]` (15 znaków). Wyświetlany w tabeli listy dealerów. Używany przez admina do weryfikacji tożsamości firmy przed zatwierdzeniem.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — rejestracja: `NotEmpty()` + regex GST | `potwierdzone` |
| Typ UI | tekst tylko do odczytu (interpolacja w td) | `wniosek z analizy` |
| Reguły walidacji (backend) | `NotEmpty().Matches("^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$")` — `RegisterDealerRequestValidator` | `potwierdzone` |
| Komunikaty błędów | [ERR-021](../ERR-021_BLEDY/ERR-021__INDEX.md) | rejestracja: "GST number format is invalid." |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `DealerSummaryDto.gstNumber: string` | `wniosek z analizy` |
| Serwis API | `AdminApiService.getDealers()` | `wniosek z analizy` |
| Endpoint | `GET /identity/api/admin/dealers` | `wniosek z analizy` |
| DTO/kontrakt | `DealerSummaryDto` w `supply-chain-frontend/src/app/core/models/auth.models.ts` | `wniosek z analizy` |
| Encja/model | `DealerProfile.GstNumber` (szacowane) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `DealerProfiles` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `GstNumber` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-021_DANE_TESTOWE/TD-021-0005__d-gstnumber.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-021__INDEX.md)
- [Akcje ekranu](../A-021_AKCJE/A-021__INDEX.md)
- [Ślad ekranu](../E-021__LINKI.md)
