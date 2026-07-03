# 07 — MeetingComponent: flat sub-events

## Why

A meeting can have sub-events: tracks (conferences), sessions,
debates (parliamentary), breakouts (IETF), opening/closing,
breaks, receptions.

These subsume the existing `ScheduleItem` (which was just a
timetable row). One concept, many kinds.

User (2026-07-03): "Flat for now" — no nesting.

## Files to create

- `models/meeting_component.lutaml`
- `models/component_kind.lutaml`

## Files to remove

- `models/schedule_item.lutaml` (subsumed)
- `models/schedule_item_localization.lutaml` (subsumed — localizations live on Component)

## Schema

```lutaml
class MeetingComponent {
  identifier: String
  urn: String
  kind: ComponentKind
  title: String
  description: String
  starts_at: DateTime
  ends_at: DateTime
  venue_refs: String[0..*]              # URNs → Meeting.venues (multi for bridged)
  chair: Person
  agenda_ref: String[0..1]              # URN → Agenda (if component has own agenda)
  minutes_ref: String[0..1]             # URN → Minutes
  attendance_refs: String[0..*]         # URNs → Meeting.attendance
  localizations: ComponentLocalization[0..*]
  extensions: MeetingExtension[0..*]
}

enum ComponentKind {
  # Substantive
  track, session, debate, breakout, bof,
  plenary_session, working_group_session,
  committee_of_the_whole, keynote,
  address, statement, question_time,
  # Procedural (replaces ScheduleItem)
  opening, closing, break, reception,
  registration, networking,
  other
}
```

## Dependencies

- TODO 01 (Venue — for venue_refs)
- TODO 09 (MeetingExtension)

## Acceptance criteria

- `MeetingComponent` is flat (no sub-components)
- `ComponentKind` has 18 values covering substantive + procedural
- `venue_refs[]` supports multi-venue bridged components
- `models/schedule_item.lutaml` removed