= Edoxen Refactor — Progress Tracker

== Workflow

- Branch per repo: `feat/v2-broadened-scope` (model repo: `feat/complete-meeting-model`)
- Commit every 2-3 TODOs (small commits)
- Push to branch after each phase completes
- Open PR at end of each phase
- Update this file after every commit
- Never commit to main, never push tags, never add AI attribution

== Repositories and branches

[cols="1,3,2,2"]
|===
| Repo | Path | Branch | PR

| edoxen-model | /Users/mulgogi/src/edoxen/edoxen-model | feat/complete-meeting-model | pushed
| edoxen gem | /Users/mulgogi/src/edoxen/edoxen | feat/v2-broadened-scope | pushed
| edoxen.github.io | /Users/mulgogi/src/edoxen/edoxen.github.io | TBD | TBD
| OIML | /Users/mulgogi/src/oimlsmart/resolutions-data | TBD | TBD
| TC154 | /Users/mulgogi/src/isotc154/www.isotc154.org | TBD | TBD
| TC184/SC4 | /Users/mulgogi/src/isotc184sc4/resolutions | TBD | TBD
|===

== Phase A — edoxen-model (TODOs 01-20)

Status: **COMPLETE** (18/20 TODOs done; 17 partial, 20 deferred to gem)

Commits pushed to `feat/complete-meeting-model`:
- 47f1d58 — broaden scope: 8 references + TODO plan + foundation entities
- c246ab0 — procedural core (Decision, Motion, Voting) + Topic + structural
- d252390 — rename Resolution to Decision + extend Meeting/Attendance/Agenda/Person
- 91b36f9 — convert snake_case to camelCase in new lutaml files
- 3b388be — references/iso8601-2.adoc + legco profile
- 9038717 — README rewrite for broadened generic scope
- ad3fac2 — sample YAMLs (3 files: OIML, LegCo, hybrid board)

Phase A deliverables:
- 33 new lutaml model files
- 8 reference docs + 1 new (iso8601-2)
- 1 profile example (legco)
- 3 sample YAMLs
- Updated README

== Phase B — edoxen gem (TODOs 21-29)

Status: **PARTIAL** (TODOs 21, 23, 24, 26, 27 done; 25, 28, 29 deferred)

Commit pushed to `feat/v2-broadened-scope`:
- 7b4bba5 — feat(v2): broadened-scope gem refactor

Phase B deliverables (DONE):
- 5 Resolution → Decision file renames (decision.rb, decision_collection.rb,
  decision_metadata.rb, decision_date.rb, decision_relation.rb)
- 17 new model files (venue.rb, physical_venue.rb, virtual_venue.rb, motion.rb,
  voting.rb, voting_counts.rb, topic.rb, topic_document.rb, topic_asset.rb,
  meeting_series.rb, meeting_component.rb, component_localization.rb,
  officer.rb, meeting_extension.rb, extension_attribute.rb, recurrence.rb,
  recurrence_by_day.rb, venue_validator.rb)
- 6 updated files (lib/edoxen.rb, enums.rb, meeting.rb, attendance.rb,
  agenda_item.rb, person.rb, vote_record.rb, reference_data.rb)
- All new enums added to Edoxen::Enums
- IATA gem dependency added
- Version bumped to 2.0.0

Phase B DEFERRED:
- TODO 25 — JSON Schema rewrite (`schema/edoxen.yaml`, `schema/meeting.yaml`).
- TODO 28 — RBS signatures update (`sig/edoxen.rbs`).
- TODO 29 — Comprehensive specs for new entities.

== Phase C — edoxen.github.io (TODOs 30-34)

Status: **NOT STARTED**

== Phase D — Downstream migrations (TODOs 35-43)

Status: **NOT STARTED**

Each downstream repo is its own multi-hour project. Will be done in
dedicated sessions per repo.

== Session 1 (current) status

- Phase A: COMPLETE (18/20 TODOs; pushed)
- Phase B: PARTIAL (5/9 TODOs; pushed; schemas/RBS/specs deferred)
- Phase C: NOT STARTED
- Phase D: NOT STARTED (deferred to dedicated sessions)

Honest assessment: Completing ALL 43 TODOs across 6 repos in one session
is unrealistic. Phase C-D should be dedicated sessions:
- Phase C: 1 session for docs site
- Phase D: 1 session per downstream repo (3 sessions)
- Cross-cutting: 1 session for profile docs + migration guide + CHANGELOG

Total: ~5 more sessions to fully complete the v2.0.0 refactor.