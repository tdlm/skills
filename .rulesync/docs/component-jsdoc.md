# Component JSDoc

Place JSDoc on the final export — the `Object.assign` result or the function export.

## Shape

Every component JSDoc follows the same shape, in this order:

1. **Summary line** — `<Layer> — <what it renders>.`
2. **`**Utility primitives:**` line** — mini-compound sub-components only; list the
   exposed utility primitives.
3. **Contract notes** — optional bold-label paragraphs for non-obvious prop contracts
   (`**Icon contract:** expects a Reshaped-compatible icon element`).
4. **`@example` blocks** — `Default usage` always; `Custom composition` additionally
   for mini-compound sub-components.

## Layer Labels

Start the summary with the canonical layer name:

- `Mini-compound sub-component` — a compound primitive's sub-component that composes
  multiple elements and exposes utility primitives (`ProductCard.Badge`)
- `Simple sub-component` — a compound primitive's sub-component wrapping a single
  Reshaped primitive (`ProductCard.Title`)
- `Opinionated wrapper` — prop-driven arrangement of a primitive (`OfferCard`)
- `Simple wrapper` — one Reshaped primitive with preset defaults
- `Page-specific composition` — a page's `Section` components (`SectionQuote`)
- `Client island` — private `'use client'` sibling (`FooTrigger`)

## Examples

Mini-compound sub-component:

```tsx
/**
 * Mini-compound sub-component — pill-shaped badge with optional icon.
 *
 * **Utility primitives:** `Container`, `Icon`, `Text`
 *
 * @example Default usage
 * ```tsx
 * <ProductCard.Badge icon={<ShieldIcon />}>37% Off</ProductCard.Badge>
 * ```
 *
 * @example Custom composition
 * ```tsx
 * <ProductCard.Badge.Container backgroundColor="critical">
 *   <ProductCard.Badge.Icon svg={<CustomIcon />} />
 *   <ProductCard.Badge.Text>Custom Badge</ProductCard.Badge.Text>
 * </ProductCard.Badge.Container>
 * ```
 */
export const Badge = Object.assign(BadgeDefault, { ... })
```

Simple sub-component:

```tsx
/**
 * Simple sub-component — product name heading.
 *
 * @example Default usage
 * ```tsx
 * <ProductCard.Title>LifeLock™</ProductCard.Title>
 * ```
 */
export function Title({ children, ...props }: TitleProps) { ... }
```

## Rules

- Every summary starts with its layer label — a reader should know the component's
  role from hover alone, without seeing the file tree
- Use namespace import form in examples (`ProductCard.Badge`, not `Badge`)
- Keep examples minimal but complete with realistic prop values
- Mini-compound sub-components: at least two examples (default + escape hatch)
