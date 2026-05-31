# TD-009-0012 Role I Review ID

Status: `potwierdzone`.

| Typ | Dane | Oczekiwany rezultat |
|---|---|---|
| Dealer | token z rolą `Dealer` | widzi add to cart i formularz review; nie widzi edit/deactivate/restock/moderacji |
| Admin | token z rolą `Admin` | widzi edit/deactivate i moderację; `includePending=true` przy pobieraniu reviews |
| Warehouse | token z rolą `Warehouse` | widzi restock; nie widzi moderacji ani add to cart |
| review pending | `ReviewId=22222222-2222-4222-8222-222222222222`, pending | Admin może approve/reject |
| review missing | nieistniejący `ReviewId` | backend zwraca `404` dla approve/reject |
