# A-009-0010 Close Restock Modal / Stop Propagation

Status: `potwierdzone`.

| Warstwa | Fakt |
|---|---|
| UI | kliknięcie tła ustawia `showRestockDialog=false`; kliknięcie modala zatrzymuje propagację |
| Frontend | `showRestockDialog.set(false)` i `$event.stopPropagation()` |
| API | brak |
| DB | brak zapisu |
| Testy | `TC-009-0005` |
