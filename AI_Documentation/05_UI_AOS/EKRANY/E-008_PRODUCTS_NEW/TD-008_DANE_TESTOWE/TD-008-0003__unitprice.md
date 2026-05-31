# TD-008-0003 Dane Testowe Dla Ceny

Status: `potwierdzone`.

| Typ | Wartość | Oczekiwany rezultat |
|---|---|---|
| poprawne minimalne UI | `0.01` | walidacja UI przechodzi |
| poprawne typowe | `1299.99` | zapis do `Products.UnitPrice` |
| backend minimalny | `0.0001` | backend przechodzi jako większe od `0`, precision DB zaokrągla według provider SQL |
| zero | `0` | [ERR-008-0003](../ERR-008_BLEDY/ERR-008-0003__positive-price-required.md) |
| ujemne | `-1` | [ERR-008-0003](../ERR-008_BLEDY/ERR-008-0003__positive-price-required.md) |

Powiązane testy: `TC-008-0001`, `TC-008-0002`.
