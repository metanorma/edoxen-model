# 30 — Docs site: Refactor structure for new model

## Why

`edoxen.github.io/docs/` has 25 markdown files reflecting the OLD model (Resolution, etc.). Restructure for new generic model.

## Files to add/remove

Remove (or rename):
- `docs/resolution.md` → `docs/decision.md`
- `docs/resolution-set.md` → `docs/decision-collection.md`
- `docs/metadata.md` → `docs/decision-metadata.md`

Add new pages (see TODO 31).

## Sidebar nav update

- `.vitepress/config.ts` — reorganize sidebar

## Acceptance criteria

- All `docs/*.md` reflect new model
- No `Resolution` references (except as DecisionKind value)
- Sidebar organized by concern (identity, time, place, people, outcomes, etc.)