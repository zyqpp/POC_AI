# ROLE_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS` i `E-008_PRODUCTS_NEW`; dokument będzie rozszerzany przy `E-009`-`E-010`.

| Obszar | Mechanizm | Role | Efekt |
|---|---|---|---|
| Route `/products` | `authGuard` na shell route | każdy zalogowany | dostęp do listy |
| `Add Product` na liście | `isAdmin()` w UI | `Admin` | widoczny link do `/products/new` |
| Route `/products/new` | `roleGuard` z `roles: ['Admin']` | `Admin` | dostęp do formularza create |
| Endpoint `POST /catalog/api/products` | `[Authorize(Roles = "Admin")]` | `Admin` | zapis produktu |
| Quick add | `isDealer()` i aktywny produkt ze stockiem | `Dealer` | dodanie pozycji do `CartStore` |
| Include inactive | `canViewInactive()` w UI oraz kontroler `User.IsInRole("Admin") || User.IsInRole("Warehouse")` | `Admin`, `Warehouse` po stronie API | możliwość pobrania inactive |
| Endpointy listy/search/detail/categories | `[AllowAnonymous]` w backendzie | technicznie publiczne API | ekran nadal chroniony przez frontend `authGuard` |

## Macierz Ekran / Akcja / Endpoint

| Ekran | Akcja | Frontend | Backend | Role |
|---|---|---|---|---|
| `E-007` | lista produktów | `authGuard` | `[AllowAnonymous]` | zalogowany w UI |
| `E-007` | quick add | `isDealer()` | brak API w tej akcji | `Dealer` |
| `E-008` | wejście na create | `roleGuard Admin` | nie dotyczy | `Admin` |
| `E-008` | pobranie kategorii | `authGuard` przez shell | `[AllowAnonymous]` | zalogowany w UI |
| `E-008` | zapis produktu | `roleGuard Admin` | `[Authorize(Roles = "Admin")]` | `Admin` |

## Ryzyka

| ID | Ryzyko | Status |
|---|---|---|
| `RISK-ROLE-007-001` | Backend listy produktów jest `[AllowAnonymous]`; prywatność katalogu zależy od gateway/frontu, nie od kontrolera. | `potwierdzone` |
| `RISK-ROLE-008-001` | Kategorie są `[AllowAnonymous]`, choć ekran create wymaga zalogowanego Admina po stronie frontendu. | `potwierdzone` |
