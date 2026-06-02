# A-021-0002 navigate [

Status: `wniosek z analizy`

## Identyfikacja

| Atrybut | Wartość |
|---|---|
| ID akcji | `A-021-0002` |
| Ekran | [E-021](../E-021__README.md) |
| Nazwa wykryta | `navigate [` |
| Typ detekcji | `bound-routerLink` |
| Źródło | `supply-chain-frontend/src/app/features/admin/dealer-list/dealer-list.component.html` |
| Status faktu | `wniosek z analizy` |

## Opis Akcji

Nawigacja do szczegółu dealera. Kliknięcie w wiersz tabeli listy dealerów przenosi admina do ekranu [E-023_ADMIN_DEALERS_ID](/admin/dealers/:id), gdzie dostępne są pełne dane dealera i akcje approve/reject/update-credit-limit.

## Ślad Techniczny

| Warstwa | Artefakt | Status |
|---|---|---|
| Element UI | `<tr [routerLink]="['/admin/dealers', d.dealerId]">` (szacowane, wzorzec jak w E-018) | `wniosek z analizy` |
| Metoda komponentu | brak (routerLink deklaratywny) | `wniosek z analizy` |
| Serwis frontend | Angular Router | `wniosek z analizy` |
| Endpoint API | brak — nawigacja kliencka | `brak w kodzie` |
| Komenda/zapytanie | brak | `brak w kodzie` |
| Walidacje | brak | `brak w kodzie` |
| Skutek w bazie | brak | `brak w kodzie` |

## Testy

- [Macierz testów ekranu](../TC-021_TESTY/TC-021__INDEX.md)
- Dane wejściowe: `d.dealerId` (GUID).
- Oczekiwany rezultat: URL zmienia się na `/admin/dealers/{dealerId}`, renderowany jest E-023.

## Linki

- [Indeks akcji](A-021__INDEX.md)
- [Pola ekranu](../P-021_POLA/P-021__INDEX.md)
- [Ślad ekranu](../E-021__LINKI.md)
