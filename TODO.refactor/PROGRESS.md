# Edoxen Refactor — Progress Tracker

## Workflow

- Branch per repo: `feat/v2-broadened-scope` (model repo: `feat/complete-meeting-model`)
- Commit every 2-3 TODOs (small commits)
- Push to branch after each phase completes
- Open PR at end of each phase
- Update this file after every commit
- Never commit to main, never push tags, never add AI attribution

## Repositories and branches

| Repo | Path | Branch | PR |
|------|------|--------|-----|
| edoxen-model | `/Users/mulgogi/src/edoxen/edoxen-model` | `feat/complete-meeting-model` | [#13](https://github.com/edoxen/edoxen-model/pull/13) |
| edoxen gem | `/Users/mulgogi/src/edoxen/edoxen` | `feat/v2-broadened-scope` | [#20](https://github.com/edoxen/edoxen/pull/20) |
| edoxen.github.io | `/Users/mulgogi/src/edoxen/edoxen.github.io` | `feat/v2-broadened-scope` | [#13](https://github.com/edoxen/edoxen.github.io/pull/13) |
| OIML | `/Users/mulgogi/src/oimlsmart/resolutions-data` | TBD | TBD |
| TC154 | `/Users/mulgogi/src/isotc154/www.isotc154.org` | TBD | TBD |
| TC184/SC4 | `/Users/mulgogi/src/isotc184sc4/resolutions` | TBD | TBD |

## Phase A — edoxen-model (TODOs 01-20)

**Status: COMPLETE.** All 20 TODOs done.

- 81 lutaml model files (33 new in v2.0)
- 8 reference docs + 1 new (iso8601-2)
- 1 profile example (legco)
- 3 sample YAMLs (snake_case wire names, flattened polymorphic Venue)
- Updated README + new CHANGELOG.adoc

## Phase B — edoxen gem (TODOs 21-29)

**Status: COMPLETE.** All 9 TODOs done.

- 5 Resolution → Decision file renames
- 17 new model files
- 6 updated files
- All new enums added to Edoxen::Enums
- IATA gem dependency added; version 2.0.0
- Schema/CLI/RBS fully migrated to v2.0
- **591 specs, 0 failures** (added 11 new spec files for v2 entities)
- Comprehensive RBS in `sig/edoxen.rbs`
- Rewritten README.adoc + new CHANGELOG.md

## Phase C — edoxen.github.io (TODOs 30-34)

**Status: COMPLETE.**

- `docs/` restructured: 4 renames + 9 new pages (decision, motion,
  voting, topic, venue, officer, meeting-component, meeting-series,
  recurrence, extension).
- VitePress nav restructured into Model dropdown + 6 sidebar groups.
- Hero rewritten for v2.0 generic-meeting focus.
- YamlSpecimen replaced with ACME hybrid board meeting.
- AnatomyStrip reframed: Meeting / Motion→Voting→Decision /
  MeetingExtension.
- Introduction + Architecture + Origin pages updated for v2.0.
- New blog post: `2026-07-03-edoxen-2-0-release.md`.

## Phase D — Downstream migrations (TODOs 35-43)

**Status: NOT STARTED.** Each downstream repo is its own multi-hour
project, deferred to dedicated sessions per repo. The migration guide
(TODO 42) and CHANGELOG (TODO 43) are done.

## TODO file format

All TODO files are in markdown (`.md`), converted from AsciiDoc (`.adoc`)
in a one-shot batch. The conversion script is `scripts/adoc_to_md.rb`.

## Session discipline

- Commit + push regularly so context-loss between sessions does not block progress.
- TODO files in this directory are the long-term plan-of-record; update them as work shifts.

## Phase E — v2.1 design tighten (TODOs 44-47)

**Status: 1 of 4 done; 3 deferred with rationale.**

- **TODO 47 (Tighten MeetingExtension)**: COMPLETE 2026-07-05.
  Documented `kind` and `ref` semantics; removed recursive
  `extensions[]` slot (YAGNI); polymorphized `ExtensionAttribute.value`
  with typed variants (string/integer/float/boolean/date/datetime)
  plus a `type` discriminator. v2.0 wire shape (`value: String`)
  remains valid for back-compat. Updated schema (edoxen.yaml +
  meeting.yaml), RBS, shared examples.

- **TODO 44 (EntityRef)**: DEFERRED. Added a Decision Log section to
  the TODO with three open questions (identity cardinality, metadata
  placement, pilot field selection). Recommended starting with
  phase 1 (EntityRef class) + a single pilot parallel field
  (`Motion.resultingDecisionRef`) to validate the design before
  rolling out to all 16 sites.

- **TODO 45 (MECE collapse)**: DEFERRED. Added a Decision Log section
  with per-relationship canonical-side recommendations. Recommended
  shipping v2.1 with derivations as computed accessors (additive),
  removing redundant inverse *storage* in v3.0 after one release of
  dual-write.

- **TODO 46 (Open enums + body_vocabulary)**: DEFERRED. Added a
  Decision Log section with five open questions (canonical count,
  vocabulary location, missing-vocabulary behavior, migration
  mapping, profile interaction). Recommended NOT implementing
  without a maintainer review session — the migration cost is high
  across every downstream repo.

The v2.1 design tighten is the next planned minor release. The
deferred TODOs need design decisions, not just code.

## Phase F — Downstream consumers (TODO 48)

**Status: AUDIT COMPLETE; migrations deferred.**

TODO 48 (`48-downstream-consumers-audit.md`) documents the path-to-v2.1
for each downstream repo (OIML, TC154, TC184/SC4):

- All three have valid GHA workflows today.
- All three currently consume edoxen v0.x (OIML explicitly pinned;
  TC154 and TC184 implicitly via no-pin).
- Migration to v2.1 requires per-repo data migration scripts +
  rendering updates — each is a multi-hour sub-project.

Out of scope for v2.1 model + gem release; tracked for the next
quarter.
