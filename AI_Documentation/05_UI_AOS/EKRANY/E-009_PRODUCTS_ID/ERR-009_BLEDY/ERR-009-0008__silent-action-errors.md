# ERR-009-0008 Silent Action Errors

Status: `brak w kodzie` jako jawna luka UX.

| Obszar | Opis |
|---|---|
| Warunek | błąd `deactivateProduct` albo `restockProduct` |
| Komunikat UI | brak toastu błędu w `error: () => {}` |
| Backend | może zwrócić `404` lub błąd walidacji/autoryzacji |
| DB | brak zapisu przy błędzie |
| Dane testowe | `TD-009-0005`, `TD-009-0006`, `TD-009-0011` |
| Test | `TC-009-0006` |
