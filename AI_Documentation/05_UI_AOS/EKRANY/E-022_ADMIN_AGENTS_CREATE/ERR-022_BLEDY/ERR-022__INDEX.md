# ERR-022 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-022-0001` | createError( | angular-if-error-view | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.html` | [ERR-022-0001__createerror.md](ERR-022-0001__createerror.md) |
| `ERR-022-0002` | createError() | error-css-class | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.html` | [ERR-022-0002__createerror.md](ERR-022-0002__createerror.md) |
| `ERR-022-0003` | err, 'Failed to create agent. | ErrorMessage | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.ts` | [ERR-022-0003__err-failed-to-create-agent.md](ERR-022-0003__err-failed-to-create-agent.md) |
| `ERR-022-0004` | error: any, fallback: string | ErrorMessage | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.ts` | [ERR-022-0004__error-any-fallback-string.md](ERR-022-0004__error-any-fallback-string.md) |
| `ERR-022-0005` | == 'string' && e.errorMessage.length > 0 | errorMessage | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.ts` | [ERR-022-0005__string-e-errormessage-length-0.md](ERR-022-0005__string-e-errormessage-length-0.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
