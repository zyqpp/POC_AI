# P-001-0002 password

Status: `wniosek z analizy`; wymagane ręczne uzupełnienie po analizie UI, API i bazy.

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-001-0002` |
| Ekran | [E-001](../E-001__README.md) |
| Nazwa wykryta | `password` |
| Typ detekcji | `formControlName` |
| Źródło | `supply-chain-frontend/src/app/features/auth/login/login.component.html` |
| Status faktu | `do uzupełnienia` |

## Opis Pola

**Co zbiera:** hasło użytkownika. **Źródło danych:** formularz reaktywny Angular → `LoginRequest.Password` → weryfikacja BCrypt hash z kolumny `Users.PasswordHash` w backendzie. **Kiedy widoczne:** zawsze. **Format:** tekst (maskowany — `type="password"`); toggle podglądu hasła przez akcję `showPwd.update` (sygnał `showPwd`). Walidator: `Validators.required` (brak walidacji siły — to rola backendu). **Tryb:** tylko zapis — hasło nigdy nie jest odczytywane z bazy na frontend.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak | `Validators.required` w `login.component.ts` |
| Typ UI | `input[type=password]` / `formControlName="password"` (toggle showPwd zmienia type) | `supply-chain-frontend/src/app/features/auth/login/login.component.html` |
| Reguły walidacji | required (brak walidacji siły po stronie frontendu przy logowaniu) | `Validators.required` w `login.component.ts` |
| Komunikaty błędów | [ERR-001](../ERR-001_BLEDY/ERR-001__INDEX.md) | do uzupełnienia |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `form.controls.password` (ReactiveForm) | `potwierdzone` |
| Serwis API | `AuthApiService.login({email, password})` | `potwierdzone` |
| Endpoint | `POST /identity/api/auth/login` | `potwierdzone` |
| DTO/kontrakt | `LoginRequest.Password` (string, plaintext w HTTPS) | `wniosek z analizy` |
| Encja/model | `User.PasswordHash` (BCrypt) | `wniosek z analizy` |
| DbContext | `IdentityAuthDbContext` | `wniosek z analizy` |
| Schemat SQL | `dbo` | `do uzupełnienia` |
| Tabela SQL | `Users` | `wniosek z analizy` |
| Kolumna SQL | `PasswordHash` | `wniosek z analizy` |
| Odczyt/zapis | tylko porównanie hash — hasło nie jest przechowywane w plain text | `potwierdzone` |

## Dane Do Testów

- [TD dla pola](../TD-001_DANE_TESTOWE/TD-001-0002__password.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-001__INDEX.md)
- [Akcje ekranu](../A-001_AKCJE/A-001__INDEX.md)
- [Ślad ekranu](../E-001__LINKI.md)
