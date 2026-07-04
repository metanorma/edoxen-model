# 21 — LutaML ↔ Ruby sync spec (root-cause gap)

## Why

The v2.0 refactor landed across two repos:

- `edoxen-model/models/*.lutaml` — the canonical LutaML files.
- `edoxen/` — the Ruby gem that mirrors them.

Four drifts slipped through (audit doc: `20-post-v2-gem-drift.md`) because
**no spec asserts the two sides agree**. The existing sync specs
(`schema_enum_sync_spec`, `schema_model_sync_spec`,
`schema_meeting_enum_sync_spec`, `schema_meeting_model_sync_spec`) only
cover schema ↔ Ruby. The LutaML ↔ Ruby link — the leftmost segment of
the pipeline — has no regression net.

This is the root-cause gap. Closing it makes the next drift fail CI
immediately rather than surviving until a manual audit.

## Scope

A spec that, for every `class` declaration in `models/*.lutaml`:

1. Parses the file (line-based; no full LutaML grammar needed — the
   project's lutaml files use a small regular subset).
2. Finds the matching `Edoxen::*` Ruby class.
3. Asserts every LutaML attribute is present on the Ruby class
   (camelCase lutaml name → snake_case Ruby name) and vice versa.
4. Asserts collection flags agree (`Type[N..M]` in lutaml ↔
   `collection: true` in Ruby).
5. (Stretch) Asserts the type names map consistently
   (`String` → `:string`, `Integer` → `:integer`, custom classes
   resolve by name).

Enums are out of scope here — they are already covered by the
schema_enum_sync + schema_meeting_enum_sync pair (the schema mirrors
the gem's `Edoxen::Enums` constants, and a separate spec could assert
the lutaml `enum` blocks agree with `Edoxen::Enums::*`; deferred to a
follow-up if needed).

## Files to create

- `edoxen/spec/support/lutaml_parser.rb` — lightweight parser. Walks
  the file line-by-line, tracks the current `class` block, extracts
  each attribute line into a `LutamlAttr` struct (`name`, `type`,
  `collection` bool) and the class into a `LutamlClass` struct (`name`,
  `parent`, `attrs`).
- `edoxen/spec/edoxen/lutaml_ruby_sync_spec.rb` — the spec. Walks
  `../../edoxen-model/models/*.lutaml` (path resolved relative to
  `__dir__`), parses each, and for every class asserts attribute-name
  and collection-flag parity with the Ruby side.

## Path strategy

The gem's spec suite assumes `edoxen-model` is checked out as a sibling
directory (`../edoxen-model/`). This is already the layout the user
uses locally; CI may differ. Two options:

- (a) **Skip if the model dir is absent.** Spec prints a single
  pending message; CI doesn't fail when the sibling repo isn't there.
  Local runs (where the audit matters) do the work.
- (b) **Add a CI step that checks out both repos side-by-side.**
  More work; deferred.

Recommend **(a)** for v1 — the spec is most valuable during local
development and PR review, where the developer has both repos.

## camelCase ↔ snake_case

The lutaml files use camelCase attribute names (per the project's
commit 91b36f9 style guide). The gem uses snake_case Ruby attribute
names. The translation is mechanical:

```ruby
def snakeify(name)
  name
    .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
    .downcase
end
```

(Same helper the gem's `scripts/camel_to_snake_samples.rb` uses —
extract to `spec/support` rather than re-implementing.)

## Type-mapping table (stretch goal)

| LutaML type     | Ruby attr type                |
|-----------------|-------------------------------|
| `String`        | `:string`                     |
| `Integer`       | `:integer`                    |
| `Float`         | `:float`                      |
| `Boolean`       | `:boolean`                    |
| `Date`          | `:date`                       |
| `DateTime`      | `:date_time`                  |
| `EnumName`      | `:string, values: Enums::X`   |
| `ClassName`     | `ClassName` (Ruby constant)   |

For v1: skip type checking. Names + collection flags catch the
overwhelming majority of drifts (the audit's four cases were all
name-shape drifts, not type drifts).

## Acceptance criteria

- Spec parses every `*.lutaml` file under `edoxen-model/models/`.
- Spec skips `enum` blocks (covered elsewhere) and the
  `_subject_body.lutaml.deprecated` file.
- Spec resolves the sibling-repo path; skips with a pending message
  when the model dir is absent.
- For every `class` block, asserts:
  - lutaml attribute names ↔ Ruby attribute names (after snake_case).
  - lutaml `Type[N..M]` ↔ Ruby `collection: true`.
  - lutaml `Type` (no cardinality) ↔ Ruby `collection: false` (or nil).
- Reports drifts with both sides named (file + line + class + attr).
- All 719 existing specs still pass.

## Out of scope

- `enum` block ↔ `Edoxen::Enums::*` sync (deferred; the schema_enum
  specs already transitively cover this).
- Cross-file `$ref` resolution (the lutaml files don't use refs).
- Validating the LutaML grammar itself — use the official
  `lutaml` gem parser if/when a deeper check is wanted.
- Auto-fixing drift (the spec only reports; humans decide which side
  wins, per the audit's principle).
