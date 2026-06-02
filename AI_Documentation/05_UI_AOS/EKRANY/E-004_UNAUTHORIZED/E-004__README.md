# E-004 UnauthorizedComponent

Status: `wniosek z analizy`; uzupełnione na podstawie analizy komponentu Angular i szablonu HTML.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID ekranu | `E-004` |
| Route | `/unauthorized` |
| Komponent | `UnauthorizedComponent` |
| Guardy | `brak guardów w route` |
| Role frontendu | `brak ról w route` |
| Źródło route | `supply-chain-frontend/src/app/app.routes.ts` |
| Źródło komponentu | `supply-chain-frontend/src/app/features/auth/unauthorized/unauthorized.component.ts` |
| Źródło template | `supply-chain-frontend/src/app/features/auth/unauthorized/unauthorized.component.html` |
| Status faktów | `wniosek z analizy` |

## Cel Ekranu

Ekran wyświetlany gdy użytkownik próbuje uzyskać dostęp do zasobu bez odpowiednich uprawnień (403). Pokazuje komunikat "Access Denied — Your role does not grant access to this route." i przycisk powrotu do dashboardu. Nie ma wywołań API — to statyczny ekran stanu błędu.

Ekran jest kierunkiem przekierowania z `roleGuard` gdy rola JWT nie pasuje do wymaganej przez route. Komponent nie posiada żadnej logiki TypeScript (pusta klasa z samym dekoratorem `@Component`) — cała treść jest statycznym HTML.

## Kluczowe Pliki Kodu

| Plik | Rola |
|---|---|
| `supply-chain-frontend/src/app/features/auth/unauthorized/unauthorized.component.ts` | Komponent Angular (brak logiki) |
| `supply-chain-frontend/src/app/features/auth/unauthorized/unauthorized.component.html` | Statyczny szablon z komunikatem i przyciskiem powrotu |
| `supply-chain-frontend/src/app/app.routes.ts` | Route `/unauthorized` bez guardów |

## Główne Wywołania API

Brak — ekran jest w pełni statyczny. Nie wykonuje żadnych wywołań HTTP.

## Stany Ekranu

| Stan | Opis |
|---|---|
| Jedyny stan | Wyświetlenie komunikatu "Access Denied" z opisem i przyciskiem `[Go to Dashboard]` (routerLink `/dashboard`) |

## Akcje

| Akcja | Element UI | Efekt |
|---|---|---|
| Go to Dashboard | `<a routerLink="/dashboard">` | Przekierowanie na `/dashboard` przez Angular Router — brak wywołania API |

## Dokumenty Atomowe

- [Pola UI](P-004_POLA/P-004__INDEX.md)
- [Akcje UI](A-004_AKCJE/A-004__INDEX.md)
- [Błędy i komunikaty](ERR-004_BLEDY/ERR-004__INDEX.md)
- [Dane testowe](TD-004_DANE_TESTOWE/TD-004__INDEX.md)
- [Testy](TC-004_TESTY/TC-004__INDEX.md)
- [Linki śladu](E-004__LINKI.md)

## Zasada Uzupełniania

Każde pole `P-004-....` musi docelowo mieć opis wymagalności, walidacji, źródła danych, mapowania do API/DTO, encji, tabeli SQL, kolumny SQL oraz danych do automatycznych testów. Brak informacji należy oznaczać jako `do uzupełnienia`, `brak w kodzie` albo `wniosek z analizy`.
