# 44 — EntityRef: typed cross-references (replacing bare String)

**Status**: design proposed, implementation deferred to v2.1

## Context

The v2.0 model uses bare `String` for every cross-entity reference:

- `Motion.votings: String[0..*]`
- `Motion.proposedDecision: String`
- `Motion.resultingDecision: String`
- `Topic.motions: String[0..*]`
- `Topic.decisions: String[0..*]`
- `Topic.resumptionOf: String`
- `Decision.broughtByMotions: String[0..*]`
- `Decision.aboutTopics: String[0..*]`
- `Decision.madeInComponent: String`
- `Meeting.seriesRef: String`
- `MeetingComponent.venueRefs: String[0..*]`
- `MeetingComponent.agendaRef: String`
- `MeetingComponent.minutesRef: String`
- `MeetingComponent.attendanceRefs: String[0..*]`
- `MeetingSeries.meetingRefs: String[0..*]`
- `Voting.onMotion: String`

The master plan says "Cross-references via URN (String)" but using bare
String loses every benefit URN-as-identifier provides:

- No type safety (any string passes)
- No URN format validation
- No way to distinguish URN vs URL vs StructuredIdentifier vs local key
- No way for the schema to enforce the join key
- No way to carry metadata on the reference (e.g., "this vote was
  recorded on motion X at agenda item Y")

## Proposed: a typed `EntityRef`

```ruby
class EntityRef {
  urn: String                            # canonical, format-validated (^urn:…)
  identifier: StructuredIdentifier       # alternative — prefix+number
  localRef: String                       # within-file (e.g., "agenda-item-4.2")
  # at least one of the three required

  # Optional metadata on the reference itself
  kind: String                           # for adopter-specific discriminator
  role: String                           # for the citation semantics
  note: String                           # free-form annotation
}
```

Then:

- `Motion.resultingDecision: EntityRef` (instead of `String`)
- `Decision.broughtByMotions: EntityRef[0..*]`
- etc.

## Migration plan

1. Add `EntityRef` class to the model + gem (additive).
2. Add `EntityRef`-typed variants of the existing String fields:
   `Motion.resultingDecisionRef`, `Decision.broughtByMotionRefs[]`,
   etc. (parallel fields, non-breaking).
3. Document the migration in CHANGELOG.
4. Deprecate the String-typed fields with a one-release grace period.
5. Remove the String fields in v3.0.

## Acceptance criteria

- [ ] `EntityRef` class exists with at-least-one-of-three identity check
- [ ] Gem mirrors the class
- [ ] Schema validates URN format when `urn` is present
- [ ] Architectural spec asserts "every cross-entity reference uses
      EntityRef, not bare String" (this is the load-bearing invariant)
- [ ] Migration guide for downstream consumers
