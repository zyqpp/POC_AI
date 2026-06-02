# TC-007-0001 Smoke — Strona Ładuje Listę Produktów (Tabela Nie Pusta)

| Atrybut | Wartość |
|---|---|
| ID | `TC-007-0001` |
| Ekran | [E-007](../E-007__README.md) |
| Typ | smoke |
| Priorytet | P0 |
| Powiązane | A-007-0005, P-007-0008, P-007-0009, P-007-0010 |
| Status | `brak w kodzie` |

## Given (Warunki wstępne)

- Użytkownik jest zalogowany jako `Dealer`, `Admin` lub `Warehouse`.
- Baza danych zawiera co najmniej jeden aktywny produkt.
- API `GET /catalog/api/products` jest dostępne i zwraca niepustą listę `ProductListItemDto`.
- Kategorie produktów są dostępne: `GET /catalog/api/categories`.

## When (Akcja)

- Użytkownik wchodzi na trasę `/products`.
- Poczekuje na zakończenie ładowania (zniknie spinner lub indicator ładowania).

## Then (Oczekiwany rezultat)

- Na ekranie widoczna jest tabela produktów z co najmniej jednym wierszem.
- Każdy wiersz zawiera: nazwę produktu (P-007-0008), SKU (P-007-0009), cenę (P-007-0010), etykietę stocku (P-007-0011).
- Kategorie (Parent/Child) są załadowane w filtrach (P-007-0006, P-007-0007).
- Licznik wyników (P-007-0012) jest widoczny i większy od 0.
- Nie wyświetla się komunikat empty state ani błąd `ERR-007-0003`.

## Dane Testowe

| Pole | Wartość poprawna | Wartość błędna |
|---|---|---|
| searchQuery | `` (pusty — domyślna lista) | `brak` |
| stockFilter | `all` (domyślny) | `brak` |

## Powiązany test automatyczny

`brak w kodzie`
