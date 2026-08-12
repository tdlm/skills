# Acceptance Criteria

Acceptance Criteria are the **contract**: testable statements of outcomes, not implementation checkboxes. Each criterion ties back to a requirement in Background. Include quality criteria (tests, documentation) as explicit items.

**AC describes outcomes, not artifacts.** Don't name specific files, counts, config field values, or implementation steps. The only paths that belong in AC are **public-surface conventions the team has to learn** (the same proper-noun rule as Approach). Everything else gets reframed as the behavior it produces.

- Bad: "lefthook.yml extended with post-checkout / post-merge / post-rewrite blocks invoking the drift notifier"
- Good: "drift notifier runs read-only on incoming source changes and never invokes the generator"
- Bad: "All 10 convention files exist as plain markdown in `.rulesync/docs/`"
- Good: "Reference content lives under `.rulesync/docs/` as plain markdown, never emitted to generated output"

## Where AC lives in JIRA

AC render as an interactive task list with checkboxes. They belong in the JIRA instance's dedicated Acceptance Criteria task-list field when one exists, and ride inline in the description body as a fallback when it doesn't -- a constraint that varies by org and issue type. The field IDs and fallback logic live in [mcp-creation.md](../mcp-creation.md); you don't have to think about the plumbing when drafting.

When presenting criteria to the user for review, show them as a simple bullet list. The MCP creation step converts them to ADF task-list format automatically.
