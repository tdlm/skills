# Compound Primitive Naming

Applies on top of the shared component-naming rules.

## Archetype + Structural Noun

End with a structural noun (`Card`, `Hero`, `List`, `Group`); qualify it with the archetype: `ProductCard`, `FeatureList`, `HeadingGroup`.

## No Domain Instances, No Brands

The primitive must not know which feature it serves. `InstacashSteps` is misnamed — "Instacash" is a brand; the primitive is a `StepList`, and the brand belongs to its wrapper (`InstacashSection`).

## Distinctive, Not Just Generic

The archetype must carry enough anatomy to distinguish the component. `SmallCard` and `BigCard` are maximally generic and carry no distinguishing information — which is how the codebase grew two of each. If you can't name the archetype, you probably haven't identified what the primitive *is* yet.

## Unique Within Reach

Two primitives sharing a name across import scopes force every reader to check paths. If a name is taken, add a context qualifier to the narrower-reach one.
