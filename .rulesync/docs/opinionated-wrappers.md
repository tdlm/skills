# Opinionated Wrappers

An **opinionated wrapper** is a single component that imports a compound primitive via `import * as Foo from '../Foo'` and encodes **one specific arrangement** of its sub-components behind a prop API. Wrappers are where flat, ergonomic, prop-driven APIs live.

Wrappers can vary — `OfferCard` and `OfferCardCompact` both wrap the same `ProductCard` primitive, but each encodes a different arrangement and ships its own prop API.

## When to Create a Wrapper

Create an opinionated wrapper when you have a **recurring opinionated arrangement** of a primitive that consumers shouldn't have to recompose every time. If the same composition shows up two or three times, extract a wrapper.

If only one page needs the arrangement, keep it as a page-specific composition — don't promote prematurely.

## Where to Place It

A wrapper lives **at the same reach as the primitive it wraps, or one level closer to the consumer**.

- Same reach as the primitive: sibling directory.
  `(identity-protection)/_components/OfferCard/` lives next to `(identity-protection)/_components/ProductCard/`.
- Closer to the consumer: a wrapper used by only one feature group can live in that group's `_components/`.
  Example: an `IdentityGuardOfferCard` consumed only by the `identity-guard/` review page lives under `identity-guard/_components/`.

A wrapper does NOT belong inside the primitive's directory. The primitive's `index.ts` is barrel-only.

## Prop API Design

The wrapper layer is where most prop-API mistakes happen. Three rules cover almost all of them: pick the right axis (new wrapper vs new prop), model variants with discriminated unions, and use escape hatches for deeper style overrides instead of reimplementing the primitive.

### New wrapper or new prop?

When you need a variation of an existing wrapper, you have two options: add a prop to the existing wrapper, or create a new wrapper next to it (e.g., `OfferCardCompact` next to `OfferCard`). Use this test to choose.

**Reach for a new wrapper when the variant differs in one of:**

- **Composition** — excludes/includes building blocks the base wrapper has, OR rearranges them (e.g., a different mobile layout, a different desktop column structure).
- **Opinionated style overrides on the base primitives** — different padding, type variant, weight, etc. baked into the variant and not tied to runtime state.

**Reach for a prop when the variant only changes appearance based on runtime state** — `selected`, `elevated`, `disabled`, `loading`, hover, focus. These are not structural variants; they're orthogonal state that any shape can take on.

Worked examples from the codebase:

- **`OfferCard` vs `OfferCardCompact`** — same `ProductCard` primitive, but the wrappers diverge on both axes: different desktop and mobile arrangements (composition), and `OfferCardCompact` bakes in opinionated style overrides like `variant="caption-2"` on the description and explicit image sizing via `ProductCard.Image.Container`. **New wrapper.** ✅
- **`OfferCard`'s `selected` and `elevated`** — same arrangement either way; only outline/elevation styling changes based on runtime state. **Props.** ✅

What stays as props on a wrapper: optional content slots (`banner?: ReactNode`, like `OfferCard` already has), runtime state booleans (`selected`, `elevated`, `disabled`), and discriminated-union variant shapes (see below). All of these keep the underlying sub-component arrangement constant.

If a variant straddles both axes (some structural difference + some state-driven styling), the structural piece pushes it into new-wrapper territory. State-driven styling within that new wrapper is still a prop on it.

### Discriminated unions for variant prop shapes

When a wrapper has multiple valid prop combinations that don't intersect, model them as a **discriminated union**. The compiler enforces the combinations at the call site.

Worked example from `OfferCard`:

```tsx
type WithDefaultAction = {
  actionContent: ReactNode
  actionUrl: string
  action?: never
}

type WithCustomAction = {
  actionContent?: never
  actionUrl?: never
  action: ReactNode
}

type WithNoAction = {
  actionContent?: never
  actionUrl?: never
  action?: never
}

type ActionProps = WithDefaultAction | WithCustomAction | WithNoAction

export type OfferCardProps =
  Omit<OfferCardItem, 'id' | 'actionContent' | 'actionUrl'> &
  ViewProps &
  ActionProps & {
    selected?: boolean
    elevated?: boolean
  }
```

This prevents call sites from mixing `actionUrl` with a custom `action` node — TypeScript flags it at compile time. Prefer this over an `actionMode: 'default' | 'custom' | 'none'` enum prop, which can't enforce that the right *other* props are present.

### Use escape hatches for deep style overrides

When a wrapper needs styling that diverges from a primitive's default, first try passing the prop directly — most primitives forward to their outermost container, so overrides like `paddingBlock`, `maxWidth`, or `align` just work.

When the override targets a *deeper nested element* the default doesn't reach (the inner `Text` inside `ProductCard.Description`, for instance), drop into the escape hatches. Don't reimplement the primitive from raw `View` + `Text`.

```tsx
// Good — escape hatch reaches the inner Text variant
<ProductCard.Description.Container>
  <ProductCard.Description.Text variant="caption-2">
    {description}
  </ProductCard.Description.Text>
</ProductCard.Description.Container>

// Bad — reimplements the primitive just to change variant
function CompactDescription({ children }: PropsWithChildren) {
  return (
    <View paddingBlock={1}>
      <Text variant="caption-2" weight="regular">
        {children}
      </Text>
    </View>
  )
}
```

The "Bad" version drifts: if the primitive's defaults change, the reimplementation won't pick them up. The escape-hatch version stays inside the primitive and swaps only the specific knob.

If your wrapper's prop API is exploding into many variant shapes (or you find yourself reaching for escape hatches everywhere to fight the primitive's defaults), that's usually a sign you should split into a separate wrapper rather than keep stretching this one. See "New wrapper or new prop?" above.
