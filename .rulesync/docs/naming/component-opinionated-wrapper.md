# Opinionated Wrapper Naming

Applies on top of the shared component-naming rules.

## Named for the Domain Instance

`OfferCard` wraps `ProductCard`; `SaveCard` wraps `HighlightCard`. The wrapper name says what the arrangement *means* to the feature.

## Never More Generic — Never Identical

A wrapper's name must never be more generic than its primitive's (no name-shrinking: `AgentCard` → `Agent`) and never identical to it (no shadowing: a wrapper `Hero` around `import * as Hero`).

When the natural domain name collides or is ambiguous, prefix the feature context: `ReviewHero`, `ProductEvaluationCard`.

## Variants Extend the Base Name

`OfferCard` → `OfferCardCompact`. Structural variants get a new wrapper; runtime state gets a prop.

## No Layer-marker Suffixes

Don't name wrappers `ProductCardDefault` or `ProductCardPreset` — the domain name *is* the layer marker.

## Smell: Third-layer Wrappers

If you're naming a wrapper of a wrapper (`OfferCardCompactEngine`), reconsider whether the middle layer should exist.
