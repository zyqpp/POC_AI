# AOS Rules Validations Errors Template

## Cel Pliku

Ten plik zbiera reguly biznesowe, walidacje i komunikaty bledow zwiazane z ekranem/funkcja. Ma byc uzyteczny dla analityka, testera i developera.

## Reguly Biznesowe

| ID reguly | Opis biznesowy | Warunek | Wynik gdy spelniona | Wynik gdy naruszona | Egzekwowana w kodzie | Test |
|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-RULE-001` | `<regula>` | `<if>` | `<then>` | `<blad/zakaz>` | `<domain/service>` | `<TC>` |

## Walidacje Frontendu

| ID | Pole/akcja | Regula | Komunikat UI | Blokuje request? | Zrodlo w kodzie |
|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-VFE-001` | `<field>` | `<required/min/max/pattern>` | `<tekst>` | `<tak/nie>` | `<component>` |

## Walidacje Backendu

| ID | DTO / encja | Regula | Status HTTP | Kod bledu | Zrodlo w kodzie |
|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-VBE-001` | `<DTO>` | `<regula>` | `<400/409>` | `<code>` | `<Validator/Entity/Service>` |

## Uprawnienia I Scope Danych

| ID | Rola | Co wolno | Co zabronione | Jak egzekwowane | Test |
|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-AUTH-001` | `<rola>` | `<operacje>` | `<ograniczenia>` | `<guard/controller/service>` | `<TC>` |

## Komunikaty Bledow

| ID bledu | Warunek | Warstwa | HTTP | Payload | Komunikat UI | Retryable |
|---|---|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-ERR-001` | `<warunek>` | `<UI/API/domain>` | `<status>` | `<code/message>` | `<tekst>` | `<true/false>` |

## Stany Brzegowe

| ID | Sytuacja | Oczekiwane zachowanie | Warstwa odpowiedzialna | Test |
|---|---|---|---|---|
| `AOS-<MOD>-<SCREEN>-EDGE-001` | `<np. pusta lista>` | `<wynik>` | `<UI/API>` | `<TC>` |
| `AOS-<MOD>-<SCREEN>-EDGE-002` | `<np. rekord zmieniony rownolegle>` | `<wynik>` | `<backend>` | `<TC>` |

## Niespojnosci I Ryzyka

| ID | Opis | Dowod | Wplyw | Rekomendacja |
|---|---|---|---|---|
| `RISK-001` | `<np. frontend dopuszcza wartosc, backend odrzuca>` | `<pliki>` | `<test/dev/business>` | `<co poprawic>` |
