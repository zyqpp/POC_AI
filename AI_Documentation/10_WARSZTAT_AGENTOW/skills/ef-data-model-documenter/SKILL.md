---
name: ef-data-model-documenter
description: Dokumentuje model danych EF Core na podstawie DbContextów, encji domenowych, konfiguracji Fluent API, migracji i skryptów SQL. Użyj, gdy trzeba opisać bazy, schematy, tabele, kolumny, indeksy, relacje fizyczne i relacje logiczne między mikroserwisami.
---

# EF Data Model Documenter

## Workflow

1. Uruchom lub przeczytaj `AI_Agent_scripts/Export-Podejscie2EfModel.ps1`.
2. Potwierdź `DbSet` i `ToTable` w `services/**/Infrastructure/Persistence/*DbContext.cs`.
3. Odczytaj właściwości z encji w `services/**/Domain/**` i klas infrastrukturalnych.
4. Sprawdź migracje EF w `services/**/Infrastructure/Persistence/Migrations/**`.
5. Porównaj ze skryptami w `scripts/migrations/**`, ale traktuj EF jako bieżący model runtime.
6. Oznacz relacje między mikroserwisami jako logiczne, jeśli nie ma fizycznego FK w tej samej bazie.

## Reguły

- Nie zakładaj schematu innego niż `dbo`, jeśli nie ma `HasDefaultSchema` lub `ToTable(name, schema)`.
- Wyliczane właściwości oznacz jako brak kolumny, jeśli nie są mapowane.
- Rozbieżności EF vs SQL zapisuj jako ryzyko lub lukę, nie poprawiaj migracji.

## Artefakt Wyjściowy

Dokument modelu danych powinien zawierać: bazę, connection string name, DbContext, tabelę, kolumny, klucze, indeksy, relacje, procesy używające danych i status źródła.

