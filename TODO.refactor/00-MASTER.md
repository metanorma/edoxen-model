# Edoxen Refactor — Master Plan

## Context

The Edoxen information model is being broadened from a
standards-body-specific Resolution model to a GENERIC
meeting/decision model that covers:

- Standards bodies (ISO, ITU, OIML, ILO, BIPM)
- Parliamentary bodies (UK Hansard, HK LegCo, US Congress)
- Technical community meetings (IETF, W3C, Apache)
- Academic conferences (Crossref-registered)
- Corporate boards (Apache Foundation pattern)
- Generic web/virtual meetings (iCalendar semantics)

The architectural principle is **generic core + profile
extensions** (per user feedback 2026-07-02/03):

- Core schema is the intersection of all meeting domains
- Domain-specific concepts live in profile extensions
- iCalendar features are referenced, not duplicated
- Date/recurrence uses ISO 8601-2 syntax (not iCalendar RRULE)
- Location uses polymorphic Venue with UNLOCODE + IATA support
- Hard breaks preferred over back-compat shims

## Repositories in scope

1. `edoxen-model` (this repo) — canonical LutaML model
2. `edoxen/` — Ruby gem implementation
3. `edoxen.github.io/` — VitePress documentation site
4. `oimlsmart/resolutions-data/` — OIML CIML meeting/resolution data
5. `isotc154/www.isotc154.org/` — ISO/TC 154 website (Vue + Jekyll)
6. `isotc184sc4/resolutions/` — ISO/TC 184/SC 4 plenary resolutions

## Architectural constraints (must hold throughout)

### Ruby code (edoxen gem + downstream Ruby)

