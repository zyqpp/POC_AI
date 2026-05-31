# TD-008-0010 Dane Testowe Dla Grupy Kategorii

Status: `potwierdzone`.

| Typ | Wartość | Oczekiwany rezultat |
|---|---|---|
| parent z dziećmi | `Industrial Equipment` z co najmniej jedną kategorią dziecko | template pokazuje `optgroup` z etykietą parent |
| parent bez dzieci | `Safety` bez dziecka | template pokazuje zwykłą opcję parent |
| sortowanie | nazwy parent w różnej kolejności z API | `topLevelCategories()` sortuje alfabetycznie |

Źródło danych: `Categories.Name`, `Categories.ParentCategoryId`. Powiązany test: `TC-008-0003`.
