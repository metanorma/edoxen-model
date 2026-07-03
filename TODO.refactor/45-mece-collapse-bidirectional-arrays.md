# 45 — MECE: collapse bidirectional arrays storing the same relationship

**Status**: design proposed, implementation deferred to v2.1

## Context

The v2.0 model stores several relationships from both sides, inviting drift:

| Forward field | Inverse field | Same relationship |
|---|---|---|
| `Decision.broughtByMotions: String[]` | `Motion.resultingDecision: String` | "Motion A brought Decision B" |
| `Decision.aboutTopics: String[]` | `Topic.decisions: String[]` | "Decision B is about Topic T" |
| `Motion.votings: String[]` | `Voting.onMotion: String` | "Voting V is on Motion M" |
| `Decision.madeInComponent: String` | (no inverse) | Asymmetric — suggests incomplete design |
| `Topic.motions: String[]` | (no inverse on Motion) | Asymmetric |

Storing both sides means:

- Two writers, two truths, no reconciliation
- Drift is invisible until a consumer reads both sides and they disagree
- Update overhead: every relationship change touches two entities
- Storage cost: every relationship is stored twice

## Proposed: store once, derive the reverse

Pick the canonical side per relationship (typically the "from" that
owns it). The reverse lookup is a derived view in the gem (computed via
in-memory index), not stored in YAML.

| Relationship | Store on | Derive on |
|---|---|---|
| Motion → Decision | `Motion.resultingDecision` | `Decision.broughtByMotions` (computed) |
| Decision → Topic | `Decision.aboutTopics` | `Topic.decisions` (computed) |
| Motion → Voting | `Voting.onMotion` | `Motion.votings` (computed) |
| Decision → Component | `Decision.madeInComponent` | `MeetingComponent.decisionRefs` (computed, add this field) |
| Topic → Motion | `Topic.motions` | (no inverse needed; topics don't have to know motions) |

## Implementation

In the gem, add accessor methods that compute the reverse:

```ruby
class Decision
  # Storage: about_topics: String[] (Topic URNs)
  # Derived: topics → back-references from Topic.decisions

  def brought_by_motions(meeting:)
    meeting.motions.select { |m| m.resulting_decision_ref == self.urn }
  end
end
```

The storage is one-way; the lookup is computed. No drift possible.

## Acceptance criteria

- [ ] Each bidirectional relationship has exactly one storage side
- [ ] Reverse lookups are computed accessors in the gem, not stored fields
- [ ] Schema drops the redundant inverse field
- [ ] Migration script removes the redundant data from existing YAMLs
- [ ] Architectural spec asserts "no relationship is stored from both sides"

## Why this matters

Without this fix, the v2 model carries the same kind of invisible-drift
risk that v1 had with `Resolution.agenda_item` ↔ `AgendaItem.resolution_ref`.
The whole point of v2 was to fix that class of bug. Don't ship v2 with
the same anti-pattern in five new places.
