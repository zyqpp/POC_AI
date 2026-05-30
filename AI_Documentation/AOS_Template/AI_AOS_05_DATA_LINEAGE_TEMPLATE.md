# AOS Data Lineage Template

## Cel Pliku

Ten plik pokazuje skad ekran bierze dane, jak sa transformowane i gdzie sa zapisywane. To jest kluczowy dokument dla analityka, testera danych i developera.

## Kontekst Danych

| Obszar | Opis |
|---|---|
| Glowne encje | `<np. Order, OrderLine, Shipment>` |
| Glowne tabele | `<np. Orders, OrderLines>` |
| Glowne DTO | `<np. OrderDto>` |
| Glowne API odczytu | `<endpointy>` |
| Glowne API zapisu | `<endpointy>` |

## Mapowanie Pol UI Do Danych

| ID pola UI | Etykieta UI | Pole DTO front | Pole DTO backend | Encja | Tabela | Kolumna | Odczyt/Zapis | Transformacja | Zrodlo w kodzie |
|---|---|---|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-DATA-001` | `<label>` | `<model.field>` | `<Dto.Field>` | `<Entity.Property>` | `<Table>` | `<Column>` | `<R/W/RW>` | `<format/enum/computed>` | `<component/service/DbContext>` |

## Odczyt Danych

| Krok | Zrodlo | Operacja | Filtry | Sortowanie | Paginacja | Wynik |
|---|---|---|---|---|---|---|
| 1 | `<API>` | `<GET>` | `<query/role>` | `<field>` | `<page/pageSize>` | `<DTO>` |
| 2 | `<Repository>` | `<LINQ/query>` | `<where>` | `<order>` | `<skip/take>` | `<entity list>` |

## Zapis Danych

| Akcja | API | DTO wejscia | Encja/tabela | Pola zapisywane | Transakcja | Efekty uboczne |
|---|---|---|---|---|---|---|
| `<ACT ID>` | `<endpoint>` | `<request DTO>` | `<table>` | `<columns>` | `<tak/nie>` | `<event/cache/integracja>` |

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
