# Upgrade Downstream — Master Plan

## Context

Two downstream reference corpora consume the `edoxen` gem and produce
data in the **pre-v2** shape (`resolutions:`, bare-string identifiers,
`dates: [{start, end, kind}]` triples, per-language content flattened
on the parent Resolution). The v2.x model (gem v2.1.0) renamed
Resolution → Decision, wrapped per-language content into `localizations[]`,
and added structured identifiers, typed cross-references, body_vocabulary,
and more.

| Repo | Path | Data files | Browser |
|------|------|-----------|---------|
| `isotc154/resolutions-data` | `/Users/mulgogi/src/isotc154/resolutions-data` | 37 plenary + 3 ballots + 1 7372ma = **41 YAMLs** | `isotc154/www.isotc154.org` (Vue + Jekyll, separate repo) |
| `isotc184sc4/resolutions` | `/Users/mulgogi/src/isotc184sc4/resolutions` | 86 plenary = **86 YAMLs** | in-repo `browser/` (Vue + Vite) |

Both data shapes are nearly identical (pre-v2 Resolution collection)
because both bodies used the same Edoxen v0.7.x toolchain. The
migration logic is shared; only the data file roots differ.

## Goal

1. **Data**: migrate every YAML from pre-v2 to v2.1 shape.
2. **Validation**: GHA `validate.yml` runs `edoxen validate` against
   the v2.1 schema. Failures block deploys.
3. **Browser**: rendering code (Vue + Jekyll / Vue + Vite) reads the
   new v2.1 wire shape. Existing UI/UX preserved.
4. **PRs**: one PR per repo (TC154 data + TC154 site + TC184 = 3 PRs).

## Architectural principles

- **No back-compat shim in the gem.** The gem's job is to model v2.1
  cleanly. The downstream repos own their migration.
- **Source preservation.** Original v0.7.x YAMLs are kept in `legacy/`
  per CLAUDE.md ("NEVER DELETE source files"). Migration is one-way
  but reversible from backups.
- **Single-source-of-truth migration logic.** One Ruby script
  (`scripts/migrate_to_v2.rb`) handles both repos, parameterised by
  the data-file root and the body's identifier prefix.
- **Validation as the regression net.** GHA runs `edoxen validate`
  on every commit; any drift between data and the v2.1 schema fails
  CI immediately (same pattern that protects the gem itself).

## TODO index

### TC154

- [01-tc154-audit.md](01-tc154-audit.md) — current data shape, browser
  shape, schema version, file inventory.
- [02-tc154-migrate-data.md](02-tc154-migrate-data.md) — migration
  script + per-file transformation rules.
- [03-tc154-validate-and-gha.md](03-tc154-validate-and-gha.md) —
  update `validate.yml` to pin edoxen ~> 2.1 and validate the migrated
  shape.
- [04-tc154-update-browser.md](04-tc154-update-browser.md) — update
  `www.isotc154.org` Vue components + Jekyll data layer to read the
  new wire shape.

### TC184

- [05-tc184-audit.md](05-tc184-audit.md) — same shape as 01 but for
  the TC184 single-repo layout.
- [06-tc184-migrate-data.md](06-tc184-migrate-data.md) — migration
  script (shared logic with 02, different file root + prefix).
- [07-tc184-validate-and-gha.md](07-tc184-validate-and-gha.md) —
  update `validate.yml` + `deploy-pages.yml`.
- [08-tc184-update-browser.md](08-tc184-update-browser.md) — update
  the in-repo Vue browser.

## Execution order

1. TC154 audit + migration script (TODOs 01-02).
2. TC184 audit + migration script (TODOs 05-06).
3. Run both migrations locally; verify `edoxen validate` passes.
4. Update both GHA workflows (TODOs 03 + 07).
5. Update both browsers (TODOs 04 + 08).
6. Open three PRs:
   - `isotc154/resolutions-data` — data + GHA.
   - `isotc154/www.isotc154.org` — browser.
   - `isotc184sc4/resolutions` — data + GHA + browser.

## Scope guardrails

This is a **mechanical** migration — no semantic changes to the data
themselves. If a v0.7.x fixture carries an OIML-specific quirk (e.g.
ballot-resolution type), preserve the quirk via the v2.1 `body_type`
mechanism rather than inventing a new enum value. New canonical
enum values are out of scope.

If the migration surfaces a genuine data bug (e.g. orphaned date),
flag it in the PR description and the migration script's `--dry-run`
report — don't fix the data in the same PR.
