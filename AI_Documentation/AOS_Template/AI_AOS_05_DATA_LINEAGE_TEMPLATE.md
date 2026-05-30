# AOS Data Lineage Template

## Cel Pliku

Ten plik pokazuje skąd ekran bierze dane, jak są transformowane i gdzie są zapisywane. Dla każdego istotnego pola trzeba wskazac encje/model, tabele SQL i konkretne kolumny SQL. To jest kluczowy dokument dla analityka, testera danych i developera.

## Kontekst Danych

| Obszar | Opis |
|---|---|
| Główne encje | `<np. Order, OrderLine, Shipment>` |
| Główne tabele SQL | `<np. Orders, OrderLines>` |
| Główne DTO | `<np. OrderDto>` |
| Główne API odczytu | `<endpointy>` |
| Główne API zapisu | `<endpointy>` |

## Mapowanie Pól UI Do Danych

| ID pola UI | Etykieta UI | Pole DTO front | Pole DTO backend | Encja/model | Tabela SQL | Kolumna SQL | Odczyt/Zapis | Transformacja | Źródło w kodzie |
|---|---|---|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-DATA-001` | `<label>` | `<model.field>` | `<Dto.Field>` | `<Entity.Property>` | `<TableName>` | `<ColumnName>` | `<R/W/RW>` | `<format/enum/computed>` | `<component/service/DbContext/migration>` |

## Odczyt Danych

| Krok | Źródło | Operacja | Filtry | Sortowanie | Paginacja | Wynik |
|---|---|---|---|---|---|---|
| 1 | `<API>` | `<GET>` | `<query/role>` | `<field>` | `<page/pageSize>` | `<DTO>` |
| 2 | `<Repository>` | `<LINQ/query>` | `<where>` | `<order>` | `<skip/take>` | `<entity list>` |

## Zapis Danych

| Akcja | API | DTO wejścia | Encja/model | Tabela SQL | Kolumny SQL zapisywane | Transakcja | Efekty uboczne |
|---|---|---|---|---|---|---|---|
| `<ACT ID>` | `<endpoint>` | `<request DTO>` | `<Entity>` | `<TableName>` | `<ColumnName, ColumnName>` | `<tak/nie>` | `<event/cache/integracja>` |

## Minimalny Dowod Dla Tabel I Kolumn SQL

| Twierdzenie | Minimalny dowod |
|---|---|
| Pole jest odczytywane z tabeli SQL | `<DTO mapper/query/repository>` + `<DbContext/entity config/migration>` |
| Pole jest zapisywane do kolumny SQL | `<command/service/repository>` + `<encja>` + `<DbContext/entity config/migration>` |
| Pole jest wyliczane, a nie zapisane | `<mapper/service/domain method>` + potwierdźenie braku kolumny SQL |
| Zapis dotyka wielu tabel | `<transąkcja/unit of work>` + lista tabel i kolumn |
| Zmiana jest historyzowana | `<history table/audit/outbox/event>` + kolumny zapisujace stan |

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
