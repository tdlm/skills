# Reshaped-First

## Use Reshaped primitives

Always build with Reshaped components as the underlying primitives. Avoid raw HTML elements when a Reshaped equivalent exists:

- `View` replaces `div` (layout, spacing, responsive direction)
- `Text` replaces `p`, `span`, `h1`-`h6` (typography variants, semantic `as` prop)
- `Icon` wraps SVGs (consistent sizing)
- `Card`, `Accordion`, `Button` for their respective patterns

This ensures consistent spacing tokens, responsive prop syntax (`gap={{ s: 4, m: 8 }}`), theme integration, and accessibility defaults.

## Type Derivation

Derive prop types from the underlying Reshaped component:

```tsx
import { Text, type TextProps } from 'reshaped'
type TitleProps = TextProps
```

For components with custom props, intersect or extend:

```tsx
type BadgeProps = ViewProps & { icon?: IconProps['svg'] }
```

For props derived from non-Reshaped libraries (e.g., Next.js), use `Partial<Pick<...>>` to make a subset optional with defaults:

```tsx
import Image, { type ImageProps } from 'next/image'

type LogoProps = ViewProps &
  Partial<Pick<ImageProps, 'src' | 'alt' | 'width' | 'height'>>
```

For default compositions that render a static layout, exclude `children`:

```tsx
type BrandDefaultProps = Omit<ViewProps, 'children'>
```

## Spread Pattern

Set defaults first, then spread `{...props}` so consumers can override any default:

```tsx
export function Body({ children, ...props }: ViewProps) {
  return (
    <View direction={{ m: 'row', s: 'column' }} gap={{ s: 4, m: 8 }} {...props}>
      {children}
    </View>
  )
}
```

## Reshaped `attributes` Escape Hatch

For HTML attributes and inline styles, use Reshaped's `attributes` prop:

```tsx
<Badge attributes={{ 'data-testid': 'badge', style: { flexWrap: 'nowrap' } }}>
```

### Attributes Merge Pattern

When a component sets default inline styles via `attributes`, destructure `attributes` separately and merge `style` to prevent consumers from silently clobbering defaults:

```tsx
function RootWrapper({ children, attributes, ...props }: ViewProps) {
  return (
    <View
      attributes={{
        ...attributes,
        style: { ...defaultStyle, ...attributes?.style },
      }}
      {...props}
    >
      {children}
    </View>
  )
}
```

Default styles spread first, then `attributes?.style` second — consumer styles win on conflict. Non-style attributes (`id`, `data-*`, `aria-*`) pass through without affecting defaults.
