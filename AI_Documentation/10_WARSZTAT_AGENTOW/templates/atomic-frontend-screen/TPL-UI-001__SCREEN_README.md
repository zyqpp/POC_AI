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

## Cel Ekranu

Do uzupełnienia na podstawie template Angular, komponentu, serwisów API i procesu biznesowego.

## Widok

Każdy ekran musi mieć widok rozpisany jako prosty wireframe z kresek. Layout ma pokazywać sekcje, główne pola, przyciski, stany warunkowe i miejsca list/tabel/modali.

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

## Dokumenty Atomowe

- [Pola UI](P-{{SCREEN_NUMBER}}_POLA/P-{{SCREEN_NUMBER}}__INDEX.md)
- [Akcje UI](A-{{SCREEN_NUMBER}}_AKCJE/A-{{SCREEN_NUMBER}}__INDEX.md)
- [Błędy i komunikaty](ERR-{{SCREEN_NUMBER}}_BLEDY/ERR-{{SCREEN_NUMBER}}__INDEX.md)
- [Dane testowe](TD-{{SCREEN_NUMBER}}_DANE_TESTOWE/TD-{{SCREEN_NUMBER}}__INDEX.md)
- [Testy](TC-{{SCREEN_NUMBER}}_TESTY/TC-{{SCREEN_NUMBER}}__INDEX.md)
- [Linki śladu](E-{{SCREEN_NUMBER}}__LINKI.md)

## Zasada Uzupełniania

Każde pole `P-{{SCREEN_NUMBER}}-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
