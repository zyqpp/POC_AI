# Publikacja dokumentacji MkDocs

## Ważne

`mkdocs serve` służy tylko do lokalnego podglądu developerskiego. Nie należy używać go jako produkcyjnego serwera dostępnego w internecie.

Do publikacji należy użyć:

```powershell
python -m mkdocs build -f mkdocs-tech.yml
python -m mkdocs build -f mkdocs-user.yml
```

Wynikiem są katalogi:

```text
site-tech/
site-user/
```

Te katalogi zawierają statyczne pliki HTML/CSS/JS, które można opublikować na hostingu statycznym.

## Opcje publikacji

### Opcja 1: GitHub Pages

Można skonfigurować GitHub Actions, które:

1. instalują `requirements-docs.txt`,
2. budują `site-tech/` i `site-user/`,
3. publikują wynik jako GitHub Pages.

Wariant dla dwóch portali:

- `/tech/` dla dokumentacji technicznej,
- `/user/` dla dokumentacji użytkownika.

### Opcja 2: serwer firmowy / intranet

Można zbudować dokumentację lokalnie lub w CI/CD i skopiować zawartość:

- `site-tech/` do katalogu serwera www `/docs/tech/`,
- `site-user/` do katalogu serwera www `/docs/user/`.

### Opcja 3: hosting statyczny

Można opublikować wygenerowane katalogi na dowolnym hostingu statycznym obsługującym HTML/CSS/JS.

## Rekomendacja

Na start:

1. uruchamiać lokalnie przez `mkdocs serve`,
2. budować przez `mkdocs build`,
3. publikację w sieci zrobić dopiero po akceptacji struktury menu i wyglądu.
