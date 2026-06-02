# MACIERZ_TESTOW_IDENTITY

Status: `potwierdzone` jako wymagania testowe dla `E-001_LOGIN`, `E-002_REGISTER`, `E-003_FORGOT_PASSWORD`, `E-004_UNAUTHORIZED`, `E-006_PROFILE`.

## Testy Istniejące

| Test | Plik | Pokrycie | Luka |
|---|---|---|---|
| `CreateDealer_SetsDealerRolePendingStatusAndProfile` | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | domena: tworzenie dealera z rolą, statusem Pending i profilem | brak API, JWT, walidatorów, blokady loginowania Pending |
| `ApproveDealer_ActivatesUserAndClearsRejectionReason` | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | domena: approve dealera, zmiana statusu na Active | brak integracji z serwisem aplikacji |
| `RejectDealer_SetsRejectedStatusAndTrimmedReason` | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | domena: reject dealera, trimowanie powodu | brak integracji |
| `UpdateCreditLimit_StoresNewValue` | `tests/IdentityAuth.Domain.Tests/UnitTest1.cs` | domena: zmiana limitu kredytowego | brak integracji z PaymentInvoice |

## Scenariusze do Przetestowania

| ID | Scenariusz | Typ testu | Dane | Obecny status | Kryterium zamknięcia |
|---|---|---|---|---|---|
| `TC-IDENTITY-0001` | Dealer rejestruje się i otrzymuje status `Pending`. | API integration | `{email, password, businessName, gstin, ...}` | `brak w kodzie` | `201`, `UserStatus.Pending` w DB, brak możliwości logowania. |
| `TC-IDENTITY-0002` | Dealer ze statusem `Pending` próbuje się zalogować — blokada. | API integration | konto Pending | `brak w kodzie` | Odpowiedź `401` lub `403` z czytelnym komunikatem, brak JWT. |
| `TC-IDENTITY-0003` | Dealer ze statusem `Rejected` próbuje się zalogować — blokada. | API integration | konto Rejected | `brak w kodzie` | Odpowiedź `401`/`403`, brak JWT. |
| `TC-IDENTITY-0004` | Aktywny Dealer loguje się i otrzymuje JWT z rolą `Dealer`. | API integration | konto Active | `brak w kodzie` | `200`, JWT zawiera `role=Dealer`, cookie `refreshToken` ustawiony. |
| `TC-IDENTITY-0005` | JWT zawiera poprawne claimy (sub, email, role, jti, exp). | unit — JWT generation | aktywny użytkownik | `brak w kodzie` | Token dekodalny, claimy zgodne z encją User. |
| `TC-IDENTITY-0006` | Refresh token rotuje — stary jest unieważniony, nowy jest wydany. | API integration | aktywna sesja + cookie refreshToken | `brak w kodzie` | `200` nowy JWT, stary refresh token nieaktualny w DB, nowe cookie. |
| `TC-IDENTITY-0007` | Refresh z unieważnionym tokenem zwraca `401`. | API integration | unieważniony refresh token | `brak w kodzie` | `401`, brak nowego JWT. |
| `TC-IDENTITY-0008` | Forgot-password wysyła OTP dla istniejącego konta; zwraca identyczną odpowiedź dla nieistniejącego (brak enumeracji). | API integration | istniejący i nieistniejący email | `brak w kodzie` | `200` dla obu przypadków z tym samym komunikatem. |
| `TC-IDENTITY-0009` | Reset-password z poprawnym OTP zmienia hasło. | API integration | poprawny OTP | `brak w kodzie` | `200`, nowe hasło działa do logowania, OTP unieważniony. |
| `TC-IDENTITY-0010` | Reset-password z wygasłym OTP zwraca błąd. | API integration | wygasły OTP | `brak w kodzie` | `400`/`422`, hasło bez zmiany. |
| `TC-IDENTITY-0011` | Zalogowany użytkownik pobiera własny profil. | API integration | JWT z sub | `brak w kodzie` | `200`, profil odpowiada encji User z DB. |
| `TC-IDENTITY-0012` | Profil Dealera zawiera sekcję `DealerProfile` (businessName, gstin, adres). | API integration | konto Dealer Active | `brak w kodzie` | `200`, `dealerProfile` nie jest null. |
| `TC-IDENTITY-0013` | Profil non-Dealer (Admin, Warehouse) nie zawiera `DealerProfile`. | API integration | konto Admin | `brak w kodzie` | `200`, `dealerProfile` jest null. |
| `TC-IDENTITY-0014` | Użytkownik bez tokena pobiera profil — `401`. | API | brak nagłówka Authorization | `brak w kodzie` | `401`. |
| `TC-IDENTITY-0015` | Zmiana hasła wymaga poprawnego starego hasła. | API integration | zalogowany użytkownik | `brak w kodzie` | `200` z poprawnym; `400` z błędnym starym hasłem. |
| `TC-IDENTITY-0016` | Rola inna niż Dealer nie może rejestrować się przez `/register`. | API | próba rejestracji z `role=Admin` w body | `brak w kodzie` | Backend ignoruje podaną rolę lub zwraca błąd, zawsze tworzy Dealer. |

## Luki Testowe

| Luka | Opis | Priorytet |
|---|---|---|
| Blokada Pending login | Brak testu integracyjnego potwierdzającego, że Dealer ze statusem `Pending` nie może się zalogować. Jest to krytyczna kontrola biznesowa. | KRYTYCZNY |
| JWT generation | Brak testu jednostkowego dla `JwtTokenService` lub odpowiednika — sprawdzenie claimów (sub, role, jti, exp) jest wymagane. | WYSOKI |
| Refresh token rotation | Brak testu API weryfikującego rotację refresh tokena i unieważnianie starego. | WYSOKI |
| OTP flow | Brak testu dla forgot-password i reset-password przez OTP — kompletny flow jest nieprzetestowany. | WYSOKI |
| Enumeracja kont | Brak testu sprawdzającego, że forgot-password zwraca identyczną odpowiedź niezależnie od tego, czy konto istnieje. | SREDNI |
| Role w JWT | Brak weryfikacji że claim `role` w JWT jest poprawnie ustawiany dla każdej roli (Admin, Dealer, Warehouse, Logistics, Agent). | WYSOKI |
