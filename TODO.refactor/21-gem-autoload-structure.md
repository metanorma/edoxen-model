# 21 — Gem: Refactor to autoload structure

## Why

Per user's CLAUDE.md: "NEVER use `require_relative` for internal library code. Never use `require` with a path to code within your own library. Use Ruby `autoload` instead. Define autoload entries in the immediate parent namespace's file."

The current gem uses `require_relative` (or `require` with paths). Refactor to `autoload`.

## Files to modify

- `lib/edoxen.rb` — define `autoload` entries for all top-level constants
- `lib/edoxen/<group>.rb` — create if doesn't exist, define autoload for sub-constants

## Pattern

```ruby
# lib/edoxen.rb
module Edoxen
  autoload :Decision, "edoxen/decision"
  autoload :Motion, "edoxen/motion"
  autoload :Voting, "edoxen/voting"
  autoload :Meeting, "edoxen/meeting"
  # ...
end
```

For nested namespaces:
```ruby
# lib/edoxen/models.rb (CREATE if doesn't exist)
module Edoxen
  module Models
    autoload :Decision, "edoxen/models/decision"
    # ...
  end
end
```

## Scan and remove

- All `require_relative "..."` calls in `lib/`
- All `require "edoxen/..."` calls in `lib/`
- Replace with autoload in the parent file

## Acceptance criteria

- `grep -r require_relative lib/` returns nothing
- `grep -r 'require "edoxen' lib/` returns nothing
- All constants reachable via `Edoxen::Foo` work
- Spec suite still passes