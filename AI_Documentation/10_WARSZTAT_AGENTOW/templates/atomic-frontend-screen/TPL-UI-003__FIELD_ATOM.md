# {{FIELD_ID}} {{FIELD_NAME}}

Status: `szkielet`; wymagane ręczne uzupełnienie po analizie UI, API i bazy.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `{{FIELD_ID}}` |
| Ekran | [{{SCREEN_ID}}](../E-{{SCREEN_NUMBER}}__README.md) |
| Nazwa wykryta | `{{FIELD_NAME}}` |
| Typ detekcji | `{{FIELD_KIND}}` |
| Źródło | `{{FIELD_SOURCE}}` |
| Status faktu | `do uzupełnienia` |

## Opis Pola

**Co wyświetla / zbiera:** do uzupełnienia.  
**Źródło danych:** `[DTO.pole]` → `[Tabela.kolumna]`  
**Kiedy widoczne:** zawsze / [warunek roli lub stanu]  
**Format / maska:** do uzupełnienia (np. `dd.MM.yyyy`, waluta z 2 miejscami po przecinku)

## Widoczność i Warunki

| Warunek | Zachowanie |
|---|---|
| rola użytkownika | do uzupełnienia |
| stan ekranu | do uzupełnienia |
| wartość innego pola | do uzupełnienia |

## Wymagalność i Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | do uzupełnienia | brak pełnej analizy formularza |
| Typ UI | do uzupełnienia | `{{FIELD_SOURCE}}` |
| Reguły walidacji | do uzupełnienia | brak pełnej analizy walidatorów |
| Komunikaty błędów | [ERR-{{SCREEN_NUMBER}}](../ERR-{{SCREEN_NUMBER}}_BLEDY/ERR-{{SCREEN_NUMBER}}__INDEX.md) | do uzupełnienia |

## Mapowanie Danych

| Warstwa | Artefakt | Przykład | Status |
|---|---|---|---|
| Frontend model/form | do uzupełnienia | `fieldName` | `do uzupełnienia` |
| Serwis API | do uzupełnienia | `ApiService.get()` | `do uzupełnienia` |
| Endpoint | do uzupełnienia | `GET /api/...` | `do uzupełnienia` |
| DTO/kontrakt | do uzupełnienia | `public string Pole { get; }` | `do uzupełnienia` |
| Encja/model | do uzupełnienia | `public string Pole { get; set; }` | `do uzupełnienia` |
| DbContext | do uzupełnienia | `DbSet<Encja>` | `do uzupełnienia` |
| Tabela SQL | do uzupełnienia | `NazwaTabeli` | `do uzupełnienia` |
| Kolumna SQL | do uzupełnienia | `NazwaKolumny` | `do uzupełnienia` |
| Odczyt/zapis | do uzupełnienia | `SELECT` / `INSERT` | `do uzupełnienia` |

## Fragment Kodu

```typescript
// {{FIELD_SOURCE}} — do uzupełnienia: wklej powiązany fragment TS lub HTML
```

## Dane Do Testów

- [TD dla pola](../TD-{{SCREEN_NUMBER}}_DANE_TESTOWE/{{TEST_DATA_ID}}__{{FIELD_SLUG}}.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-{{SCREEN_NUMBER}}__INDEX.md)
- [Akcje ekranu](../A-{{SCREEN_NUMBER}}_AKCJE/A-{{SCREEN_NUMBER}}__INDEX.md)
- [Ślad ekranu](../E-{{SCREEN_NUMBER}}__LINKI.md)
