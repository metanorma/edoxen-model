# One-shot refactor scripts

These scripts were used during the v2.0 refactor and are kept here for
historical reference. They are NOT part of the build pipeline. If you
need to re-run them, copy to a working directory first.

| Script | Purpose | Used during TODO |
|---|---|---|
| `adoc_to_md.rb` | Convert the 43 `.adoc` TODO files to `.md` | TODO batch (one-shot) |
| `camel_to_snake_samples.rb` | Convert sample YAMLs from camelCase to snake_case | TODO 19 |
| `flatten_venues.rb` | Flatten polymorphic Venue structure in sample YAMLs | TODO 19 |

If you add a NEW one-shot utility during a future refactor, follow the
same pattern: drop it here with a one-line entry in this README.
