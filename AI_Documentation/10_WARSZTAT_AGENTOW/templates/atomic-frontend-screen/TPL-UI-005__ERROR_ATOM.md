# {{ERROR_ID}} {{ERROR_NAME}}

Status: `szkielet`; wymagane ręczne uzupełnienie po analizie UI, API i obsługi błędów.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID błędu | `{{ERROR_ID}}` |
| Ekran | [{{SCREEN_ID}}](../E-{{SCREEN_NUMBER}}__README.md) |
| Nazwa wykryta | `{{ERROR_NAME}}` |
| Typ detekcji | `{{ERROR_KIND}}` |
| Źródło | `{{ERROR_SOURCE}}` |
| Status faktu | `do uzupełnienia` |

## Opis Błędu

**Kod HTTP:** do uzupełnienia (np. `400`, `403`, `404`, `422`, `500`)  
**Kod domenowy / klucz i18n:** do uzupełnienia (np. `ORDER_NOT_FOUND`)  
**Komunikat dla użytkownika:** do uzupełnienia — tekst widoczny w UI  
**Co ląduje w logu serwera:** do uzupełnienia — techniczny opis wyjątku lub walidacji

## Warunki Wystąpienia

| Warstwa | Warunek | Status |
|---|---|---|
| UI | do uzupełnienia | `do uzupełnienia` |
| Walidacja frontend | do uzupełnienia | `do uzupełnienia` |
| API/backend | do uzupełnienia | `do uzupełnienia` |
| Baza/integracja | do uzupełnienia | `do uzupełnienia` |

## Obsługa w Kodzie

| Warstwa | Plik | Fragment |
|---|---|---|
| Walidator frontend | `{{ERROR_SOURCE}}` | do uzupełnienia |
| Serwis HTTP | do uzupełnienia | np. `catchError(...)` |
| Backend validator | do uzupełnienia | np. `AbstractValidator<T>` |
| Exception handler | do uzupełnienia | np. `ProblemDetails` |

## Testy

- [Macierz testów ekranu](../TC-{{SCREEN_NUMBER}}_TESTY/TC-{{SCREEN_NUMBER}}__INDEX.md)
- Dane wywołujące błąd: do uzupełnienia.
- Oczekiwany komunikat: do uzupełnienia.

## Linki

- [Indeks błędów](ERR-{{SCREEN_NUMBER}}__INDEX.md)
- [Pola ekranu](../P-{{SCREEN_NUMBER}}_POLA/P-{{SCREEN_NUMBER}}__INDEX.md)
- [Akcje ekranu](../A-{{SCREEN_NUMBER}}_AKCJE/A-{{SCREEN_NUMBER}}__INDEX.md)
