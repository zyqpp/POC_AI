# AOS Rules Validations Errors Template

## Cel Pliku

Ten plik zbiera reguły biznesowe, walidacje i komunikaty błędów związane z ekranem/funkcją. Ma być użyteczny dla analityka, testera i developera.

## Reguły Biznesowe

| ID reguły | Opis biznesowy | Warunek | Wynik gdy spelniona | Wynik gdy naruszona | Egzekwowana w kodzie | Test |
|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-RULE-001` | `<reguła>` | `<if>` | `<then>` | `<błąd/zakaz>` | `<domain/service>` | `<TC>` |

## Walidacje Frontendu

| ID | Pole/akcja | Regula | Komunikat UI | Blokuje request? | Źródło w kodzie |
|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-VFE-001` | `<field>` | `<required/min/max/pattern>` | `<tekst>` | `<tak/nie>` | `<component>` |

## Walidacje Backendu

| ID | DTO / encja | Regula | Status HTTP | Kod błędu | Źródło w kodzie |
|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-VBE-001` | `<DTO>` | `<reguła>` | `<400/409>` | `<code>` | `<Validator/Entity/Service>` |

## Uprawnienia I Scope Danych

| ID | Rola | Co wolno | Co zabronione | Jak egzekwowane | Test |
|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-AUTH-001` | `<rola>` | `<operacje>` | `<ograniczenia>` | `<guard/controller/service>` | `<TC>` |

## Komunikaty Bledow

| ID błędu | Warunek | Warstwa | HTTP | Payload | Komunikat UI | Retryable |
|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-ERR-001` | `<warunek>` | `<UI/API/domain>` | `<status>` | `<code/messąge>` | `<tekst>` | `<true/false>` |

## Stany Brzegowe

| ID | Sytuacja | Oczekiwane zachowanie | Warstwa odpowiedzialna | Test |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-EDGE-001` | `<np. pusta lista>` | `<wynik>` | `<UI/API>` | `<TC>` |
| `AOS-<MOD>-<SCREEN>-EDGE-002` | `<np. rekord zmieniony rownolegle>` | `<wynik>` | `<backend>` | `<TC>` |

## Niespójnośći I Ryzyka

| ID | Opis | Dowod | Wpływ | Rekomendacja |
|---|---|---|---|---|
| `RISK-001` | `<np. frontend dopuszcza wartość, backend odrzuca>` | `<pliki>` | `<test/dev/business>` | `<co poprawić>` |
