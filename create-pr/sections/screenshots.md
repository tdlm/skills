# Screenshots

Visual evidence for rendered changes that Storybook doesn't already show.

**Include this section when the change alters rendered output and a story doesn't cover it.** The cases that qualify:

- A page or route composition with no story of its own
- Responsive behavior that only appears at particular breakpoints
- A visual fix, where the before and after are the whole point

When a Chromatic link already shows the change, that link is the evidence and this section is redundant. When neither applies — a config change, a docs edit, a dependency bump — there is nothing visual to show and the heading comes out entirely.

## Rules

- **Before and after, labeled**, for anything that fixes or changes existing appearance. A single "after" image proves the new state looks deliberate, not that it is different from what shipped.
- **Name what to look at.** A screenshot without a pointer makes a reviewer diff two images by eye.
- **Ask rather than guess.** When a visual change needs an image that isn't available, prompt for it instead of shipping the section empty or describing the appearance in prose.
