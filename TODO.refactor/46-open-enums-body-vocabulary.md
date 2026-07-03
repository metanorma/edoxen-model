# 46 — Open enums: replace `other` escape hatches with body_vocabulary

**Status**: design proposed, implementation deferred to v2.1

## Context

The v2.0 model has three enums that violate the master-plan principle
"open String for adopter-extensible kinds":

- **`MeetingType`** — 17 values including `other`
- **`ComponentKind`** — 19 values including `other`
- **`DecisionKind`** — 9 values including `other`

`other` is a code smell — it's the model admitting "we couldn't enumerate
reality". Adopters who need `task_force` or `briefing` either push for a
core change (breaking for everyone) or use `other` and lose semantic
clarity.

The enums also mix org-specific terminology (working_group, task_group,
markup) with abstract function (plenary, committee). This is exactly the
pattern the user pushed back on during the MeetingType discussion
(2026-07-02): org-specific values shouldn't be in the canonical enum.

## Proposed: small canonical + body_vocabulary

For each enum, replace the long list with a small abstract canonical
set + a free `body_type` string + a per-dataset `body_vocabulary`
mechanism.

### MeetingType — 4 canonical values

```
plenary     — full-body decision meeting
governing   — manages between plenaries (boards, councils, bureaus)
working     — does the work (WGs, SGs, PGs, SCs, CCs)
advisory    — recommends, no decisions (advisory boards, expert panels)
```

Plus structural attributes in separate fields:

- `standing: Boolean` — permanent vs time-limited (false for ad_hoc/task_group)
- `parent: EntityRef` — for sessions within larger meetings
- `joint_with: EntityRef[]` — for joint meetings

Bodies record their own term via `body_type: "CIML Meeting"` and declare
the mapping in `metadata.body_vocabulary[]`.

### ComponentKind — collapse to 4-5 abstract values

```
deliberative  — plenaries, debates, question time
working       — sessions, breakouts, BOFs
ceremonial    — keynotes, addresses, openings, closings
break         — breaks, receptions, networking, registration
other         — escape (temporary, while the vocabulary stabilizes)
```

Plus `body_type` + `body_vocabulary`.

### DecisionKind — collapse to 4 abstract values

```
decision      — generic decision (the default)
recommendation — non-binding
statement     — declarative, no obligation
finding       — factual determination
other         — escape
```

Bodies extend with `body_type` ("Resolution", "Order", "Ruling",
"Determination", etc.) + per-dataset vocabulary.

## Migration plan

1. Add the new short canonical enums alongside the old ones (non-breaking).
2. Add `body_type` field to Meeting / MeetingComponent / Decision.
3. Add `body_vocabulary` slot to MeetingCollectionMetadata (and the
   resolution-equivalent metadata).
4. Document the migration mapping (old value → new canonical + body_type).
5. Deprecate the old long enums in v2.1.
6. Remove in v3.0.

## Acceptance criteria

- [ ] Each enum has ≤ 5 canonical values
- [ ] No enum has an `other` escape value
- [ ] `body_type` field exists on Meeting, MeetingComponent, Decision
- [ ] `body_vocabulary` slot exists on collection metadata
- [ ] Schema validates `body_type` against the dataset's vocabulary
- [ ] Migration guide covers old → new mapping for each enum
- [ ] Architectural spec asserts "no enum has `other`"

## Why this matters

The whole point of v2's "generic core + profile extensions" was to stop
baking org-specific terminology into the canonical model. Long enums
with `other` revert that principle. The body_vocabulary mechanism gives
adopters the flexibility they need without forcing core changes for
every new body onboarded.
