# AOS UI Fields And Layout Template

## Widok

Każdy ekran ma mieć prosty wireframe z kresek. Widok pokazuje sekcje, najważniejsze pola, akcje, stany warunkowe i miejsce komunikatów.

```text
+----------------------------------------------------------------------------+
| <nazwa ekranu>                                                 [akcja]      |
+----------------------------------------------------------------------------+
| <sekcja główna>                                                            |
| P-XXX-0001 [____________]    P-XXX-0002 [____________]       [A-XXX-0001]  |
|                                                                            |
| +------------------------------------------------------------------------+ |
| | <lista/tabela/karta/modal/stany empty/loading/error>                   | |
| +------------------------------------------------------------------------+ |
+----------------------------------------------------------------------------+
```

## Pola I Elementy UI

| Element | Pole / etykieta | Akcja | Źródło UI | Status |
|---|---|---|---|---|
| `<element>` | `<pole>` | `<akcja>` | `<component.html:line>` | do potwierdzenia |

## Stany

| Stan | Warunek | Zachowanie | Status |
|---|---|---|---|
| loading | `<warunek>` | `<zachowanie>` | do potwierdzenia |
| error | `<warunek>` | `<zachowanie>` | do potwierdzenia |
