# 15 — references/iso8601-2.adoc with `@` includes

## Why

User (2026-07-02): "for important things like RRULE and dates
can be implemented using ISO 8601-2 (@../../iso-8601-2/sources/iso-8601-2-2026/ syntax)."

The AsciiDoc `@` prefix is the include directive. Edoxen's
recurrence reference doc should INCLUDE the relevant ISO 8601-2
sections verbatim, not paraphrase them.

## File to create

- `references/iso8601-2.adoc`

## Content

```adoc
ISO 8601-2 — Date and Time Extensions
=====================================

ISO 8601-2 (2nd edition, 2026) extends ISO 8601 with
formal syntax for time intervals, durations, recurring
time intervals, and profiles. Edoxen adopts ISO 8601-2
as the canonical date/time/recurrence standard.

Source: /Users/mulgogi/src/iso-8601-2/sources/iso-8601-2-2026/
(referenced via AsciiDoc `@` includes — verbatim text from
the ISO standard)


## Time intervals (§10)

include::../../iso-8601-2/sources/iso-8601-2-2026/sections/10-extended-time-interval-representations.adoc[]


## Durations (§11)

include::../../iso-8601-2/sources/iso-8601-2-2026/sections/11-explicit-duration-and-extensions.adoc[]


## Date/time selection (§12)

include::../../iso-8601-2/sources/iso-8601-2-2026/sections/12-date-time-selection.adoc[]


## Recurring time intervals (§13)

include::../../iso-8601-2/sources/iso-8601-2-2026/sections/13-recurring-time-intervals.adoc[]


## Date/time calculations (§14)

include::../../iso-8601-2/sources/iso-8601-2-2026/sections/14-date-time-calculations.adoc[]


## Profiles (§15)

include::../../iso-8601-2/sources/iso-8601-2-2026/sections/15-profiles.adoc[]


## Edoxen mapping

- `Recurrence` (TODO 10) — implements §13 as a structured,
  queryable class
- `DateRange` (existing) — implements §10
- `MeetingExtension` (TODO 09) — implements §15 profile concept
  for adopter customization
```

## Path verification

Before writing this file, verify that the relative path from
`/Users/mulgogi/src/edoxen/edoxen-model/references/` to
`/Users/mulgogi/src/iso-8601-2/sources/iso-8601-2-2026/sections/`
is `../../iso-8601-2/sources/iso-8601-2-2026/sections/`.

## Acceptance criteria

- `references/iso8601-2.adoc` exists
- All 6 sections included via `@` directive
- File renders correctly when built with asciidoctor
- Path to ISO 8601-2 source verified