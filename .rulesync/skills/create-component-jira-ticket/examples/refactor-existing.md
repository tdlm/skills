# Example: Refactoring an Existing Component (FAQ)

Rebuilding a legacy component as a compound component, using the old one as a reference.

**Description** (goes into the Description field):

```markdown
## Summary

Create a new compound FAQ component in `src/components/Faq/` that provides a flexible, composable foundation for FAQ sections across the application. This component uses the existing FAQ component as a reference for baseline functionality, but is rebuilt with a compound component pattern, prop forwarding, and optional escape hatches from the start.

---

## Background

The current FAQ component has several architectural limitations:

1. **Limited API surface** -- Only accepts `heading` and `pageKey` props, with no way to customize Reshaped attributes, spacing, or text variants.
2. **Centralized data problem** -- `Data.tsx` imports 28+ data files and eagerly evaluates all datasets on every call just to return one. FAQ data should be co-located with the features using it.
3. **Hardcoded styling** -- `FAQItem` contains magic numbers with no customization escape hatches.
4. **String-based data lookup** -- The `pageKey` union type requires manual updates for every new FAQ page.
5. **Duplicate components** -- Both `FAQ` and `FAQSection` exist with overlapping purposes.

---

## Approach

- **Compound component pattern** -- Namespace import and composable sub-components following the same conventions as Hero.
- **Sub-components** -- Root (outer container), Header (title), List (data-driven with optional `renderItem`), List.Container (escape hatch), ListItem (individual accordion item with Title and Description sub-parts).
- **Data-driven rendering** -- `FAQ.List` accepts a `data` array and optional `renderItem` callback; consumers can also use `FAQ.List.Container` for full manual control.
- **Reshaped prop passthrough** -- All components extend their underlying Reshaped component props.

---

## Out Of Scope

- Migration of existing FAQ usages to the new API
- Deletion or modification of existing `data/` folder
- Changes to the `FAQSection` component
- Backward compatibility shim for the old API

---

## Downstream Impact

- Existing FAQ component API remains functional; no breaking changes
- New compound component exported alongside old; teams migrate at their own pace

---

## Future Work

- **Migration ticket** -- Update existing FAQ usages to the new compound component API with co-located data.
- **FAQSection consolidation** -- Evaluate merging FAQSection into the new FAQ compound component.
- **Data folder cleanup** -- Remove centralized `data/` folder after all usages are migrated.
```

**Acceptance Criteria** (goes into the dedicated JIRA field as a task list):

- Root, Header, List, List.Container, and ListItem components created with Reshaped prop passthrough
- Compound component exported via `Object.assign` pattern
- All components have proper TypeScript types
- Unit tests for all sub-components and the main FAQ namespaced export
- Storybook stories for the main FAQ export demonstrating all usage patterns
- JSDoc documentation on all exported components with `@example` blocks
