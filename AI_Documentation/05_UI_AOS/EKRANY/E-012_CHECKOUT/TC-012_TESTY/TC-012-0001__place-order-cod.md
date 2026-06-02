# TC-012-0001 Złożenie Zamówienia COD

Status: `potwierdzone` jako referencyjny przypadek testowy dla aktywnego pionu `/checkout`.

## Cel

Potwierdzić, że dealer z niepustym koszykiem może przejść przez checkout w wariancie `COD`, a po sukcesie frontend czyści szkic checkout i przechodzi do szczegółu nowego zamówienia.

## Powiązane Artefakty

| Typ | Link |
|---|---|
| Ekran | [E-012](../E-012__README.md) |
| AOS | [AOS Checkout](../../../AOS_CHECKOUT.md) |
| Akcja | [A-012-0001 placeorder](../A-012_AKCJE/A-012-0001__placeorder.md) |
| Błąd referencyjny | [ERR-012-0003](../ERR-012_BLEDY/ERR-012-0003__cart-updated-with-latest-stock-and-pricing-please-review-and-place-order-again.md) |
| Proces | [CHECKOUT_E2E](../../../../06_PROCESY/CHECKOUT_E2E.md) |
| API | [API_CHECKOUT](../../../../04_API/API_CHECKOUT.md) |

## Preconditions

- Użytkownik jest zalogowany jako `Dealer`.
- `CartStore` zawiera co najmniej jedną poprawną pozycję.
- Produkty w koszyku mają aktualny stock, cenę i `IsActive = true`.
- Metoda płatności jest ustawiona na `COD`.

## Kroki

1. Wejdź na route `/checkout`.
2. Zweryfikuj widoczność listy pozycji, totalu i sekcji wyboru płatności.
3. Wybierz lub pozostaw metodę płatności `COD`.
4. Użyj akcji `Place Order`.
5. Poczekaj na zakończenie walidacji stocku i requestu `POST /orders/api/orders`.

## Oczekiwany Wynik

- Frontend nie uruchamia flow Razorpay dla wariantu `COD`.
- Backend przyjmuje `CreateOrderRequest` i zwraca `OrderDto`.
- Frontend czyści `sc_cart` i `sc_checkout_draft`.
- Użytkownik trafia na `/orders/{orderId}`.
- Widoczny jest komunikat sukcesu.

## Luki / Do Potwierdzenia

| Obszar | Status | Uwagi |
|---|---|---|
| Test automatyczny Angular/Playwright | `brak w kodzie` | Dokument opisuje przypadek referencyjny, ale nie wskazuje istniejącego testu automatycznego. |
| Idempotency przy retry | `do potwierdzenia` | Ryzyko opisane w `AOS_CHECKOUT.md` wymaga osobnego testu odpornościowego. |
