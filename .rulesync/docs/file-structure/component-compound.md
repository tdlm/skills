# Component Full Compound Layout

## When to Use

Components with multiple sub-components that each merit their own tests, stories, and JSDoc.

```text
ComponentName/
├── index.ts                    # barrel: named exports for tree-shaking
├── SubA/
│   ├── SubA.tsx
│   ├── SubA.test.tsx
│   └── index.ts                # export { SubA } from './SubA'
├── SubB/
│   ├── SubB.tsx
│   ├── SubB.test.tsx
│   └── index.ts
├── stories/                    # individual story files
│   ├── data.tsx                # shared story data
│   ├── Default.tsx             # one story per file
│   ├── CustomComposition.tsx
│   └── Sandbox.tsx
├── ComponentName.stories.tsx   # meta + re-exports from stories/
└── ComponentName.test.tsx      # integration tests at root level
```

Pick this layout when:

- The component has 2+ sub-components with their own public APIs (e.g. `ProductCard.Badge`, `ProductCard.Banner`, `ProductCard.Action`)
- Sub-components are reusable building blocks for custom composition, not just internal helpers
- Each sub-component warrants its own unit test file, and the component as a whole warrants integration tests
- Stories cover both the default composition and individual sub-components
