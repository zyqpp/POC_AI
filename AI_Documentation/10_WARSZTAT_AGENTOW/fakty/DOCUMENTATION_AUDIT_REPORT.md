# Raport Audytu Dokumentacji

Wygenerowano: 2026-06-02T21:58:01Z
Git HEAD: `a19a926`
Generator: Invoke-DocumentationAudit.ps1 (audit_v1)

> **Zastrzeżenie:** wyniki są heurystyczne — parser statyczny i wyszukiwanie tekstowe.
> Raport jest materiałem pomocniczym; fakty należy potwierdzić ręcznie w kodzie.

## Podsumowanie Wykonawcze

| Obszar | Razem | Kompletne | Szkielety / Luki | Pokrycie % |
|---|---:|---:|---:|---:|
| Ekrany (E-NNN) | 23 | 23 | 0 | 100% |
| Procesy (PROC + E2E) | 10 | 10 | 10 | 100% |
| Handlery MediatR | 87 | 87 | 0 | 100% |
| Walidatory | 36 | 36 | 0 | 100% |

## Macierz Pokrycia Ekranów

| ID | Katalog | Struktura | Status README | Pola | Akcje | TC | Poziom |
|---|---|---|---|---:|---:|---:|---|
| `E-001` | E-001_LOGIN | tak | wniosek z analizy | 2 | 4 | 5 | **kompletny** |
| `E-002` | E-002_REGISTER | tak | wniosek z analizy | 12 | 2 | 4 | **kompletny** |
| `E-003` | E-003_FORGOT_PASSWORD | tak | wniosek z analizy | 3 | 4 | 0 | **kompletny** |
| `E-004` | E-004_UNAUTHORIZED | tak | wniosek z analizy | 0 | 0 | 0 | **kompletny** |
| `E-005` | E-005_DASHBOARD | tak | wniosek z analizy | 29 | 13 | 0 | **kompletny** |
| `E-006` | E-006_PROFILE | tak | wniosek z analizy | 10 | 2 | 0 | **kompletny** |
| `E-007` | E-007_PRODUCTS | tak | potwierdzone | 12 | 6 | 4 | **kompletny** |
| `E-008` | E-008_PRODUCTS_NEW | tak | potwierdzone | 11 | 3 | 0 | **kompletny** |
| `E-009` | E-009_PRODUCTS_ID | tak | potwierdzone | 21 | 14 | 0 | **kompletny** |
| `E-010` | E-010_PRODUCTS_ID_EDIT | tak | potwierdzone | 11 | 3 | 0 | **kompletny** |
| `E-011` | E-011_CART | tak | wniosek z analizy | 7 | 8 | 3 | **kompletny** |
| `E-012` | E-012_CHECKOUT | tak | potwierdzone | 6 | 2 | 1 | **kompletny** |
| `E-013` | E-013_ORDERS | tak | wniosek z analizy | 21 | 9 | 0 | **kompletny** |
| `E-014` | E-014_ORDERS_ID_TRACKING | tak | wniosek z analizy | 18 | 7 | 0 | **kompletny** |
| `E-015` | E-015_ORDERS_ID | tak | potwierdzone | 18 | 19 | 1 | **kompletny** |
| `E-016` | E-016_SHIPMENTS | tak | wniosek z analizy | 9 | 0 | 0 | **kompletny** |
| `E-017` | E-017_SHIPMENTS_ID | tak | potwierdzone | 32 | 32 | 1 | **kompletny** |
| `E-018` | E-018_INVOICES | tak | wniosek z analizy | 16 | 13 | 0 | **kompletny** |
| `E-019` | E-019_INVOICES_ID | tak | wniosek z analizy | 13 | 8 | 0 | **kompletny** |
| `E-020` | E-020_NOTIFICATIONS | tak | wniosek z analizy | 18 | 15 | 0 | **kompletny** |
| `E-021` | E-021_ADMIN_DEALERS | tak | wniosek z analizy | 8 | 2 | 4 | **kompletny** |
| `E-022` | E-022_ADMIN_AGENTS_CREATE | tak | wniosek z analizy | 4 | 2 | 3 | **kompletny** |
| `E-023` | E-023_ADMIN_DEALERS_ID | tak | wniosek z analizy | 5 | 10 | 0 | **kompletny** |

## Luki Procesów

| Plik | Typ | Cel | Opis/Przepływ | Kroki | Błędy | Ref. Ekranów | Poziom |
|---|---|---|---|---|---|---:|---|
| CHECKOUT_E2E.md | e2e | tak | tak | tak | tak | 6 | **kompletny częściowy** |
| ORDER_DETAIL_LIFECYCLE.md | e2e | tak | tak | tak | tak | 10 | **kompletny częściowy** |
| PROC-001_AUTH.md | proc | tak | tak | tak | tak | 18 | **kompletny częściowy** |
| PROC-006_PROFILE.md | proc | tak | tak | tak | tak | 3 | **kompletny częściowy** |
| PROC-007_PRODUCTS.md | proc | tak | tak | tak | tak | 4 | **kompletny częściowy** |
| PROC-008_PRODUCTS_NEW.md | proc | tak | tak | tak | tak | 12 | **kompletny częściowy** |
| PROC-009_PRODUCTS_ID.md | proc | tak | tak | tak | tak | 13 | **kompletny częściowy** |
| PROC-010_PRODUCTS_ID_EDIT.md | proc | tak | tak | tak | tak | 10 | **kompletny częściowy** |
| PROC-011_CART.md | proc | tak | tak | tak | tak | 14 | **kompletny częściowy** |
| SHIPMENT_DETAIL_LIFECYCLE.md | e2e | tak | tak | tak | tak | 13 | **kompletny częściowy** |

## Jak Używać

1. Sprawdź ekrany oznaczone `szkielet` — użyj skilla `aos-documentation-from-code` do uzupełnienia AOS.
2. Dla procesów z lukami wypełnij brakujące sekcje (Cel, Opis/Przepływ, Kroki, Błędy).
3. Dla nieudokumentowanych handlerów sprawdź, czy są objęte istniejącym PROC lub E2E.
4. Wyniki potwierdź w kodzie przed zmianą statusu faktu na `potwierdzone`.
5. Po uzupełnieniu uruchom `Test-Podejscie2DocumentationQuality.ps1` jako bramkę jakości.
