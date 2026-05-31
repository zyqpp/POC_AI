# ROLE_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS`, `E-008_PRODUCTS_NEW`, `E-009_PRODUCTS_ID`, `E-010_PRODUCTS_ID_EDIT`.

| Obszar | Mechanizm | Role | Efekt |
|---|---|---|---|
| Route `/products` | `authGuard` na shell route | każdy zalogowany | dostęp do listy |
| Route `/products/new` | `roleGuard Admin` | `Admin` | dostęp do formularza create |
| Route `/products/:id` | `authGuard` na shell route, brak `roleGuard` na samym route | każdy zalogowany | szczegół produktu |
| Route `/products/:id/edit` | `roleGuard Admin` | `Admin` | dostęp do formularza edit |
| `Add Product` | `isAdmin()` w UI | `Admin` | link do create |
| `Edit` i `Deactivate` | `isAdmin()` w UI, backend `Admin` | `Admin` | edycja/dezaktywacja |
| `Update Product` | route `Admin`, backend `Admin` | `Admin` | zapis edycji produktu |
| `Add to Cart` | `isDealer()` w UI | `Dealer` | lokalny koszyk |
| `Restock` | `canRestock()` w UI, backend `Admin,Warehouse` | `Admin`, `Warehouse` | zapis stock |
| Reviews submit | `isDealer()` w UI, backend `Dealer` | `Dealer` | utworzenie review pending |
| Reviews approve/reject | `isAdmin()` w UI, backend `Admin` | `Admin` | moderacja review |
| Include inactive | `Admin`, `Warehouse` po stronie API | `Admin`, `Warehouse` | możliwość pobrania inactive |
| Endpointy read | `[AllowAnonymous]` w backendzie | technicznie publiczne API | ekran nadal chroniony przez frontend/gateway |

## Macierz Ekran / Akcja / Endpoint

| Ekran | Akcja | Frontend | Backend | Role |
|---|---|---|---|---|
| `E-007` | lista produktów | `authGuard` | `[AllowAnonymous]` | zalogowany w UI |
| `E-007` | quick add | `isDealer()` | brak API w tej akcji | `Dealer` |
| `E-008` | wejście na create | `roleGuard Admin` | nie dotyczy | `Admin` |
| `E-008` | zapis produktu | `roleGuard Admin` | `[Authorize(Roles = "Admin")]` | `Admin` |
| `E-009` | szczegół produktu | `authGuard` | `[AllowAnonymous]` | zalogowany w UI |
| `E-009` | deactivate | `isAdmin()` | `[Authorize(Roles = "Admin")]` | `Admin` |
| `E-009` | restock | `canRestock()` | `[Authorize(Roles = "Admin,Warehouse")]` | `Admin`, `Warehouse` |
| `E-009` | submit review | `isDealer()` | `[Authorize(Roles = "Dealer")]` | `Dealer` |
| `E-009` | approve/reject review | `isAdmin()` | `[Authorize(Roles = "Admin")]` | `Admin` |
| `E-010` | wejście na edit | `roleGuard Admin` | nie dotyczy | `Admin` |
| `E-010` | load product/categories | `roleGuard Admin`, API read `[AllowAnonymous]` | `[AllowAnonymous]` | `Admin` w UI |
| `E-010` | update product | `roleGuard Admin` | `[Authorize(Roles = "Admin")]` | `Admin` |
| `E-010` | cancel | `roleGuard Admin` | brak API | `Admin` |

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-ROLE-007-001` | Backend listy produktów jest `[AllowAnonymous]`; prywatność katalogu zależy od gateway/frontu, nie od kontrolera. | `potwierdzone` |
| `RISK-ROLE-008-001` | Kategorie są `[AllowAnonymous]`, choć ekran create wymaga zalogowanego Admina po stronie frontendu. | `potwierdzone` |
| `RISK-ROLE-009-001` | Reviews read jest `[AllowAnonymous]`; pending review zależy od `User.IsInRole("Admin")`, ale zatwierdzone review są publiczne na poziomie kontrolera. | `potwierdzone` |
| `RISK-ROLE-010-001` | Load produktu i kategorii dla edit korzysta z read endpointów `[AllowAnonymous]`; ochrona ekranu jest na route/gateway, a zapis dopiero na backend `Admin`. | `potwierdzone` |
