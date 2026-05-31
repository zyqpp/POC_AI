# 05 UI AOS

## Dokumenty

- [E-000 Indeks Ekranów](EKRANY/E-000__INDEKS_EKRANOW.md) - zagnieżdżony katalog ekranów wygenerowany z routingu Angular.
- `EKRANY/E-.../E-...__README.md` - opis konkretnego ekranu.
- `EKRANY/E-.../P-..._POLA/` - atomowe dokumenty pól UI.
- `EKRANY/E-.../A-..._AKCJE/` - atomowe dokumenty akcji UI.
- `EKRANY/E-.../ERR-..._BLEDY/` - atomowe dokumenty błędów i komunikatów.
- `EKRANY/E-.../TD-..._DANE_TESTOWE/` - dane do testów automatycznych per pole.
- `EKRANY/E-.../TC-..._TESTY/` - przypadki testowe ekranu.
- `MAPA_EKRANOW.md` - dotychczasowa mapa route'ów Angular, komponentów, ról i powiązanych API.
- `AOS_CHECKOUT.md`, `AOS_ORDER_DETAIL.md`, `AOS_SHIPMENT_DETAIL.md` - starsze agregaty referencyjne z pierwszych pionów; nie zastępują dokumentów atomowych.

## Zasada

Docelowy opis ekranu jest rozdrobniony i linkowalny. Każde pole, akcja i błąd mają osobny identyfikator oraz osobny plik. Brakujące mapowanie do API, procesu, bazy i testów oznacza się jawnie jako `do uzupełnienia`, a nie pomija.
