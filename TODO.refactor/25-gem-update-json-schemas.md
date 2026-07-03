# 25 — Gem: Update JSON Schemas

## Why

The gem ships JSON Schemas (`schema/edoxen.yaml`, `schema/meeting.yaml`) used by the CLI for validation. These must reflect the new model.

## Files to modify

- `schema/edoxen.yaml` — Decision (was Resolution) schema
- `schema/meeting.yaml` — Meeting schema with new fields

## New schemas to add

- `schema/venue.yaml` — polymorphic Venue
- `schema/decision.yaml` — full Decision (was embedded in edoxen.yaml)
- `schema/motion.yaml`
- `schema/voting.yaml`

## Pattern

JSON Schema with `additionalProperties: false`, `required`, `enum`, `pattern`. Use `$ref` to compose.

## Sample (decision.yaml)

```yaml
$schema: https://json-schema.org/draft/2020-12/schema
$id: https://edoxen.org/schema/decision.yaml
title: Decision
type: object
additionalProperties: false
required: [identifier, kind, status]
properties:
  identifier:
    type: array
    items: { $ref: structured_identifier.yaml }
    minItems: 1
  urn: { type: string }
  kind:
    type: string
    enum: [resolution, order, ruling, determination,
           recommendation, statement, finding, opinion, other]
  status:
    type: string
    enum: [draft, proposed, under_consideration,
           decided, negatived, withdrawn, deferred]
  # ...
```

## Acceptance criteria

- All schemas validate against sample YAMLs (TODO 19)
- Schemas use `$ref` composition (DRY)
- additionalProperties: false everywhere
- CLI validation works (TODO 26)