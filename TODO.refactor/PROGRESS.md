= Edoxen Refactor — Progress Tracker

== Workflow

- Branch per repo: `feat/v2-broadened-scope` (current branch in edoxen-model
  is `feat/complete-meeting-model` — will continue using it for v2 work)
- Commit every 2-3 TODOs (small commits)
- Push to branch after each phase completes
- Open PR at end of each phase
- Update this file after every commit
- Never commit to main, never push tags, never add AI attribution

== Repositories and branches

[cols="1,3,2,2"]
|===
| Repo | Path | Branch | PR
| edoxen-model | /Users/mulgogi/src/edoxen/edoxen-model | feat/complete-meeting-model | TBD
| edoxen gem | /Users/mulgogi/src/edoxen/edoxen | (TBD: feat/v2-broadened-scope) | TBD
| edoxen.github.io | /Users/mulgogi/src/edoxen/edoxen.github.io | (TBD: feat/v2-broadened-scope) | TBD
| OIML | /Users/mulgogi/src/oimlsmart/resolutions-data | fix/canonical-meeting-urls (TBD switch) | TBD
| TC154 | /Users/mulgogi/src/isotc154/www.isotc154.org | feat/edoxen-meeting-format (TBD switch) | TBD
| TC184/SC4 | /Users/mulgogi/src/isotc184sc4/resolutions | (TBD: feat/v2-broadened-scope) | TBD
|===

== Phase A — edoxen-model (TODOs 01-20)

Status: **PHASE A MOSTLY COMPLETE** — 18/20 TODOs done; 17 and 20 are
deferred to follow-up commits.

=== Completed TODOs

- ✅ TODO 01 — Venue polymorphic (Venue base + PhysicalVenue + VirtualVenue
  via inheritance, VenueKind, VirtualFeature; physical_details and
  virtual_details renamed to physical_venue and virtual_venue)
- ✅ TODO 02 — Decision base type + DecisionKind (9 values) + DecisionStatus
  (7-state machine)
- ✅ TODO 03 — Motion + MotionStatus (9-state machine) + open seconders list
- ✅ TODO 04 — Voting + VotingStatus + VotingMethod (8) + VotingOutcome +
  VotingCounts + casting_vote for tie-breaker
- ✅ TODO 05 — Topic + TopicDocument + TopicAsset + TopicStatus (with
  resumptionOf for cross-meeting threading)
- ✅ TODO 06 — MeetingSeries (parent of recurring meetings)
- ✅ TODO 07 — MeetingComponent (flat sub-events) + ComponentKind (18 values
  covering substantive + procedural; subsumes ScheduleItem)
- ✅ TODO 08 — Officer + OfficerRole (9 values: chair, vice_chair,
  deputy_chair, secretary, treasurer, parliamentarian, presiding_officer,
  sergeant_at_arms, other)
- ✅ TODO 09 — MeetingExtension + ExtensionAttribute (profile mechanism,
  ISO 8601-2 §15)
- ✅ TODO 10 — Recurrence + RecurrenceFreq + RecurrenceByDay (structured,
  queryable; ISO 8601-2 §13)
- ✅ TODO 11 — New enums: Visibility, AttendanceRole, AttendanceResponse
- ✅ TODO 12 — Extend Meeting (added seriesRef, visibility, recurrence,
  venues, officers, components, decisions, motions, votings, extensions;
  removed year, virtual Boolean, chair, secretary, host, schedule,
  vote_records)
- ✅ TODO 13 — Extend Attendance (role, response, extensions), AgendaItem
  (topics, components, extensions, decisionRef renamed), Person (kind,
  extensions)
- ✅ TODO 14 — Renamed Resolution → Decision across all files; resolution_type
  marked as superseded stub; subject_body comment updated
- ✅ TODO 15 — references/iso8601-2.adoc with `include::` directives for
  §10/§11/§12/§13/§14/§15
- ✅ TODO 16 — references/profiles/legco.adoc (8 extension kinds with
  sample YAML)
- ✅ TODO 18 — README.adoc rewritten for generic scope + polymorphic Venue +
  profile mechanism + full entity table organized by concern
- ✅ TODO 19 — 3 sample YAMLs created:
  - samples/oiml-ciml-56.yaml (standards body, unanimous consent)
  - samples/legco-sitting-2024-01-15.yaml (parliamentary, division vote,
    profile extensions, multi-seconder)
  - samples/hybrid-board-meeting.yaml (corporate, roll_call with casting vote)

=== Deferred TODOs (in this repo)

- ⏳ TODO 17 — Update existing 8 reference docs with post-refactor entity
  names. The references are still accurate for source data; only the
  "Net contribution" sections need refresh. Will do as follow-up.
- ⏳ TODO 20 — Schema sync spec. Belongs in the gem (edoxen), not the model
  repo. The model repo has no spec setup. Moved to TODO 29 (gem specs).

=== Phase A commits (edoxen-model)

- 47f1d58 — broaden scope: 8 references + TODO plan + foundation entities
- c246ab0 — procedural core (Decision, Motion, Voting) + Topic + structural
- d252390 — rename Resolution to Decision + extend Meeting/Attendance/Agenda/Person
- 91b36f9 — convert snake_case to camelCase in new lutaml files
- 3b388be — references/iso8601-2.adoc + legco profile
- 9038717 — README rewrite for broadened generic scope
- (pending) — sample YAMLs (3 files)

== Phase B — edoxen gem (TODOs 21-29)

Status: **NOT STARTED**

Dependencies: Phase A complete (✓).

Will create branch `feat/v2-broadened-scope` in /Users/mulgogi/src/edoxen/edoxen.

== Phase C — edoxen.github.io (TODOs 30-34)

Status: **NOT STARTED**

Dependencies: Phase A complete (✓); Phase B preferably complete.

== Phase D — Downstream migrations (TODOs 35-43)

Status: **NOT STARTED**

Dependencies: Phase A + B complete (data migration uses gem for validation).

== Cross-cutting (TODOs 41-43)

Status: **NOT STARTED**

These live in edoxen-model repo.

== Pause points

Per user instruction (2026-07-03): proceed autonomously through phases
but COMMIT regularly so progress persists across context compaction.
Push branch and open PR after each phase completes.

== Session 1 (current) status

- Phase A: ~90% complete (18/20 TODOs)
- Phase B: queued next
- Phase C: queued
- Phase D: queued (depends on B)

Will commit remaining Phase A work, then push, then start Phase B.