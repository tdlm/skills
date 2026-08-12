---
name: create-jira-ticket
description: Generate a JIRA ticket. Use when the user asks to create, write, or draft a JIRA ticket, ticket description, or story for any feature work.
targets: ["*"]
---

# Create JIRA Ticket

Commit to a **detail tier** before drafting.

## Core idea

A ticket has two layers, and deliberately leaves a third to the PR:

- **Acceptance Criteria = the contract.** Testable statements of outcomes. This is what "done" means.
- **Approach = the strategy.** The decisions that satisfy the contract -- not the mechanisms.

The **mechanisms** -- the files, paths, configs, and wiring chosen while implementing -- don't belong on the ticket at all. They live in the PR, which travels hand in hand with the ticket but is a separate artifact. Keeping mechanisms off the ticket is what makes it skimmable.

The tool that enforces the split is the **decisions-vs-mechanisms litmus**, applied to every Approach bullet and every AC:

> Could the engineer make a different choice here and still pass every AC?
>
> - **Yes** -> it's a mechanism. It belongs in the PR, not the ticket.
> - **No** -> it's a decision (Approach) or an outcome (AC). Keep it.

---

## Pick a tier

Walk this decision tree. The first match is your tier -- stop there and Read the linked template for its section composition and worked example. Default to **Standard** when no cue fits; **never start at Detailed without an explicit signal** -- detailed-by-default produces walls of text reviewers won't read.

1. **Bug fix, small follow-up, or context is one ticket-link away?**
   (Cues: "fix", "follow-up to PROJ-NNN", "tiny change", "implements PROJ-NNN" spike.)
   -> **Minimal** -- `./templates/minimal.md`

2. **Net-new initiative, cross-team, or ambiguous scope?**
   (Cues: "design doc", "RFC", "stakeholders", "epic", "multiple teams".)
   -> **Detailed** -- `./templates/detailed.md`

3. **Otherwise -- normal story-shaped work the team broadly understands?**
   -> **Standard** -- `./templates/standard.md`

**Tier-picking rules:**

- If a linked ticket already covers Background/Approach, default down one tier (the link is doing the work).
- If you picked a tier without an explicit cue, surface it when presenting the draft so the user can adjust. "More detail" / "shorter" are valid requests -- offer to step up or down a tier.

---

## Workflow

Shared across all tiers. Your tier's template decides only **which sections to compose** and **which worked example to mirror**.

1. **Gather context.** Read the implementation plan (if one exists), browse key source files, and note any design links or specs the user provides.
2. **Draft each section your tier lists**, in order, reading its linked guidance file first.
3. **Draft the Acceptance Criteria separately**, reading `.rulesync/docs/jira/ticket-sections/acceptance-criteria.md`.
4. **Run the litmus** on every Approach bullet and every AC as you write. Mechanisms move to the PR.
5. **Mirror your tier's worked example** for shape and word budget, then run the "Always (across all tiers)" pass below.
6. **Present the full ticket** -- the description in a markdown code block, then the AC as a bullet list. Label each part so the description goes into the Description field and the criteria into the dedicated Acceptance Criteria field. If you picked the tier without an explicit cue, say so.
7. **Ask** if the user wants any section revised -- offer to step up or down a tier.
8. **Create via Atlassian MCP** only after the user confirms, per `.rulesync/docs/jira/mcp-creation.md`.

---

## Always (across all tiers)

Run this pre-finalize pass on every draft, after the Core idea litmus.

- [ ] **Acceptance Criteria go in the dedicated JIRA field**, not the description body (inline as a fallback only -- see `.rulesync/docs/jira/mcp-creation.md`).
- [ ] **No files/configs leaking into Approach or AC.** Reword to the decision or outcome; keep a path only when it's a public-surface convention the team must learn.
- [ ] **No "implementer note" / "during migration" asides.** They belong in the PR.
- [ ] **Out Of Scope and Future Work don't overlap.** If they do, drop Future Work.
- [ ] **No bullet chains multiple ideas with `;`.** Parallel ideas -> nested sub-bullets; action + rationale -> split with `.` and keep the bullet flat.
- [ ] **No bullet has >=2 commas.** Strategic items -> nested sub-bullets; files/configs -> rewrite the parent at a higher level.
- [ ] **No section exceeds 5 top-level bullets.** Group or nest.

**Style:**

- Bullets with **bold leads** for scannability.
- Markdown horizontal rules (`---`) between sections.
- Natural, conversational language. Avoid clinical tone.
- Break dense Summary/Background paragraphs at sentence boundaries when sentences carry distinct ideas.
