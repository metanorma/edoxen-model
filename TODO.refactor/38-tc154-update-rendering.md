# 38 — TC154: Update Vue components with /frontend-design

## Why

TC154 site is Vue.js. All components touching meetings/resolutions need updating for new model.

## Files to update

- `src/components/` (Vue components)
- `src/views/` (page views)
- `src/composables/` (Vue composables)
- `src/types/` (TypeScript types)
- `src/router/` (routes)

## Approach

1. Invoke `/frontend-design` skill
2. Audit existing components
3. Update each to use new model fields
4. Add new components:
   - `DecisionDetail.vue`
   - `MotionTimeline.vue`
   - `VotingResults.vue`
   - `OfficerRoster.vue`
   - `VenueDisplay.vue` (polymorphic)
   - `TopicList.vue`

## Design system

- Use existing TC154 design language (ISO-branded)
- Add distinctive elements per /frontend-design

## Acceptance criteria

- All components updated
- New components added
- Site renders correctly with new data
- Accessibility WCAG 2.1 AA