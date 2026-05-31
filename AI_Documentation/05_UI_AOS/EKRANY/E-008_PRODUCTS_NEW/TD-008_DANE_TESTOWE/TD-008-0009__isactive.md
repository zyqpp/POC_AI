# TD-008-0009 Dane Testowe Dla Aktywności

Status: `potwierdzone`.

| Typ | Wartość | Oczekiwany rezultat |
|---|---|---|
| create default | brak pola w `CreateProductRequest` | `Product.IsActive=true` po utworzeniu |
| użytkownik Dealer | rola `Dealer` | brak dostępu do route `/products/new` |
| użytkownik Warehouse | rola `Warehouse` | brak dostępu do route `/products/new` |

Pole `isActive` istnieje w `ProductFormComponent.form`, ale w trybie create nie jest widoczne w UI i nie jest wysyłane do `CreateProductRequest`. Powiązane testy: `TC-008-0001`, `TC-008-0005`.
