# AOS Data Lineage Template

## Cel Pliku

Ten plik pokazuje, skąd ekran bierze dane, jak są transformowane i gdzie są zapisywane. Dla każdego istotnego pola trzeba wskazać encję/model, bazę danych, schemat, tabelę SQL i konkretne kolumny SQL. To jest kluczowy dokument dla analityka, testera danych i developera.

## Kontekst Danych

| Obszar | Opis |
|---|---|
| Główne encje | `<np. Order, OrderLine, Shipment>` |
| Główne tabele SQL | `<np. Orders, OrderLines>` |
| Główne DTO | `<np. OrderDto>` |
| Główne API odczytu | `<endpointy>` |
| Główne API zapisu | `<endpointy>` |

## Tabele Uczestniczące W Ekranie Lub Procesie

Wypełnij tę tabelę przed mapowaniem pojedynczych pól. Jeżeli ekran dotyka kilku mikroserwisów, rozbij dane po bazach.

| Baza danych | Schemat | Tabela | Rola w procesie | Odczyt/Zapis | Klucz główny | Relacje użyte w procesie | Dowód w kodzie |
|---|---|---|---|---|---|---|---|
| `<np. OrderMigrationsDB>` | `dbo` | `<np. Orders>` | `<np. główny agregat zamówienia>` | `<R/W/RW>` | `<OrderId>` | `<OrderLines.OrderId -> Orders.OrderId>` | `<DbContext/repository/service>` |

## Relacje Danych Dla Procesu

| Relacja | Typ relacji | Strona źródłowa | Strona docelowa | Czy fizyczny FK | Gdzie potwierdzone |
|---|---|---|---|---|---|
| `<np. linie zamówienia>` | `<1:N>` | `<Orders.OrderId>` | `<OrderLines.OrderId>` | `<tak>` | `<OrderDbContext>` |
| `<np. zamówienie -> przesyłka>` | `<logiczna>` | `<Orders.OrderId>` | `<Shipments.OrderId>` | `<nie>` | `<service/API/event>` |

## Mapowanie Pól UI Do Danych

| ID pola UI | Etykieta UI | Pole DTO front | Pole DTO backend | Encja/model | Baza danych | Schemat | Tabela SQL | Kolumna SQL | Odczyt/Zapis | Transformacja | Źródło w kodzie |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-DATA-001` | `<label>` | `<model.field>` | `<Dto.Field>` | `<Entity.Property>` | `<DatabaseName>` | `dbo` | `<TableName>` | `<ColumnName>` | `<R/W/RW>` | `<format/enum/computed>` | `<component/service/DbContext/migration>` |

## Odczyt Danych

| Krok | Źródło | Operacja | Filtry | Sortowanie | Paginacja | Wynik |
|---|---|---|---|---|---|---|
| 1 | `<API>` | `<GET>` | `<query/role>` | `<field>` | `<page/pageSize>` | `<DTO>` |
| 2 | `<Repository>` | `<LINQ/query>` | `<where>` | `<order>` | `<skip/take>` | `<entity list>` |

## Zapis Danych

| Akcja | API | DTO wejścia | Encja/model | Baza danych | Schemat | Tabela SQL | Kolumny SQL zapisywane | Transakcja | Efekty uboczne |
|---|---|---|---|---|---|---|---|---|---|
| `<ACT ID>` | `<endpoint>` | `<request DTO>` | `<Entity>` | `<DatabaseName>` | `dbo` | `<TableName>` | `<ColumnName, ColumnName>` | `<tak/nie>` | `<event/cache/integracja>` |

## Minimalny Dowód Dla Tabel I Kolumn SQL

| Twierdzenie | Minimalny dowód |
|---|---|
| Pole jest odczytywane z tabeli SQL | `<DTO mapper/query/repository>` + `<DbContext/entity config/migration>` |
| Pole jest zapisywane do kolumny SQL | `<command/service/repository>` + `<encja>` + `<DbContext/entity config/migration>` |
| Pole jest wyliczane, a nie zapisane | `<mapper/service/domain method>` + potwierdzenie braku kolumny SQL |
| Zapis dotyka wielu tabel | `<transakcja/unit of work>` + lista baz, tabel i kolumn |
| Zmiana jest historyzowana | `<history table/audit/outbox/event>` + kolumny zapisujące stan |
| Relacja jest fizycznym FK | `<DbContext fluent config>` albo `<skrypt SQL>` |
| Relacja jest tylko logiczna między bazami | `<identyfikator w DTO/encji>` + `<API/event/integracja między serwisami>` |

Przed wpisaniem tabel i kolumn sprawdź `AI_DATABASE_STRUCTURE.md`. Jeżeli AOS wykryje różnicę między tym dokumentem, EF i skryptem SQL, wpisz ją w sekcji luk danych.

## Dane Wyliczane

| Pole | Formula / logika | Gdzie liczona | Czy zapisywana w DB | Testy |
|---|---|---|---|---|
| `<np. AvailableStock>` | `<TotalStock - ReservedStock>` | `<Entity/DTO mapper>` | `<nie>` | `<TC>` |

## Słowniki I Enumy

| Nazwa | Wartość | Znaczenie biznesowe | Backend enum | Frontend enum | Wpływ na UI |
|---|---|---|---|---|---|
| `<Status>` | `<value>` | `<opis>` | `<plik>` | `<plik>` | `<badge/akcje>` |

## Retencja, Historia I Audyt

| Dane | Czy jest historia | Gdzie | Co pozwala odtworzyć |
|---|---|---|---|
| `<np. status orderu>` | `<tak/nie>` | `<OrderStatusHistory>` | `<zmiany statusu>` |

## Luki Danych

| Luka | Objaw | Wpływ | Rekomendacja |
|---|---|---|---|
| `<brak pola / brak historii>` | `<co widać>` | `<ryzyko>` | `<co dodać>` |
