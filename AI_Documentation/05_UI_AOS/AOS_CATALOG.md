# AOS_CATALOG

Status: `potwierdzone` dla `E-007_PRODUCTS`; dokument będzie rozszerzany dla `E-008`, `E-009`, `E-010`.

## Ekrany

| Ekran | Route | Zakres |
|---|---|---|
| [E-007_PRODUCTS](EKRANY/E-007_PRODUCTS/E-007__README.md) | `/products` | lista, search, filtry, quick add |
| `E-008_PRODUCTS_NEW` | `/products/new` | tworzenie produktu, do uzupełnienia w kolejnym commicie |
| `E-009_PRODUCTS_ID` | `/products/:id` | szczegół produktu, do uzupełnienia w kolejnym commicie |
| `E-010_PRODUCTS_ID_EDIT` | `/products/:id/edit` | edycja produktu, do uzupełnienia w kolejnym commicie |

## End-To-End

| Obszar | Dokument |
|---|---|
| API | [API_CATALOG](../04_API/API_CATALOG.md) |
| Model danych | [MODEL_DANYCH_CATALOG](../03_MODEL_DANYCH/MODEL_DANYCH_CATALOG.md) |
| Proces listy | [PROC-007_PRODUCTS](../06_PROCESY/PROC-007_PRODUCTS.md) |
| Role | [ROLE_CATALOG](../07_ROLE_I_UPRAWNIENIA/ROLE_CATALOG.md) |
| Testy | [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md) |

## Model Danych

Lista produktów korzysta z tabel `Products` i `Categories`. Pole `AvailableStock` jest wyliczane w domenie jako `TotalStock - ReservedStock`.

## API I Kontrakty

`E-007` używa endpointów listy, kategorii, search i szczegółu produktu. Szczegóły kontraktów są w [API_CATALOG](../04_API/API_CATALOG.md).

## Testy I Luki

Brak testów komponentu dla listy, filtrów i quick add. Wymagane scenariusze są w [MACIERZ_TESTOW_CATALOG](../08_TESTY/MACIERZ_TESTOW_CATALOG.md).

## Ryzyka

Lista produktów jest dobrze mapowalna do `Products` i `Categories`, ale quick add jest stanem frontendowym bez zapisu DB. Zapis następuje dopiero w koszyku/checkout.
