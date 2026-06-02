# A-023-0008 updateCreditLimit

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-023-0008` |
| Ekran | [E-023](../E-023__README.md) |
| Nazwa wykryta | `updateCreditLimit` |
| Typ detekcji | `click` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-detail/dealer-detail.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Zmiana limitu kredytowego dealera. Wywoływana z dialogu "Update Credit Limit". Po sukcesie przeładowuje konto kredytowe i faktury dealera. Backend waliduje: `CreditLimit >= 0`.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | Przycisk "Update" w dialogu Credit Limit (trigger: A-023-0003 `showCreditDialog.set(true)`) | `wniosek z analizy` |
| Metoda komponentu | `DealerDetailComponent.updateCreditLimit()` | `wniosek z analizy` |
| Serwis frontend | `AdminApiService.updateCreditLimit(dealerId, {creditLimit: newCreditLimit})` | `wniosek z analizy` |
| Endpoint API | `PUT /identity/api/admin/dealers/{id}/credit-limit` z body `{creditLimit}` | `wniosek z analizy` |
| Komenda/zapytanie | `UpdateCreditLimitCommand` → `UpdateCreditLimitCommandHandler` | `wniosek z analizy` |
| Walidacje | `UpdateCreditLimitRequestValidator`: `CreditLimit >= 0` (IdentityAuth + PaymentInvoice) | `potwierdzone` |
| Skutek w bazie | Aktualizacja `DealerCreditAccounts.CreditLimit` lub `DealerProfiles.CreditLimit` (szacowane) | `wniosek z analizy` |

## Przykład HTTP

```http
PUT /identity/api/admin/dealers/{id}/credit-limit
Content-Type: application/json
Authorization: Bearer {token}

{
  "creditLimit": 150000.00
}

Response: 200 OK
{
  "dealerId": "...",
  "creditLimit": 150000.00,
  ...
}
```

## Testy

- [Macierz testów ekranu](../TC-023_TESTY/TC-023__INDEX.md)
- Dane wejściowe: `newCreditLimit` (decimal >= 0).
- Oczekiwany rezultat: dialog zamknięty; konto kredytowe odświeżone; toast "Credit limit updated".
- Oczekiwany rezultat (błąd < 0): błąd walidacji z backend "GreaterThanOrEqualTo 0".

## Linki

- [Indeks akcji](A-023__INDEX.md)
- [Pola ekranu](../P-023_POLA/P-023__INDEX.md)
- [Ślad ekranu](../E-023__LINKI.md)
