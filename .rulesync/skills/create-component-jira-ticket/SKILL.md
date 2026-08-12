---
name: create-component-jira-ticket
description: Generate JIRA ticket descriptions for React component creation or refactoring work. Extends the general create-jira-ticket template with compound component patterns, escape hatches, Reshaped primitives, and project conventions. Use when the user asks to create a JIRA ticket for a new or refactored component.
targets: ["*"]
---

# Create Component JIRA Ticket

This skill extends [create-jira-ticket](../create-jira-ticket/SKILL.md). Follow the baseline Core idea, workflow, detail tiers, and section templates from that skill (including JIRA creation via Atlassian MCP per `.rulesync/docs/jira/mcp-creation.md` after user confirmation), then apply the component-specific overrides below.

## Component-Specific Overrides

### Background

Include pain points of the existing component when refactoring or replacing (e.g., limited API surface, hardcoded styling, no prop forwarding, centralized data anti-patterns). When an existing component is the reference, include a brief "current state" summary of what it supports and where it falls short.

If Figma mocks are available (via user-provided link or Figma MCP), include mock links with node IDs and enumerate visual differences between variations (e.g., optional sections, responsive placement changes). Figma mocks are optional; when absent, describe the component requirements from other sources (plan, spec, conversation context).

### Approach

Apply the base skill's Core idea litmus ("could the engineer make a different choice and still pass every AC?") to every bullet. For component work, the architectural decisions that pass the test are usually the pattern itself (compound vs simple wrapper), the composition strategy (data-driven vs manual), and any escape hatches the API commits to. Name sub-components only when their existence is part of the API contract (i.e., AC enforces them). Don't prescribe internal roles, styling, prop wiring, or file paths -- those are mechanisms the engineer chooses.

For architectural context, consult:

- `.rulesync/docs/compound-primitives.md` -- barrel-only namespace, simple vs mini-compound sub-components, escape hatches
- `.rulesync/docs/opinionated-wrappers.md` -- prop API design (new-wrapper-vs-prop test, discriminated unions, escape hatches)
- `.rulesync/docs/reshaped-first.md` -- Reshaped-first principle, type derivation
- `.rulesync/docs/file-structure/component.md`, `.rulesync/docs/file-structure/component-compound.md`  -- directory layout, naming, barrel exports
- `.rulesync/docs/composition-patterns.md` -- children vs render props, avoiding boolean props

### Acceptance Criteria

These go into the dedicated JIRA Acceptance Criteria field as a task list (not in the description body). See the base skill for details. Include the following areas where applicable:

- **Composable API** -- Component consumed via namespace import, composed from sub-components; layout variations achieved by composition, not separate component variants.
- **Escape hatches** -- Sub-components that need customization expose overridable sub-parts (e.g., container/wrapper, list/item, icon/text).
- **Figma variation support** -- Each Figma variation can be represented using the same primitives plus page-level composition and visibility (e.g., Reshaped `Hidden`), not by variant props or separate component code. Include only when Figma mocks are provided.
- **Responsive layout** -- Breakpoint-specific layout differences achievable by the consumer via composition and `Hidden`; no breakpoint logic inside the component. Include only when the design has responsive differences.
- **Unit tests** -- Tests for all sub-components AND the main namespaced export. Reference `.rulesync/docs/testing/component.md` for BDD conventions.
- **Storybook stories** -- Stories for the main namespaced export only, demonstrating all usage patterns. Reference `.rulesync/docs/component-storybook.md` for conventions.
- **JSDoc** -- Documentation on all exported components with `@example` blocks. Reference `.rulesync/docs/component-jsdoc.md` for format.

### Out Of Scope

Typical exclusions for component tickets:

- Consumer migration (tracked in separate tickets)
- Modifications to existing components being replaced
- Deprecation or removal of old components
- Responsive layout logic inside the component itself
- Page-level concerns (conditional shadows, list ordering, selected state wiring)
- Backward compatibility shims

### Downstream Impact

- Existing component API remains functional; no breaking changes
- New compound component exported alongside old; teams migrate at their own pace
- Note where the new component lives and how consumers import it

### Future Work

Typical follow-on items:

- **Migration ticket** -- Update existing usages to the new compound component API
- **Consolidation** -- Evaluate merging old component or wrapper layers into the new one
- **Cleanup** -- Remove deprecated code, centralized data, or wrapper layers after migration

## Examples

Two full worked tickets. Read only the one that matches the work at hand:

- **Net-new component** (especially from Figma mocks) -- `./examples/new-from-figma.md` (ProductCard: a new compound component matching multiple Figma variations).
- **Refactoring or replacing an existing component** -- `./examples/refactor-existing.md` (FAQ: rebuilding a legacy component as a compound component).
