# 29 — Gem: Comprehensive specs

## Why

Per user's CLAUDE.md: "Good specs throughout. Every public method should have specs. Every behavioral edge case should be covered. Specs use real model instances — never doubles."

## Files to create

- `spec/edoxen/decision_spec.rb`
- `spec/edoxen/motion_spec.rb`
- `spec/edoxen/voting_spec.rb`
- `spec/edoxen/venue_spec.rb`
- `spec/edoxen/topic_spec.rb`
- `spec/edoxen/meeting_series_spec.rb`
- `spec/edoxen/meetingcomponent_spec.rb`
- `spec/edoxen/officer_spec.rb`
- `spec/edoxen/meeting_extension_spec.rb`
- `spec/edoxen/recurrence_spec.rb`
- `spec/edoxen/venue_validator_spec.rb` (with UNLOCODE/IATA)
- `spec/edoxen/profiles/legco_spec.rb` (end-to-end profile test)
- `spec/edoxen/sync/schema_enum_sync_spec.rb` (updated)
- `spec/edoxen/sync/schema_model_sync_spec.rb` (updated)

## Pattern

```ruby
RSpec.describe Edoxen::Decision do
  let(:decision) do
    Edoxen::Decision.from_hash(
      identifier: [{ prefix: "OIML", number: "2025-44" }],
      kind: "resolution",
      status: "decided",
      # ...
    )
  end

  describe "#kind" do
    it "returns DecisionKind instance" do
      expect(decision.kind).to be_a(Edoxen::Enums::DecisionKind)
    end
  end

  # ...
end
```

## Constraints

- NO doubles — use real Edoxen classes or lightweight Structs
- NO `expect(subject).to receive(:method)` — assert on output/state, not interactions

## Acceptance criteria

- Spec coverage ≥ 90% for new code
- All edge cases covered (empty arrays, nil optional fields, etc.)
- `bundle exec rake spec` passes
- `bundle exec rubocop` passes