- **NEVER** use `send` to call private methods
- **NEVER** use `instance_variable_set` or `instance_variable_get`
- **NEVER** use `respond_to?` for type checking (use `is_a?` or
  design the type hierarchy so the check isn't needed)
- **NEVER** use `require_relative` for internal library code
- **NEVER** use `require` with a path to code within your own library
- **ALWAYS** use Ruby `autoload`
- **ALWAYS** define autoload entries in the immediate parent
  namespace's file — create that file if it doesn't exist
- **NEVER** use doubles in specs — use real model instances or
  lightweight Structs
- **NEVER** hand-roll `to_h` / `from_h` / `to_json` / `from_json`
  on model classes — use lutaml-model declarations + mappings

### LutaML model files

- One `.lutaml` file per concept
- Closed enums for finite value sets; open `String` for
  adopter-extensible kinds
- Every entity has `extensions: MeetingExtension[0..*]` slot
  for profile customization
- Cross-references via URN (String), not direct composition,
  when the same entity can be referenced from multiple parents

### Frontend code

- Use `/frontend-design` skill for all rendering work
- Component-driven, accessible, no AI-generic aesthetics
- Read existing site's design language before refactoring

## Phase sequencing

**Phase A — Edoxen-model (this repo)** — TODOs 01-20
Foundation. Everything else depends on this. MUST complete
before Phase B starts.

**Phase B — Edoxen gem** — TODOs 21-29
Ruby implementation of the new model. Schema sync, CLI,
specs, integration with `unlocodes` and `iata` gems.

**Phase C — Edoxen docs site** — TODOs 30-34
VitePress content refactor + frontend redesign.

**Phase D — Downstream migrations** — TODOs 35-43
Three repos with their own data shapes and rendering stacks.
Each migration is its own sub-project with data + rendering
work. Use `/frontend-design` skill for rendering updates.

## TODO index

### Phase A — Edoxen-model

- [01 — Venue: polymorphic physical/virtual with UNLOCODE + IATA](01-venue-polymorphic.md)
- [02 — Decision base type (rename from Resolution)](02-decision-base-type.md)
- [03 — Motion: procedural act entity](03-motion-procedural-act.md)
- [04 — Voting: state machine with methods and outcomes](04-voting-state-machine.md)
- [05 — Topic / TopicDocument / TopicAsset](05-topic-document-asset.md)
- [06 — MeetingSeries: parent of recurring meetings](06-meeting-series.md)
- [07 — MeetingComponent: flat sub-events](07-meeting-component.md)
- [08 — Officer + OfficerRole (replaces chair/secretary shortcuts)](08-officer-role.md)
- [09 — MeetingExtension: profile mechanism](09-meeting-extension.md)
- [10 — Recurrence: structured ISO 8601-2 §13](10-recurrence-iso8601-2.md)
- [11 — New enums: VenueKind, Visibility, AttendanceRole, AttendanceResponse, ComponentKind, etc.](11-new-enums.md)
- [12 — Extend Meeting entity](12-extend-meeting.md)
- [13 — Extend Attendance, AgendaItem, Person](13-extend-attendance.agenda.person.md)
- [14 — Rename Resolution → Decision across all files](14-rename-resolution-to-decision.md)
- [15 — references/iso8601-2.adoc with `@` includes](15-references-iso8601-2.md)
- [16 — references/profiles/legco.adoc — first profile](16-references-profile-legco.md)
- [17 — Update existing references with generic-core mapping](17-references-update-existing.md)
- [18 — Update README.adoc for broadened scope](18-update-readme.md)
- [19 — Create sample YAML demonstrating broadened scope](19-sample-yaml.md)
- [20 — Schema sync spec (LutaML ↔ gem ↔ JSON Schema)](20-specs-for-model.md)

### Phase B — Edoxen gem

- [21 — Refactor gem to autoload structure](21-gem-autoload-structure.md)
- [22 — Remove anti-patterns (send, instance_variable_*, respond_to?, require_relative)](22-gem-remove-anti-patterns.md)
- [23 — Add new model classes (Decision, Motion, Voting, etc.)](23-gem-new-model-classes.md)
- [24 — Add new enum classes](24-gem-new-enum-classes.md)
- [25 — Update JSON Schemas (edoxen.yaml, meeting.yaml)](25-gem-update-json-schemas.md)
- [26 — Update CLI commands](26-gem-update-cli.md)
- [27 — Integrate unlocodes + iata gems for venue validation](27-gem-integrate-unlocodes-iata.md)
- [28 — Update RBS signatures (sig/edoxen.rbs)](28-gem-update-rbs.md)
- [29 — Comprehensive specs for all new entities](29-gem-comprehensive-specs.md)

### Phase C — Edoxen docs site

- [30 — Refactor docs structure for new model](30-docs-restructure.md)
- [31 — Add new pages (decision, motion, voting, venue, topic, etc.)](31-docs-new-pages.md)
- [32 — Update existing pages with new terminology](32-docs-update-existing.md)
- [33 — Frontend redesign with /frontend-design skill](33-docs-frontend-redesign.md)
- [34 — Update VitePress config + theme](34-docs-update-vitepress.md)

### Phase D — Downstream migrations

- [35 — OIML: migrate YAML data to new schema](35-oiml-migrate-data.md)
- [36 — OIML: update rendering code with /frontend-design](36-oiml-update-rendering.md)
- [37 — TC154: migrate site data to new schema](37-tc154-migrate-data.md)
- [38 — TC154: update Vue components with /frontend-design](38-tc154-update-rendering.md)
- [39 — TC184/SC4: migrate plenary YAML to new schema](39-tc184sc4-migrate-data.md)
- [40 — TC184/SC4: update browser/ with /frontend-design](40-tc184sc4-update-rendering.md)
- [41 — Profile documentation pattern (adopters write profiles)](41-cross-cutting-profile-docs.md)
- [42 — Migration guide for downstream consumers](42-cross-cutting-migration-guide.md)
- [43 — CHANGELOG with breaking changes + migration notes](43-cross-cutting-changelog.md)

## Execution discipline

- Each TODO has acceptance criteria — don't mark complete unless met
- Run `bundle exec rubocop` and `bundle exec rake spec` after
  every Phase B-D change
- Commit after each TODO completes (small commits, not batched)
- Push branches, not main — open PRs for review
- Never push tags or commit to main without explicit user approval
- Never add AI attribution (`Co-authored-by`, `Generated with`)
- When in doubt, STOP and ASK

## Realistic session scope

This plan represents 100+ hours of work. In one session:

- ALL TODO files will be written (the plan is complete)
- Phase A (TODOs 01-20) will be executed — the canonical
  model will be in place
- Phase B (TODOs 21-29) will be started — gem refactor
  in progress
- Phase C-D will be deferred to subsequent sessions, with
  the TODO files providing the roadmap

User can review after Phase A and redirect before Phase B
touches the gem.
## Phase E — v2.1 architectural follow-ups (post-v2.0-merge)

These are NOT blocking v2.0 — they're the architectural debt the audit
identified. Track them as separate issues for the v2.1 cycle.

- [44 — EntityRef: typed cross-references (replacing bare String)](44-entityref-typed-cross-references.md)
- [45 — MECE: collapse bidirectional arrays storing the same relationship](45-mece-collapse-bidirectional-arrays.md)
- [46 — Open enums: replace `other` escape hatches with body_vocabulary](46-open-enums-body-vocabulary.md)
- [47 — Tighten MeetingExtension (document kind/ref, drop recursion, polymorphize value)](47-tighten-meeting-extension.md)
