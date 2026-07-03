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
