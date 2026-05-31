# P-003 Pola UI

Status: `szkielet`; indeks pól wykrytych automatycznie z komponentu i template Angular.

| ID pola | Nazwa | Typ detekcji | Źródło | Dokument |
|---|---|---|---|---|
| `P-003-0001` | email | formControlName | `supply-chain-frontend/src/app/features/auth/forgot-password/forgot-password.component.html` | [P-003-0001__email.md](P-003-0001__email.md) |
| `P-003-0002` | otpCode | formControlName | `supply-chain-frontend/src/app/features/auth/forgot-password/forgot-password.component.html` | [P-003-0002__otpcode.md](P-003-0002__otpcode.md) |
| `P-003-0003` | newPassword | formControlName | `supply-chain-frontend/src/app/features/auth/forgot-password/forgot-password.component.html` | [P-003-0003__newpassword.md](P-003-0003__newpassword.md) |

## Reguła Uzupełniania

Każdy dokument pola musi docelowo wskazywać wymagalność, walidacje, źródło danych, DTO/API, encję, tabelę SQL, kolumnę SQL, odczyt/zapis oraz dane do testów automatycznych.
