# Detailed tier example

Net-new initiative, cross-team work, or ambiguous scope. All six sections with expanded Background and Approach, and optionally a Risks / Trade-offs section. AC stays outcome-based even when the description is long.

**Description** (goes into the Description field):

```markdown
## Summary

Adopt rulesync as the single source of truth for agent context (rules, skills, hooks) in this repo.

Today the same conventions are duplicated across `.cursor/` and `.claude/`, and the two drift apart whenever someone edits one and forgets the other. This work makes `.rulesync/` canonical and generates the tool-specific copies, so contributors edit one place and every agent stays in sync.

---

## Background

We maintain agent guidance for two tools (Cursor and Claude Code). Each expects its own directory layout, so a rule or skill has to exist twice -- once under `.cursor/` and once under `.claude/`.

What doesn't work today:

- **Silent drift** -- An edit to a `.cursor/` rule rarely gets mirrored to `.claude/`, so the agents give different answers for the same task.
- **No review signal** -- Because the copies are hand-maintained, a reviewer can't tell which file is authoritative or whether a PR updated both.
- **Onboarding tax** -- New contributors don't know which directory to edit, and often pick the wrong one.

A preliminary spike (PAID-189) confirmed rulesync can generate both targets from one `.rulesync/` source, and that generation can be manual (no postinstall hook) so it never surprises a contributor mid-install.

---

## Approach

- **Single canonical source** -- `.rulesync/` becomes the single authoritative home for agent context. The tool-specific directories become generated output, never edited by hand.
- **Manual-only generation** -- Generation runs only when a contributor invokes it explicitly. No install-time or save-time automation fires it, so regeneration is always an intentional act.
- **Drift awareness, not enforcement** -- When the canonical source changes underneath a contributor, they are notified that regeneration is needed. Nothing regenerates automatically on their behalf.
- **Generated output is disposable** -- Anything in the generated directories that doesn't trace back to the canonical source is removed on regenerate, so the output always matches the source.

---

## Out Of Scope

- Migrating the existing rule/skill *content* (this ticket sets up the pipeline, with content moving in follow-ups)
- Adding a third agent target beyond Cursor and Claude Code
- CI enforcement that fails builds on drift

---

## Downstream Impact

- **New contributor workflow** -- Edits go in `.rulesync/`. The tool-specific directories are no longer edited directly.
- **No runtime impact** -- This affects developer tooling only. Nothing ships to users.
- **Migration** -- Existing hand-maintained copies are replaced by generated output in the adopting PR.

---

## Future Work

- **Content migration** -- Move the remaining hand-written rules and skills under `.rulesync/` so they regenerate cleanly.
- **CI drift check** -- Evaluate a read-only CI step that flags when generated output is stale relative to source.
```

**Acceptance Criteria** (goes into the dedicated JIRA field as a task list):

- `.rulesync/` is the only place contributors edit agent rules, skills, and reference docs
- Both Cursor and Claude Code targets are produced from the canonical source by an explicit, documented command
- Generation never runs automatically at install or save time
- Contributors are notified when the canonical source changes and regeneration is needed
- Generated output that doesn't trace back to a canonical source is removed on regenerate
- Adoption process is documented for new contributors
