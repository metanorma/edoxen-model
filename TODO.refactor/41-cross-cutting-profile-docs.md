# 41 — Cross-cutting: Profile documentation pattern

## Why

Adopters need a clear template for writing their own profiles. Document the pattern once.

## Files to create

- `docs/profiles/README.adoc` — how to write a profile
- `docs/profiles/template.adoc` — template
- `docs/profiles/legco.adoc` — full example (cross-link to TODO 16)
- `docs/profiles/us-congress.adoc` — second example
- `docs/profiles/ietf.adoc` — third example
- `docs/profiles/standards-body.adoc` — fourth example (OIML/ISO/ITU)

## Pattern documentation

```adoc
# Profile: <name>

## Namespace
profile = "<name>"

## Purpose
<what this profile is for>

## Extension kinds

### <kind 1>
- Hangs on: <entity>
- Maps to: <source>
- Attributes:
  - `key1` (String) — <description>
  - `key2` (String) — <description>

Sample YAML:
  extensions:
    - profile: <name>
      kind: <kind 1>
      attributes:
        - key: key1
          value: "..."
```

## Acceptance criteria

- Pattern documented clearly
- 4 example profiles written
- Template reproducible