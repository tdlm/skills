# Standard tier example

Feature work the team broadly understands: all six description sections, each tight, plus an outcome-based AC list.

Note how the AC names the new `@/assets/` convention (a public surface the team must learn) but otherwise describes behavior, not a checklist of files, counts, or directories to create and delete.

**Description** (goes into the Description field):

```markdown
## Summary

Consolidate the project's asset directories into a single, predictable convention.

Today the same kinds of files live in several overlapping locations, which causes duplication and confusion about where new assets belong. This work establishes one home for shared importable assets and documents the rule.

---

## Background

Assets are currently scattered across several locations -- `src/public/`, `src/assets/`, `src/modules/assets/`, and colocated `assets/` folders -- with no rule for which to use.

This leads to duplicated files, inconsistent import paths, and confusion for new contributors about where an asset belongs.

---

## Approach

- **Single shared directory** -- One `@/assets/` location is the home for all importable shared assets, organized by asset type.
- **`public/` reserved for URL-only assets** -- Files that must be referenced by URL (favicons, `og:image`) stay in the Next.js `public/` directory.
- **Colocated assets unchanged** -- Feature-specific assets stay next to the component that uses them.

---

## Out Of Scope

- Colocated `assets/` directories under routes or components (already correctly placed)
- React icon components under `src/components/icons/`

---

## Downstream Impact

- **No breaking changes** -- All existing imports are updated in this PR. Consumers need no action.
- **New convention** -- Future assets follow the documented placement rule.

---

## Future Work

- **Font consolidation** -- Move fonts into the shared assets location if the team decides to.
- **Icon component audit** -- Evaluate whether icons should follow the same pattern.
```

**Acceptance Criteria** (goes into the dedicated JIRA field as a task list):

- Shared importable assets resolve from a single `@/assets/` location
- No imports remain from the previous shared-asset locations
- URL-only assets continue to load from `public/`
- The asset placement convention is documented for contributors
