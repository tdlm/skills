# Component File Structure

## Scope and Reach

This convention covers component file structure regardless of location. A component's *reach* (where it's consumed) determines its *location*; a component's *internal complexity* determines its *file structure*.

**Reach → Location:**

- One page → `app/<route>/_components/<Component>/`
- One feature group → `app/(<feature>)/_components/<Component>/`
- Cross-feature → `src/components/<Component>/`

**Complexity → Structure:** see the Layout decision below.

These axes are independent. A feature-level component can be a flat one-off (e.g. `(holiday-expenses)/_components/Hero/index.tsx`), a hybrid (e.g. `(identity-protection)/.../ProductEvaluationCard/`), or a full compound (e.g. `(identity-protection)/_components/ProductCard/`). Pick the structure that matches the component's complexity, not its location.

## Layout

Choose the layout based on how many source files the component's directory will contain. Three options:

- **Flat (single file)** — one-off components with a single public export and no co-located helpers.
- **Hybrid (named files + barrel)** — main file plus small siblings (a private helper, a client island, stories).
- **Full compound (per-sub-component subdirectories)** — multiple sub-components each meriting their own tests, stories, and JSDoc.

## Heuristic

- One file → `index.tsx`
- Multiple files in one dir → named files + barrel
- Multiple sub-components with public APIs and per-component test/story/JSDoc surface → full compound layout

## Barrel Exports

Root `index.ts` uses named exports only:

```ts
export { Root } from './Root'
export { Content } from './Content'
export { Title } from './Title'
```

For hybrid layout, the barrel re-exports the main component (and its public types):

```ts
export { Foo, type FooData } from './Foo'
```

Sub-component `index.ts` is a minimal re-export:

```ts
export { Badge } from './Badge'
```

## Naming Conventions

- Named files (`Badge.tsx`, not `index.tsx`) for IDE tab distinguishability and search
- Tests import from sibling, not barrel: `import { Badge } from './Badge'`
- The `.stories.tsx` file sits next to the main `.tsx` in hybrid layouts; at the component root in full compound layouts
- Integration tests live at the component root, not inside sub-directories
- Private siblings (e.g. client islands) use the `<Parent><Role>` pattern: `FooTrigger.tsx`, `FooEmptyState.tsx`
- These are file-naming rules; *component* naming (archetype vs domain instance, layer rules) is a separate concern

## Sub-component Promotion

- Standalone, logical entities within a parent component should be promoted to their own directory in the full compound layout
- Small structural/visual-formatting sub-components (layout wrappers, spacing helpers, typographic composition) may remain inline and be attached via `Object.assign` escape hatches
- Private siblings that exist purely as RSC client islands stay flat — they have no public API, no story, often no dedicated test
