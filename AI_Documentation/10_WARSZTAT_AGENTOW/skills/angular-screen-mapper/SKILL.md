---
name: angular-screen-mapper
description: Mapuje ekrany Angular na podstawie app.routes.ts, komponentów, template'ów, guardów, modeli TypeScript i serwisów API. Użyj, gdy trzeba opisać route, role, widoczne pola, przyciski, akcje użytkownika i powiązania UI z backendem.
---

# Angular Screen Mapper

## Workflow

1. Uruchom lub przeczytaj `AI_Agent_scripts/Export-Podejscie2AngularRoutes.ps1`.
2. Potwierdź route i role w `supply-chain-frontend/src/app/app.routes.ts`.
3. Otwórz komponent `.ts`, template `.html` i style tylko wtedy, gdy wpływają na opis ekranu.
4. Ustal serwisy API używane przez komponent.
5. Dopasuj modele TypeScript w `core/models/**`.
6. Przekaż ślad do skilla AOS, jeżeli opis ma przejść przez backend i bazę.

## Reguły

- Nie opisuj funkcji widocznej tylko w tekście, jeśli nie ma akcji w komponencie lub template.
- Role frontendu nie zastępują autoryzacji backendu; dokumentuj oba poziomy.
- Gdy komponent używa mocków lub stanu lokalnego, oznacz to jawnie.

## Artefakt Wyjściowy

Mapa ekranu powinna zawierać: route, komponent, guardy, role, pola, akcje, serwisy API, modele TypeScript, zależności backendowe i luki do potwierdzenia.

