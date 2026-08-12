---
name: plan-landing-page
description: Produce an implementation plan for a new landing page as a set of self-contained component schemas plus standardized page-level sections, derived from a Figma file and a JIRA ticket. The plan ends with wave-ordered build instructions that dispatch component-builder subagents. Use when asked to plan, outline, or spec the components for a new landing page.
targets: ["*"]
---

# Plan Landing Page

Produce a **spec-only** plan for a new landing page: no code is written. The output is a plan whose per-component sections are self-contained schemas an implementation agent can build without re-opening Figma or the ticket. The build itself is handed off to `component-builder` subagents (see "Build instructions" below).

## Inputs

- **Figma file/URL** — the page mocks (desktop + mobile). Extract node IDs, exact styles, tokens, and verbatim copy. Use the Figma MCP (`get_design_context`, `get_metadata`, `get_screenshot`).
- **JIRA ticket** — scope, slug/route, labels, theme, and what is out of scope. Read it via the Atlassian MCP.

If either input is missing, ask for it before planning. If the ticket defers anything (SDK wiring, tracking), record it under "Out of scope".

## Workflow

1. **Survey the page.** Read the Figma metadata and screenshots top to bottom. List every distinct section in document order.
2. **Assign a layer to each component.** Walk the `create-react-component` decision tree (`.rulesync/skills/create-react-component/SKILL.md`) for each one:
   - Used by exactly one page → **page-specific composition**.
   - Aliases a single Reshaped primitive with preset defaults → **simple wrapper**.
   - New building block with 2+ sub-components that each have their own public API → **compound primitive**.
   - Otherwise a recurring opinionated arrangement behind a prop API → **opinionated wrapper**.
   - Reuse existing shared compounds where one already fits (e.g. `@/components/Faq`, `@/components/Footer`) instead of re-authoring.
3. **Extract design detail fully.** For each component, pull exact Reshaped tokens, `Text` variants, spacing/radius/padding, colors (Figma hex → Reshaped token where one exists), and verbatim copy. The schema must be self-contained — `component-builder` does not get Figma access.
4. **Set the RSC boundary.** Server by default; name the smallest `'use client'` islands (CTA buttons, stateful carousels).
5. **Record dependencies.** For each component, list `dependsOn` (other schema'd components it imports). This drives the build waves.
6. **Write the per-component schema blocks** following `.rulesync/docs/landing-page-component-schema.md` exactly (part-ownership of `props`/`styles`, the `props` convention, required vs optional fields).
7. **Emit the standardized plan** using the skeleton below.

## Standardized plan skeleton

Every generated plan uses these fixed top-level sections:

1. **Header** — JIRA link, slug/route, label, theme, one-line scope + what's out of scope.
2. **Shared decisions** — feature group + route, reach for each tier (feature-group `_components/` vs page `_components/`), CTA seam, Reshaped-first note, RSC default, data layer location, asset placement.
3. **Typography mapping** — Figma type styles → Reshaped `Text variant` table.
4. **Color tokens** — Figma hex → Reshaped token (note any color with no token, passed as hex).
5. **Page assembly** — `page.tsx` + `PageContent.tsx` composition in document order, with a mermaid diagram.
6. **Component schemas** — the YAML blocks, grouped by reach (feature-group primitives, then page-specific components). One block per component per `.rulesync/docs/landing-page-component-schema.md`.
7. **Data layer** — `_data/` typed content arrays.
8. **Open items / TBD** — content gaps, placeholder copy, hrefs to confirm.
9. **Out of scope** — deferred work (SDK, tracking, etc.).
10. **Build instructions** — the wave ordering + dispatch instructions (see next section).

## Build instructions section (always emitted last)

Close every plan with a "Build instructions" section that the parent agent reads to drive the build:

- Derive **waves** from the `dependsOn` graph (see `.rulesync/docs/landing-page-component-schema.md` → "`dependsOn` → build waves"): compound primitives first, then wrappers, then page-specific compositions, then `_data` + `PageContent`/`page.tsx` assembly.
- List each wave with the component `name`s it contains.
- Add the standing instruction:

  > For each wave in order, dispatch one `component-builder` subagent per schema entry **in parallel** (one Task call per component, batched in a single message). Pass the component's full schema block in the dispatch prompt. Wait for the entire wave to finish before starting the next. After the final wave, assemble `_data`, `PageContent.tsx`, and `page.tsx`.

## Checks

- [ ] Every section in the Figma mock maps to exactly one component (or a reused shared compound).
- [ ] Each component has a layer assigned via the decision tree.
- [ ] Each schema block is self-contained (styles, tokens, verbatim copy inline) and follows the schema doc's field rules.
- [ ] `props` follows the convention (reused types cited, new interfaces defined inline).
- [ ] `dependsOn` is set on every component; the Build instructions waves are consistent with it.
- [ ] The plan contains all standardized sections, ending with Build instructions.
