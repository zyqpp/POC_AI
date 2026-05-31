# ERR-010-0010 Image URL Invalid

Status: `potwierdzone`.

| Atrybut | Wartość |
|---|---|
| Pole | [P-010-0008](../P-010_POLA/P-010-0008__imageurl.md) |
| Komunikat UI | `Image URL must be valid and max 500 chars` |
| Warunek UI | wartość niepusta nie pasuje do HTTP/HTTPS albo przekracza 500 znaków |
| Backend | absolutny URL HTTP/HTTPS gdy podany, max 500 |
| DB | brak zapisu `Products.ImageUrl` przy błędzie |
| Dane testowe | [TD-010-0008](../TD-010_DANE_TESTOWE/TD-010-0008__imageurl.md) |
