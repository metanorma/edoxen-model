# 47 — Tighten MeetingExtension

**Status**: design proposed, implementation deferred to v2.1

## Context

The v2.0 `MeetingExtension` is under-specified:

```ruby
class MeetingExtension {
  profile: String
  kind: String              # undocumented — what's it for?
  ref: String               # undocumented — what's it for?
  attributes: ExtensionAttribute[0..*]
  extensions: MeetingExtension[0..*]   # recursive — why?
}

class ExtensionAttribute {
  key: String
  value: String             # always String — loses Int/Float/Bool/Date
}
```

### Concerns

1. **`kind` and `ref` have no documented meaning.** Profiles will diverge
   in how they use them. The legco profile shows usage but doesn't
   establish a convention.

2. **Recursive `extensions[]` is over-engineered.** No use case is
   documented. If a profile needs nested extensions, the `attributes`
   key-value pairs are usually enough. Recursion invites complexity.

3. **`ExtensionAttribute.value: String` loses type information.** A
   profile that records `quorum: 7` gets "7" not Integer 7. A profile
   that records `meeting.start: 2026-07-03T10:00` gets the string, not
   a DateTime. Consumers must parse on read.

## Proposed

### Document `kind` and `ref`

Either:

**(a)** Remove them if the legco profile doesn't use them.

**(b)** Document their canonical meanings:
- `kind` — discriminator within the profile (e.g., legco's
  "division", "public_bill_committee_stage")
- `ref` — URN of the profile document this extension comes from

### Remove recursive `extensions[]`

Unless a concrete use case emerges, drop the recursion. If nesting is
needed later, add it back. YAGNI.

### Polymorphize `ExtensionAttribute.value`

Replace the single String field with a typed-value structure:

```ruby
class ExtensionAttribute {
  key: String
  
  # Exactly one of the following should be set.
  stringValue: String
  intValue: Integer
  floatValue: Float
  booleanValue: Boolean
  dateValue: Date
  dateTimeValue: DateTime
  
  # Type discriminator for serialization
  type: String  # "string" | "int" | "float" | "bool" | "date" | "datetime"
}
```

Or, if the LutaML type system supports it:

```ruby
class ExtensionAttribute {
  key: String
  value: String | Integer | Float | Boolean | Date | DateTime
}
```

## Acceptance criteria

- [ ] `kind` and `ref` either documented or removed
- [ ] Recursive `extensions[]` removed (or justified with a use case)
- [ ] `ExtensionAttribute.value` polymorphic (or documented as String-only
      with rationale)
- [ ] legco profile updated to match the tightened shape
- [ ] Architectural spec asserts "MeetingExtension fields are documented"
