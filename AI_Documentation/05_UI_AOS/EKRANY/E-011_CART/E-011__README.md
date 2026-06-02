# E-011 CartComponent

Status: `wniosek z analizy`; źródło startowe: routing i komponent Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-011` |
| Route | `/cart` |
| Komponent | `CartComponent` |
| Guardy | `roleGuard` |
| Role frontendu | `Dealer` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/cart/cart.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/cart/cart.component.html` |
| Status faktów | `do uzupełnienia` |

## Dokumenty Atomowe

- [Pola UI](P-011_POLA/P-011__INDEX.md)
- [Akcje UI](A-011_AKCJE/A-011__INDEX.md)
- [Błędy i komunikaty](ERR-011_BLEDY/ERR-011__INDEX.md)
- [Dane testowe](TD-011_DANE_TESTOWE/TD-011__INDEX.md)
- [Testy](TC-011_TESTY/TC-011__INDEX.md)
- [Linki śladu](E-011__LINKI.md)

## Cel Ekranu

Widok koszyka zakupowego — wyłącznie frontend (CartStore + localStorage klucz `sc_cart`). Dealer przegląda wybrane produkty, edytuje ilości z walidacją `minOrderQty` i `availableStock`, dodaje notatki do pozycji i przechodzi do checkout. NIE ma zapisu do bazy danych — koszyk jest stanem przeglądarki persystowanym w localStorage przez `effect()` w CartStore.

Główne funkcje:
- Lista pozycji koszyka (produkt, SKU, ilość, cena jednostkowa, suma linii)
- Edycja ilości pozycji (input + increment/decrement + szybkie mnożniki) z walidacją `minOrderQty`
- Usunięcie pozycji (przy normalizacji do 0)
- Notatki do pozycji (max 160 znaków)
- Wyczyszczenie całego koszyka (`clearCart()`)
- Przejście do checkout (link nawigacyjny)

Dostęp chroniony guardem `roleGuard` — tylko rola `Dealer`.

Powiązany proces: [PROC-011_CART](../../../../06_PROCESY/PROC-011_CART.md)

## Kluczowe Pliki Kodu

| Rola | Ścieżka |
|---|---|
| Komponent Angular | `supply-chain-frontend/src/app/features/cart/cart.component.ts` |
| Template HTML | `supply-chain-frontend/src/app/features/cart/cart.component.html` |
| Store koszyka | `supply-chain-frontend/src/app/core/stores/cart.store.ts` |
| Model pozycji | `supply-chain-frontend/src/app/core/models/shared.models.ts` (CartItem) |
| Serwis toast | `supply-chain-frontend/src/app/core/services/toast.service.ts` |
| Guard dostępu | `supply-chain-frontend/src/app/core/guards/role.guard.ts` (roleGuard) |

## Główne Wywołania API

| Metoda | Endpoint | Cel | DTO Odpowiedzi |
|---|---|---|---|
| brak | — | koszyk jest stanem lokalnym (CartStore + localStorage `sc_cart`) | — |

## Stany Ekranu

| Stan | Warunek | Zachowanie UI |
|---|---|---|
| Pusty | `cartStore.items().length === 0` | komunikat "Your cart is empty" + link do produktów |
| Z pozycjami | `cartStore.items().length >= 1` | tabela pozycji + edycja ilości + notatki + suma (`cartStore.total()`) + przycisk checkout |
| Produkt niedostępny | `availableStock < minOrderQty` dla pozycji | `maxPurchasable()` zwraca 0; pozycja usuwana przy próbie edycji; toast warning |
| Przekroczony stock | ilość > availableStock | toast "Cannot exceed available stock"; ilość normalizowana do max |
| Min. ilość zamówienia | ilość < minOrderQty | toast z komunikatem `Minimum order quantity is {minOrderQty}`; ilość normalizowana |

## Zasada Uzupełniania

Każde pole `P-011-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
