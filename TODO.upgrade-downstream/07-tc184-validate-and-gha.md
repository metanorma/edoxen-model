# 07 — TC184: validate + GHA

## Goal

Update `.github/workflows/{validate,deploy-pages}.yml` so CI:

1. Pins edoxen to `~> 2.1`.
2. Validates migrated YAMLs against the v2.1 schema.
3. Gates the deploy job on validation passing.

## Workflow diff

Same shape as TODO 03 (TC154):

- `Gemfile` pins `edoxen ~> 2.1`.
- `validate.yml` runs against the new shape.
- `deploy-pages.yml` `needs: validate` (already the case; just ensure
  the dependency is preserved).

## Schema URL refresh

Migration script updates each fixture's yaml-language-server comment
to point at `edoxen/edoxen` (not `metanorma/edoxen`).

## Acceptance criteria

Same as TODO 03.
