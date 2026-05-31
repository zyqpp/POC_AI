# TD-008-0008 Dane Testowe Dla URL Obrazu

Status: `potwierdzone`.

| Typ | Wartość | Oczekiwany rezultat |
|---|---|---|
| puste | pusty string | wysłane jako `undefined`, zapis `Products.ImageUrl=NULL` |
| poprawne HTTPS | `https://cdn.example.test/products/pump-x100.png` | zapis do `Products.ImageUrl` |
| poprawne HTTP | `http://cdn.example.test/products/pump-x100.png` | backend dopuszcza |
| zły schemat | `ftp://example.test/file.png` | [ERR-008-0010](../ERR-008_BLEDY/ERR-008-0010__image-url-must-be-valid-and-max-500-chars.md) |
| za długie | 501 znaków | [ERR-008-0010](../ERR-008_BLEDY/ERR-008-0010__image-url-must-be-valid-and-max-500-chars.md) |

Powiązane testy: `TC-008-0001`, `TC-008-0002`.
