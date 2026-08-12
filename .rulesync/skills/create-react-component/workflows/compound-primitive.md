# Compound Primitive Workflow

A building-block component made up of sub-components. The top-level `index.ts` is barrel-only (no top-level default). See `.rulesync/docs/compound-primitives.md`.

## File structure

Full compound layout — one directory per sub-component.

- `.rulesync/docs/file-structure/component.md` — Scope-and-Reach, Decision Tree, naming conventions, barrel exports.
- `.rulesync/docs/file-structure/component-compound.md` — full compound layout details.

## Workflow

1. Identify the sub-components. What are the visual layers? Which ones compose multiple elements (and are therefore mini-compounds)?
2. Choose each sub-component's shape structurally. A sub-component wrapping a single Reshaped primitive is a plain function export. A sub-component composing two or more elements gets `XContainer` / `XText` / `XIcon` utility primitives, a `XDefault` that composes them, and `export const X = Object.assign(XDefault, { Container, Text, Icon })` — set up during initial authoring, not deferred until a consumer needs it. Set `displayName` on every function.
3. Author the top-level barrel — one `export { Sub } from './Sub'` line per sub-component. **Do not** author a top-level `XDefault`. The default arrangement of these blocks is a sibling opinionated wrapper.
4. Write BDD-style sub-component tests and a root integration test (see Tests below).
5. Write Storybook stories under `stories/` with a `.stories.tsx` barrel at the root (see Storybook below).
6. Add JSDoc with `@example` blocks on each sub-component's final export. See `.rulesync/docs/component-jsdoc.md`.

## Tests

- `.rulesync/docs/testing/component.md` — BDD pattern, four contract categories, import convention.
- `.rulesync/docs/testing/component-compound-primitive.md` — root integration + sub-component contracts.

## Storybook

- `.rulesync/docs/component-storybook.md` — story conventions (see the "Compound primitive" section for `stories/` subdirectory layout).

## Rules to follow

- `.rulesync/docs/naming/component.md` — layer naming (archetype down, domain up), `Section` reservation, mechanical rules.
- `.rulesync/docs/naming/component-compound-primitive.md` — primitive naming rules.
- `.rulesync/docs/reshaped-first.md` — Reshaped-first, type derivation, defaults + spread.
- `.rulesync/docs/stateful-compound-components.md` — only if sibling sub-components share state.
- `.rulesync/docs/rsc-boundaries.md` — only if a sub-component needs client interactivity; client-island extraction, boundary hygiene.

## Checks

- [ ] Top-level `index.ts` is barrel-only — no `XDefault`, no `Object.assign` at the top level.
- [ ] Each sub-component has its own subdirectory with named `.tsx`, `.test.tsx`, `index.ts`.
- [ ] Sub-components that have multiple internal layers use `Object.assign(XDefault, { Container, ... })` and expose escape hatches.
- [ ] Stories live under `stories/` with a `.stories.tsx` barrel at root.
- [ ] Integration test at root uses `import * as Foo from '.'`; sub-component tests use direct imports.
- [ ] Name is an archetype + structural noun (`ProductCard`), not a domain instance or brand.
- [ ] Name is unique within its import reach.
