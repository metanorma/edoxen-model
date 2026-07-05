# Phase F — Downstream consumers (TC154, TC184/SC4, OIML)

**Status: AUDIT COMPLETE; migrations deferred per master plan.**

The v2.0 / v2.1 model is in the gem (PR [#20](https://github.com/edoxen/edoxen/pull/20))
and docs site (PR [#13](https://github.com/edoxen/edoxen.github.io/pull/13)).
Adopting it in the three downstream reference corpora is each repo's
own multi-hour project — the master plan defers these to dedicated
sessions.

This file is the audit + consumption checklist for each.

## Audit (2026-07-05)

### `oimlsmart/resolutions-data`

- **Branch**: `main` (clean).
- **Gemfile pin**: `gem "edoxen", github: "edoxen/edoxen", ref: "eae1ca2"`
  (i.e. v0.7.2 — explicitly locked because their meeting YAMLs use the
  pre-v2 schema: no `meetings:` collection, `year`, `virtual`, etc.).
- **GHA**: `deploy-pages.yml` — validates then deploys. **Valid YAML.**
- **Path to v2.1**:
  1. Write `scripts/migrate_to_v2.rb` mapping each pre-v2 meeting +
     resolution YAML to the v2 shape (Decision + MeetingCollection).
  2. Run migration; preserve originals in `legacy/` per CLAUDE.md.
  3. Bump Gemfile to `gem "edoxen", "~> 2.1"`.
  4. Update `validate` step in `deploy-pages.yml` to validate the new
     shape.
  5. Demo the v2.1 typed ExtensionAttribute in one fixture (e.g.
     `samples/v2.1-typed-extension.yaml`).

### `isotc154/www.isotc154.org`

- **Branch**: `feat/edoxen-meeting-format`.
- **Edoxen gem usage**: in a nested `_data/resolutions/` subdirectory
  (likely a submodule; it has its own `Gemfile` + `.github/workflows/validate.yml`).
  The site itself uses Vue + Jekyll and validates via `npm run validate`
  in the root `build_deploy.yml`.
- **GHA**: `build_deploy.yml` + `sync_iso_data.yml`. **Both valid YAML.**
- **Path to v2.1**:
  1. Update the nested `_data/resolutions/` submodule to consume v2.1.
  2. Update Vue components in `src/` if they reference fields that
     changed shape (chair/secretary shortcuts → officers[], etc.).
  3. Update the root `validate` step.

### `isotc184sc4/resolutions`

- **Branch**: `main` (with untracked debug files).
- **Gemfile**: `gem "edoxen"` (no version pin — pulls latest).
- **GHA**: `deploy-pages.yml` + `validate.yml`. **Both valid YAML.**
- **Path to v2.1**:
  1. Bump Gemfile to `gem "edoxen", "~> 2.1"` (or pin to a specific
     commit on `feat/v2-broadened-scope` until v2.1 ships to RubyGems).
  2. Migrate `plenary/*.yaml` to the v2 shape.
  3. Update the Vue browser code in `browser/`.

## Cross-cutting notes

- **v2.1 not yet on RubyGems.** All three downstreams currently pull v0.x
  behavior. Once v2.1 ships to RubyGems, the version pins can drop.
- **Migration cost.** Each downstream has 30+ years of plenary/meeting
  data in YAML. The migration scripts must preserve original files in
  `legacy/` (CLAUDE.md: never delete source). Plan for one PR per repo.
- **Profile demos.** Once migrated, each repo can showcase the v2.1
  typed ExtensionAttribute with a real-world profile (e.g. OIML's
  `ciml_vote_kind`, TC154's `plenary_session_status`).

## Verdict

The downstream migration is **out of scope for the v2.1 release** of
the model + gem. It's the next quarter's work. This file tracks the
checklist for each repo so the next maintainer doesn't have to redo
the audit.
