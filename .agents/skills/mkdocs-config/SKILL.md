# Skill: mkdocs-config

Use this skill when creating or updating MkDocs configuration files.

## Responsibilities

- Create or update `mkdocs-tech.yml`.
- Create or update `mkdocs-user.yml`.
- Set correct `docs_dir` for each documentation area.
- Set separate `site_dir` values:
  - `site-tech`
  - `site-user`
- Build navigation from existing Markdown files.
- Do not invent files that do not exist unless a minimal `index.md` is absolutely required.
- Do not move existing documentation unless explicitly approved.

## Required Material theme settings

Use:

```yaml
theme:
  name: material
  language: pl
```

## Required plugins

Use at minimum:

```yaml
plugins:
  - search
```

## Required Markdown extensions

Use at minimum:

```yaml
markdown_extensions:
  - admonition
  - attr_list
  - md_in_html
  - tables
  - toc:
      permalink: true
  - pymdownx.details
  - pymdownx.superfences
```

## Output

Report:

- detected technical docs directory,
- detected user docs directory,
- created/updated yml files,
- resulting navigation,
- unresolved files or navigation warnings.
