# TD-010-0008 Image URL

| Atrybut | Wartość |
|---|---|
| Pole | [P-010-0008](../P-010_POLA/P-010-0008__imageurl.md) |
| Poprawne | pusty string, `https://cdn.example.test/pump.png` |
| Graniczne | 500 znaków |
| Błędne | `ftp://cdn.example.test/pump.png`, 501 znaków |
| Oczekiwane | pusty string zapisuje `null`; poprawny URL zapisuje `Products.ImageUrl`; błędny blokuje submit lub API |
| Status testu | `brak w kodzie` |
