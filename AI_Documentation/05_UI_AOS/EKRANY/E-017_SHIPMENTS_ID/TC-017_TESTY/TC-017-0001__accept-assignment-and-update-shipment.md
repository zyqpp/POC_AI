# TC-017-0001 Akceptacja Przypisania I Aktualizacja Shipmentu

Status: `potwierdzone` jako referencyjny przypadek testowy dla aktywnego pionu `/shipments/:id`.

## Cel

Potwierdzić, że przypisany agent może zaakceptować assignment, a następnie zmienić status shipmentu zgodnie z warunkami backendu.

## Powiązane Artefakty

| Typ | Link |
|---|---|
| Ekran | [E-017](../E-017__README.md) |
| AOS | [AOS Shipment Detail](../../../AOS_SHIPMENT_DETAIL.md) |
| Akcje | [A-017-0001 acceptassignment](../A-017_AKCJE/A-017-0001__acceptassignment.md), [A-017-0025 updatestatus](../A-017_AKCJE/A-017-0025__updatestatus.md) |
| Błąd referencyjny | [ERR-017-0024](../ERR-017_BLEDY/ERR-017-0024__this-geterrormessage-err-failed-to-update-shipment-status.md) |
| Proces | [SHIPMENT_DETAIL_LIFECYCLE](../../../../06_PROCESY/SHIPMENT_DETAIL_LIFECYCLE.md) |
| API | [API_SHIPMENT_DETAIL](../../../../04_API/API_SHIPMENT_DETAIL.md) |

## Preconditions

- Użytkownik jest zalogowany jako `Agent`.
- Shipment ma `AssignedAgentId` zgodny z użytkownikiem i `AssignmentDecisionStatus = Pending`.
- Shipment ma przypisany pojazd przed przejściem do statusów operacyjnych wymagających pojazdu.

## Kroki

1. Wejdź na route `/shipments/:id`.
2. Uruchom akcję `Accept Assignment`.
3. Zweryfikuj odświeżenie danych shipmentu po sukcesie.
4. Otwórz akcję zmiany statusu i ustaw status zgodny z dopuszczalnym przejściem.
5. Zatwierdź zmianę i odśwież widok.

## Oczekiwany Wynik

- Frontend wysyła `PUT /logistics/api/logistics/shipments/{id}/assignment/accept`.
- Backend zapisuje decyzję assignment i odpowiedni event logistyczny.
- Frontend pozwala na zmianę statusu dopiero po zaakceptowanym assignment.
- `PUT /logistics/api/logistics/shipments/{id}/status` kończy się sukcesem dla dozwolonego przejścia.
- Widok pokazuje nowy status shipmentu oraz zaktualizowaną oś zdarzeń.

## Luki / Do Potwierdzenia

| Obszar | Status | Uwagi |
|---|---|---|
| Test automatyczny API auth/data scope | `brak w kodzie` | Dokumentacja wskazuje scenariusz, ale brak potwierdzonego testu integracyjnego dla ról i maskowania `404`. |
| Chatbot i ops-state | `do potwierdzenia` | To osobne gałęzie procesu; nie są objęte tym minimalnym przypadkiem referencyjnym. |
