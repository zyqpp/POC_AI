# TC-007-0002 Wyszukiwanie — Wpisz Frazę → Lista Filtrowana (Klienckie Filtrowanie z Debounce)

| Atrybut | Wartość |
|---|---|
| ID | `TC-007-0002` |
| Ekran | [E-007](../E-007__README.md) |
| Typ | happy path |
| Priorytet | P1 |
| Powiązane | A-007-0005, P-007-0001, ERR-007-0003 |
| Status | `brak w kodzie` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Dealer`.
- Lista produktów jest załadowana (co najmniej 2 produkty o różnych nazwach).
- Pole search jest puste — widoczna pełna lista.

## When (Akcja)

- Użytkownik wpisuje frazę w polu wyszukiwania (np. `"Cement"`).
- Użytkownik czeka minimum 300ms (debounce `debounceTime(300)`).

## Then (Oczekiwany rezultat)

- Po upływie 300ms (debounce) frontend wywołuje `GET /catalog/api/products/search?q=Cement` lub `GET /catalog/api/products` i filtruje lokalnie.
- Lista produktów zawęża się do produktów pasujących do frazy `"Cement"` (po nazwie lub SKU).
- Licznik wyników (P-007-0012) aktualizuje się.
- UWAGA: filtrowanie jest klienckie przez debounce — weryfikuj czy API jest wywoływane czy tylko stan komponentu.
- Wyczyszczenie pola search (`""`) przywraca pełną listę bez dodatkowego kliknięcia.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| searchQuery | `Cement` (istniejąca fraza) | `XYZ999NOTEXIST` (fraza bez wyników) |
| debounceMs | `300` | `0` (za szybkie) |

## Powiązany test automatyczny

`brak w kodzie`
