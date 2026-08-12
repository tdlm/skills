# Component Storybook Stories

## Namespace Import

Always use namespace imports to match how consumers use the component:

```tsx
import * as ProductCard from '../index'
```

## Meta JSDoc

Include a sub-component documentation table in the meta JSDoc:

```tsx
/**
 * ProductCard compound component with escape hatches.
 *
 * | Component | Description | Escape Hatches |
 * |-----------|-------------|----------------|
 * | `ProductCard.Badge` | Pill badge with icon | `Container`, `Icon`, `Text` |
 * | `ProductCard.Title` | Product title | None |
 */
const meta: Meta = {
  title: 'Components/SectionName/ComponentName',
  tags: ['autodocs'],
  parameters: {
    layout: 'padded',
    docs: { source: { type: 'dynamic' } },
  },
}
```

## Story File Organization

Each story lives in its own file under a `stories/` directory for progressive disclosure. The `.stories.tsx` barrel file contains only meta and explicit named re-exports:

```tsx
// ComponentName.stories.tsx
// biome-ignore-all assist/source/organizeImports: manual export order controls Storybook sidebar ordering
import type { Meta } from '@storybook/react'

/** JSDoc with sub-component table */
const meta: Meta = { ... }
export default meta

export { Default } from './stories/Default'
export { CustomComposition } from './stories/CustomComposition'
export { Sandbox } from './stories/Sandbox'
```

**Important**: Use explicit named re-exports (`export { X } from`), not `export *`. Storybook's static analysis cannot discover stories through `export *` from barrel files — they will silently disappear from the sidebar. Add `// biome-ignore-all assist/source/organizeImports` at the top to prevent Biome from reordering exports and disrupting intentional sidebar ordering.

Each story file exports a single named story. Use `parameters.docs.description.story` for descriptions (JSDoc on story objects does not appear in Storybook autodocs):

```tsx
// stories/Default.tsx
import type { StoryObj } from '@storybook/react'
import * as ProductCard from '../index'
import { sampleData } from './data'

type Story = StoryObj

export const Default: Story = {
  name: 'Default',
  parameters: {
    docs: {
      description: {
        story: 'Demonstrates the default ProductCard with typical props.',
      },
    },
  },
  render: () => ( ... ),
}
```

### Shared story data

Centralize test data in a `data.tsx` file. Prefer `satisfies` over manual remapping when reusing data from other sources:

```tsx
// stories/data.tsx
import { sourceData } from '@/path/to/source'
import type { ItemType } from '../SubComponent'

export const items = sourceData satisfies ItemType[]
```

## Standard Story Types

1. **Default** -- basic usage with typical props
2. **Variant stories** -- different states (selected, elevated, without banner, etc.)
3. **Escape hatch stories** -- composed using sub-components directly
4. **Sandbox** -- interactive playground with Storybook controls

Every story must have a `parameters.docs.description.story` string describing what it demonstrates.

## By Layer

Different component layers have different story shapes.

### Compound primitive

Stories live in a `stories/` subdirectory with one story per file. The root `Foo.stories.tsx` is meta + named re-exports. The meta JSDoc includes a sub-component documentation table. Story types should cover Default, variants composed via escape hatches, and a Sandbox.

```text
ProductCard/
├── ProductCard.stories.tsx     # meta + re-exports
└── stories/
    ├── data.tsx
    ├── Default.tsx
    ├── Selected.tsx
    ├── CustomComposition.tsx
    └── Sandbox.tsx
```

Use **namespace imports** in stories: `import * as ProductCard from '../index'`.

### Opinionated wrapper

Single `Foo.stories.tsx` file at the wrapper's directory root. No `stories/` subdirectory. Each story exercises one shape of the wrapper's prop API (e.g. with default action / with custom action / without action / selected / elevated). Use a **direct named import**: `import { OfferCard } from './OfferCard'`.

If your wrapper variants are exploding past five or six stories, that's a sign the wrapper is shaped too broadly — consider splitting into a sibling wrapper.

### Simple wrapper

Optional. If included, a single short story file demonstrating defaults and a couple of overrides.

### Page-specific composition

No Storybook stories — these are tested at the page level.
