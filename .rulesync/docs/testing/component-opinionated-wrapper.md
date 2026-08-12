# Opinionated Wrapper Tests

Use a **direct named import** (`import { OfferCard } from './OfferCard'`). Test the wrapper's prop API and behavior — discriminated-union variant shapes, conditional rendering, prop-driven state. Rely on the primitive's own tests for sub-component contracts; do not re-test what the primitive already covers.

```tsx
import { OfferCard, type OfferCardProps } from './OfferCard'

describe('OfferCard should', () => {
  it('render the default action button when actionContent + actionUrl are provided', () => { /* ... */ })
  it('render a custom action node when action prop is provided', () => { /* ... */ })
  it('render no action when no action props are provided', () => { /* ... */ })
})
```
