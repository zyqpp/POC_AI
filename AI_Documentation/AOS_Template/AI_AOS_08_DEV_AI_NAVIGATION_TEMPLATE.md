# AOS Dev AI Navigation Template

## Cel Pliku

Ten plik jest mapa dla developera i agenta AI. Pokazuje gdzie zaczac analize, jakie pliki sa zrodlami prawdy i jak potwierdzac fakty bez zgadywania.

## Punkty Startowe

| Obszar | Plik / symbol | Po co otworzyc |
|---|---|---|
| Route frontendu | `<app.routes.ts>` | `<potwierdzic URL i komponent>` |
| Komponent | `<component.ts/html/scss>` | `<UI, akcje, formularz>` |
| API service TS | `<core/api/...service.ts>` | `<URL, request, response>` |
| Model TS | `<core/models/...>` | `<typy frontu>` |
| Gateway | `<ocelot.json>` | `<route downstream>` |
| Controller | `<Controller.cs>` | `<auth, endpoint, statusy>` |
| Command/Query | `<Application/Features/...>` | `<wejscie do use case>` |
| Service | `<Application/Services/...>` | `<logika procesu>` |
| Domain | `<Domain/Entities/...>` | `<reguly biznesowe>` |
| Repository/DbContext | `<Infrastructure/...>` | `<dane, tabele SQL, kolumny SQL, relacje>` |

## Sciezka Analizy Dla Nowej Zmiany

1. Znajdz ekran w `app.routes.ts`.
2. Znajdz komponent i sprawdz, jakie API/services/stores wstrzykuje.
3. Znajdz metode API w Angular service.
4. Dopasuj prefiks gatewaya.
5. Znajdz kontroler i endpoint backendowy.
6. Przejdz do command/query handlera.
7. Przejdz do serwisu aplikacyjnego.
8. Jesli sa reguly, otworz encje domenowe i walidatory.
9. Jesli sa dane, otworz repozytorium i DbContext.
10. Jesli sa integracje, otworz `Infrastructure/Integrations` i endpoint internal w drugim serwisie.
11. Dopiero po tej sciezce aktualizuj AOS.

## Fakty Do Potwierdzenia Przy Kazdej Aktualizacji

| Fakt | Jak potwierdzic | Gdzie zapisac |
|---|---|---|
| Czy rola widzi ekran | `app.routes.ts`, guard, controller `[Authorize]` | `00` i `01` |
| Czy przycisk jest aktywny | component TS/HTML | `01` i `02` |
| Jakie API jest wolane | Angular API service + controller | `03` |
| Jakie DTO sa uzyte | TS model + C# DTO | `03` |
| Gdzie sa dane | DbContext + entity + mapper | `04` |
| Jakie sa walidacje | validators + domain methods | `05` |
| Jak UI pokazuje bledy | error interceptor + component | `05` |
| Jak testowac | test files + brakujace testy | `06` |

## Komendy Pomocnicze

```powershell
rg "nazwaAkcji|nazwaEndpointu" supply-chain-frontend services gateway
rg "record .*Request|record .*Dto" services -g "*.cs"
rg "Http(Get|Post|Put|Delete)|Route" services -g "*Controller.cs"
rg "DbSet<|ToTable|HasIndex" services -g "*DbContext.cs"
powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\Collect-CodeFacts.ps1
powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\Generate-ProjectTree.ps1
```

## Standard Dowodu W AOS

Kazda techniczna teza powinna miec dowod:

| Twierdzenie | Minimalny dowod |
|---|---|
| Ekran ma route | `app.routes.ts` + komponent |
| Akcja wywoluje endpoint | metoda w komponencie + API service |
| Endpoint wymaga roli | `[Authorize]` w kontrolerze albo policy |
| Pole pochodzi z tabeli i kolumny SQL | DTO mapper + DbContext/encja/config/migration |
| Regula blokuje operacje | validator/domain/service |
| Blad pokazuje sie w UI | error interceptor / component |

## Luki Dla Developera

| Luka | Objaw | Wplyw | Propozycja poprawki |
|---|---|---|---|
| `<np. brak data-testid>` | `<testy UI kruche>` | `<wysoki/sredni/niski>` | `<dodac selector>` |
| `<np. frontend model rozny od DTO>` | `<blad runtime>` | `<wysoki>` | `<ujednolic kontrakt>` |
