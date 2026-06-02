# {{SCREEN_ID}} {{SCREEN_NAME}}

Status: `szkielet`; źródło startowe: routing i komponent Angular.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `{{SCREEN_ID}}` |
| Route | `{{ROUTE}}` |
| Komponent | `{{COMPONENT}}` |
| Guardy | `{{GUARDS}}` |
| Role frontendu | `{{ROLES}}` |
| Źródło route | `{{ROUTES_SOURCE}}` |
| Źródło komponentu | `{{COMPONENT_SOURCE}}` |
| Źródło template | `{{TEMPLATE_SOURCE}}` |
| Status faktów | `do uzupełnienia` |

## Kluczowe Pliki Kodu

| Rola | Ścieżka |
|---|---|
| Komponent Angular | `{{COMPONENT_SOURCE}}` |
| Template HTML | `{{TEMPLATE_SOURCE}}` |
| Serwis API frontend | do uzupełnienia |
| Kontroler .NET | do uzupełnienia |
| Handler MediatR | do uzupełnienia |
| Encja domenowa | do uzupełnienia |

## Cel Ekranu

_Co robi ten ekran — jedno zdanie._

Główne funkcje:
- funkcja 1
- funkcja 2

Powiązany proces: [do uzupełnienia — link do 06_PROCESY]

## Widok

Wireframe pokazuje sekcje, główne pola, przyciski, stany warunkowe i miejsca list/tabel/modali.

```text
+----------------------------------------------------------------------------+
| {{SCREEN_ID}} {{SCREEN_NAME}}                                               |
+----------------------------------------------------------------------------+
| [sekcja nagłówka / akcje główne]                                            |
|                                                                            |
| +------------------------------------------------------------------------+ |
| | [sekcja danych / formularz / tabela]                                   | |
| | [P-{{SCREEN_NUMBER}}-0001] [P-{{SCREEN_NUMBER}}-0002]                  | |
| |                                                                        | |
| | [A-{{SCREEN_NUMBER}}-0001] [A-{{SCREEN_NUMBER}}-0002]                  | |
| +------------------------------------------------------------------------+ |
|                                                                            |
| [stany: loading / empty / error / modal, jeśli występują]                  |
+----------------------------------------------------------------------------+
```

## Główne Wywołania API

| Metoda | Endpoint | Cel | DTO Odpowiedzi |
|---|---|---|---|
| do uzupełnienia | do uzupełnienia | do uzupełnienia | do uzupełnienia |

## Stany Ekranu

| Stan | Warunek | Zachowanie UI |
|---|---|---|
| Ładowanie | żądanie w toku | spinner / skeleton loader |
| Pusty | brak danych | komunikat / pusta lista |
| Błąd HTTP | status ≥ 400 | komunikat błędu |
| Normalny | dane załadowane | pełny widok |

## Dokumenty Atomowe

- [Pola UI](P-{{SCREEN_NUMBER}}_POLA/P-{{SCREEN_NUMBER}}__INDEX.md)
- [Akcje UI](A-{{SCREEN_NUMBER}}_AKCJE/A-{{SCREEN_NUMBER}}__INDEX.md)
- [Błędy i komunikaty](ERR-{{SCREEN_NUMBER}}_BLEDY/ERR-{{SCREEN_NUMBER}}__INDEX.md)
- [Dane testowe](TD-{{SCREEN_NUMBER}}_DANE_TESTOWE/TD-{{SCREEN_NUMBER}}__INDEX.md)
- [Testy](TC-{{SCREEN_NUMBER}}_TESTY/TC-{{SCREEN_NUMBER}}__INDEX.md)
- [Linki śladu](E-{{SCREEN_NUMBER}}__LINKI.md)

## Zasada Uzupełniania

Każde pole `P-{{SCREEN_NUMBER}}-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
