# 03 — TC154: validate + GHA

## Goal

Update `.github/workflows/validate.yml` so CI:

1. Pins edoxen to `~> 2.1` (currently unpinned, pulling latest 0.7.x).
2. Validates migrated YAMLs against the v2.1 schema.
3. Reports per-file failures with line-accurate errors.

## Workflow diff

```yaml
# Before
- name: Validate all YAML files
  run: |
    bundle exec edoxen validate "{plenary,ballots,7372ma}/*.yaml"

# After
- name: Validate all YAML files (v2.1 schema)
  run: |
    bundle exec edoxen validate "{plenary,ballots,7372ma}/*.yaml" \
      || (echo "::error::Validation failed; see edoxen output above" && exit 1)
```

Plus a `Gemfile` change:

```ruby
# Before
gem 'edoxen'

# After
gem 'edoxen', '~> 2.1'
```

The `bundle exec edoxen validate` command's exit code already
reflects per-file success/failure; the change is mostly cosmetic
(adding the GitHub Actions `::error` annotation so failures surface
in the PR review UI).

## Schema URL refresh

Each fixture carries a yaml-language-server comment pointing at
the live schema. The migration script (TODO 02) updates the URL to:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/edoxen/edoxen/refs/heads/main/schema/edoxen.yaml
```

(Note: `edoxen/edoxen` not `metanorma/edoxen` — the repo moved.)

## Acceptance criteria

- [ ] `Gemfile` pins `edoxen ~> 2.1`.
- [ ] `validate.yml` runs against the new shape.
- [ ] A failing fixture (deliberately corrupted) fails CI.
- [ ] A passing fixture (the migrated data) passes CI.
- [ ] GHA annotation surfaces the failure in the PR review UI.
