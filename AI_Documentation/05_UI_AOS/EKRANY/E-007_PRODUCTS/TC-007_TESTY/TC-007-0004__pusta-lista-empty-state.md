# TC-007-0004 Pusta Lista → Empty State Widoczny

| Atrybut | Wartość |
|---|---|
| ID | `TC-007-0004` |
| Ekran | [E-007](../E-007__README.md) |
| Typ | błąd HTTP |
| Priorytet | P2 |
| Powiązane | A-007-0001, P-007-0001, ERR-007-0003 |
| Status | `wniosek z analizy` |

## Given (Warunki wstępne)

Scenariusz A — baza nie zawiera produktów:
- API `GET /catalog/api/products` zwraca pustą listę `[]`.

Scenariusz B — filtry wykluczają wszystkie wyniki:
- Lista produktów załadowana (niepusta).
- Użytkownik wpisuje frazę wyszukiwania, która nie pasuje do żadnego produktu (np. `"XYZ999NOTEXIST"`).
- Lub użytkownik wybiera kombinację filtrów kategorii + stock, która zwraca 0 wyników.

## When (Akcja)

Scenariusz A: Użytkownik wchodzi na `/products`.
Scenariusz B: Użytkownik wpisuje frazę w polu search lub ustawia filtry powodujące 0 wyników.

## Then (Oczekiwany rezultat)

- Tabela produktów jest pusta — brak wierszy.
- Na ekranie widoczny jest komunikat empty state (np. `"No products found"` lub podobny).
- Licznik wyników (P-007-0012) wskazuje `0`.
- Przycisk `"Clear Filters"` (A-007-0001) jest widoczny w scenariuszu B i po kliknięciu przywraca pełną listę.
- Błąd `ERR-007-0003` (products load failed) **nie** jest wyświetlany — to inne zachowanie niż błąd HTTP.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| searchQuery | `XYZ999NOTEXIST` (brak wyników) | `Cement` (ma wyniki) |
| stockFilter | `inStock` (gdy brak produktów in stock) | `all` |

## Powiązany test automatyczny

`brak w kodzie`
