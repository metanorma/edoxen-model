# 22 — Gem: Remove anti-patterns

## Why

Per user's CLAUDE.md: never `send` private methods, never `instance_variable_set`/`get`, never `respond_to?` for type checking.

## Files to scan

All `lib/edoxen/**/*.rb`

## Patterns to remove

- `obj.send(:private_method)` → refactor to public API or redesign
- `obj.instance_variable_set(:@foo, val)` → add public accessor or redesign
- `obj.instance_variable_get(:@foo)` → add public reader
- `obj.respond_to?(:method_name)` → use `obj.is_a?(ClassName)` or design types so check isn't needed

## Refactor approach

For each anti-pattern found:
1. Understand why it was used
2. Find the proper OOP alternative (public method, type hierarchy, etc.)
3. Refactor
4. Verify specs still pass

## Acceptance criteria

- `grep -r '\.send(' lib/` returns nothing (or only legitimate public sends with documentation)
- `grep -r 'instance_variable_set' lib/` returns nothing
- `grep -r 'instance_variable_get' lib/` returns nothing
- `grep -r 'respond_to?' lib/` returns nothing (except possibly in public API introspection)