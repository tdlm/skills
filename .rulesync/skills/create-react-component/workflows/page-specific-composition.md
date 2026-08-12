# Page-specific Composition Workflow

A one-off arrangement for one page. Lives in `app/<route>/_components/`.

## File structure

Flat (`Section/index.tsx`) or hybrid (named `Section.tsx` + barrel + a small client-island sibling).

- `.rulesync/docs/file-structure/component.md` — Scope-and-Reach, Decision Tree, naming conventions.
- `.rulesync/docs/file-structure/component-flat.md` — flat layout details.
- `.rulesync/docs/file-structure/component-hybrid.md` — hybrid layout details.

## Workflow

1. Compose the primitive(s) you need with the structure for this one page.
2. Keep `'use client'` on the smallest island. If only one part of the composition needs the client (e.g. a `useResponsiveClientValue` hook to toggle a background color), extract a client-island sibling and keep the rest server-rendered. See `.rulesync/docs/rsc-boundaries.md`.
3. Skip tests and stories — page-level testing happens at the page level.

## When to extract into an opinionated wrapper

If the same composition shows up on a second page, extract it into an opinionated wrapper at the appropriate reach (feature-group `_components/` or shared `src/components/`). Don't promote until you have the second consumer.

## Rules to follow

- `.rulesync/docs/naming/component.md` — full-width page slots use the `Section` prefix (`SectionQuote`); `Section` is reserved for this layer.
- `.rulesync/docs/composition-patterns.md` — consumer-side composition.
