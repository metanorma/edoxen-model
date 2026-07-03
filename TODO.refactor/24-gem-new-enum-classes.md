# 24 — Gem: Add new enum classes

## Why

Mirror LutaML enums in Ruby. `Edoxen::Enums` module holds all enums; existing pattern.

## Files to create

- `lib/edoxen/enums.rb` (extend existing)
- New enums: VenueKind, VirtualFeature, Visibility, AttendanceRole, AttendanceResponse, ComponentKind, DecisionKind (renamed), DecisionStatus, MotionStatus, VotingStatus, VotingMethod, VotingOutcome, TopicStatus, OfficerRole, RecurrenceFreq

## Pattern (lutaml-model)

```ruby
module Edoxen
  module Enums
    class DecisionKind < Lutaml::Model::Type::Enum
      values %i[
        resolution order ruling determination
        recommendation statement finding opinion other
      ]
    end
  end
end
```

## Acceptance criteria

- All enums from TODOs 01-11 have Ruby counterparts
- Sync spec (TODO 20) enforces LutaML ↔ Ruby parity
- No hand-rolled enum classes (use Lutaml::Model::Type::Enum)