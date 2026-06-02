# P-023-0002 newCreditLimit

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-023-0002` |
| Ekran | [E-023](../E-023__README.md) |
| Nazwa wykryta | `newCreditLimit` |
| Typ detekcji | `[(ngModel)]` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Nowy limit kredytowy dealera. Pole edytowalne w dialogu "Update Credit Limit". Inicjalizowane wartością `dealer().creditLimit` przy załadowaniu strony. Wysyłane do API jako `{creditLimit: newCreditLimit}`.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — przy zapisaniu w dialogu | `wniosek z analizy` |
| Typ UI | `input[type=number]` z `[(ngModel)]="newCreditLimit"` w dialogu | `wniosek z analizy` |
| Reguły walidacji (backend) | `CreditLimit >= 0` — `UpdateCreditLimitRequestValidator` w `AuthValidators.cs` | `potwierdzone` |
| Komunikaty błędów | [ERR-023](../ERR-023_BLEDY/ERR-023__INDEX.md) | błąd z API przy wartości ujemnej |

## Walidator Backend

Plik: `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs`
```csharp
RuleFor(x => x.CreditLimit).GreaterThanOrEqualTo(0m);
```

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `DealerDetailComponent.newCreditLimit: number` | `wniosek z analizy` |
| Serwis API | `AdminApiService.updateCreditLimit(id, {creditLimit: newCreditLimit})` | `wniosek z analizy` |
| Endpoint | `PUT /identity/api/admin/dealers/{id}/credit-limit` | `wniosek z analizy` |
| DTO/kontrakt | `UpdateCreditLimitRequest` w `supply-chain-frontend/src/app/core/models/auth.models.ts` | `wniosek z analizy` |
| Encja/model | `DealerCreditAccount.CreditLimit` lub `DealerProfile.CreditLimit` (szacowane) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `DealerCreditAccounts` lub `DealerProfiles` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `CreditLimit` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | odczyt (init) / zapis (PUT) | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-023_DANE_TESTOWE/TD-023-0002__newcreditlimit.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-023__INDEX.md)
- [Akcje ekranu](../A-023_AKCJE/A-023__INDEX.md)
- [Ślad ekranu](../E-023__LINKI.md)
