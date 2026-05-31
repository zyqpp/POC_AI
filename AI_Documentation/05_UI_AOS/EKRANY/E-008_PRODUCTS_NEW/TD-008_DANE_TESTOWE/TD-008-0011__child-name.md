# TD-008-0011 Dane Testowe Dla Kategorii Dziecko

Status: `potwierdzone`.

| Typ | Wartość | Oczekiwany rezultat |
|---|---|---|
| child typowy | `Pumps` z `ParentCategoryId` wskazującym parent | select pokazuje opcję child w `optgroup` parent |
| sortowanie | dzieci `Valves`, `Pumps` | `categoryChildrenMap()` sortuje dzieci alfabetycznie |
| wybór child | `Categories.CategoryId` dziecka | `CreateProductRequest.CategoryId` ma ID dziecka |

Źródło danych: `Categories.CategoryId`, `Categories.Name`, `Categories.ParentCategoryId`. Powiązany test: `TC-008-0003`.
