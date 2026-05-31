# P-009-0006 Restock Reference ID

Status: `potwierdzone`.

| Obszar | Opis |
|---|---|
| Typ UI | input text `[(ngModel)]="restockRef"`, placeholder `PO-12345` |
| Wymagalność | wymagane; przycisk restock disabled, gdy `!restockRef` |
| Walidacje | backend `ReferenceId` required i max 120 |
| API/DTO | `RestockProductRequest.ReferenceId` |
| Tabela SQL | `StockTransactions` |
| Kolumna SQL | `StockTransactions.ReferenceId` W, max 120, `NOT NULL` |
| Dane Do Test | `TD-009-0006`: `PO-12345`, pusty, 120 znaków, 121 znaków |
| Testy | `TC-009-0005`, `TC-009-0006` |
