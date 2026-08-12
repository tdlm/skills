# Component Flat Layout

## When to Use

Components that fit in one file with no siblings.

```text
Foo/
└── index.tsx
```

- Consumers: `import { Foo } from './Foo'` (resolves to `index.tsx`)
- No barrel needed
- Default for one-off components with a single public export and no co-located helpers
