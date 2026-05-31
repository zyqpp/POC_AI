---
name: api-inventory-from-dotnet
description: Dokumentuje API .NET z kontrolerów ASP.NET Core, atrybutów Route/Http/Authorize, DTO, komend i zapytań MediatR oraz walidatorów FluentValidation. Użyj, gdy trzeba zbudować lub zweryfikować spis endpointów, ról, requestów, response'ów i błędów.
---

# API Inventory From Dotnet

## Workflow

1. Uruchom lub przeczytaj `AI_Agent_scripts/Export-Podejscie2DotnetApi.ps1`.
2. Potwierdź wyniki w `services/**/API/Controllers/*Controller.cs`.
3. Dla każdego endpointu ustal request/response z `services/**/Application/DTOs/**`.
4. Ustal komendę lub zapytanie MediatR w `services/**/Application/Features/**`.
5. Sprawdź walidatory w `services/**/Application/Validation/**`.
6. Sprawdź role w `[Authorize]` i dodatkowe warunki w kodzie metody.

## Reguły

- Base route kontrolera i route metody dokumentuj osobno oraz jako pełną ścieżkę.
- `api/internal/**` oznaczaj jako internal API, nawet jeśli mechanizm ochrony jest w filtrze lub middleware.
- Jeżeli rola zależy od dodatkowego sprawdzenia w metodzie, opisz to jako warunek runtime.
- Nie zakładaj response DTO bez sprawdzenia `ProducesResponseType`, zwracanego typu lub wywołania `sender.Send`.

## Artefakt Wyjściowy

Spis API powinien zawierać: metodę HTTP, ścieżkę, kontroler, akcję, role, request DTO, response DTO, walidator, handler/usługę, status faktu i źródło kodowe.

