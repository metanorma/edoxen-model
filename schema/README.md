# Edoxen Canonical Schemas

This directory holds the canonical JSON Schema (Draft 7) files for
Edoxen YAML data. These are the single source of truth — the Ruby gem
at [edoxen/edoxen](https://github.com/edoxen/edoxen) mirrors them.

## Files

| File | Validates | Root type |
|------|-----------|-----------|
| `decision-collection.yaml` | Decision YAML files (was Resolution) | `DecisionCollection` or single `Decision` |
| `meeting.yaml` | Meeting/Agenda YAML files | `Meeting` or `MeetingCollection` |

## Examples

The `examples/` directory has one fully-worked YAML per type:

- `decision-example.yaml` — a CIML Decision (real fixture from the gem)
- `meeting-example.yaml` — a CIML Meeting (from `samples/`)
- `agenda-example.yaml` — just the `agenda` section of a Meeting
