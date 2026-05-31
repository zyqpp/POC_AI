# TD-008-0007 Dane Testowe Dla Opisu

Status: `potwierdzone`.

| Typ | Wartość | Oczekiwany rezultat |
|---|---|---|
| poprawne typowe | `Industrial pump for automated warehouse flow.` | zapis do `Products.Description` |
| graniczne | 2000 znaków | walidacja przechodzi |
| puste | pusty string | [ERR-008-0009](../ERR-008_BLEDY/ERR-008-0009__description-is-required-max-2000-chars.md) |
| za długie | 2001 znaków | [ERR-008-0009](../ERR-008_BLEDY/ERR-008-0009__description-is-required-max-2000-chars.md) |

Powiązane testy: `TC-008-0001`, `TC-008-0002`.
