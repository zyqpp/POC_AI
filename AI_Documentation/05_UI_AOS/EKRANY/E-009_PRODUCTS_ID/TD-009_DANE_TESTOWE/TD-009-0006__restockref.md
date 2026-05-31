# TD-009-0006 Restock Reference ID

Status: `potwierdzone`.

| Typ | Dane | Oczekiwany rezultat |
|---|---|---|
| poprawne | `PO-12345` | zapis `StockTransactions.ReferenceId=PO-12345` |
| graniczne | 120 znaków | backend akceptuje |
| puste | pusty string | UI disabled i backend odrzuca |
| za długie | 121 znaków | backend odrzuca |
