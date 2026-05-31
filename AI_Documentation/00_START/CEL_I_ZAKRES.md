# Cel I Zakres

## Cel biznesowo-techniczny

Celem jest udowodnienie, że agent może odtworzyć kompletną dokumentację projektową aplikacji od zera, bez korzystania z wcześniejszych opisów. Dokumentacja ma być przydatna dla właściciela produktu, analityka, architekta, developera, testera i kolejnych agentów AI.

## Zakres aktywnej dokumentacji

Dokumentujemy:

- strukturę systemu i modułów,
- architekturę frontend/backend/gateway,
- API i kontrakty danych,
- model danych i relacje,
- ekrany oraz procesy użytkownika w standardzie AOS,
- role i uprawnienia,
- testy i luki testowe,
- ryzyka oraz rekomendacje,
- narzędzia i skille wspierające dalszą automatyzację.

## Poza zakresem

Nie zmieniamy kodu aplikacji, testów, migracji, konfiguracji runtime ani kontraktów API. Jeżeli analiza ujawni błąd, brak lub ryzyko, zapisujemy to w dokumentacji zamiast naprawiać kod.

## Kryteria ukończenia

Dokumentacja jest kompletna, gdy każdy route frontendu, każdy kontroler API i każdy `DbContext` mają opisany ślad: ekran lub proces -> akcja -> frontend -> API -> logika aplikacyjna -> encje -> baza danych -> testy -> ryzyka.

Szczegółowa bramka jakości AOS jest w `CHECKLISTA_JAKOSCI_AOS.md`. Każdy kolejny AOS ma spełniać ten sam standard co wzorcowy opis `/checkout`.
