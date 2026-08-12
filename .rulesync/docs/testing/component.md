# Component Testing Conventions

## Import Convention

Import from sibling file, not barrel (faster, isolated):

```tsx
import { Badge } from './Badge'  // good
import { Badge } from '.'        // avoid
```

## BDD "should" Pattern

Structure tests so output reads as natural sentences:

```tsx
describe('Badge should', () => {
  describe('by default', () => {
    it('render children as text content', () => { ... })
  })

  describe('for prop passthrough', () => {
    it('forward attributes to underlying View', () => { ... })
  })

  describe('for slots', () => {
    it('render icon when icon prop is provided', () => { ... })
  })

  describe('sub-components', () => {
    it('expose Container for custom composition', () => { ... })
    it('allow full escape hatch composition', () => { ... })
  })
})
```

## Four Contract Test Categories

1. **Defaults** -- default props/styling render correctly
2. **Overrides** -- custom props replace defaults
3. **Passthrough** -- unknown props forward to underlying component via `attributes`
4. **Slots/Children** -- content renders in correct positions

## Integration Tests

Place at component root (`ComponentName.test.tsx`). Import from barrel:

```tsx
import * as Faq from '.'

it('render all sub-components together', () => {
  render(<Faq.Root><Faq.Header>FAQs</Faq.Header><Faq.List data={data} /></Faq.Root>)
})
```
