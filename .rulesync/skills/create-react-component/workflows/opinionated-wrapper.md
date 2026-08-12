# Opinionated Wrapper Workflow

A single component that imports a primitive via `import * as Foo from '../Foo'` and encodes one specific arrangement behind a prop API. See `.rulesync/docs/opinionated-wrappers.md`.

## File structure

Hybrid layout — named main file + barrel + optional small siblings (a private helper, a client island).

- `.rulesync/docs/file-structure/component.md` — Scope-and-Reach, Decision Tree, naming conventions, barrel exports.
- `.rulesync/docs/file-structure/component-hybrid.md` — hybrid layout details.

## Workflow

1. Identify the primitive(s) you'll wrap. Import via `import * as Foo from '../Foo'`.
2. Design the prop API. Decide new-wrapper vs new-prop on the *composition / opinionated-style-override / runtime-state* axis. Use **discriminated unions** for variant prop shapes that don't intersect (`WithDefaultAction | WithCustomAction | WithNoAction`). For consumer-side composition concerns (boolean prop proliferation, children vs render props), see `.rulesync/docs/composition-patterns.md`.
3. Implement the wrapper. Lean on the primitive's escape hatches when you need a non-default arrangement — don't re-wrap them. If only part of the wrapper needs the client, extract a client-island sibling; see `.rulesync/docs/rsc-boundaries.md`.
4. Write behavior tests (see Tests below) and a single `.stories.tsx` at root covering each variant (see Storybook below).
5. Add JSDoc with `@example` on the wrapper's export. See `.rulesync/docs/component-jsdoc.md`.

## Tests

- `.rulesync/docs/testing/component.md` — BDD pattern, four contract categories, import convention.
- `.rulesync/docs/testing/component-opinionated-wrapper.md` — prop API + behavior tests for wrappers.

## Storybook

- `.rulesync/docs/component-storybook.md` — story conventions (see the "Opinionated wrapper" section).

## Rules to follow

- `.rulesync/docs/naming/component.md` — layer naming (archetype down, domain up), `Section` reservation, mechanical rules.
- `.rulesync/docs/naming/component-opinionated-wrapper.md` — wrapper naming rules.
- `.rulesync/docs/compound-primitives.md` — pattern context for the primitive being wrapped (barrel-only `index.ts`, escape hatches available on sub-components).
- `.rulesync/docs/reshaped-first.md` — Reshaped-first, defaults + spread.

## Checks

- [ ] Wrapper imports the primitive via `import * as Foo from '../Foo'`.
- [ ] Variant prop shapes use discriminated unions, not enum props.
- [ ] Variant differences pass the new-wrapper-vs-prop test (composition or opinionated style overrides → new wrapper; runtime state → prop).
- [ ] No re-wrapped escape hatches.
- [ ] Tests use direct named import, focus on prop API and behavior.
- [ ] Stories live in a single `.stories.tsx` at the directory root (no `stories/` subdir).
- [ ] Name is a domain instance, never more generic than or identical to the primitive it wraps.
- [ ] Colliding or ambiguous names use a feature-context prefix (`ReviewHero`).
