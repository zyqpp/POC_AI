# E-010 Edycja Produktu

Status: `potwierdzone` dla śladu `UI -> API -> proces -> DB -> testy`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-010` |
| Route | `/products/:id/edit` |
| Komponent | `ProductFormComponent` |
| Guardy | `authGuard` na shell route oraz `roleGuard` na route ekranu |
| Role frontendu | `Admin` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts:61` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/catalog/product-form/product-form.component.html` |
| Backend | `ProductsController.Update`, `UpdateProductCommand`, `CatalogInventoryService.UpdateProductAsync` |
| Model danych | `Products`, `Categories`, `OutboxMessages` |

## Cel Ekranu

Ekran pozwala administratorowi edytować istniejący produkt. Formularz używa tego samego komponentu co tworzenie produktu, ale w trybie edit ładuje produkt po `id`, blokuje zmianę `SKU`, ukrywa `Opening Stock`, pokazuje checkbox `Active` i zapisuje zmiany przez `PUT /catalog/api/products/{id}`.

## Widok

```text
+----------------------------------------------------------------------------+
| Edit Product                                                    [Cancel]    |
+----------------------------------------------------------------------------+
| +------------------------------------------------------------------------+ |
| | SKU * [readonly/disabled]        | Name * [_________________________]  | |
| | Unit Price * [__________]        | Min Order Qty * [____]             | |
| | Category * [Select category v]                                      | |
| |   Parent category / child option labels from Categories              | |
| | Description *                                                       | |
| | [______________________________________________________________]     | |
| | [______________________________________________________________]     | |
| | Image URL                                                           | |
| | [https://........................................................]  | |
| | [x] Active                                                          | |
| |                                                        [Cancel] [Update Product] |
| +------------------------------------------------------------------------+ |
+----------------------------------------------------------------------------+
```

Uwagi do widoku: `Opening Stock` istnieje w współdzielonym formularzu, ale w trybie edit jest ukryte przez warunek `!isEdit()` i nie trafia do `UpdateProductRequest`. `SKU` jest pokazane jako wartość identyfikacyjna, ale komponent po załadowaniu produktu wywołuje `disable()` dla tego kontrola.

## Dokumenty Atomowe

- [Pola UI](P-010_POLA/P-010__INDEX.md)
- [Akcje UI](A-010_AKCJE/A-010__INDEX.md)
- [Błędy i komunikaty](ERR-010_BLEDY/ERR-010__INDEX.md)
- [Dane testowe](TD-010_DANE_TESTOWE/TD-010__INDEX.md)
- [Testy](TC-010_TESTY/TC-010__INDEX.md)
- [Linki śladu](E-010__LINKI.md)

## Ślad End-To-End

| Krok | Fakt | Źródło | Status |
|---|---|---|---|
| Wejście | Route `/products/:id/edit` ma `roleGuard` z rolą `Admin`. | `app.routes.ts:61` | `potwierdzone` |
| Load | `ngOnInit()` ładuje kategorie oraz produkt przez `getProductById(id)`. | `product-form.component.ts:81`, `product-form.component.ts:83` | `potwierdzone` |
| Formularz | `SKU` jest po patchowaniu danych wyłączone; `Opening Stock` jest ukryte w edit. | `product-form.component.ts:86`, `product-form.component.html:31` | `potwierdzone` |
| Submit | `submit()` dla edit buduje `UpdateProductRequest` bez `Sku` i bez `OpeningStock`. | `product-form.component.ts:113` | `potwierdzone` |
| API | Frontend wywołuje `PUT /catalog/api/products/{id}`. | `catalog-api.service.ts:50` | `potwierdzone` |
| Backend | `ProductsController.Update` wymaga `Admin`, zwraca `200` albo `404`. | `ProductsController.cs:25`, `ProductsController.cs:28` | `potwierdzone` |
| Walidacja | `UpdateProductRequestValidator` waliduje name, description, category, price, min qty, image URL. | `CatalogValidators.cs:40` | `potwierdzone` |
| Domena | `Product.Update` zapisuje name, description, category, price, min qty, image URL, active i `UpdatedAtUtc`. | `Product.cs:54` | `potwierdzone` |
| DB | Zapis dotyczy `Products`; kategoria jest walidowana przez `Categories`; powstaje outbox `ProductUpdated`. | `CatalogInventoryService.cs:104`, `CatalogInventoryService.cs:129` | `potwierdzone` |
| Testy | Istnieją testy domenowe create/restock/deactivate, ale brak testu update produktu, API, UI i ról dla E-010. | `tests/CatalogInventory.Domain.Tests/UnitTest1.cs` | `brak w kodzie` |

## Luki I Ryzyka

| ID | Luka | Wpływ | Status |
|---|---|---|---|
| `GAP-E-010-001` | Error handler submit w edit tylko wyłącza `loading`; nie pokazuje toastu ani komunikatu API. | Administrator nie wie, czy błąd wynika z 404, walidacji, roli czy awarii. | `brak w kodzie` |
| `GAP-E-010-002` | Brak testów komponentu i API dla readonly `SKU` oraz braku zapisu `OpeningStock`. | Regresja mogłaby dopuścić zmianę SKU albo stocku przez formularz edit. | `brak w kodzie` |
| `GAP-E-010-003` | `UpdateProductRequestValidator` nie ma jawnej reguły dla `IsActive`, bo bool jest wymagany przez typ. | Małe ryzyko nieczytelnego kontraktu dla klientów API. | `wniosek z analizy` |
| `GAP-E-010-004` | Ekran nie ma dedykowanego stanu 404 przy ładowaniu produktu. | Błąd ładowania produktu nie jest opisany w UI jako widoczny komunikat. | `brak w kodzie` |
