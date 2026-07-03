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
| edoxen-model | `/Users/mulgogi/src/edoxen/edoxen-model` | `feat/complete-meeting-model` | pushed |
| edoxen gem | `/Users/mulgogi/src/edoxen/edoxen` | `feat/v2-broadened-scope` | pushed |
| edoxen.github.io | `/Users/mulgogi/src/edoxen/edoxen.github.io` | `feat/v2-broadened-scope` | pushed |
| OIML | `/Users/mulgogi/src/oimlsmart/resolutions-data` | TBD | TBD |
| TC154 | `/Users/mulgogi/src/isotc154/www.isotc154.org` | TBD | TBD |
| TC184/SC4 | `/Users/mulgogi/src/isotc184sc4/resolutions` | TBD | TBD |

## Phase A — edoxen-model (TODOs 01-20)

**Status: COMPLETE.** All 20 TODOs done.

Commits pushed to `feat/complete-meeting-model`:
- 47f1d58 — broaden scope: 8 references + TODO plan + foundation entities
- c246ab0 — procedural core (Decision, Motion, Voting) + Topic + structural
- d252390 — rename Resolution → Decision + extend Meeting/Attendance/Agenda/Person
- 91b36f9 — convert snake_case to camelCase in new lutaml files
- 3b388be — references/iso8601-2.adoc + legco profile
- 9038717 — README rewrite for broadened generic scope
- ad3fac2 — sample YAMLs (3 files: OIML, LegCo, hybrid board)

Deliverables:
- 81 lutaml model files (33 new in v2.0)
- 8 reference docs + 1 new (iso8601-2)
- 1 profile example (legco)
- 3 sample YAMLs
- Updated README

## Phase B — edoxen gem (TODOs 21-29)

**Status: COMPLETE.** All 9 TODOs done.

Deliverables:
- 5 Resolution → Decision file renames (decision.rb, decision_collection.rb, decision_metadata.rb, decision_date.rb, decision_relation.rb)
- 17 new model files (venue.rb, physical_venue.rb, virtual_venue.rb, motion.rb, voting.rb, voting_counts.rb, topic.rb, topic_document.rb, topic_asset.rb, meeting_series.rb, meeting_component.rb, component_localization.rb, officer.rb, meeting_extension.rb, extension_attribute.rb, recurrence.rb, recurrence_by_day.rb, venue_validator.rb)
- 6 updated files (lib/edoxen.rb, enums.rb, meeting.rb, attendance.rb, agenda_item.rb, person.rb, vote_record.rb, reference_data.rb)
- All new enums added to Edoxen::Enums
- IATA gem dependency added
- Version 2.0.0
- Schema/CLI/RBS/specs fully migrated to v2.0 terminology

## Phase C — edoxen.github.io (TODOs 30-34)

**Status: COMPLETE.**

- `docs/` restructured for new model terminology
- New pages: decision, motion, voting, venue, topic, meeting-series, component, officer, extension, recurrence
- Existing pages: `resolution.md` → `decision.md`; `resolution-set.md` → `decision-collection.md`; cross-links updated
- VitePress sidebar reflects new model tree

## Phase D — Downstream migrations (TODOs 35-43)

**Status: NOT STARTED.** Each downstream repo is its own multi-hour project, deferred to dedicated sessions per repo.

## Session discipline

- Commit + push regularly so context-loss between sessions does not block progress.
- TODO files in this directory are the long-term plan-of-record; update them as work shifts.
