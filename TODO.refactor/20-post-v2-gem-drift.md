# 20 — Post-v2 model↔gem drift to close

## Context

The v2 refactor landed across two repos:

- `edoxen-model` (this repo) — canonical LutaML files
- `edoxen/` — Ruby gem + JSON-Schemas

A post-v2 audit of the gem (2026-07-04) surfaced four places where the
model and the gem no longer agree. The gem's CLAUDE.md promises
"The Ruby model is faithful to the LUTAML files" — that contract is
currently broken in the four cases below. Each one is small in
isolation; together they erode the invariant that lets reviewers read
either side as canonical.

This doc proposes the model-side changes. Companion gem-side changes
will land in `edoxen/edoxen` PR #20 (or a successor).

## Principle

> When the model and the gem disagree, the model is canonical — *unless*
> the gem's behavior is the deliberate choice and the model wasn't
> updated. Decide which side wins per item; do not let them drift.

The drifts split into two buckets:

- **A. Gem is correct, model is stale** (3 cases). Fix: update the model.
- **B. Model declares something the gem doesn't implement** (1 case).
  Fix: decide whether the model is aspirational (then implement in the
  gem) or vestigial (then remove from the model).

---

## A. Model is stale — update the lutaml

### A1. `models/voting.lutaml` — `method` was never renamed to `votingMethod`

