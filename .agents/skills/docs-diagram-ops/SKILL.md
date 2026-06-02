# Skill: docs-diagram-ops

Use this skill when Mermaid or PlantUML diagrams in MkDocs are displayed as plain text/code blocks instead of rendered diagrams.

## Responsibilities

- Verify MkDocs diagram configuration (`mkdocs-tech.yml`) for Mermaid and PlantUML.
- Verify documentation dependencies in `requirements-docs.txt`.
- Detect diagram blocks in Markdown:
  - fenced `mermaid`
  - fenced `plantuml` / `puml` / `uml`
  - `::uml::` blocks
- Build documentation and validate render output in generated HTML.
- Report exact files with non-rendered diagrams.
- Propose minimal fixes before touching documentation content.

## Required configuration checks

Mermaid:

```yaml
markdown_extensions:
  - pymdownx.superfences:
      custom_fences:
        - name: mermaid
          class: mermaid
          format: !!python/name:pymdownx.superfences.fence_code_format
```

PlantUML:

```yaml
markdown_extensions:
  - plantuml_markdown:
      format: svg
```

Dependencies:

```txt
mkdocs-material==9.*
plantuml-markdown>=3.11,<4
```

## Preferred commands

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\docs-install.ps1
python -m mkdocs build -f mkdocs-tech.yml
powershell -ExecutionPolicy Bypass -File .\AI_Agent_scripts\Test-DocsDiagramRendering.ps1 -ConfigFile mkdocs-tech.yml
```

## Output

Report:

- detected diagram blocks and locations,
- whether Mermaid render is active,
- whether PlantUML extension is active,
- list of pages still showing diagram source as text,
- exact remediation steps.

## Safety rules

- Do not rewrite business documentation content unless explicitly requested.
- Prefer config/dependency fixes and targeted lint-like changes.
- For PlantUML rendering, note runtime requirements (local PlantUML binary or remote server) when relevant.
