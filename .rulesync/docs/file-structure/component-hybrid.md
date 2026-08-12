# Component Hybrid Layout

## When to Use

Once a directory grows a sibling — typically because of a client island, a private helper, or a co-located stories file — promote the main file to a named file and add a barrel.

```text
Foo/
├── index.ts                # barrel
├── Foo.tsx                 # main component
├── Foo.stories.tsx         # optional, sits next to Foo.tsx
└── FooClientPiece.tsx      # private sibling (not re-exported)
```

- Consumers: same import path (`./Foo`) — barrel preserves it
- Barrel exposes only the public API; siblings stay private
- Tests and stories import from the named sibling, not the barrel: `import { Foo } from './Foo'`
