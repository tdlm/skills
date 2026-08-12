# Simple Wrapper Workflow

A single Reshaped primitive with preset defaults. One file, no escape hatches, no sub-components.

## File structure

Flat — one file.

- `.rulesync/docs/file-structure/component.md` — Scope-and-Reach, Decision Tree, naming conventions.
- `.rulesync/docs/file-structure/component-flat.md` — flat layout details.

## Workflow

1. Pick the underlying Reshaped primitive (`Text`, `View`, `Icon`, etc.).
2. Derive the prop type from that primitive (`type TitleProps = TextProps`).
3. Set defaults first, spread `{...props}` after so consumers can override.

```tsx
export function Title({ children, ...props }: TextProps) {
  return <Text variant="title-3" weight="bold" {...props}>{children}</Text>
}
```

## Tests

Single test file colocated with the component. Cover defaults and prop overrides — no integration tests, no namespace import. See `.rulesync/docs/testing/component.md` for the BDD pattern and contract categories.

## Storybook

Optional. If included, a single short story file demonstrating defaults and a couple of overrides. See `.rulesync/docs/component-storybook.md`.

## Rules to follow

- `.rulesync/docs/naming/component.md` — layer naming and mechanical rules (directory = export name, acronym casing).
- `.rulesync/docs/reshaped-first.md` — Reshaped-first, type derivation, defaults + spread.

## Checks

- [ ] One file, no escape hatches, no `Object.assign`.
- [ ] Prop type derived from the underlying Reshaped primitive.
- [ ] Defaults set first, `{...props}` spread after.
