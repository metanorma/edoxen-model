# 05 — TC184 audit

## Repo

`isotc184sc4/resolutions` at `/Users/mulgogi/src/isotc184sc4/resolutions`.

Branch: `main` (with some untracked debug files at audit time).

Single repo containing both the data and the browser.

## Data inventory

| Directory | Files | Description |
|-----------|-------|-------------|
| `plenary/` | 86 (`plenary-YYYY-MM-location.yaml`) | Plenary meeting resolutions from 1984 to 2025 |

Total: **86 YAML files**.

## Current shape (pre-v2, edoxen 0.7.x)

Identical to TC154 (same Edoxen v0.7.x toolchain). See
[01-tc154-audit.md](01-tc154-audit.md) for the full breakdown.

Key differences from TC154:

- File names include location (e.g.
  `plenary-1984-07-gaithersburg-washington-dc-usa.yaml`).
- Identifier prefix is `ISO/TC 184/SC 4` (not `ISO/TC 154`).
- No `ballots/` or `7372ma/` directories — just plenary.
- Browser is in-repo (`browser/`).

## GHA

- `validate.yml` — same shape as TC154's. Runs `edoxen validate` on
  every push/PR.
- `deploy-pages.yml` — builds the Vue browser and deploys to GitHub
  Pages.

Both pin to whatever edoxen version is on RubyGems (currently 0.7.x).

## Browser

In-repo `browser/` — Vue + Vite. Renders the YAML data into a
meetings index, resolution detail pages, etc.

Same adapter pattern as TC154's site: components consume a flat
view, the adapter projects the wire shape into it.

## Migration impact

Same as TC154. Migration script is shared; only the `--prefix` and
`--data-dir` flags differ.

## Acceptance criteria for TODO 06

Same as TODO 02 (TC154), with 86 fixtures instead of 41.
