# feat example

A new shared component. All of the profile's sections apply except one.

Two things to notice. **There is no Screenshots section** -- the Chromatic stories already show the component, so a second visual section would repeat them. And **Downstream Impact is present** because the component is a new public surface that future pages import, which is the include test for that section rather than a default.

The Changes bullets sit loose, with a blank line between them, because each wraps past one line. The Description prose puts one sentence per line.

PR title: `feat(paid-landing-pages): [ML:PAID-90] add shared ProductCard component`

```markdown
## Description

Adds a **ProductCard** compound component under `(paid-landing-pages)` that supports the card layouts from the LL Migration (GBR → ML) Figma mocks ([variation 1](https://www.figma.com/design/McL3BxpbWnSbbrqk94QKap/LL-Migration--GBR--%3E-ML-?node-id=1-1980&m=dev), [variation 2](https://www.figma.com/design/McL3BxpbWnSbbrqk94QKap/LL-Migration--GBR--%3E-ML-?node-id=25-6674&m=dev)).
It is built as composable primitives with escape hatches, so the variations in the mocks -- optional banner, two-column body, rating and CTA moving by breakpoint -- come out of the same building blocks rather than separate components.

**Link to Jira ticket**

[PAID-90](https://moneylion.atlassian.net/browse/PAID-90)

**Development URL**

<!-- DEVELOPMENT_URL:START -->
https://moneylion-next-XXXX.moneylion.dev
<!-- DEVELOPMENT_URL:END -->

**Storybook Preview**

<!-- CHROMATIC:START -->
_Chromatic links will be automatically added here when the build completes._
<!-- CHROMATIC:END -->

### Motivation

Paid landing pages need product comparison cards matching the LL Migration designs, and the mocks show more than one card.
Banner, badge, title, description, and features are each optional, and the rating and CTA change position by breakpoint.
Separate components per layout would have duplicated most of that surface, so the shape had to be flexible enough to cover every variation from one API.

### Changes

- **Compound component** — Namespace import with composable sub-components, following the pattern `Hero` and `Faq` already use. Layout differences come from composition and page-level visibility, not breakpoint logic inside ProductCard.

- **Escape hatches** — Sub-components expose overridable sub-parts via `Object.assign`, so Figma variations and later tweaks don't require forking the component.

- **Building blocks** — Root, Banner, Body, Aside, Content, Header, Image, Badge, Title, Description, Rating, Features, and Action. Rating fills stars fractionally through an SVG `linearGradient`. Banner, badge, CTA, border, and radius tokens align with the existing theme.

### Downstream Impact

- **No breaking changes** — Nothing consumed ProductCard before this PR, so there is nothing to migrate.
- **New import path** — Paid landing pages compose cards from the `ProductCard` namespace rather than building their own. Search's own `ProductCards` are untouched and stay separate.

### Testing

Unit tests per sub-component, an integration test for a full composition, and Storybook stories for the default and variant layouts, including the responsive cases.

### Validation

Compare the [Responsive](https://67924fa9656531edcf1fcbe4-qnfhlscvwo.chromatic.com/?path=/story/components-paid-landing-pages-productcard--responsive) and [Compact](https://67924fa9656531edcf1fcbe4-qnfhlscvwo.chromatic.com/?path=/story/components-paid-landing-pages-productcard--compact) stories against the two Figma variations linked above. Both should match at desktop and mobile widths.
```
