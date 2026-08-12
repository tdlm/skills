# Compound Primitives

A **compound primitive** is a set of related sub-components, exposed through a shared namespace, that consumers assemble into different UI structures. The primitive owns the building blocks and their visual defaults; the consumer owns the arrangement.

```tsx
import * as ProductCard from '../ProductCard'

<ProductCard.Root>
  <ProductCard.Header>
    <ProductCard.Title>LifeLock™</ProductCard.Title>
    <ProductCard.Badge>37% Off Your 1st Year</ProductCard.Badge>
  </ProductCard.Header>
  <ProductCard.Description>Identity theft protection</ProductCard.Description>
  <ProductCard.Action href="/apply">Get Protected</ProductCard.Action>
</ProductCard.Root>
```

## The Namespace

A compound primitive's `index.ts` is **barrel-only** — named re-exports and nothing else:

```ts
// ProductCard/index.ts
export { Action } from './Action'
export { Badge } from './Badge'
export { Body } from './Body'
export { Description } from './Description'
export { Header } from './Header'
export { Root } from './Root'
export { Title } from './Title'
```

Consumers group the exports with a namespace import:

```tsx
import * as ProductCard from '../ProductCard'
```

`ProductCard` is an import namespace, not a callable component — `<ProductCard>` does not exist. Dot notation at this level (`ProductCard.Badge`) comes from the namespace import, which is why the barrel needs no `Object.assign`.

There is also no canonical arrangement of the sub-components. Arrangements are feature-scoped, so the "default card" is deliberately absent from the primitive:

- A **recurring** arrangement belongs in a sibling **opinionated wrapper** (`OfferCard`, `OfferCardCompact`).
- An arrangement used by **one page** stays a page-specific composition in that page's `_components/`.

If you find yourself authoring a `ProductCardDefault` colocated with the building blocks, stop — that's a wrapper, and it belongs in its own sibling directory.

## Sub-Components

A sub-component takes one of two shapes, determined by its internal structure. A primitive typically contains a mix of both — in `ProductCard`, `Title` and `Action` wrap a single Reshaped primitive (simple), while `Badge` and `Rating` compose several elements (mini-compounds).

### Simple sub-components

A plain component export — commonly one Reshaped primitive with preset defaults:

```tsx
import { Text, type TextProps } from 'reshaped'

export function Title({ children, ...props }: TextProps) {
  return (
    <Text as="h3" variant={{ l: 'featured-2', s: 'featured-3' }} weight="bold" {...props}>
      {children}
    </Text>
  )
}

Title.displayName = 'ProductCard.Title'
```

A simple sub-component wraps exactly one Reshaped primitive — there are no internals worth exposing, so `Object.assign` here is ceremony. If the sub-component composes two or more elements, it's a mini-compound.

### Mini-compound sub-components

A sub-component that composes two or more elements gets the compound treatment itself. It has three pieces:

- **Utility primitives** (`BadgeContainer`, `BadgeIcon`, `BadgeText`) — the low-level building blocks.
- A **default function** (`BadgeDefault`) that composes them into the common case.
- An **`Object.assign` export** that attaches the utilities to the default as escape hatches.

```tsx
function BadgeContainer({ children, ...props }: BadgeContainerProps) {
  return (
    <View direction="row" align="center" gap={1} backgroundColor="primary" {...props}>
      {children}
    </View>
  )
}
BadgeContainer.displayName = 'ProductCard.Badge.Container'

function BadgeIcon(props: IconProps) {
  return <Icon size={4} {...props} />
}
BadgeIcon.displayName = 'ProductCard.Badge.Icon'

function BadgeText({ children, ...props }: TextProps) {
  return <Text variant="body-3" weight="regular" maxLines={1} {...props}>{children}</Text>
}
BadgeText.displayName = 'ProductCard.Badge.Text'

function BadgeDefault({ icon, children, ...props }: BadgeDefaultProps) {
  return (
    <BadgeContainer {...props}>
      {icon && <BadgeIcon svg={icon} />}
      <BadgeText>{children}</BadgeText>
    </BadgeContainer>
  )
}
BadgeDefault.displayName = 'ProductCard.Badge'

export const Badge = Object.assign(BadgeDefault, {
  Container: BadgeContainer,
  Icon: BadgeIcon,
  Text: BadgeText,
})
```

