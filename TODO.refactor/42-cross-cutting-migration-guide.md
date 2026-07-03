# 42 — Cross-cutting: Migration guide for downstream consumers

## Why

This is a breaking change. Downstream consumers (OIML, TC154, TC184/SC4, and any others) need a migration guide.

## File to create

- `docs/migration-v2.adoc` — guide from v1 (Resolution-based) to v2 (Decision-based)

## Topics covered

1. Resolution → Decision rename
2. ResolutionType → DecisionKind (with expanded values)
3. New DecisionStatus state machine
4. Motion entity (new — for procedural acts)
5. Voting entity (new — state machine)
6. Topic / TopicDocument / TopicAsset (new — replaces MeetingDocument concept)
7. Venue polymorphic (replaces Location + virtual: Boolean)
8. Officer (replaces chair/secretary direct fields)
9. MeetingComponent (replaces ScheduleItem)
10. MeetingExtension (profile mechanism)
11. Recurrence (ISO 8601-2 §13 structured)
12. UNLOCODE + IATA integration

## For each topic

- Old shape → New shape
- Migration command (if automated)
- Common pitfalls

## Acceptance criteria

- Guide covers all 12 breaking changes
- Each has before/after sample
- Migration script (`scripts/migrate_v1_to_v2.rb`) documented