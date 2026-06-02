# P-023-0003 settleAmount

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-023-0003` |
| Ekran | [E-023](../E-023__README.md) |
| Nazwa wykryta | `settleAmount` |
| Typ detekcji | `[(ngModel)]` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Kwota rozliczenia należności dealera. Pole edytowalne w dialogu "Settle Outstanding". Wysyłana do `POST /payments/api/payment/dealers/{id}/settlements` jako `{amount, referenceNo}`. Backend waliduje: `Amount > 0`.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak | `wniosek z analizy` |
| Typ UI | `input[type=number]` z `[(ngModel)]="settleAmount"` | `wniosek z analizy` |
| Reguły walidacji (backend) | `Amount.GreaterThan(0m)` — `SettleOutstandingRequestValidator` w `PaymentValidators.cs` | `potwierdzone` |
| Komunikaty błędów | [ERR-023](../ERR-023_BLEDY/ERR-023__INDEX.md) | błąd z API przy kwocie <= 0 |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `DealerDetailComponent.settleAmount: number` | `wniosek z analizy` |
| Serwis API | `PaymentApiService.settleOutstanding(dealerId, {amount: settleAmount, referenceNo: settleRef})` | `wniosek z analizy` |
| Endpoint | `POST /payments/api/payment/dealers/{id}/settlements` | `wniosek z analizy` |
| DTO/kontrakt | `SettleOutstandingRequest` | `wniosek z analizy` |
| Encja/model | `DealerCreditAccount.CurrentOutstanding` (zmniejszane o kwotę) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `DealerCreditAccounts` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `CurrentOutstanding` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | zapis (POST) | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-023_DANE_TESTOWE/TD-023-0003__settleamount.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-023__INDEX.md)
- [Akcje ekranu](../A-023_AKCJE/A-023__INDEX.md)
- [Ślad ekranu](../E-023__LINKI.md)