Most consumers use the default. The escape hatches are for non-default composition:

```tsx
// Default composition
<ProductCard.Badge icon={<ShieldIcon />}>37% Off Your 1st Year</ProductCard.Badge>

// Escape hatch — custom arrangement
<ProductCard.Badge.Container backgroundColor="critical">
  <ProductCard.Badge.Text color="white">Custom Badge</ProductCard.Badge.Text>
</ProductCard.Badge.Container>
```

The default is colocated with the utilities because the sub-component itself *is* the default arrangement of its own utility primitives — unlike the top-level primitive, where no single default arrangement exists.

### Choosing a shape

The rule is structural:

- **One internal element** → simple sub-component.
- **Two or more internal elements** → mini-compound, with utility primitives exposed from the start.

Utility primitives must stay **thin Reshaped presets** — props derived from the underlying primitive, defaults set first, `{...props}` spread after. If a utility would need custom logic or state to be safely public, reconsider its design before exposing it.

Restraint applies at the barrel, not here: adding a sub-component to the namespace extends the public vocabulary of the whole component group, so add sub-components deliberately.

### Summary

| Question | `ProductCard` (namespace) | `ProductCard.Title` (simple) | `ProductCard.Badge` (mini-compound) |
|---|---|---|---|
| Callable component? | No | Yes | Yes |
| Has a default composition? | No — recurring arrangements live in sibling wrappers | — | Yes (`BadgeDefault`) |
| Uses `Object.assign`? | No — dot access comes from the namespace import | No | Yes — attaches utility primitives |
| Customization path | Compose different sub-components | Prop overrides | Prop overrides, then utility primitives (`Badge.Container`, …) |

## Default Composition Props

These rules apply to a mini-compound's default function.

1. **Derive props from the outermost utility primitive** (typically the Container), plus any content props the default needs:
   `type BadgeDefaultProps = ViewProps & { icon?: IconProps['svg'] }`.
2. **Decide `children` handling explicitly.** Accept `children` when it's an intentional content slot (the badge's text). Exclude it when the default renders a fixed layout that doesn't accept arbitrary content:

   ```ts
   type RatingDefaultProps = Omit<ViewProps, 'children'> & {
     value: number
   }
   ```

3. **Never use `children ??`** to conditionally fall back to default content — that creates an ambiguous API where the component is both a default and an escape hatch. Consumers who need custom layouts use the utility primitives directly.

Utility primitives (`Container`, `Icon`, `Text`, etc.) **do** accept `children` and forward props normally — they are the building blocks for custom composition.

## Display Names

Every function in a compound primitive sets a `displayName` mirroring its public path. Function names can't carry the dotted path, and a mini-compound's default function has an internal name (`BadgeDefault`) that isn't its public name (`Badge`) — `displayName` restores both.

```tsx
Title.displayName = 'ProductCard.Title'
BadgeDefault.displayName = 'ProductCard.Badge'
BadgeContainer.displayName = 'ProductCard.Badge.Container'
```

## When NOT a Compound Primitive

If your component is just one Reshaped primitive with preset defaults, it's a **simple wrapper** — a plain function export, no namespace, no compound layout.

If your component is a prop-driven API around an existing primitive's sub-components (`OfferCard`), it's an **opinionated wrapper**.

A component is a compound primitive because it exposes meaningful public composition — not because its implementation happens to render multiple elements.

## Stateful Compound Primitives

When sibling sub-components need shared state, use the Context/Provider pattern.
