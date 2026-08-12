# Component Naming

Component names encode **which layer** a component belongs to. A reader should be able to tell a compound primitive from an opinionated wrapper from a page section by name alone — in the file tree, in a PR diff, in the Storybook sidebar — without seeing the import or the JSX.

## Archetype Down, Domain Up

**Primitives are named for a content archetype. Wrappers are named for a domain instance.** Specificity only increases as you move up the layer stack.

An *archetype* is the category of thing the layout is shaped around — a product, a quote, a person's profile. A *domain instance* is the specific meaning a feature assigns to it — an offer, a savings tip, an insurance agent.

| Layer | Names the… | Answers | Examples |
|---|---|---|---|
| Compound primitive | shape / archetype | "What does it look like?" | `ProductCard`, `QuoteCard`, `Hero`, `HeadingGroup` |
| Opinionated wrapper | domain meaning | "What is it, for which feature?" | `OfferCard`, `SaveCard`, `ReviewHero` |
| Page-specific composition | page slot | "Where does it sit on the page?" | `SectionQuote`, `SectionAgents` |

The canonical pair is `ProductCard` → `OfferCard`: the primitive knows it lays out a product-shaped thing; only the wrapper knows that thing is an offer.

## Litmus Test

Read the name and ask which question it answers.

- A primitive whose name answers "what is it for?" is misnamed.
- A wrapper whose name answers only "what does it look like?" is misnamed.

Good: `ProfileCard` (primitive: a card shaped around a person) → `AgentCard` (wrapper: that person is an insurance agent).

Bad: `AgentCard` (primitive) → `Agent` (wrapper). The primitive carries the domain meaning and the wrapper drops information.

## Page Section Names

Page-scoped compositions that render a full-width page slot use the `Section` prefix: `SectionQuote`, `SectionAgents`, `SectionFaq`. The prefix groups all sections together in the file tree and in import lists.

`Section` is reserved for this layer:

- A shared wrapper is never a `Section`.
- A section is never shared — if it grows a second consumer, it's becoming an opinionated wrapper; rename it accordingly.

## Reach Qualifier

These rules bind in proportion to reach:

- **Shared components** (`src/components/`, feature-group `_components/`) — all rules apply fully.
- **Page-scoped components** (a single page's `_components/`) — domain names are fine even on compound layouts. The component's reach *is* the domain; a page-scoped `RentCalculator` doesn't need an archetype name until a second page wants it.

Promotion to wider reach is the moment to fix the name.

## Mechanical Rules

- **Directory name equals the exported component name.** A folder named `Hero/` must not export `ReviewHero`.
- **Acronyms are PascalCased as words**: `Faq`, `Cta`, `SectionFaq` — not `FAQ`, `CTA`.

## Cross-layer Smells

- **Name-shrinking** — the wrapper's name is a substring or generalization of its primitive's (`AgentCard` → `Agent`). The pair is inverted; the domain name belongs on the wrapper.
- **Shadowing** — the wrapper shares the primitive's exact name (a page `Hero` wrapping `import * as Hero`). Namespace import and named import become indistinguishable at call sites. Prefix the context.
