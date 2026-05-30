# AOS Data Lineage Template

## Cel Pliku

Ten plik pokazuje skad ekran bierze dane, jak sa transformowane i gdzie sa zapisywane. Dla kazdego istotnego pola trzeba wskazac encje/model, tabele SQL i konkretne kolumny SQL. To jest kluczowy dokument dla analityka, testera danych i developera.

## Kontekst Danych

| Obszar | Opis |
|---|---|
| Glowne encje | `<np. Order, OrderLine, Shipment>` |
| Glowne tabele SQL | `<np. Orders, OrderLines>` |
| Glowne DTO | `<np. OrderDto>` |
| Glowne API odczytu | `<endpointy>` |
| Glowne API zapisu | `<endpointy>` |

## Mapowanie Pol UI Do Danych

| ID pola UI | Etykieta UI | Pole DTO front | Pole DTO backend | Encja/model | Tabela SQL | Kolumna SQL | Odczyt/Zapis | Transformacja | Zrodlo w kodzie |
|---|---|---|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-DATA-001` | `<label>` | `<model.field>` | `<Dto.Field>` | `<Entity.Property>` | `<TableName>` | `<ColumnName>` | `<R/W/RW>` | `<format/enum/computed>` | `<component/service/DbContext/migration>` |

## Odczyt Danych

| Krok | Zrodlo | Operacja | Filtry | Sortowanie | Paginacja | Wynik |
|---|---|---|---|---|---|---|
| 1 | `<API>` | `<GET>` | `<query/role>` | `<field>` | `<page/pageSize>` | `<DTO>` |
| 2 | `<Repository>` | `<LINQ/query>` | `<where>` | `<order>` | `<skip/take>` | `<entity list>` |

## Zapis Danych

| Akcja | API | DTO wejscia | Encja/model | Tabela SQL | Kolumny SQL zapisywane | Transakcja | Efekty uboczne |
|---|---|---|---|---|---|---|---|
| `<ACT ID>` | `<endpoint>` | `<request DTO>` | `<Entity>` | `<TableName>` | `<ColumnName, ColumnName>` | `<tak/nie>` | `<event/cache/integracja>` |

## Minimalny Dowod Dla Tabel I Kolumn SQL

| Twierdzenie | Minimalny dowod |
|---|---|
| Pole jest odczytywane z tabeli SQL | `<DTO mapper/query/repository>` + `<DbContext/entity config/migration>` |
| Pole jest zapisywane do kolumny SQL | `<command/service/repository>` + `<encja>` + `<DbContext/entity config/migration>` |
| Pole jest wyliczane, a nie zapisane | `<mapper/service/domain method>` + potwierdzenie braku kolumny SQL |
| Zapis dotyka wielu tabel | `<transakcja/unit of work>` + lista tabel i kolumn |
| Zmiana jest historyzowana | `<history table/audit/outbox/event>` + kolumny zapisujace stan |

## Dane Wyliczane

| Pole | Formula / logika | Gdzie liczona | Czy zapisywana w DB | Testy |
|---|---|---|---|---|
| `<np. AvailableStock>` | `<TotalStock - ReservedStock>` | `<Entity/DTO mapper>` | `<nie>` | `<TC>` |

## Slowniki I Enumy

| Nazwa | Wartosc | Znaczenie biznesowe | Backend enum | Frontend enum | Wplyw na UI |
|---|---|---|---|---|---|
| `<Status>` | `<value>` | `<opis>` | `<plik>` | `<plik>` | `<badge/akcje>` |

## Retencja, Historia I Audyt

| Dane | Czy jest historia | Gdzie | Co pozwala odtworzyc |
|---|---|---|---|
| `<np. status orderu>` | `<tak/nie>` | `<OrderStatusHistory>` | `<zmiany statusu>` |

## Luki Danych

| Luka | Objaw | Wplyw | Rekomendacja |
|---|---|---|---|
| `<brak pola / brak historii>` | `<co widac>` | `<ryzyko>` | `<co dodac>` |
