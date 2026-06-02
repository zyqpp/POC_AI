# Plan Naprawczy Dokumentacji — 2026-06-02

Data: 2026-06-02  
Poprzedni audyt: 2026-06-02 (baseline)  
Autor: Claude Code (Sonnet 4.6) + Kamil Adamczyk

## Stan Wejściowy (z audytu `Invoke-DocumentationAudit.ps1`)

| Obszar | Razem | Kompletne | Luki | Pokrycie % |
|---|---:|---:|---:|---:|
| Ekrany (E-NNN) | 23 | 5 | 18 | 22% |
| Procesy (PROC + E2E) | 8 | 0 | 8 | 0% |
| Handlery MediatR | 87 | 79 | 8 | 91% |
| Walidatory | 36 | 31 | 5 | 86% |

Nieudokumentowane handlery: `SearchProductsQueryHandler`, `ChangePasswordCommandHandler`, `GetInternalUserContactQueryHandler`, `AddOutstandingCommandHandler`, `UpsertInvoiceWorkflowCommandHandler`, `AddInvoiceWorkflowActivityCommandHandler`, `GetDealerInvoiceWorkflowsQueryHandler`, `GetInvoiceWorkflowActivitiesQueryHandler`

## Etap 0 — Infrastruktura (ZREALIZOWANE)

- [x] Przebudowa szablonów ekranów (TPL-UI-001, 003, 004, 005, 011) — dodano narracje, diagramy Mermaid, przykłady HTTP, Given/When/Then
- [x] Nowy skill `documentation-quality-audit` + skrypt `Invoke-DocumentationAudit.ps1`
- [x] Nowy skill `process-documenter`
- [x] Nowy skill `cross-reference-linker`
- [x] Nowy skrypt `Invoke-UpdateDocumentationLinks.ps1`

## Etap 1 — Procesy (P0: 0/8 kompletnych)

### Istniejące PROC do uzupełnienia

Każdy plik wymaga: `## Cel` (2–4 zdania), `## Błędy Procesu` (tabela z akcją kompensującą).

| Plik | Brakujące sekcje | Priorytet |
|---|---|---|
| `PROC-006_PROFILE.md` | `## Cel`, `## Błędy` | P0 |
| `PROC-007_PRODUCTS.md` | `## Cel`, `## Błędy` | P0 |
| `PROC-008_PRODUCTS_NEW.md` | `## Cel` (reszta kompletna) | P0 |
| `PROC-009_PRODUCTS_ID.md` | `## Cel`, `## Błędy` | P0 |
| `PROC-010_PRODUCTS_ID_EDIT.md` | `## Błędy` | P0 |

### Nowe PROC do stworzenia

| Plik | Zakres | Priorytet |
|---|---|---|
| `PROC-001_AUTH.md` | login, register, forgot password, reset password, logout | P0 |
| `PROC-011_CART.md` | dodawanie/usuwanie z koszyka (localStorage), przejście do checkout | P1 |
| `PROC-020_NOTIFICATIONS.md` | wyświetlanie powiadomień, oznaczanie jako przeczytane | P2 |
| `PROC-021_ADMIN_DEALERS.md` | lista dealerów, approval, reject, credit limit | P2 |

## Etap 2 — Ekrany Priorytetowe (P1)

Ekrany do uzupełnienia — wypełnienie sekcji: Cel Ekranu, Kluczowe Pliki Kodu, Główne Wywołania API, Stany Ekranu + pola/akcje z realną treścią.

| Ekran | Route | Priorytet | Uzasadnienie |
|---|---|---|---|
| E-001_LOGIN | `/login` | P0 | entry point, bezpieczeństwo |
| E-002_REGISTER | `/register` | P0 | krytyczny flow, walidacje |
| E-003_FORGOT_PASSWORD | `/forgot-password` | P1 | security flow |
| E-005_DASHBOARD | `/dashboard` | P1 | główny ekran po login |
| E-011_CART | `/cart` | P1 | kluczowy przepływ przed checkout |
| E-013_ORDERS | `/orders` | P2 | lista zamówień |
| E-016_SHIPMENTS | `/shipments` | P2 | lista wysyłek |
| E-020_NOTIFICATIONS | `/notifications` | P2 | powiadomienia |
| E-021_ADMIN_DEALERS | `/admin/dealers` | P2 | panel admin |

## Etap 3 — Powiązania (Po Etapie 1 i 2)

1. Uruchom `Invoke-UpdateDocumentationLinks.ps1` — mechaniczne linki
2. Uruchom skill `cross-reference-linker` — semantyczne uzupełnienia
3. Sprawdź wszystkie `LINKI.md` — uzupełnij `Kluczowe Pliki Kodu` w README

## Etap 4 — Nieudokumentowane Handlery

| Handler | Obszar | Akcja |
|---|---|---|
| `SearchProductsQueryHandler` | Catalog | Dodać wzmiankę w PROC-007 lub API_CATALOG |
| `ChangePasswordCommandHandler` | Identity | Dodać do PROC-006 lub nowego PROC-006b |
| `GetInternalUserContactQueryHandler` | Identity | Sprawdzić czy używany przez UI — ryzyko P1 |
| `AddOutstandingCommandHandler` | Payment | Dodać do dokumentacji płatności |
| `UpsertInvoiceWorkflowCommandHandler` | Payment | Nowy PROC lub rozszerzyć CHECKOUT_E2E |
| `AddInvoiceWorkflowActivityCommandHandler` | Payment | j.w. |
| `GetDealerInvoiceWorkflowsQueryHandler` | Payment | E-018/E-019 lub PROC |
| `GetInvoiceWorkflowActivitiesQueryHandler` | Payment | E-019 szczegół faktury |

## Etap 5 — Kolejny Audyt

Po Etapach 1–3 uruchom:
```powershell
powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\Invoke-DocumentationAudit.ps1
powershell -ExecutionPolicy Bypass -File AI_Agent_scripts\Test-Podejscie2DocumentationQuality.ps1
```

## Cel Docelowy

| Obszar | Stan Docelowy Po Etapie 2 |
|---|---|
| Ekrany | ≥ 40% kompletnych (9–10/23) |
| Procesy | ≥ 62% kompletnych (5/8) |
| Handlery | ≥ 95% |
| Walidatory | ≥ 95% |
