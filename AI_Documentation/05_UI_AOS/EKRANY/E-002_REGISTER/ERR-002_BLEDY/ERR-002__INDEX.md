# ERR-002 Błędy I Komunikaty

Status: `szkielet`; indeks kandydatów wykrytych automatycznie z template i komponentu.

| ID błędu | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `ERR-002-0001` | errorMsg( | angular-if-error-view | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0001__errormsg.md](ERR-002-0001__errormsg.md) |
| `ERR-002-0002` | Full name is required | error-css-class | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0002__full-name-is-required.md](ERR-002-0002__full-name-is-required.md) |
| `ERR-002-0003` | Valid email is required | error-css-class | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0003__valid-email-is-required.md](ERR-002-0003__valid-email-is-required.md) |
| `ERR-002-0004` | Min 8 chars, uppercase, lowercase, number, special char | error-css-class | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0004__min-8-chars-uppercase-lowercase-number-special-char.md](ERR-002-0004__min-8-chars-uppercase-lowercase-number-special-char.md) |
| `ERR-002-0005` | Valid 10-digit Indian mobile number required (starts with 6-9) | error-css-class | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0005__valid-10-digit-indian-mobile-number-required-starts-with-6-9.md](ERR-002-0005__valid-10-digit-indian-mobile-number-required-starts-with-6-9.md) |
| `ERR-002-0006` | Business name is required | error-css-class | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0006__business-name-is-required.md](ERR-002-0006__business-name-is-required.md) |
| `ERR-002-0007` | Valid GST required (example: 29ABCDE1234F1Z5) | error-css-class | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0007__valid-gst-required-example-29abcde1234f1z5.md](ERR-002-0007__valid-gst-required-example-29abcde1234f1z5.md) |
| `ERR-002-0008` | Required | error-css-class | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0008__required.md](ERR-002-0008__required.md) |
| `ERR-002-0009` | 6-digit PIN code required | error-css-class | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0009__6-digit-pin-code-required.md](ERR-002-0009__6-digit-pin-code-required.md) |
| `ERR-002-0010` | Address is required | error-css-class | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0010__address-is-required.md](ERR-002-0010__address-is-required.md) |
| `ERR-002-0011` | errorMsg() | error-css-class | `supply-chain-frontend/src/app/features/auth/register/register.component.html` | [ERR-002-0011__errormsg.md](ERR-002-0011__errormsg.md) |

## Reguła Uzupełniania

Każdy błąd musi docelowo wskazywać warunek wystąpienia, powiązane pole albo akcję, komunikat użytkownika, źródło techniczne i dane do testu negatywnego.
