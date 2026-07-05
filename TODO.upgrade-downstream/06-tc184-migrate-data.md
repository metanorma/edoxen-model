# 06 — TC184: migrate data

## Goal

Convert all 86 YAMLs in `isotc184sc4/resolutions/plenary/` from
pre-v2 shape to v2.1 shape.

## Migration script

**Same script as TODO 02** — `scripts/migrate_to_v2.rb`. The script
is parameterised by `--prefix` and `--data-dir`. The TC184 invocation:

```sh
$ cd /Users/mulgogi/src/isotc184sc4/resolutions
$ bundle add edoxen --version "~> 2.1"
$ ruby scripts/migrate_to_v2.rb \
    --prefix "ISO/TC 184/SC 4" \
    --data-dir plenary \
    --legacy-dir legacy
$ bundle exec edoxen validate "plenary/*.yaml"
```

## Transformation rules

Identical to TODO 02. See that doc for the per-field mapping.

## Per-fixture notes

- TC184 file names encode date + location. The migration script does
  not change file names — only the YAML content.
- Some TC184 fixtures may use action verbs that aren't in
  `Edoxen::Enums::ACTION_TYPE`. The migration script flags these in
  the report; they need manual review (likely additions to a body
  vocabulary, not core enum changes).

## Acceptance criteria

Same as TODO 02 (TC154), with 86 fixtures instead of 41.
