# 22 — LutaML enum ↔ Ruby sync (companion to TODO 21)

## Why

TODO 21 closed the LutaML class ↔ Ruby class sync gap but deliberately
deferred enum blocks:

> Enums are out of scope here — they are already covered by the
> schema_enum_sync + schema_meeting_enum_sync pair (the schema mirrors
> the gem's `Edoxen::Enums` constants, and a separate spec could assert
> the lutaml `enum` blocks agree with `Edoxen::Enums::*`; deferred to a
> follow-up if needed).

That transitively-cover story is half-true: schema_enum_sync covers
schema ↔ `Edoxen::Enums`, but nothing covers lutaml ↔ schema or
lutaml ↔ `Edoxen::Enums`. The lutaml files can drift from the gem's
constants and the only signal would be a reviewer noticing.

This TODO closes the gap by extending the existing
`spec/edoxen/lutaml_ruby_sync_spec.rb` (or a sibling spec) to also walk
every `enum` block in `models/*.lutaml` and assert each one matches
the corresponding `Edoxen::Enums::*` constant.

## Scope

For every `enum EnumName { ... }` block in `models/*.lutaml`:

1. Parse the block (already supported by `LutamlParser` — minor
   extension to emit `LutamlEnum` structs instead of discarding them).
2. Resolve the matching `Edoxen::Enums::*` constant by translating
   `EnumName` (CamelCase) to `ENUM_NAME` (SCREAMING_SNAKE_CASE).
3. Assert value-for-value equality.

Skips:

- The `// Superseded by` files (`resolution_type.lutaml` is the only
  enum among them — its replacement is `decision_kind.lutaml`).
- Enum names without a corresponding `Edoxen::Enums::*` constant.
  Today every enum has one; if a future enum is added without the
  constant, the spec surfaces the drift.

## Naming convention

The project's enum-naming convention is consistent:

- File: `models/foo_kind.lutaml`, `models/foo_status.lutaml`,
  `models/foo_type.lutaml`, `models/foo_outcome.lutaml`,
  `models/foo_role.lutaml`, etc.
- LutaML block name: `FooKind`, `FooStatus`, etc. (PascalCase of the
  file basename).
- Ruby constant: `Edoxen::Enums::FOO_KIND`, `FOO_STATUS`, etc.
  (SCREAMING_SNAKE_CASE of the block name).

The translation is the same `snakeify` helper used for class attrs,
uppercased.

## Files to modify

- `edoxen/spec/support/lutaml_parser.rb` — emit `LutamlEnum` structs
  alongside `LutamlClass` structs. Return value of `parse` becomes
  `{ classes:, enums: }` (or two methods; pick one and stick with it).
- `edoxen/spec/edoxen/lutaml_ruby_sync_spec.rb` — add a second
  describe block that walks every enum block and asserts the matching
  `Edoxen::Enums::*` constant.

## Acceptance criteria

- Spec parses every `enum` block in `models/*.lutaml`.
- For every enum, finds the matching `Edoxen::Enums::*` constant.
- Asserts value-for-value equality (order-independent; same set).
- Reports drifts with both sides named (file + enum + values diff).
- All existing specs still pass.

## Out of scope

- Type-checking of `attribute :foo, :string, values: Enums::X` — the
  class sync (TODO 21) does not check that the enum-typed attribute
  resolves to the named enum class. Defer; the existing drift surface
  is small.
- Cross-enum consistency (e.g., a class with `kind: FooKind` should
  have `FooKind` defined). Out of scope; would require resolving type
  references.
- Auto-fixing drift.
