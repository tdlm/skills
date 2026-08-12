# Compound Primitive Tests

A compound primitive has two test shapes that pair together: root integration tests (default composition end-to-end) and sub-component contract tests (each sub-component's contract independently).

## Root integration tests

Use a **namespace import** from the barrel (`import * as Foo from '.'`) and exercise the full default composition. These tests prove the sub-components hold together end-to-end.

```tsx
import * as ProductCard from '.'

it('render all sub-components together', () => {
  render(
    <ProductCard.Root>
      <ProductCard.Header>
        <ProductCard.Badge>Special Offer</ProductCard.Badge>
        <ProductCard.Title>Product Name</ProductCard.Title>
      </ProductCard.Header>
      <ProductCard.Description>Product description.</ProductCard.Description>
    </ProductCard.Root>,
  )
})
```

## Sub-component contract tests

Use a **direct import from the sibling file** (`import { Badge } from './Badge'`), and follow the BDD pattern with the four contract categories (defaults, overrides, passthrough, slots/children). These tests cover each sub-component's contract independently.
