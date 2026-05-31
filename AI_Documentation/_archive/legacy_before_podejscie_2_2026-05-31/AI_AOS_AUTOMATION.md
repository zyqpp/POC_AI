# Automatyzacja AOS

Ten dokument opisuje narzędzia dodane po pierwszej iteracji AOS dla procesu `Checkout -> Create Order`.

## Zasada Bezpieczeństwa

Automatyzacja AOS służy wyłącznie dokumentowaniu i walidacji dokumentacji. Skrypty mogą czytać kod i generować raporty, ale nie mogą zmieniać kodu aplikacji, testów, migracji, konfiguracji runtime ani kontraktów API. Wykryte błędy i luki należy zapisywać jako fakty, ryzyka albo rekomendacje w dokumentacji.

## Skrypty

| Skrypt | Cel | Przykład |
|---|---|---|
| `AI_Agent_scripts/New-AosScaffold.ps1` | Generuje katalog i komplet plików `00-09` dla nowego AOS na podstawie szablonów. | `powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\New-AosScaffold.ps1 -Module orders -FeatureId order-detail -Title "Order Detail" -DryRun` |
| `AI_Agent_scripts/Export-AosTraceFacts.ps1` | Zbiera fakty z routingu Angulara, serwisów API, Ocelota, kontrolerów, DTO TS/C#, EF `DbContext` i generuje raport luk. | `powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\Export-AosTraceFacts.ps1` |

## Co Automatyzuje `New-AosScaffold.ps1`

- tworzy folder `AI_Documentation/AOS/<module>/<feature>/`;
- kopiuje komplet plików AOS `00-09`;
- podstawia tytuł, moduł, route, komponent i główne API, jeżeli zostaną podane;
- ma tryb `-DryRun`, żeby sprawdzić ścieżki bez tworzenia plików.

## Co Automatyzuje `Export-AosTraceFacts.ps1`

- parser route Angulara z `app.routes.ts`;
- parser metod Angular API z `supply-chain-frontend/src/app/core/api/*.service.ts`;
- parser pól UI z template Angular `*.component.html`;
- parser tras Ocelota z `gateway/OcelotGateway/ocelot.json`;
- parser endpointów kontrolerów ASP.NET;
- indeks handlerów MediatR oraz kandydackich serwisów aplikacyjnych;
- parser DTO TypeScript i rekordów DTO C#;
- porównanie nazw pól DTO TypeScript / C#;
- parser EF `DbContext`, tabel SQL, kolumn/właściwości oraz pól ignorowanych;
- porównanie ustaleń z dokumentem `AI_DATABASE_STRUCTURE.md`, jeżeli agent przygotowuje konkretny AOS;
- macierz kandydacka `frontend -> HTTP -> controller -> command/query -> handler -> service -> entity -> SQL`;
- raport potencjalnych luk: pole UI bez oczywistego zapisu/lineage, DTO bez oczywistej tabeli SQL, API bez oczywistego testu, route bez jawnej roli, API bez dopasowanego kontrolera, różnice DTO, kontrakty wymagające przeglądu lineage.

## Ograniczenia

- Skrypty są parserami statycznymi i heurystycznymi. Nie zastępują review kodu.
- Parser EF ustala kolumny na podstawie encji i `DbContext`, nie z fizycznej bazy danych.
- Parser Angular API rozumie typowe wzorce `HttpClient`, ale może wymagać korekty dla bardziej złożonych template stringów.
- Parser pól UI wykrywa głównie `formControlName`, `[(ngModel)]` i `name`; pola wyliczane albo własne komponenty mogą wymagać ręcznej analizy.
- Wykrywanie API bez testu jest heurystyczne: sprawdza, czy akcja albo route pojawia się w testach, ale nie ocenia jakości testu.
- Macierz SQL wskazuje kandydackie encje i tabele po obszarze serwisu. Agent musi potwierdzić fakty w kodzie.

## Zalecany Workflow

1. Uruchom `Export-AosTraceFacts.ps1`.
2. Wybierz proces/ekran i odszukaj go w `AI_AOS_TRACE_REPORT.md`.
3. Sprawdź `AI_DATABASE_STRUCTURE.md`, żeby ustalić bazy, schematy, tabele, kolumny i relacje dla procesu.
4. Wygeneruj szkielet przez `New-AosScaffold.ps1`.
5. Wypełnij AOS ręcznie, potwierdzając każdy ważny fakt w kodzie.
6. Uruchom raport ponownie po większych zmianach w API, DTO albo `DbContext`.
7. Jeżeli raport pokaże problem w kodzie, dopisz lukę lub rekomendację do AOS; nie poprawiaj kodu aplikacji w tym trybie pracy.