**Symptom.** Both CHANGELOGs (this repo's `CHANGELOG.adoc` and the
gem's `CHANGELOG.md`) claim the rename happened in commit
`11a57ba fix(model): rename Voting.method → votingMethod`. The actual
`models/voting.lutaml` was not touched by that commit — only the
sample YAMLs were. Today:

```lutaml
class Voting {
  method: VotingMethod     # ← still camelCase name pre-rename
  ...
}
```

**Gem-side state.** The Ruby attribute is `voting_method`
(snake_case from `votingMethod`), and the wire form is `voting_method`.
The rename is real on the gem side; only the lutaml missed it.

**Why it matters.** `lutaml-model` (and any future code generator or
doc generator fed by these files) will emit `method:` — which shadows
Ruby's `Object#method` and breaks the gem's voting.rb. The rename
exists *because* of that conflict; leaving the lutaml on the old name
re-introduces the bug the rename was meant to prevent.

**Proposed fix.**

```lutaml
class Voting {
  votingMethod: VotingMethod
  ...
}
```

Update `samples/*.yaml` to use `votingMethod:` if any still say
`method:` (the camelCase form is correct on the wire per the
convention; the gem's snake_case `voting_method` is the Ruby-side
attribute).

### A2. `models/agenda.lutaml` — three drifts in one file

**Symptom.** Today:

```lutaml
class Agenda {
  identifier: StructuredIdentifier[0..*]
  status: AgendaStatus
  source_doc: String                    # ← snake_case typo
  items: AgendaItem[0..*]
  opening_session: ScheduleItem         # ← should be removed
  closing_session: ScheduleItem         # ← should be removed
}
```

**Three problems.**

1. **`opening_session` / `closing_session` are still here.** The
   CHANGELOG says: *"Removed `Agenda.openingSession` / `closingSession`.
   Use MeetingComponents."* The gem's `lib/edoxen/agenda.rb` removed
   them. The model didn't.
2. **`source_doc` is snake_case** — every other attribute in this file
   is camelCase (`agendaItem`, `dateRange`, etc.). This is a typo from
   when the file was first written; the gem accepts `source_doc` as
   the wire name today, so fixing the typo also requires a wire-name
   decision (see "Open question" below).
3. **Missing `extensions: MeetingExtension[0..*]`.** Every other v2
   entity that hosts profile data (Decision, Meeting, Motion, Voting,
   Topic, TopicDocument, TopicAsset, Officer, MeetingComponent,
   MeetingSeries, Recurrence, Person, VoteRecord, Attendance,
   AgendaItem, Venue) has `extensions[]`. Agenda was missed.

**Proposed fix.**

```lutaml
class Agenda {
  identifier: StructuredIdentifier[0..*]
  status: AgendaStatus
  sourceDoc: String                     # camelCase, matches the rest
  items: AgendaItem[0..*]
  extensions: MeetingExtension[0..*]
}
```

**Open question — `source_doc` vs `sourceDoc`.** The gem currently
serializes this field as `source_doc` (snake_case wire name matching
the Ruby attribute). If the model moves to `sourceDoc`, that's a
breaking change to every existing agenda fixture. Two options:

- (a) Rename wire-side to `sourceDoc` to match the rest of the file.
  Update the gem and all fixtures in the same PR. **Recommended** —
  consistent with the camelCase convention.
- (b) Keep the wire name `source_doc` and add an explicit note that
  this attribute is the one exception. Not recommended — exceptions
  rot into folklore.

**Affected gem files if (a):** `lib/edoxen/agenda.rb` (attribute
stays `source_doc`; the wire mapping stays `source_doc` because the
gem's wire form is snake_case across the board — this is actually a
non-issue on the wire side, only on the model-side attribute name).
The model uses camelCase attribute names that the gem maps to
snake_case wire form; this is already the convention everywhere else.

### A3. `models/url.lutaml` — missing

**Symptom.** The gem has `lib/edoxen/url.rb` defining `class Url`
with `kind` (URL_KIND enum: access, report), `ref`, `format`. The
schema's `$defs/Url` mirrors it. `Decision#urls: Url[0..*]` references
it. The lutaml repo has *no* `url.lutaml` file.

**Why it matters.** The lutaml repo is supposed to be the canonical
source. Today, `Url` exists only in derived artifacts — like a header
file with no corresponding `.c`.

**Proposed fix.** Add `models/url.lutaml`:

```lutaml
// URL with a kind (access / report) and an optional format hint.
// Used by Decision#urls.
class Url {
  kind: UrlKind
  ref: String
  format: String
}
```

And `models/url_kind.lutaml`:

```lutaml
enum UrlKind {
  access
  report
}
```

(Or merge `UrlKind` into an existing enum file if a multiple-values-per-
file convention is preferred — but every other enum in this repo has
its own file, so the one-file-per-enum convention wins.)

---

## B. Model is aspirational — decide gem-side

### B1. `models/subject_body.lutaml` — declared, never implemented in gem

**Symptom.** The lutaml repo declares:

```lutaml
class SubjectBody {
  name: String
  organization: String
  identifier: String
  role: String
  kind: String
}
```

with the comment: *"Used by Localization#subject when the subject is
more than a plain string."* But the gem's `Localization#subject` is
just `:string` — there is no `SubjectBody` Ruby class, no schema
`$defs/SubjectBody`, no fixture that exercises it.

**Why it matters.** Either the gem is missing a feature, or the model
is carrying vapor. Both states are bad:

- If **missing feature**: a downstream consumer reading the model
  would expect `subject:` to accept either a string or a `SubjectBody`
  object. The gem silently drops everything except strings.
- If **vapor**: the model is wider than reality, and the next person
  to write a code generator off it will emit a class that has no
  backing semantics.

**Two ways out — pick one.**

- **(a) Implement in the gem.** Add `Edoxen::SubjectBody`, change
  `Localization#subject` from `:string` to a union (`:string |
  SubjectBody`), add `$defs/SubjectBody` to the schema, add a fixture.
  Cost: ~50 lines of Ruby + schema + spec.
- **(b) Remove from the model.** Delete `models/subject_body.lutaml`.
  Cost: 1 file delete. Document in `CHANGELOG.adoc` that the
  structured-subject concept was considered and dropped.

**Recommendation: (b)** unless there's a known downstream consumer
asking for it. The Glossarist-style flat `subject: String` is fine
for the standards-body use case (where subjects are short topical
strings like "JWG 1 work programme"); structured subjects are a
parliamentary use case (bill numbers, committee codes) that can be
expressed via the profile mechanism (`MeetingExtension#attributes`)
when it shows up.

If the answer is (b), the deletion should land in this repo's next
minor release. If (a), the gem-side implementation should be tracked
in the gem repo and this lutaml file stays as the spec.

---

## Verification

After the model changes land, the gem's sync specs are the
verification:

- `spec/edoxen/schema_model_sync_spec.rb` — Ruby ↔ `$defs` shape.
- `spec/edoxen/schema_enum_sync_spec.rb` — enum values.
- `spec/edoxen/schema_cross_file_sync_spec.rb` — edoxen.yaml ↔
  meeting.yaml shared $defs (new in this audit).

There is currently **no spec in either repo** that asserts
`edoxen-model/models/*.lutaml` parses and matches the gem's Ruby
classes. That is the root-cause gap that let all four drifts slip.
Adding such a spec (lutaml parser → Ruby model → diff) would be a
worthwhile follow-up but is out of scope here.

## Proposed PR order

1. **A1 + A2 + A3** as one PR to this repo — they are mechanical model
   updates with no semantic debate.
2. **B1** as a separate PR — it needs a maintainers' call on
   (a) vs (b) before code is written.
3. Companion gem-side PR (`edoxen/edoxen`) adding the
   `MeetingExtension[0..*]` field to `DecisionMetadata` (the inverse
   drift: gem is missing what the model declares). Not in this doc's
   scope but noted for completeness.

## Out of scope

- Restructuring the duplicated `$defs` between the gem's
  `schema/edoxen.yaml` and `schema/meeting.yaml` into a shared
  `_shared.yaml`. The gem has a sync spec enforcing they stay aligned;
  the duplication is intentional (self-contained schemas per file).
- Adding a structured lutaml → Ruby code generator.
- Migrating any fixtures.
