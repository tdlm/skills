# RSC Boundaries

## Default: Server Components

App Router components are server components by default. Prefer this. Server components:

- Render static JSX, accept serializable props (strings, numbers, plain objects, JSX elements)
- Do not ship JS to the client for their own code
- May freely render client components as children

Add `'use client'` only when the component genuinely needs the client.

## Recognition Signs that Force `'use client'`

A component must be a client component if it:

- Uses React hooks (`useState`, `useEffect`, `useRef`, `useContext` for client contexts, etc.)
- Reads `window`, `document`, `localStorage`, or any browser-only API
- Passes a function as a child or prop to another component (render-props, inline event handlers)
- Imports a module marked `'use client'` AND passes it a function/non-serializable value

A component does NOT need `'use client'` just because it renders a client component as a child — server components can render client components, they only can't pass them functions or other non-serializable values.

## Three Component Shapes

### Pure server component

No `'use client'` directive. Static JSX, serializable props.

```tsx
export function FaqItem({ question, answer }: { question: string; answer: ReactNode }) {
  return (
    <View>
      <Text variant="featured-3">{question}</Text>
      <Text>{answer}</Text>
    </View>
  )
}
```

### Whole-component client (`'use client'`)

When the component is a thin wrapper around a client primitive — splitting it buys nothing because the underlying primitive ships either way.

```tsx
'use client'
export function CollapsibleWrapper(props: AccordionProps) {
  return <Accordion gap={4} {...props} />
}
```

Heuristic: if the wrapper is essentially a 1:1 forward to a Reshaped client primitive (`Accordion`, `Modal`, `Tabs`, etc.), keep `'use client'` on the whole thing.

### Hybrid: server parent + client island

When the component is a thick composition with one small client-bound pinhole — most of the JSX is server-renderable, only one spot needs client behavior. Extract the pinhole into a sibling client module; keep the parent server-rendered.

```tsx
// Foo/FooTrigger.tsx
'use client'
import * as Collapsible from '@/components/Collapsible'

export function FooTrigger() {
  return (
    <Collapsible.Trigger>
      {({ active }) => <span>{active ? 'Hide' : 'Show'}</span>}
    </Collapsible.Trigger>
  )
}
```

```tsx
// Foo/Foo.tsx — no 'use client'
import { FooTrigger } from './FooTrigger'
import * as Collapsible from '@/components/Collapsible'

export function Foo() {
  return (
    <Collapsible.Root>
      <FooTrigger />
      <Collapsible.Content>{/* server-rendered children */}</Collapsible.Content>
    </Collapsible.Root>
  )
}
```

The render-prop function is created inside `FooTrigger` (already client-side), so it never crosses a server→client boundary. `Foo` only passes JSX into `Collapsible.Root`, which is serializable.

## Choosing the Shape

Ask: "What fraction of the component's JSX is client-bound?"

- **Most/all** → whole-component client (one file, one directive)
- **One small pinhole, the rest is static** → extract a client island sibling
- **Nothing client-bound** → pure server component

## Client Island Conventions

- Co-locate the island as a sibling file, not in a subfolder: `Foo/FooTrigger.tsx`
- Name it `<ParentName><Role>.tsx` to communicate ownership and role
- Don't re-export it from the barrel — it's a private implementation detail
- Skip stories/tests for the island unless it has logic worth isolating in isolation; test through the parent

Extracting an island moves the parent from the flat to the hybrid file layout.

## Boundary Hygiene

When a server component renders a client component, only serializable values cross the boundary:

- Strings, numbers, booleans, plain objects, arrays
- JSX elements (including JSX trees containing other server-rendered content)
- Promises that resolve to serializable values

Values that do NOT cross the boundary:

- Functions (event handlers, render props, callbacks)
- Class instances, `Date` objects with methods called on the client side
- React context values created on the client side (cannot be read from server children)

If a `ReactNode`-typed prop receives a function from a server caller, it'll error at runtime. The TypeScript type doesn't catch this — it's a runtime contract.
