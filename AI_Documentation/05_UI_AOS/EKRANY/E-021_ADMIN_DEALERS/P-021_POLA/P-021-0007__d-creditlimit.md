# P-021-0007 d.creditLimit

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-021-0007` |
| Ekran | [E-021](../E-021__README.md) |
| Nazwa wykryta | `d.creditLimit` |
| Typ detekcji | `interpolation` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Limit kredytowy dealera w INR. Wyświetlany w tabeli listy dealerów jako wartość numeryczna. Na ekranie szczegółu [E-023](../../E-023_ADMIN_DEALERS_ID/E-023__README.md) jest polem edytowalnym w dialogu "Update Credit Limit".

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — przy aktualizacji (PUT) | `wniosek z analizy` |
| Typ UI | tekst tylko do odczytu w liście; `input[type=number]` w dialogu edycji (E-023) | `wniosek z analizy` |
| Reguły walidacji (backend) | `CreditLimit >= 0` — `UpdateCreditLimitRequestValidator` w `AuthValidators.cs` (IdentityAuth) i `PaymentValidators.cs` (PaymentInvoice) | `potwierdzone` |
| Komunikaty błędów | [ERR-021](../ERR-021_BLEDY/ERR-021__INDEX.md) | `do uzupełnienia` |

## Walidator Backend (UpdateCreditLimitRequestValidator)

Plik: `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs`
```csharp
RuleFor(x => x.CreditLimit).GreaterThanOrEqualTo(0m);
```
Identyczna reguła w: `services/PaymentInvoice/PaymentInvoice.Application/Validation/PaymentValidators.cs`

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `DealerSummaryDto.creditLimit: number` | `wniosek z analizy` |
| Serwis API | `AdminApiService.getDealers()` (odczyt), `AdminApiService.updateCreditLimit(id, {creditLimit})` (zapis) | `wniosek z analizy` |
| Endpoint | `GET /identity/api/admin/dealers` (odczyt), `PUT /identity/api/admin/dealers/{id}/credit-limit` (zapis) | `wniosek z analizy` |
| DTO/kontrakt | `DealerSummaryDto` / `UpdateCreditLimitRequest` w `supply-chain-frontend/src/app/core/models/auth.models.ts` | `wniosek z analizy` |
| Encja/model | `DealerProfile.CreditLimit` (szacowane) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `DealerProfiles` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `CreditLimit` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt (lista) / zapis (update) | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-021_DANE_TESTOWE/TD-021-0007__d-creditlimit.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-021__INDEX.md)
- [Akcje ekranu](../A-021_AKCJE/A-021__INDEX.md)
- [Ślad ekranu](../E-021__LINKI.md)
