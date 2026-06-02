# PROC-011 Koszyk (Cart)

Status: `potwierdzone` dla logiki frontendowej; `brak w kodzie` dla trwałości backendowej.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| Proces | `PROC-011_CART` |
| Ekran | [E-011_CART](../05_UI_AOS/EKRANY/E-011_CART/E-011__README.md) |
| Route | `/cart` |
| Główne role | `Dealer` |
| API | brak dedykowanego endpointu koszyka; checkout używa `POST /order/api/orders` |
| Model danych | przejście do [CHECKOUT_E2E](CHECKOUT_E2E.md) |

## Cel

Koszyk jest stanem wyłącznie frontendowym — przechowywany w localStorage pod kluczem `sc_cart` przez `CartStore` (Angular service). Użytkownik dodaje produkty z listy (`E-007`) lub szczegółu (`E-009`), edytuje ilości, usuwa pozycje. Proces kończy się przejściem do checkout (`E-012`), gdzie koszyk jest finalizowany i tworzony jest rekord zamówienia w DB. Koszyk NIE ma trwałości serwera — utrata localStorage = utrata koszyka.

## Przepływ

| Krok | Warstwa | Fakt | Status |
|---|---|---|---|
| 1 | Routing | `/cart` z `authGuard`; dostęp dla Dealer | `potwierdzone` |
| 2 | UI init | `CartComponent.ngOnInit()` odczytuje `CartStore.items$` | `wniosek z analizy` |
| 3 | Cart store | `CartStore` odczytuje localStorage `sc_cart` przy inicjalizacji | `potwierdzone` |
| 4 | UI render | Lista pozycji: produkt, ilość, cena jednostkowa, suma | `potwierdzone` |
| 5 | Edycja ilości | `CartStore.updateQuantity(productId, qty)` → zapis localStorage | `wniosek z analizy` |
| 6 | Usunięcie | `CartStore.removeItem(productId)` → zapis localStorage | `wniosek z analizy` |
| 7 | Przejście do checkout | `[routerLink]="/checkout"` lub przycisk "Proceed to Checkout" | `potwierdzone` |
| 8 | Warunek checkout | Koszyk musi mieć ≥ 1 pozycję z ilością ≥ minOrderQty | `wniosek z analizy` |

## Granice Procesu

- Koszyk zaczyna się gdy Dealer dodaje pierwszy produkt (w E-007 lub E-009).
- Koszyk kończy się gdy Dealer klika "Proceed to Checkout" → przekazanie do `CHECKOUT_E2E`.
- Koszyk NIE tworzy żadnego zapisu w bazie danych.

## Dane I Transakcje

| Obszar | Operacja | Artefakt |
|---|---|---|
| CartStore | R/W | `CartStore.items` (pamięć Angular) |
| localStorage | R/W | `sc_cart` (JSON z pozycjami koszyka) |
| Baza danych | **brak** | koszyk nie ma trwałości serwera |

## Błędy Procesu

| ID | Warunek | HTTP | Akcja kompensująca | Status |
|---|---|---|---|---|
| `ERR-PROC-011-001` | Pusty koszyk przy próbie checkout | — | przycisk "Proceed to Checkout" nieaktywny lub komunikat | `wniosek z analizy` |
| `ERR-PROC-011-002` | Produkt niedostępny (odświeżenie info stocku) | — | brak walidacji stocku w koszyku przed checkout; ryzyko P1 | `brak w kodzie` |
| `ERR-PROC-011-003` | localStorage niedostępny (tryb prywatny) | — | koszyk resetuje się przy nawigacji; brak obsługi tego przypadku | `brak w kodzie` |

## Luki

| ID | Luka | Status |
|---|---|---|
| `GAP-PROC-011-001` | Brak walidacji dostępności stocku w koszyku przed checkout | `brak w kodzie` |
| `GAP-PROC-011-002` | Brak persistencji serwera koszyka — utrata przy wyczyszczeniu localStorage | `brak w kodzie` |
| `GAP-PROC-011-003` | Brak synchronizacji koszyka między kartami przeglądarki | `brak w kodzie` |
