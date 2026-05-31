# MODEL_DANYCH_PROFILE

Status: `potwierdzone` dla `E-006_PROFILE`.

## IdentityAuth

| Tabela | Kolumna | Typ/konfiguracja EF | Nullability | R/W | Użycie |
|---|---|---|---|---|---|
| `Users` | `UserId` | key `Guid` | `NOT NULL` | `R` | identyfikator profilu i lookup po tokenie |
| `Users` | `Email` | max 256, unique index | `NOT NULL` | `R` | pole email |
| `Users` | `FullName` | max 120 | `NOT NULL` | `R` | nagłówek, avatar initial |
| `Users` | `PhoneNumber` | max 20 | `NOT NULL` | `brak na UI` | nie jest pokazane w profilu |
| `Users` | `Role` | enum string max 32 | `NOT NULL` | `R` | pole roli i warunek sekcji dealer |
| `Users` | `Status` | enum string max 32 | `NOT NULL` | `R` | badge statusu |
| `Users` | `CreditLimit` | precision 18,2 | `NOT NULL` | `R` | widoczne dla dealera |
| `DealerProfiles` | `UserId` | FK do `Users.UserId` | `NOT NULL` | `R` | relacja 1:1 dla dealera |
| `DealerProfiles` | `BusinessName` | max 180 | `NOT NULL` | `R` | nazwa firmy dealera |
| `DealerProfiles` | `GstNumber` | max 20, unique index | `NOT NULL` | `R` | numer GST |
| `DealerProfiles` | `IsInterstate` | bool/bit | `NOT NULL` | `R` | flaga interstate |

## Relacje

| Relacja | Typ | Źródło |
|---|---|---|
| `Users` 1:1 `DealerProfiles` | fizyczny FK `DealerProfiles.UserId` -> `Users.UserId`, cascade delete | `IdentityAuthDbContext.OnModelCreating` |

## Luki

| ID | Luka | Status |
|---|---|---|
| `GAP-DATA-006-001` | `PhoneNumber` istnieje w encji i bazie, ale ekran profilu go nie pokazuje. | `potwierdzone` |
