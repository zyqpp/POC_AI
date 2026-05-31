# PROC-007 Lista Produktów

Status: `potwierdzone`.

## Przepływy

| ID | Przepływ | Ślad |
|---|---|---|
| `PROC-007-0001` | Ładowanie listy | `/products` -> `ngOnInit()` -> `getCategories()` + `loadPage(1)` -> Catalog API -> `Products`, `Categories` |
| `PROC-007-0002` | Search | `searchQuery` -> `search$` -> debounce 300 ms -> `searchProducts(q)` -> `ProductsController.Search` |
| `PROC-007-0003` | Filtry lokalne | selecty kategorii/stock/sort -> `applyView()` -> widok bez dodatkowego zapisu DB |
| `PROC-007-0004` | Quick add | `+ Add to Cart` -> `getProductById()` -> `CartStore.addItem()` -> brak zapisu DB |

## Granice Procesu

`E-007` nie tworzy zamówienia. Koszyk jest stanem frontendowym; zapis biznesowy zaczyna się dopiero w procesie checkout.
