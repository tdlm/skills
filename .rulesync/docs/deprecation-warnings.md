# Deprecation Warnings

When a shared component replaces a legacy component, add `@deprecated` JSDoc to the legacy **component functions only** — not barrel files, data files, or type definitions.

## Direct Replacement

Single-line JSDoc when a dedicated new component exists:

```tsx
/** @deprecated Use `Footer.Social` from `@/components/Footer` instead. */
const SocialSection = () => {
```

## No Direct Replacement

Multi-line JSDoc with `@see` pointing to the relevant story source file when the legacy component is replaced by composition of multiple new components:

```tsx
/**
 * @deprecated No direct equivalent. This layout is replaced by explicit composition
 * using `Footer.Row`, `Footer.Brand`, `Footer.Navigation`, `Footer.Divider`,
 * and `Footer.Legal` from `@/components/Footer`.
 *
 * @see src/components/Footer/stories/FullComposition.tsx
 */
const NavigationLayout = ({ children }: NavigationLayoutProps) => (
```

## What NOT to Annotate

- Barrel/index files (pure re-exports)
- Data files (constants, arrays, config)
- Type definitions
- Test files
