# ROLE_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS`; dokument będzie rozszerzany przy `E-008`-`E-010`.

| Obszar | Mechanizm | Role | Efekt |
|---|---|---|---|
| Route `/products` | `authGuard` na shell route | każdy zalogowany | dostęp do listy |
| `Add Product` | `isAdmin()` w UI, route `/products/new` ma `roleGuard Admin` | `Admin` | wejście do tworzenia produktu |
| Quick add | `isDealer()` i aktywny produkt ze stockiem | `Dealer` | dodanie pozycji do `CartStore` |
| Include inactive | `canViewInactive()` w UI oraz kontroler `User.IsInRole("Admin") || User.IsInRole("Warehouse")` | `Admin`, `Warehouse` po stronie API | możliwość pobrania inactive |
| Endpointy listy/search/detail | `[AllowAnonymous]` w backendzie | technicznie publiczne API | ekran nadal chroniony przez frontend `authGuard` |

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-ROLE-007-001` | Backend listy produktów jest `[AllowAnonymous]`; prywatność katalogu zależy od gateway/frontu, nie od kontrolera. | `potwierdzone` |
