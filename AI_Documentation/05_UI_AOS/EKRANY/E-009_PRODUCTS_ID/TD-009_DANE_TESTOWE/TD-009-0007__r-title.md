# TD-009-0007 Review Title Display

Status: `potwierdzone`.

| Typ | Dane | Oczekiwany rezultat |
|---|---|---|
| approved | `Reliable pump`, `isApproved=true` | widoczny tytuł i badge `Approved` |
| pending | `Needs review`, `isApproved=false`, `isRejected=false` | Admin widzi pending; Dealer bez pending po reload |
| rejected | `Bad batch`, `isRejected=true` | widoczny badge `Rejected` dla Admina, jeśli pobiera pending/rejected |
