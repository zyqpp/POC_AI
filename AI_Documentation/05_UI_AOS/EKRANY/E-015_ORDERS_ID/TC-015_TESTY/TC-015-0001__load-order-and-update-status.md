# TC-015-0001 Odczyt Szczegółu I Zmiana Statusu

Status: `potwierdzone` jako referencyjny przypadek testowy dla aktywnego pionu `/orders/:id`.

## Cel

Potwierdzić, że uprawniony użytkownik odczytuje szczegół zamówienia i może uruchomić akcję zmiany statusu zgodnie z macierzą ról backendu.

## Powiązane Artefakty

| Typ | Link |
|---|---|
| Ekran | [E-015](../E-015__README.md) |
| AOS | [AOS Order Detail](../../../AOS_ORDER_DETAIL.md) |
| Akcja | [A-015-0015 updatestatus](../A-015_AKCJE/A-015-0015__updatestatus.md) |
| Błąd referencyjny | [ERR-015-0006](../ERR-015_BLEDY/ERR-015-0006__this-geterrormessage-err-failed-to-update-order-status.md) |
| Proces | [ORDER_DETAIL_LIFECYCLE](../../../../06_PROCESY/ORDER_DETAIL_LIFECYCLE.md) |
| API | [API_ORDER_DETAIL](../../../../04_API/API_ORDER_DETAIL.md) |

## Preconditions

- Użytkownik jest zalogowany jako `Admin` albo `Logistics`.
- Istnieje zamówienie z identyfikatorem routingu i statusem umożliwiającym przejście lifecycle.
- API `GET /orders/api/orders/{id}` zwraca poprawny `OrderDto`.

## Kroki

1. Wejdź na route `/orders/:id`.
2. Zweryfikuj, że ekran pokazuje numer zamówienia, status i historię statusów.
3. Uruchom akcję `Update Status`.
4. Wybierz poprawny status docelowy z listy dostępnych przejść.
5. Zatwierdź zmianę i odśwież widok danych.

## Oczekiwany Wynik

- Szczegół zamówienia ładuje się bez błędu `404` albo `403` dla uprawnionego użytkownika.
- Frontend wysyła `PUT /orders/api/orders/{id}/status`.
- Backend zapisuje nowy status i wpis w `OrderStatusHistory`.
- Po sukcesie ekran odświeża dane i pokazuje nowy status.

## Luki / Do Potwierdzenia

| Obszar | Status | Uwagi |
|---|---|---|
| Spójność roli `Warehouse` | `do potwierdzenia` | `AOS_ORDER_DETAIL.md` wskazuje rozjazd UI/backend dla zmiany statusu. |
| Test automatyczny komponentu | `brak w kodzie` | Brakuje potwierdzonego testu UI dla widoczności i użycia akcji lifecycle. |
