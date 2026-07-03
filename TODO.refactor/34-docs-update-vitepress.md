# 34 — Docs: Update VitePress config + theme

## Why

`.vitepress/config.ts` controls nav, sidebar, search. Must reflect new structure.

## Files to modify

- `.vitepress/config.ts`
- `.vitepress/theme/index.ts` (or .js)
- `.vitepress/posts.data.ts` (if used)

## Sidebar structure

```
- Introduction
- Architecture
- Getting Started
  - Installation
  - CLI
  - Validation
  - Parse YAML
- Core Concepts
  - Meeting
  - MeetingSeries
  - MeetingComponent
  - Agenda
  - AgendaItem
- People
  - Officer
  - Attendance
- Place
  - Venue (polymorphic)
  - UNLOCODE / IATA
- Time
  - DateRange
  - Recurrence (ISO 8601-2)
- Outcomes
  - Decision
  - Motion
  - Voting
  - VoteRecord
- Topics
  - Topic
  - TopicDocument
  - TopicAsset
  - Reference
- Records
  - Minutes
  - MinutesSection
- Extensions
  - MeetingExtension
  - Profiles
  - LegCo profile (example)
- Multilingual
- Schema
```

## Acceptance criteria

- Sidebar reflects new structure
- Search works for all new terms
- Theme updated per TODO 33