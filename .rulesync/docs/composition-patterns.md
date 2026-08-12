# Composition Patterns

These patterns apply at the **consumer side** — when a page, an opinionated wrapper, or any other consumer composes a primitive's sub-components.

## Avoid Boolean Prop Proliferation

If 2+ boolean props affect rendering structure, use composition instead. Each boolean doubles possible states (2^n complexity).

```tsx
// Bad: what does this render?
<Composer isThread isDMThread isEditing />

// Good: explicit about what it renders
<ThreadComposer channelId={id} />
```

**When booleans ARE fine:** Single non-combinatorial toggles like `disabled`, `loading`, `selected`.

## Prefer Children Over Render Props

Default to `children` for composition. Use compound components for multiple named slots.

```tsx
// Bad: render props with no data
<Card renderHeader={() => <Title />} renderFooter={() => <Actions />} />

// Good: children + compound components
<Card>
  <Card.Header><Title /></Card.Header>
  <Card.Footer><Actions /></Card.Footer>
</Card>
```

**When render props ARE appropriate:** Only when the parent needs to pass data back to the consumer.

```tsx
// Good: renderItem receives data
<ProductCard.Features data={features} renderItem={(item) => (
  <ProductCard.Features.Item key={item.id}>{item.text}</ProductCard.Features.Item>
)} />
```

## Decision Guide

| Use Case | Pattern |
|----------|---------|
| Static structure | `children` |
| Multiple named slots | Compound components |
| Data passed to consumer | Render props (`renderItem`) |
| List with customizable items | `data` + optional `renderItem` |
