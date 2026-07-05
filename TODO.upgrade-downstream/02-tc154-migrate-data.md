# 02 — TC154: migrate data

## Goal

Convert all 41 YAMLs in `isotc154/resolutions-data/{plenary,ballots,7372ma}/`
from pre-v2 shape to v2.1 shape.

## Migration script

`scripts/migrate_to_v2.rb` — parameterised by body prefix (so the
same script handles TC154 + TC184). See TODO 06 for the TC184
invocation.

### Per-fixture transformation rules

| v0.7.x | v2.1 | Notes |
|--------|------|-------|
| `metadata:` (top-level) | `metadata:` (top-level, mostly unchanged) | `dates:` shape changes (see below). |
| `metadata.dates: [{start, end, kind: meeting}]` | `metadata.date: <start>` | Drop the array; v2.1 DecisionMetadata.date is a single Date. Keep `start` (or `end` if `start` missing). |
| `resolutions:` | `decisions:` | Rename. |
| Resolution `identifier: '88'` (string) | Decision `identifier: [{prefix: "ISO/TC 154", number: "88"}]` | Wrap in StructuredIdentifier list. Prefix from `--prefix` flag. |
| Resolution (no `kind`) | Decision `kind: resolution` | Default; ballot files may use `kind: recommendation` if appropriate. |
| Resolution (no `status`) | Decision `status: decided` | Default; all pre-v2 resolutions are post-adoption. |
| Resolution `dates: [{start, end, kind: decision}]` | Decision `dates: [{date: <start>, type: "adoption"}]` | Flatten the triple. `kind=decision` → `type=adoption`. `kind=effective` → `type=effective`. `kind=ballot` → `type=adoption` (ballots are adoptions). |
| Resolution `subject`, `title`, `considerations`, `approvals`, `actions`, `considering` | Wrap into `localizations: [{language_code: "eng", script: "Latn", subject:, title:, considering:, considerations:, approvals:, actions:}]` | Single language (eng) for TC154. |
| Action `dates: [{start, end, kind: effective}]` | Action `date_effective: {date: <start>, type: "effective"}` | Flatten. |
| Approval `dates: [{start, end, kind: decision}]` | Approval `date: {date: <start>, type: "adoption"}` | Flatten. |
| Consideration `dates: [{start, end, kind: effective}]` | Consideration `date_effective: {date: <start>, type: "effective"}` | Flatten. |

### Edge cases flagged in the audit

- **Ballot fixtures** (`ballots/*.yaml`): each "resolution" is a
  ballot-resolution. The migration treats them as Decisions with
  `kind: resolution` (the ballot metadata lives in the title).
- **7372ma fixture**: single fixture with the same shape; migrates
  identically.
- **Identifier prefixes**: TC154 uses bare numbers (`'88'`); the
  migration wraps as `{prefix: "ISO/TC 154", number: "88"}`.

## File layout

```
isotc154/resolutions-data/
├── plenary/                # migrated YAMLs (v2.1 shape)
├── ballots/                # migrated YAMLs (v2.1 shape)
├── 7372ma/                 # migrated YAMLs (v2.1 shape)
├── legacy/                 # NEW: original v0.7.x YAMLs (backup)
└── scripts/
    └── migrate_to_v2.rb    # NEW: migration script
```

## Verification

```sh
$ cd /Users/mulgogi/src/isotc154/resolutions-data
$ bundle add edoxen --version "~> 2.1"  # bump from "edoxen" (latest 0.7.x)
$ ruby scripts/migrate_to_v2.rb --prefix "ISO/TC 154" --legacy-dir legacy
$ bundle exec edoxen validate "{plenary,ballots,7372ma}/*.yaml"
```

The migration prints a per-file report. Any fixture the script
couldn't migrate mechanically (e.g. one with a missing `identifier`)
is flagged in the report and skipped — never silently corrupted.

## Idempotence

Running the script twice produces identical output. The script
detects already-migrated files (presence of `decisions:` key) and
skips them.

## Acceptance criteria

- [ ] 41/41 YAMLs migrated to v2.1 shape.
- [ ] `bundle exec edoxen validate "{plenary,ballots,7372ma}/*.yaml"`
      exits 0.
- [ ] `legacy/` directory contains all 41 originals.
- [ ] Migration script is idempotent.
- [ ] `bundle exec edoxen normalize "{plenary,ballots,7372ma}/*.yaml" --inplace`
      round-trip is a no-op (i.e. the migration output is canonical).
