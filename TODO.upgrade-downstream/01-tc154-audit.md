# 01 — TC154 audit

## Repo

`isotc154/resolutions-data` at `/Users/mulgogi/src/isotc154/resolutions-data`.

Branch: `main` (clean at audit time).

Rendered by the **separate** repo `isotc154/www.isotc154.org` (Vue +
Jekyll hybrid; consumes the data via git submodule under
`_data/resolutions/`).

## Data inventory

| Directory | Files | Description |
|-----------|-------|-------------|
| `plenary/` | 37 (`plenary-10.yaml` through `plenary-46.yaml`) | Plenary meeting resolutions |
| `ballots/` | 3 (`ballots-2023.yaml`, `ballots-2024.yaml`, `ballots-2025.yaml`) | Committee internal ballots |
| `7372ma/` | 1 (`7372ma-20020904.yaml`) | ISO 7372 maintenance agreement resolutions |

Total: **41 YAML files**.

## Current shape (pre-v2, edoxen 0.7.x)

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/metanorma/edoxen/refs/heads/main/schema/edoxen.yaml
---
metadata:
  title: Resolutions adopted at the meeting of ISO/TC 154 in Cologne
  dates:
  - start: '1995-08-31'
    end: '1995-09-01'
    kind: meeting
  source: ISO/TC 154 Secretariat
resolutions:
- dates:
  - start: '1995-08-31'
    end: '1995-09-01'
    kind: decision
  subject: ISO/TC 154 "Documents and Data Elements..."
  identifier: '88'
  approvals:
  - type: affirmative
    degree: unanimous
    message: UNANIMOUS
  actions:
  - type: scopes
    message: |
      The current scope of ISO/TC is...
    dates:
    - start: '1995-08-31'
      end: '1995-09-01'
      kind: effective
```

Key shape points:

- **Root**: `metadata` + `resolutions:` (not `decisions:`).
- **Identifier**: bare string (`'88'`, `'2023-PWI'`), not a
  StructuredIdentifier list.
- **Dates**: `{start, end, kind}` triples. Kinds seen in the data:
  `meeting`, `decision`, `effective`, `ballot`.
- **Per-language content** (`subject`, `title`, `considerations`,
  `approvals`, `actions`) is **flattened on the resolution** —
  not wrapped in `localizations[]`.
- **No `kind`/`status`** on the resolution (these are v2 concepts).
- **Schema URL**: pinned to `metanorma/edoxen` main, which now
  serves the v2.1 schema — so the existing data is already
  schema-invalid against the live schema.

## GHA

`.github/workflows/validate.yml` runs on push + PR + dispatch. Steps:

1. Checkout.
2. `ruby/setup-ruby@v1` with `bundler-cache: true` (pulls latest
   `edoxen` from RubyGems).
3. `bundle exec edoxen validate "{plenary,ballots,7372ma}/*.yaml"`.

Currently this passes against edoxen 0.7.x but **fails against v2.x**
because the wire shape diverged. The migration must land before this
PR merges; otherwise main is broken.

## Rendering (separate repo)

`isotc154/www.isotc154.org` consumes the data via:

- `_data/resolutions/` (git submodule pointing at
  `isotc154/resolutions-data`).
- Vue components in `src/` read the data through `src/data/` and
  `src/domain/` adapters.
- Type definitions in `src/types/`.

Browser update lives in TODO 04.

## Migration impact

- **No data loss** — every field on the v0.7.x side has a v2.1
  destination (subject/title/considerations/approvals/actions →
  Localization; identifier string → StructuredIdentifier with
  `prefix: "ISO/TC 154"`; dates triples → DecisionDate list).
- **Additive**: the v2.1 form gains `kind: resolution`, `status:
  decided`, `localizations: [...]`. The v0.7.x form had these
  implicitly; v2.1 makes them explicit.
- **Backups**: originals preserved in `legacy/` per CLAUDE.md.

## Acceptance criteria for TODO 02

- [ ] All 41 YAML files migrated to v2.1 shape.
- [ ] `bundle exec edoxen validate "{plenary,ballots,7372ma}/*.yaml"`
      passes against edoxen ~> 2.1.
- [ ] Originals in `legacy/` (never deleted).
- [ ] Migration script idempotent (re-running produces same output).
- [ ] PR description lists any per-fixture quirks the script
      couldn't migrate mechanically (e.g. ballot-specific fields).
