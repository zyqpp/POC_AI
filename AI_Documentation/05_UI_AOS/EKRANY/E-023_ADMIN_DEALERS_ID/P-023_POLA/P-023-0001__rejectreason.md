# P-023-0001 rejectReason

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-023-0001` |
| Ekran | [E-023](../E-023__README.md) |
| Nazwa wykryta | `rejectReason` |
| Typ detekcji | `[(ngModel)]` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Powód odrzucenia rejestracji dealera. Pole tekstowe w dialogu "Reject Dealer". Wymagane przed wysłaniem akcji `reject`. Backend waliduje: `NotEmpty().MaximumLength(400)`.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — backend: `NotEmpty()` | `potwierdzone` |
| Typ UI | `textarea` lub `input[type=text]` z `[(ngModel)]="rejectReason"` w dialogu | `wniosek z analizy` |
| Reguły walidacji (backend) | `NotEmpty().MaximumLength(400)` — `RejectDealerRequestValidator` w `AuthValidators.cs` | `potwierdzone` |
| Komunikaty błędów | [ERR-023](../ERR-023_BLEDY/ERR-023__INDEX.md) | błąd z API przy pustym powodzie |

## Walidator Backend

Plik: `services/IdentityAuth/IdentityAuth.Application/Validation/AuthValidators.cs`
```csharp
RuleFor(x => x.Reason).NotEmpty().MaximumLength(400);
```

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `DealerDetailComponent.rejectReason: string` | `wniosek z analizy` |
| Serwis API | `AdminApiService.rejectDealer(id, {reason: rejectReason})` | `wniosek z analizy` |
| Endpoint | `PUT /identity/api/admin/dealers/{id}/reject` | `wniosek z analizy` |
| DTO/kontrakt | `RejectDealerRequest` w `supply-chain-frontend/src/app/core/models/auth.models.ts` | `wniosek z analizy` |
| Encja/model | `DealerProfile.RejectionReason` lub `User.RejectionReason` (szacowane) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `DealerProfiles` lub `Users` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `RejectionReason` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | zapis (PUT) | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-023_DANE_TESTOWE/TD-023-0001__rejectreason.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-023__INDEX.md)
- [Akcje ekranu](../A-023_AKCJE/A-023__INDEX.md)
- [Ślad ekranu](../E-023__LINKI.md)
