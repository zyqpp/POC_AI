# P-022-0003 phoneNumber

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID pola | `P-022-0003` |
| Ekran | [E-022](../E-022__README.md) |
| Nazwa wykryta | `phoneNumber` |
| Typ detekcji | `[(ngModel)]` |
| Źródło | `supply-chain-frontend/src/app/features/admin/agent-create/agent-create.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Pola

Numer telefonu komórkowego agenta. Format: 10-cyfrowy indyjski numer mobilny (pierwsza cyfra 6-9). Frontend normalizuje numer: akceptuje `9182683257`, `09182683257`, `919182683257` — wszystkie konwertowane do `9182683257`. Backend waliduje pattern `^[6-9][0-9]{9}$`.

## Wymagalność I Walidacje

| Właściwość | Wartość | Źródło |
|---|---|---|
| Wymagane | tak — `!this.phoneNumber.trim()` → błąd "All fields are required." | `potwierdzone` |
| Typ UI | `input[type=tel]` z `[(ngModel)]="phoneNumber"` | `wniosek z analizy` |
| Reguły walidacji (frontend) | `normalizeIndianMobile()` — akceptuje format z 0, 91, lub czysty 10-cyfrowy | `potwierdzone` |
| Reguły walidacji (backend) | `NotEmpty().Matches("^[6-9][0-9]{9}$")` — `CreateAgentRequestValidator` | `potwierdzone` |
| Komunikaty błędów | [ERR-022](../ERR-022_BLEDY/ERR-022__INDEX.md) | "Phone number must be a valid Indian mobile number (example: 9182683257)." |

## Mapowanie Danych

| Warstwa | Artefakt | Status |
|---|---|---|
| Frontend model/form | `AgentCreateComponent.phoneNumber: string` (surowy input) | `wniosek z analizy` |
| Serwis API | `AdminApiService.createAgent({phoneNumber: normalizedPhoneNumber})` | `wniosek z analizy` |
| Endpoint | `POST /identity/api/admin/users/agents` | `wniosek z analizy` |
| DTO/kontrakt | `CreateAgentRequest.phoneNumber` | `wniosek z analizy` |
| Encja/model | `User.PhoneNumber` (szacowane) | `wniosek z analizy` |
| DbContext | `do uzupełnienia` | `do uzupełnienia` |
| Schemat SQL | `do uzupełnienia` | `do uzupełnienia` |
| Tabela SQL | `Users` (szacowane) | `wniosek z analizy` |
| Kolumna SQL | `PhoneNumber` (szacowane) | `wniosek z analizy` |
| Odczyt/zapis | zapis (POST) | `wniosek z analizy` |

## Dane Do Testów

- [TD dla pola](../TD-022_DANE_TESTOWE/TD-022-0003__phonenumber.md)
- Zakres danych poprawnych: do uzupełnienia.
- Zakres danych błędnych: do uzupełnienia.

## Linki

- [Indeks pól](P-022__INDEX.md)
- [Akcje ekranu](../A-022_AKCJE/A-022__INDEX.md)
- [Ślad ekranu](../E-022__LINKI.md)
