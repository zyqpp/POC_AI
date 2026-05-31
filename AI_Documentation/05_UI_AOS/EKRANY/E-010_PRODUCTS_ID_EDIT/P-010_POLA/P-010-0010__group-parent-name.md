# P-010-0010 Parent Category Label

Status: `potwierdzone`.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-010-0010` |
| Ekran | [E-010](../E-010__README.md) |
| Nazwa UI | etykieta grupy kategorii |
| Typ UI | `optgroup label` |
| Źródło | `product-form.component.html:44`, `product-form.component.ts:59` |

## Opis Pola

Etykieta nadrzędnej kategorii w select. Nie jest osobnym polem zapisywanym z formularza; służy tylko do czytelnego grupowania opcji.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagalność | display only | template |
| UI validator | brak | `brak w kodzie` |
| Backend validator | nazwa kategorii pochodzi z danych `CategoryDto` | `GetCategories` |
| Komunikat | brak dedykowanego komunikatu | `brak w kodzie` |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `categoryGroups().parent.name` | `potwierdzone` |
| Serwis API | `getCategories()` | `potwierdzone` |
| Endpoint | `GET /catalog/api/products/categories` | `potwierdzone` |
| DTO/kontrakt | `CategoryDto.Name` | `potwierdzone` |
| Encja/model | `Category.Name` | `potwierdzone` |
| DbContext | `Property(x => x.Name).HasMaxLength(140).IsRequired()` | `potwierdzone` |
| Tabela SQL | `Categories` | `potwierdzone` |
| Kolumna SQL | `Name` | `potwierdzone` |
| Odczyt/zapis | `R` | `potwierdzone` |

## Dane Do Testów

- [TD-010-0010](../TD-010_DANE_TESTOWE/TD-010-0010__group-parent-name.md)
- Seed: kategoria nadrzędna `Industrial`.
