# TD-008-0004 Dane Testowe Dla Minimalnej Ilości

Status: `potwierdzone`.

| Typ | Wartość | Oczekiwany rezultat |
|---|---|---|
| poprawne minimalne | `1` | zapis do `Products.MinOrderQty` |
| poprawne typowe | `24` | zapis do `Products.MinOrderQty` |
| zero | `0` | [ERR-008-0004](../ERR-008_BLEDY/ERR-008-0004__positive-integer-required.md) |
| ujemne | `-1` | [ERR-008-0004](../ERR-008_BLEDY/ERR-008-0004__positive-integer-required.md) |

Powiązane testy: `TC-008-0001`, `TC-008-0002`.
