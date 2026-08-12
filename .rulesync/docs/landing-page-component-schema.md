# Landing-Page Component Schema

A **component schema** is a self-contained, machine-readable description of one landing-page component: enough information for an implementation agent to build it via `/create-react-component` without consulting Figma, the JIRA ticket, or asking follow-up questions.

This doc is the single source of truth for the schema.

Schemas are authored as YAML blocks embedded in a plan's markdown (one list of `- name: ...` entries). They must be fully self-contained: all styles, tokens, and verbatim copy are extracted inline. The agent implementing a block cannot pause to ask for missing information, so anything it needs must be in the block.

## Core principle: parts own their `props` and `styles`

`props` and `styles` attach to the **part** that owns them.

- A **compound primitive** is barrel-only — it has no top-level component. It therefore carries **no top-level `props`/`styles`**; each sub-component owns its own `props` and `styles`.
- Every other layer (`opinionated-wrapper`, `simple-wrapper`, `page-specific-composition`) is a **single part**. Its `props`/`styles` live at the **top level**, and `subComponents` is `[]`.

## Fields

### Always required

| Field | Description |
| --- | --- |
| `layer` | One of `compound-primitive \| opinionated-wrapper \| simple-wrapper \| page-specific-composition`. Drives which `create-react-component` workflow the implementing agent reads. |
| `name` | PascalCase component name. |
| `path` | Target directory (encodes reach). E.g. `src/app/(paid-landing-pages)/(savvy)/_components/HighlightCard/`. One page → `app/<route>/_components/<Component>/`; one feature group → `app/(<feature>)/_components/<Component>/`; cross-feature → `src/components/<Component>/`. |
| `rsc` | RSC boundary: `server-only`, or a note naming the `'use client'` island(s) to extract. Server by default; `'use client'` only on the smallest island. |
| `dependsOn` | List of other schema'd component `name`s this one imports. Drives the build wave ordering. `[]` if none. |

### Layer-conditional required

| Field | Required for | Notes |
| --- | --- | --- |
| `subComponents` | `compound-primitive` | List of `{ name, role, props, styles }`. Each sub-component owns its `props` and `styles`. Omitted (or `[]`) for all other layers. |
| `props` | the three single-part layers | The component's type/interface (see convention below). Omitted for `compound-primitive`. |
| `styles` | the three single-part layers | Reshaped tokens, `Text` variants, spacing/radius/padding. Omitted for `compound-primitive` (styles live per sub-component). |

### Optional

| Field | Description |
| --- | --- |
| `text` | Verbatim copy the component renders (headlines, labels, body). Use when copy is part of the component rather than supplied via `_data`. |
| `data` | `_data` file/shape the component reads (for data-driven sections). |
| `assets` | Assets it consumes: path + how (`next/image` for raster/illustration, Reshaped `<Icon svg={...}>` for stylable icons). |
| `figmaNodes` | Figma `fileKey` + node IDs, reference only (the schema is already self-contained; this is for traceability/QA). |
| `escapeHatches` | Sub-parts that must be overridable (e.g. `Object.assign(RootDefault, { Container })`). |
| `notes` | Open items / TBD / design-QA flags. |

## `props` field convention

Applies to the top-level `props` and to each sub-component's `props`. Prefer deriving from a Reshaped type over a hand-rolled one whenever an equivalent exists.

- **Reusing a type verbatim** — name it and cite its source. No re-declaration.
  - `ViewProps (Reshaped)`, `TextProps (Reshaped)`, `ImageProps (next/image)`.
- **Deriving from an existing type** — show the composition with the base flagged.
  - `{ tone: 'teal' | 'yellow' | 'purple' } & ViewProps (Reshaped)`
  - `Omit<TextProps, 'variant'>` (Reshaped)
- **A new interface** — define it inline as a TS `type`/`interface` so it is implemented verbatim. Flag any reused base types.
- **Non-intersecting variants** — express as a discriminated union (e.g. `WithDefaultAction | WithCustomAction | WithNoAction`).

## `dependsOn` → build waves

The build runs in dependency-ordered **waves**. Derive them from `dependsOn`:

1. **Wave 1 — compound primitives** with `dependsOn: []` (no internal component deps).
2. **Wave 2 — opinionated/simple wrappers** that depend only on wave-1 components.
3. **Wave 3 — page-specific compositions** that depend on waves 1–2.
4. **Wave 4 — assembly**: `_data` files + `PageContent` + `page.tsx`.

Rule: a component may only be built once every name in its `dependsOn` has been built. Within a wave, components are independent and built in parallel. The plan states the concrete wave list in its build instructions.

## Worked example 1 — compound primitive

No top-level `props`/`styles`; each sub-component owns its own.

```yaml
- name: HighlightCard
  layer: compound-primitive
  path: src/app/(paid-landing-pages)/(savvy)/_components/HighlightCard/
  rsc: server-only
  dependsOn: []
  subComponents:
    - name: Root
      role: white card shell
      props: ViewProps (Reshaped)
      styles: "bg backgroundElevationRaised, direction column, gap 18, padding inline 24 block 40, radius 16, flex-1, full height"
    - name: Icon
      role: illustration slot ~50-72px
      props: ImageProps (next/image)
      styles: "decorative next/image, alt empty"
    - name: Title
      role: card title
      props: TextProps (Reshaped)
      styles: "variant featured-2, weight bold, color #1f1f1f"
    - name: Body
      role: card body copy
      props: TextProps (Reshaped)
      styles: "variant body-2, color foreground"
  escapeHatches: "Object.assign(RootDefault, { Container }) so consumers can swap the shell View"
```

## Worked example 2 — opinionated wrapper

Single-part layer: `props`/`styles` at the top level, `subComponents: []`. New interface derived from a Reshaped type, with the base flagged.

```yaml
- name: SaveCard
  layer: opinionated-wrapper
  path: src/app/(paid-landing-pages)/(savvy)/_components/SaveCard/
  rsc: server-only
  dependsOn: [HighlightCard]
  subComponents: []
  props: |
    type SaveCardProps = {
      icon: ReactNode | ImageProps['src']; // ImageProps from next/image
      title: ReactNode;
      body: ReactNode;
    } & ViewProps; // ViewProps from Reshaped
  styles: "composes HighlightCard.Root > Icon/Title/Body in canonical arrangement"
  text: |
    Three instances rendered by SectionSavings:
    - Save Money / "No need to shop around. We get multiple offers from top insurers."
    - Save Time / "Quickly search top carriers after a few brief questions."
    - Save Sanity / "Our licensed agents are here to help by text, phone, or email."
  assets: "value-money.svg, value-time.svg, value-sanity.svg (next/image)"
```
