# 04 — TC154: update browser

## Goal

Update `isotc154/www.isotc154.org` (Vue + Jekyll hybrid) so the
rendering code reads the v2.1 wire shape.

## Repo shape

The site:

- Sources data via `_data/resolutions/` git submodule (points at
  `isotc154/resolutions-data`).
- Renders via Vue components in `src/` + Jekyll pages in `content/`.
- Has TypeScript type definitions in `src/types/` describing the
  data shape.
- Has adapter code in `src/data/` and `src/domain/` that mediates
  between the YAML and the Vue components.

## Transformation rules

The adapter layer is the right place to absorb the wire-shape
change. Components should not need to change.

| Adapter / type | Change |
|----------------|--------|
| `src/types/resolution.ts` (or similar) | Rename type to `Decision`; add `kind`, `status`, `body_type`; restructure `identifier` to a list of `{prefix, number}`; wrap per-language fields in `localizations[]`. |
| `src/data/resolutions.ts` (or similar loader) | Iterate `decisions[]` not `resolutions[]`. For each, build a flattened view via `localizations[0]` (the eng entry). |
| `src/domain/` lookup helpers | Update to read `decision.identifier[0].number` not `resolution.identifier`. Update date accessors (`decision.dates[0].date` not `resolution.dates[0].start`). |

## Strategy

1. **Adapter-only change.** Components continue to call
   `decision.title`, `decision.subject`, `decision.actions[]`, etc.
   The adapter projects the v2.1 wire shape into a flat per-component
   view (matching the v0.7.x shape components already expect).
2. **One PR.** This keeps the surface area small; if the adapter is
   correctly written, no Vue component file needs to change.
3. **Visual regression.** The `npm run build` + Playwright snapshot
   tests should produce identical output before and after.

## Files to touch

Likely candidates (will confirm during implementation):

- `src/types/*.ts` — type definitions.
- `src/data/resolutions.ts` (or similar) — loader.
- `src/domain/*.ts` — lookup helpers.

Files that should NOT need to change:

- `src/components/*.vue` — Vue components.
- `content/*.md` — Jekyll content pages.

## Acceptance criteria

- [ ] Site builds (`npm run build`) without errors.
- [ ] All existing pages render with the same content as before
      (visual diff = none).
- [ ] One Playwright snapshot test passes (if the repo has them).
- [ ] No Vue component file is modified.

## Coupling

This PR depends on the `resolutions-data` submodule bump (TODO 02's
PR). The submodule update + browser update can land in the same PR
or sequentially.
