# A-010-0002 Cancel To Products

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-010-0002` |
| Ekran | [E-010](../E-010__README.md) |
| Element UI | link/button `Cancel` w headerze i stopce formularza |
| Handler | `routerLink="/products"` |
| Źródło | `product-form.component.html:5`, `product-form.component.html:79` |

## Opis Akcji

Akcja opuszcza formularz i wraca na listę produktów. Nie zapisuje danych, nie wywołuje API i nie ostrzega o utracie niezapisanych zmian.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | dwa linki `Cancel` | `potwierdzone` |
| Routing | `/products` | `potwierdzone` |
| API | brak | `potwierdzone` |
| DB | brak odczytu/zapisu w tej akcji | `potwierdzone` |
| Test | [TC-010-0008](../TC-010_TESTY/TC-010__INDEX.md) | `brak w kodzie` |

## Ryzyko

| ID | Problem | Status |
|---|---|---|
| `GAP-E-010-CANCEL-001` | Brak guardu lub dialogu dla niezapisanych zmian. | `brak w kodzie` |
