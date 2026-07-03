# 18 — Update README.adoc for broadened scope

## Why

The current README documents Edoxen as a standards-body-specific
Resolution model. After the refactor, Edoxen is a GENERIC
meeting/decision model with profile extensions.

## File to modify

- `README.adoc`

## New README structure

```
# Edoxen information models

## Purpose
 GENERIC meeting/decision model. Profile-based customization.

## Applicability
 - Standards bodies (ISO, ITU, OIML, ILO, BIPM)
 - Parliamentary bodies (UK Hansard, HK LegCo, US Congress)
 - Technical community meetings (IETF, W3C, Apache)
 - Academic conferences (Crossref-registered)
 - Corporate boards
 - Generic web/virtual meetings

## Information model
 LutaML files in `models/`. Organized by concern:
 - Identity & classification
 - Time & place
 - People
 - Documents
 - Outcomes (Decision, Motion, Voting)
 - Records (Minutes)
 - Extensions (profile mechanism)

## The Meeting trinity (+ 2)
 - Agenda (planned business)
 - Minutes (running record)
 - Decisions (formal outcomes)
 PLUS:
 - Motions (procedural acts)
 - Votings (state machines)

## Multilingual support
 (existing — unchanged)

## Profile mechanism
 ISO 8601-2 §15 profiles. Every core entity has `extensions[]`.
 See `references/profiles/legco.adoc` for the canonical example.

## Sample YAML
 (demonstrates polymorphic Venue, Decision, Motion, Voting,
 Topic, MeetingComponent, extensions)

## Ruby implementation
 (existing — updated for new model)

## ISO 8601-2 integration
 Dates, durations, recurrence via ISO 8601-2.
 See `references/iso8601-2.adoc`.

## UN/LOCODE + IATA integration
 Physical venues can be identified by UN/LOCODE or IATA code.
 Validation via the `unlocodes` and `iata` gems.
```

## Dependencies

- TODOs 01-17 (everything else must be done first)

## Acceptance criteria

- README reflects new generic scope
- Sample YAML in README uses new entities
- All cross-links work (references/, models/)