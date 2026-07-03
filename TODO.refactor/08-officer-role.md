# 08 — Officer + OfficerRole (replaces chair/secretary shortcuts)

## Why

Current Meeting has:
- `chair: Person`
- `secretary: Person`
- `host: String`
- `hosts: HostRef[0..*]`

Four different ways to encode "people related to the meeting"
— not MECE. Unify into one `officers[]` list with role enum.

Keep `hosts` (organizational, distinct from people).

## Files to create

- `models/officer.lutaml`
- `models/officer_role.lutaml`

## Schema

```lutaml
class Officer {
  role: OfficerRole
  person: Person
  term_start: Date[0..1]
  term_end: Date[0..1]
  extensions: MeetingExtension[0..*]
}

enum OfficerRole {
  chair,
  vice_chair,
  deputy_chair,
  secretary,
  treasurer,
  parliamentarian,
  presiding_officer,
  sergeant_at_arms,
  other
}
```

## Dependencies

- TODO 09 (MeetingExtension)
- TODO 12 (Extend Meeting — adds `officers[]`, removes `chair`/`secretary`)

## Acceptance criteria

- `Meeting.officers: Officer[0..*]`
- `Meeting.chair` and `Meeting.secretary` REMOVED
- `Meeting.host` (singular String) REMOVED — use `hosts[]`
- OfficerRole has 9 values