# TD-009-0010 Moderation Note

Status: `potwierdzone`.

| Typ | Dane | Oczekiwany rezultat |
|---|---|---|
| brak | `null` | sekcja noty niewidoczna |
| poprawne | `Verified purchase.` | nota widoczna, jeśli backend ją zwróci |
| graniczne | 500 znaków | backend akceptuje |
| za długie | 501 znaków | backend odrzuca |

Luka: ekran E-009 nie ma pola do wpisania noty; `Approve` i `Reject` wysyłają pusty obiekt.
