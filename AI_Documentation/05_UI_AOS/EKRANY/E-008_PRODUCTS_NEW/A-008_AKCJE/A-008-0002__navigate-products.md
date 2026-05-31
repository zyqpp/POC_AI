# A-008-0002 Anuluj I Wróć Do Listy Produktów

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-008-0002` |
| Ekran | [E-008](../E-008__README.md) |
| Trigger UI | link `Cancel` w nagłówku i stopce formularza |
| Route docelowy | `/products` |
| Źródło | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` |

## Opis Akcji

Akcja opuszcza formularz tworzenia produktu i przechodzi do listy produktów. Nie wywołuje API i nie zapisuje częściowo wprowadzonych danych.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | dwa linki `routerLink="/products"` | `potwierdzone` |
| Metoda komponentu | brak metody TS | `potwierdzone` |
| Serwis frontend | brak | `potwierdzone` |
| Endpoint API | brak | `potwierdzone` |
| Walidacje | brak, bo akcja nie submituje formularza | `potwierdzone` |
| Skutek w bazie | brak zapisu do `Products`, `OutboxMessages`, `StockTransactions` | `potwierdzone` |

## Testy

| Test | Dane | Oczekiwany rezultat |
|---|---|---|
| `TC-008-0006` | rozpoczęty formularz z danymi lokalnymi | przejście do `/products`, brak requestu `POST /catalog/api/products` |

`TC-008-0006` jest wymaganiem testowym dodanym w indeksie [TC-008](../TC-008_TESTY/TC-008__INDEX.md); test automatyczny ma status `brak w kodzie`.

## Linki

- [Indeks akcji](A-008__INDEX.md)
- [Pola ekranu](../P-008_POLA/P-008__INDEX.md)
- [Ślad ekranu](../E-008__LINKI.md)
