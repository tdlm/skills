# Example: New Component from Figma (ProductCard)

A net-new compound component built to match multiple Figma variations.

**Description** (goes into the Description field):

```markdown
## Summary

Introduce a ProductCard compound component under `(paid-landing-pages)` that supports the different card layouts represented in the LL Migration (GBR to ML) Figma mocks. The architecture uses composable primitives with escape hatches so multiple card variations can be built from the same building blocks without separate component implementations.

---

## Background

Paid landing pages need product comparison cards that align with the LL Migration (GBR to ML) Figma designs. The mocks show more than one card variation:

- **Variation 1:** [Figma - Card variation 1](https://www.figma.com/design/McL3BxpbWnSbbrqk94QKap/LL-Migration--GBR--%3E-ML-?node-id=1-1980&m=dev)
- **Variation 2:** [Figma - Card variation 2](https://www.figma.com/design/McL3BxpbWnSbbrqk94QKap/LL-Migration--GBR--%3E-ML-?node-id=25-6674&m=dev)

Differences include: optional top banner, a two-column body with different content by breakpoint, rating and CTA placement that changes between desktop and mobile, and optional badge, title, description, and feature list. A single, flexible architecture was needed to support these and future variants without separate components per layout.

---

## Approach

- **Compound component pattern** -- ProductCard follows the same pattern as Hero and Faq: namespace import and composable sub-components so each variant is a different composition of the same primitives.
- **Single source of truth** -- One set of primitives under `src/app/(paid-landing-pages)/_components/ProductCard/`; responsive visibility (e.g. Reshaped `Hidden`) at the page level matches each Figma variation.
- **Escape hatches** -- Sub-components expose sub-parts via `Object.assign` so Figma variations and future tweaks can be supported without forking the component.
- **Design tokens** -- Banner/badge teal, CTA green, border and radius aligned with existing theme.
- **Quality** -- Unit tests per sub-component, integration tests for full compositions, Storybook stories for default and variant layouts.

---

## Out Of Scope

- "Chosen by X" footer (removed from scope per design update)
- Box shadow by card index (handled at page/list level)
- Responsive layout logic inside ProductCard (done by consumer with `Hidden`)
- Replacing existing search ProductCards (scoped to paid-landing-pages only)

---

## Downstream Impact

- **New usage** -- Paid landing pages import and compose from `@/app/(paid-landing-pages)/_components/ProductCard`.
- **Assets** -- Logos in `src/assets/logos/`; icons from existing moneylion-theme/icons set.

---

## Future Work

- **ProductCardList / page-level composition** -- Implement the list or grid of cards, including conditional shadow and selected state wiring.
- **Further variants** -- New Figma variants supported by new compositions of the same primitives.
```

**Acceptance Criteria** (goes into the dedicated JIRA field as a task list):

- Composable API via namespace import; different layouts achieved by composition, not variant props
- Escape hatches expose overridable sub-parts (e.g. container/wrapper, list/item, icon/text)
- Figma variation 1 representable using ProductCard primitives plus page-level visibility
- Figma variation 2 representable using the same primitives with different composition
- Responsive layout differences achievable by consumer via `Hidden`, not inside ProductCard
- Unit tests for all sub-components and at least one integration test for a full composition
- Storybook stories demonstrating default composition and at least one variant layout
- JSDoc on all exported components with `@example` blocks
