---
name: create-react-component
description: Create shared React components following the project's layered architecture (compound primitive, opinionated wrapper, simple wrapper, page-specific composition). Reshaped-first, prop forwarding, BDD tests, JSDoc, and Storybook stories. Apply when authoring or substantially refactoring components under src/components/**/*.tsx or src/app/**/_components/**/*.tsx.
targets: ["*"]
---

# Create React Component

Commit to a **layer** before writing code.

## Pick a layer

Walk this decision tree. The first match is your layer — stop there and Read the linked workflow.

1. **Used by exactly one page?**
   → **Page-specific composition** — `./workflows/page-specific-composition.md`
   Lives in `app/<route>/_components/`. Promote later if a second consumer appears.

2. **Aliasing a single Reshaped primitive with preset defaults — one file, no sub-components, no escape hatches?**
   → **Simple wrapper** — `./workflows/simple-wrapper.md`
   E.g., `<Title>` → `<Text variant="title-3" weight="bold">`.

3. **A new building block with 2+ sub-components that each have their own public APIs, composed in multiple arrangements, meriting per-sub-component tests + stories?**
   → **Compound primitive** — `./workflows/compound-primitive.md`
   E.g., `(identity-protection)/_components/ProductCard/`, `src/components/Hero/`, `src/components/Footer/`.

4. **Otherwise — a recurring opinionated arrangement of an existing primitive, encoded behind a prop API?**
   → **Opinionated wrapper** — `./workflows/opinionated-wrapper.md`
   E.g., `(identity-protection)/_components/OfferCard/`, `(identity-protection)/_components/OfferCardCompact/`.

Refactoring an existing component? Ask "what should it *become*?" then walk the tree.

---

## Deprecating Legacy Components

If your new component replaces an existing legacy one, add `@deprecated` JSDoc to each legacy component function (not barrel files, data files, or types). See `.rulesync/docs/deprecation-warnings.md` for direct-replacement vs. no-direct-replacement formats.

---

## Always (across all layers)

- [ ] Reshaped primitives wherever a Reshaped equivalent exists (no raw HTML where Reshaped covers it).
- [ ] `displayName` set wherever the public name differs from the function name: every function inside a compound primitive gets its namespaced path (`'ProductCard.Badge.Container'`). Standalone named exports (wrappers, sections, islands) need none.
- [ ] Props spread after defaults: `<View defaultProp={x} {...props}>`.
- [ ] Types derived from Reshaped (`TextProps`, `ViewProps`, etc.) or composed via `&` / `Omit` / `Pick`.
- [ ] RSC boundary correctly chosen: no `'use client'` unless this file genuinely needs it; client islands extracted where the rest is server-renderable.
- [ ] Legacy components, if any, have `@deprecated` JSDoc pointing to the new equivalent.
