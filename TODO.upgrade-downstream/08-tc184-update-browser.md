# 08 — TC184: update browser

## Goal

Update the in-repo `browser/` (Vue + Vite) so the rendering code
reads the v2.1 wire shape.

## Strategy

Same as TODO 04 (TC154): adapter-only change. Components continue
to consume a flat view; the adapter projects v2.1 → flat.

## Files to touch

Likely:

- `browser/src/types/*.ts` — type definitions.
- `browser/src/data/*.ts` — loader.
- `browser/src/domain/*.ts` — lookup helpers.

Files that should NOT need to change:

- `browser/src/components/*.vue` — Vue components.
- `browser/src/views/*.vue` — page views.

## Acceptance criteria

- [ ] `npm run build` succeeds.
- [ ] All existing pages render with the same content as before.
- [ ] No Vue component file is modified.

## Coupling

This PR is in the same repo as the data migration (TODO 06). They
can land in one PR or sequentially.
