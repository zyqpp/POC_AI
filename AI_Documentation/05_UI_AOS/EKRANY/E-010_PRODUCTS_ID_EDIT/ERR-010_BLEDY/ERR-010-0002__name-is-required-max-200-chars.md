# ERR-010-0002 Name Required Or Too Long

Status: `potwierdzone`.

| Atrybut | Wartość |
|---|---|
| Pole | [P-010-0002](../P-010_POLA/P-010-0002__name.md) |
| Komunikat UI | `Name is required (max 200 chars)` |
| Warunek UI | puste `name` albo naruszenie max 200 po touched |
| Backend | `UpdateProductRequestValidator` wymaga `Name` i max 200 |
| Status HTTP | zależny od pipeline walidacji, do potwierdzenia integracyjnie |
| DB | brak zapisu `Products.Name` przy błędzie |
| Dane testowe | [TD-010-0002](../TD-010_DANE_TESTOWE/TD-010-0002__name.md) |
