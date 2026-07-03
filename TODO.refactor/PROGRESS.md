= Edoxen Refactor — Progress Tracker

== Workflow

- Branch per repo: `feat/v2-broadened-scope`
- Commit every 2-3 TODOs (small commits)
- Push to branch after each phase completes
- Open PR at end of each phase
- Update this file after every commit
- Never commit to main, never push tags, never add AI attribution

== Repositories and branches

[cols="1,3,2,2"]
|===
| Repo | Path | Branch | PR
| edoxen-model | /Users/mulgogi/src/edoxen/edoxen-model | feat/complete-meeting-model (will rename to feat/v2-broadened-scope) | TBD
| edoxen gem | /Users/mulgogi/src/edoxen/edoxen | (TBD) | TBD
| edoxen.github.io | /Users/mulgogi/src/edoxen/edoxen.github.io | (TBD) | TBD
| OIML | /Users/mulgogi/src/oimlsmart/resolutions-data | (TBD) | TBD
| TC154 | /Users/mulgogi/src/isotc154/www.isotc154.org | (TBD) | TBD
| TC184/SC4 | /Users/mulgogi/src/isotc184sc4/resolutions | (TBD) | TBD
|===

== Phase A — edoxen-model (TODOs 01-20)

Dependency order (NOT numeric order):

1. TODO 11 — New enums (independent) — Status: NOT STARTED
2. TODO 09 — MeetingExtension (foundational) — Status: NOT STARTED
3. TODO 10 — Recurrence (depends on 09) — Status: NOT STARTED
4. TODO 01 — Venue (depends on 09, 11) — Status: NOT STARTED
5. TODO 02 — Decision base type (depends on 09) — Status: NOT STARTED
6. TODO 03 — Motion (depends on 09) — Status: NOT STARTED
7. TODO 04 — Voting (depends on 09) — Status: NOT STARTED
8. TODO 05 — Topic (depends on 09) — Status: NOT STARTED
9. TODO 06 — MeetingSeries (depends on 09, 10) — Status: NOT STARTED
10. TODO 07 — MeetingComponent (depends on 09, 11) — Status: NOT STARTED
11. TODO 08 — Officer (depends on 09) — Status: NOT STARTED
12. TODO 12 — Extend Meeting (depends on all above) — Status: NOT STARTED
13. TODO 13 — Extend Attendance/AgendaItem/Person (depends on 05, 09, 11) — Status: NOT STARTED
14. TODO 14 — Rename Resolution → Decision (depends on 02) — Status: NOT STARTED
15. TODO 15 — references/iso8601-2.adoc — Status: NOT STARTED
16. TODO 16 — references/profiles/legco.adoc — Status: NOT STARTED
17. TODO 17 — Update existing references (depends on all model) — Status: NOT STARTED
18. TODO 18 — Update README — Status: NOT STARTED
19. TODO 19 — Sample YAMLs — Status: NOT STARTED
20. TODO 20 — Schema sync spec — Status: NOT STARTED

== Phase B — edoxen gem (TODOs 21-29)

Status: NOT STARTED

Depends on: Phase A complete

== Phase C — edoxen.github.io (TODOs 30-34)

Status: NOT STARTED

Depends on: Phase A complete; Phase B preferably complete

== Phase D — Downstream migrations (TODOs 35-43)

Status: NOT STARTED

Depends on: Phase A + B complete (data migration uses gem for validation)

== Cross-cutting (TODOs 41-43)

Status: NOT STARTED

These live in edoxen-model repo.

== Commit log

(Updated after each commit. Format: `timestamp | repo | commit-sha | TODOs`)

== Pause points

The plan calls for pause-and-review at:
- After Phase A complete (before touching gem)
- After Phase B complete (before touching docs)
- Before each downstream migration

User instructed (2026-07-03): "Do EVERYTHING now" — proceed
autonomously through phases but COMMIT regularly so progress
persists across context compaction.