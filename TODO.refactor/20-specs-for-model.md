# 20 — Schema sync spec (LutaML ↔ gem ↔ JSON Schema)

## Why

The edoxen gem already has `schema_enum_sync_spec.rb` and
`schema_model_sync_spec.rb` to enforce that the gem's
`schema/edoxen.yaml` matches the LutaML definition value-for-value.

After the broadened scope, these specs must cover all new entities
and enums. This is a GUARDRAIL — without it, the gem and the
LutaML model will drift.

## Files to update

- (in edoxen gem, not this repo) `spec/edoxen/schema_enum_sync_spec.rb`
- (in edoxen gem) `spec/edoxen/schema_model_sync_spec.rb`
- (in edoxen gem) `spec/edoxen/schema_meeting_enum_sync_spec.rb`
- (in edoxen gem) `spec/edoxen/schema_meeting_model_sync_spec.rb`

## This TODO is for the edoxen-model side

- Create `edoxen-model/spec/` directory
- Add a spec that verifies every `.lutaml` file in `models/` parses
  correctly via lutaml-model
- Add a spec that verifies every enum file has unique values
- Add a spec that verifies every entity has an `extensions` slot
  (where applicable)

## Sample spec (illustrative)

```ruby
# spec/models/extension_slot_spec.rb
require "lutaml/model"

RSpec.describe "extension slot presence" do
  Dir.glob("models/*.lutaml").each do |path|
    name = File.basename(path, ".lutaml")
    it "#{name} has extensions: MeetingExtension[0..*] slot" do
      # ... lutaml-model autoloading + reflection
    end
  end
end
```

## Dependencies

- TODOs 01-14 (all model files must exist)

## Acceptance criteria

- `edoxen-model/spec/` directory exists
- Spec runs successfully against all model files
- CI integration (GitHub Actions) — run on every push
- Gem-side sync specs updated (TODO 29 covers this in detail)